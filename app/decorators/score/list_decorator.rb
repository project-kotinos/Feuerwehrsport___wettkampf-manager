module Score
  class ListDecorator < ApplicationDecorator
    def name
      [assessment.try(:decorate).try(:to_s), object.name].reject(&:blank?).join(" - ")
    end

    def discipline
      object.assessment.discipline.decorate
    end

    def to_s
      name
    end
  end
end