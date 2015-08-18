require "spec_helper"

describe Ibge::Reader::State do
  subject { described_class }

  let(:columns) do
    {
      dtb: {
        "0": :code,
        "1": :state_name
      },

      sidra: {
        "2": :state_federative_unit
      }
    }
  end

  it "should have defined columns" do
    expect(subject.defined_columns).to eq columns
  end

  it "should read from multiple sources" do
    expect(subject.read).to include code: "11",
                                    state_name: "Rondônia",
                                    state_federative_unit: "RO"
  end
end
