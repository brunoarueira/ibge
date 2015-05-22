require 'spec_helper'

describe Ibge::Reader::Base do
  class Reader < Ibge::Reader::Base
    columns "0": :code
  end

  subject { Reader }

  describe '.columns' do
    it { should respond_to :columns }

    it 'maps the column index to a recognized column name' do
      expect(subject.defined_columns).to eq "0": :code
    end
  end

  describe '.read' do
    context 'without pass a :filename as option' do
      it 'reads the file inside data folder' do
        expect(subject.read).to include code: "11"
      end
    end

    context 'passing a :filename' do
      it 'reads the file provided' do
        filename = "spec/fixtures/DTB_example_subdistrito.xls"

        expect(subject.read(filename: filename)).to include code: "11"
      end
    end
  end

  describe '#filename' do
    it 'sets the default to file inside data folder' do
      expect(subject.new.filename).to include 'data/DTB_2014_subdistrito.xls'
    end
  end
end
