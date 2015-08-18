require 'spec_helper'

describe Ibge::Reader::SubDistrict do
  subject { described_class }

  let(:columns) do
    {
      dtb: {
        "0": :state_code,
        "2": :meso_region_code,
        "4": :micro_region_code,
        "6": :municipality_code,
        "9": :district_code,
        "12": :code,
        "13": :full_code,
        "14": :name
      }
    }
  end

  it 'should have defined columns' do
    expect(subject.defined_columns).to include columns
  end
end
