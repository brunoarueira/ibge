module Ibge
  module Reader
    module Helpers
      SOURCES = {
        dtb: "DTB_2014_subdistrito.xls",
        sidra: "sidra.xls"
      }

      attr_reader :defined_columns, :selected_source

      def columns(columns)
        if columns.empty?
          raise ArgumentError,
                "Columns must be provided as hash which contains " /
                  "the index and field name"
        end

        @defined_columns ||= {}
        @selected_source ||= :dtb

        distinct_sources = []

        columns.each do |_, v|
          if v.is_a?(Hash)
            hash_column_definition = v.values.first

            unless hash_column_definition.key?(:from_source)
              raise ArgumentError, "#{v.key} must have the key from_source"
            end

            valid_informed_source(hash_column_definition[:from_source])

            distinct_sources << hash_column_definition[:from_source]
          end
        end

        distinct_sources = distinct_sources.compact.uniq.sort

        distinct_sources.each do |source|
          extracted_columns = columns.select do |_, v|
            v.is_a?(Hash) && v.values.first[:from_source] == source
          end

          @defined_columns[source] = extracted_columns.inject({}) do |h, (k, v)|
            h.merge!(k.to_s.to_sym => v.is_a?(Hash) ? v.keys.first : v)

            h
          end
        end

        if @selected_source
          @defined_columns[@selected_source] = columns.select do |_, v|
            v.is_a?(Symbol)
          end
        end
      end

      def source(selected_source = :dtb)
        valid_informed_source(selected_source)

        @selected_source = selected_source
      end

      def sources
        SOURCES
      end

      def valid_informed_source(informed_source)
        source_keys = sources.keys

        unless source_keys.include?(informed_source)
          raise ArgumentError,
                "Source must be one of those '#{source_keys.join(', ')}'"
        end
      end
    end
  end
end
