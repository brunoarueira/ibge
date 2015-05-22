require 'spec_helper'

describe Ibge::Reader::MesoRegion do
  subject { described_class }

  it 'should have defined columns' do
    expect(subject.defined_columns).to include "0": :state_code,
                                               "2": :code,
                                               "3": :name
  end
end
