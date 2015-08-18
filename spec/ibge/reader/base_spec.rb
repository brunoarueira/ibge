require "spec_helper"

describe Ibge::Reader::Base do
  context "source on top of the reader" do
    class ReaderWithSource < Ibge::Reader::Base
      source :sidra

      columns "0": :code
    end

    subject { ReaderWithSource }

    describe ".columns" do
      it { should respond_to :columns }

      it "maps the column index to a recognized column name" do
        expect(subject.defined_columns).to eq sidra: { "0": :code }
      end
    end

    describe ".read" do
      context "without pass a :filename as option" do
        it "reads the file inside data folder" do
          expect(subject.read).to include code: "11"
        end
      end

      context "passing a :filename" do
        it "reads the file provided" do
          filename = "spec/fixtures/DTB_example_subdistrito.xls"

          content = subject.read(filename: { dtb: filename })

          expect(content).to include code: "11"
        end
      end
    end

    describe ".selected_source" do
      it "show the default file source to read" do
        expect(subject.selected_source).to eq :sidra
      end
    end

    describe "#filename" do
      it "sets the default to file inside data folder" do
        expect(subject.new.filename).to include "data/sidra.xls"
      end
    end
  end

  context "without source defined" do
    class ReaderWithoutSource < Ibge::Reader::Base
      columns "0": :code
    end

    subject { ReaderWithoutSource }

    describe ".columns" do
      it { should respond_to :columns }

      it "maps the column index to a recognized column name" do
        expect(subject.defined_columns).to eq dtb: { "0": :code }
      end
    end

    describe ".read" do
      context "without pass a :filename as option" do
        it "reads the file inside data folder" do
          expect(subject.read).to include code: "11"
        end
      end

      context "passing a :filename" do
        it "reads the file provided" do
          filename = "spec/fixtures/DTB_example_subdistrito.xls"

          content = subject.read(filename: { dtb: filename })

          expect(content).to include code: "11"
        end
      end
    end

    describe ".selected_source" do
      it "show the default file source to read" do
        expect(subject.selected_source).to eq :dtb
      end
    end

    describe "#filename" do
      it "sets the default to file inside data folder" do
        expect(subject.new.filename).to include "data/DTB_2014_subdistrito.xls"
      end
    end
  end
end
