require 'spec_helper'

describe Ibge::Reader::Municipality do
  subject { described_class }

  let(:columns) do
    {
      dtb: {
        "0": :state_code,
        "2": :meso_region_code,
        "4": :micro_region_code,
        "6": :code,
        "7": :full_code,
        "8": :name
      }
    }
  end

  it 'should have defined columns' do
    expect(subject.defined_columns).to eq columns
  end
end
