require 'spreadsheet'

module Ibge
  module Reader
    class Base
      class << self
        attr_reader :defined_columns

        def columns(columns = {})
          @defined_columns = columns
        end
      end

      attr_reader :filename

      def self.read(options = {})
        new(options).read
      end

      def initialize(options = {})
        @filename = options.fetch(:filename, default_filename)
      end

      def read
        transformed_rows = rows[1..-1].map do |row|
          transform(row.compact.values_at(*column_range), column_range)
        end

        transformed_rows.uniq.sort_by { |hash| data_sort(hash) }
      end

      protected

      def default_filename
        File.join DATA_PATH, 'DTB_2014_subdistrito.xls'
      end

      def spreadsheet
        @spreadsheet ||= Spreadsheet.open filename
      end

      def sheet
        @selected_sheet ||= spreadsheet.worksheets.first
      end

      def rows
        @rows ||= sheet.rows
      end

      def column_keys
        self.class.defined_columns.keys.map(&:to_s).map(&:to_i)
      end

      def column_range
        column_keys.compact.sort.uniq
      end

      def transform(row, column_range)
        row.each_with_index.inject({}) do |item, (raw_data, index)|
          column_index = column_range[index]

          item.merge!(self.class.defined_columns[column_index.to_s.to_sym] => raw_data)
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
    end
  end
end
