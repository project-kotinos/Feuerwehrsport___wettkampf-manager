class Score::CompetitionResultDecorator < ApplicationDecorator
  decorates_association :rows
  decorates_association :results

  def to_s
    [object.name, translated_gender].reject(&:blank?).join(' - ')
  end

  def short_name
    [object.name, translated_gender].reject(&:blank?).map { |s| s.truncate(20) }.join(' - ').truncate(30)
  end

  def translated_gender
    t("gender.#{gender}")
  end
end
