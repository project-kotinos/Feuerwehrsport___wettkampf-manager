class FireSportStatistics::PersonSuggestionDecorator < ApplicationDecorator
  decorates_association :person
  decorates_association :first
end
