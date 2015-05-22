require 'spec_helper'

describe Ibge::Reader::District do
  subject { described_class }

  it 'should have defined columns' do
    expect(subject.defined_columns).to include "0": :state_code,
                                               "2": :meso_region_code,
                                               "4": :micro_region_code,
                                               "6": :municipality_code,
                                               "9": :code,
                                               "10": :full_code,
                                               "11": :name
  end
end
