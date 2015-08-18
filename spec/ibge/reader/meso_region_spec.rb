require 'spec_helper'

describe Ibge::Reader::MesoRegion do
  subject { described_class }

  let(:columns) do
    {
      dtb: {
        "0": :state_code,
        "2": :code,
        "3": :name
      }
    }
  end

  it 'should have defined columns' do
    expect(subject.defined_columns).to eq columns
  end
end
