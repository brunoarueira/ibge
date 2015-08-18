require 'spec_helper'

describe Ibge::Reader::Neighborhood do
  subject { described_class }

  let(:columns) do
    {
      sidra: {
        "0": :state_code,
        "3": :municipality_full_code,
        "5": :name
      }
    }
  end

  it 'should have defined columns' do
    expect(subject.defined_columns).to eq columns
  end
end
