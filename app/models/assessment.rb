class Assessment < ActiveRecord::Base
  include Taggable

  belongs_to :discipline
  belongs_to :score_competition_result, class_name: "Score::CompetitionResult"
  has_many :requests, class_name: "AssessmentRequest", dependent: :destroy
  has_many :results, class_name: "Score::Result", dependent: :restrict_with_error
  has_many :list_assessments, class_name: "Score::ListAssessment", dependent: :restrict_with_error
  has_many :lists, class_name: "Score::List", through: :list_assessments, dependent: :restrict_with_error
  enum gender: { female: 0, male: 1 }

  validates :discipline, presence: true

  scope :gender, -> (gender) { where(gender: Assessment.genders[gender]) }
  scope :no_double_event, -> { joins(:discipline).where.not(disciplines: { type: "Disciplines::DoubleEvent" }) }
  scope :discipline, -> (discipline) { joins(:discipline).where(disciplines: { type: discipline.type }) }

  def to_label
    decorate
  end

  def fire_relay?
    discipline.is_a?(Disciplines::FireRelay)
  end

  def person_tags
    @person_tags ||= tags.where(type: PersonTag)
  end

  def team_tags
    @team_tags ||= tags.where(type: TeamTag)
  end

  def self.requestable_for entity
    if entity.is_a? Person
      where(arel_table[:gender].eq(nil).or(arel_table[:gender].eq(Person.genders[entity.gender]))).select do |assessment|
        assessment.discipline.single_discipline? && (assessment.person_tags.blank? || entity.include_tags?(assessment.person_tags))
      end
    else
      where(arel_table[:gender].eq(nil).or(arel_table[:gender].eq(Team.genders[entity.gender]))).select do |assessment|
        assessment.discipline.group_discipline? && (assessment.team_tags.blank? || entity.include_tags?(assessment.team_tags))
      end
    end
  end
end
