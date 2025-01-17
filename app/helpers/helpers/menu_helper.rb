module Helpers::MenuHelper
  MenuItem = Struct.new(:label, :controller_path, :action) do
    def url
      { controller: controller_path, action: (action || :index) }
    end
  end

  def main_menu_items
    items = [
      MenuItem.new('Übersicht', '/dashboard', :show),
      MenuItem.new('Mannschaften', '/teams'),
      MenuItem.new('Wettkämpfer', '/people'),
      MenuItem.new('Startlisten', '/score/lists'),
      MenuItem.new('Ergebnisse', '/score/results'),
    ]

    if Competition.result_type.present? && (can?(:manage, Competition) || !Competition.one.hide_competition_results?)
      items.push(MenuItem.new('Gesamtwertung', '/score/competition_results'))
    end
    items.push(MenuItem.new('Cup-Wertung', '/series/rounds')) if Series::Round.with_local_results.present?

    items
  end

  def admin_menu_items
    if admin_logged_in?
      [
        MenuItem.new('Disziplinen', '/disciplines'),
        MenuItem.new('Wertungen', '/assessments'),
        MenuItem.new('Urkunden', '/certificates/templates'),
        MenuItem.new('Wettkampf', '/competitions', :edit),
        MenuItem.new('Veröffentlichung', '/fire_sport_statistics/publishings', :new),
        MenuItem.new('API-Zeiten', '/api/time_entries'),
        MenuItem.new('Benutzer', '/users'),
        MenuItem.new('Abmelden', '/sessions', :destroy),
      ]
    else
      [
        MenuItem.new('Abmelden', '/sessions', :destroy),
      ]
    end
  end
end
