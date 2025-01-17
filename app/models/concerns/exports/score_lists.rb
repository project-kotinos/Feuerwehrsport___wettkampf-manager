module Exports::ScoreLists
  def show_export_data(list, more_columns: false, double_run: false)
    data = [show_export_header(list, more_columns: more_columns, double_run: double_run)]

    score_list_entries(list) do |entry, run, track|
      line = []
      line.push((track == 1 ? run : ''), track)
      if list.single_discipline?
        line.push(entry.try(:entity).try(:bib_number).to_s) if Competition.one.show_bib_numbers?

        last_name = entry.try(:entity).try(:short_last_name).to_s
        tags = (entry.try(:entity).try(:tag_names) || []) & list.tag_names
        last_name += "<font size='6'> #{tags.join(',')}</font>" if tags.present?
        line.push(content: last_name, inline_format: true)

        line.push(entry.try(:entity).try(:short_first_name).to_s)
        line.push(entry.try(:entity).try(:team_shortcut_name, entry.try(:assessment_type)))
      else
        team_name = entry.try(:entity).to_s
        if list.multiple_assessments? && entry.present?
          team_name += "<font size='6'> (#{entry.try(:assessment).try(:decorate)})</font>"
        end

        tags = (entry.try(:entity).try(:tag_names) || []) & list.tag_names
        team_name += "<font size='6'> #{tags.join(',')}</font>" if tags.present?

        federal_state_shortcut = entry.try(:entity).try(:federal_state).try(:shortcut)
        team_name += "<font size='6'> <i>#{federal_state_shortcut}</i></font>" if federal_state_shortcut.present?
        line.push(content: team_name, inline_format: true)
      end
      line.push(entry.try(:human_time))
      line.push('', '') if more_columns
      line.push('') if double_run
      data.push(line)
    end
    data
  end

  def show_export_header(list, more_columns:, double_run:)
    header = %w[Lauf Bahn]
    if list.single_discipline?
      header.push('Nr.') if Competition.one.show_bib_numbers?
      header.push('Nachname', 'Vorname')
    end
    header.push('Mannschaft')
    if more_columns
      header.push('', '', '')
    elsif double_run
      header.push('Lauf 1', 'Lauf 2')
    else
      header.push('Zeit')
    end
    header
  end

  def score_list_entries(list, move_modus = false)
    entries = list.entries.includes(:entity).to_a
    track = 0
    run = 1
    entry = entries.shift
    invalid_count = 0
    extra_run = move_modus
    while entry.present? || track != 0 || extra_run
      extra_run = false if entry.blank? && track.zero? && extra_run
      track += 1
      if entry && entry.track == track && entry.run == run
        yield entry.decorate, run, track
        entry = entries.shift
      else
        yield nil, run, track
      end

      if track == list.track_count
        track = 0
        run += 1
      end

      invalid_count += 1
      return if invalid_count > 1000
    end
  end
end
