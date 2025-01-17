class TeamRelayDecorator < ApplicationDecorator
  decorates_association :team

  def to_s(full = false)
    full ? numbered_name_with_gender : "#{team} #{name}"
  end

  def numbered_name_with_gender
    "#{team.numbered_name_with_gender} #{name}"
  end

  def self.human_name_cols
    ['Mannschaft']
  end

  def shortcut_name
    "#{team.shortcut_name} #{name}"
  end

  def name_cols(_assessment_type, shortcut)
    [shortcut ? shortcut_name : to_s]
  end
end
