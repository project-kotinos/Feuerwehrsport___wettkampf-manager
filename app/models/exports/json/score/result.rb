Exports::JSON::Score::Result = Struct.new(:result) do
  include Exports::JSON::Base
  include Exports::ScoreResults

  def to_hash
    hash = {
      rows: build_data_rows(result, discipline, false, export_headers: true),
      gender: result.assessment.gender,
      discipline: result.assessment.discipline.key,
      name: result.to_s,
    }
    hash[:group_rows] = build_group_data_rows(result) if result.group_assessment? && discipline.single_discipline?
    hash
  end

  def filename
    "#{result.to_s.parameterize}.json"
  end

  protected

  def discipline
    @discipline ||= result.assessment.discipline.decorate
  end
end
