require 'spreadsheet'

module Ibge
  module Reader
    class Base
      extend Ibge::Reader::Helpers

      attr_reader :filename

      def self.read(options = {})
        new(options).read
      end

      def initialize(options = {})
        @spreadsheet = {}
        @rows = {}
        @selected_sheet = {}

        self.selected_source = self.class.selected_source

        unless options.fetch(:filename, nil).nil?
          filename = options.fetch(:filename)

          if filename.is_a?(Hash)
            sources_filename = options.fetch(:filename).keys

            sources_filename.each do |source_filename|
              self.class.valid_informed_source(source_filename)
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
        transformed_rows = []
        previous_column_range = nil

        if multiple_sources?
          loaded_sources = defined_columns.keys.sort

          loaded_sources.each do |loaded_source|
            self.selected_source = loaded_source
            @filename = default_filename_to(loaded_source)

            if transformed_rows == []
              transformed_rows = rows[1..-1].map do |row|
                transform(row.compact.values_at(*column_range), column_range)
              end

              transformed_rows = transformed_rows.uniq

              previous_column_range = column_range
            else
              transformed_rows.each do |transformed_row|
                selected_rows = rows[1..-1].select do |r|
                  r[previous_column_range.first] == transformed_row.values.first
                end

                new_row = selected_rows.compact.uniq { |r| r[0] }.map do |row|
                  transform(row.compact.values_at(*column_range), column_range)
                end

                if new_row.empty?
                  columns = self.class.defined_columns[selected_source]

                  columns.each do |column|
                    new_row << { column[1] => "" }
                  end
                end

                transformed_row.merge!(*new_row)
              end
            end
          end
        else
          transformed_rows = rows[1..-1].map do |row|
            transform(row.compact.values_at(*column_range), column_range)
          end
        end

        transformed_rows.uniq.sort_by { |h| data_sort(h) }
      end

      protected

      attr_accessor :selected_source

      def default_filename_to(source)
        sources[source.to_sym]
      end

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

      def sources
        self.class.sources
      end

      def defined_columns
        self.class.defined_columns
      end

      def column_keys
        defined_columns[selected_source].keys.map(&:to_s).map(&:to_i)
      end

      def column_range
        column_keys.compact.sort.uniq
      end

      def transform(row, column_range)
        row.each_with_index.inject({}) do |item, (raw_data, index)|
          column_index = column_range[index].to_s.to_sym

          hash = {
            defined_columns[selected_source][column_index] => raw_data
          }

          item.merge!(hash)
        end
      end

      def data_sort(hash)
        keys = hash.keys
        order_values = []

        (keys.length - 1).times.each do |index|
          order_values << hash[keys[index]]
        end

        order_values
      end

      def multiple_sources?
        defined_columns.keys.size > 1
      end
    end
  end
end
