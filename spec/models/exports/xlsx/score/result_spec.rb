require 'rails_helper'

RSpec.describe Exports::XLSX::Score::Result, type: :model do
  let(:show_xlsx) { described_class.perform(result.decorate) }
  let(:person1) { create(:person, :generated) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment, group_assessment: true) }
  let!(:list) { create_score_list(result, person1 => 2200, person2 => nil) }

  describe 'perform' do
    it 'creates xlsx' do
      expect(show_xlsx.bytestream).to start_with "PK\u0003"
      expect(show_xlsx.bytestream).to end_with "\u0000\u0000"
      expect(show_xlsx.bytestream.size).to be_within(100).of(4623)

      expect(show_xlsx.filename).to eq 'hakenleitersteigen-manner.xlsx'
    end
  end
end
