require 'spec_helper'

describe Ibge::Reader::State do
  subject { described_class }

  it 'should have defined columns' do
    expect(subject.defined_columns).to include "0": :code, "1": :state_name
  end
end
