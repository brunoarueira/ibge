require 'spreadsheet'

module Ibge
  module Reader
    class Base
      include Ibge::Reader::Helpers

      attr_reader :filename

      def self.read(options = {})
        new(options).read
      end

      def initialize(options = {})
        @spreadsheet = {}
        @rows = {}
        @selected_sheet = {}
        @all_rows = {}

        self.selected_source = self.class.selected_source

        filename = options.fetch(:filename, nil)

        unless filename.nil?
          if filename.is_a?(Hash)
            sources_filename = options.fetch(:filename).keys

            sources_filename.each do |source_filename|
              self.class.informed_source_is_valid?(source_filename)
            end
          else
            raise ArgumentError,
                  "Filename must be a hash with the source as key"
          end
        end

        default_filename = default_filename_to(selected_source)

        @filename = options.fetch(:filename, "#{DATA_PATH}/#{default_filename}")
      end

      def read
        rows = []

        if multiple_sources?
          rows = read_from_multiple_sources
        else
          rows = transformed_rows
        end

        rows.sort_by { |h| data_sort(h) }
      end

      protected

      attr_accessor :selected_source

      def spreadsheet
        filename = File.join(DATA_PATH, default_filename_to(selected_source))

        @spreadsheet[selected_source] ||= Spreadsheet.open filename
      end

      def sheet
        @selected_sheet[selected_source] ||= spreadsheet.worksheets.first
      end

      def rows
        @rows[selected_source] ||= sheet.rows
      end

      def all_rows
        @all_rows[selected_source] ||= rows[1..-1]
      end

      def transform(original_row, column_range)
        row = original_row.compact.values_at(*column_range)

        row.each_with_index.inject({}) do |item, (raw_data, index)|
          column_index = column_range[index].to_s.to_sym

          hash = {
            defined_columns[selected_source][column_index] => raw_data
          }

          item.merge!(hash)
        end
      end

      def read_from_multiple_sources
        rows = []
        previous_column = nil
        loaded_sources = defined_columns.keys.sort

        loaded_sources.each do |loaded_source|
          self.selected_source = loaded_source

          if rows.empty?
            rows = transformed_rows

            previous_column = column_range.first
          else
            rows.each do |transformed_row|
              new_row = handle_new_row(transformed_row.values, previous_column)

              transformed_row.merge!(*new_row)
            end
          end
        end

        rows
      end

      def transformed_rows
        unless @transformed_rows
          transformed_rows = all_rows.map do |row|
            transform(row, column_range)
          end

          @transformed_rows ||= transformed_rows.uniq
        end

        @transformed_rows
      end

      def handle_new_row(transformed_row_values, previous_column)
        first_row = transformed_row_values.first

        selected_rows = filter_rows(first_row, previous_column)
        selected_rows = selected_rows.compact.uniq { |r| r[0] }

        new_row = selected_rows.map do |row|
          transform(row, column_range)
        end

        if new_row.empty?
          columns = defined_columns[selected_source]

          columns.each do |column|
            new_row << { column[1] => "" }
          end
        end

        new_row
      end

      def filter_rows(value, column)
        all_rows.select { |r| r[column] == value }
      end
    end
  end
end
