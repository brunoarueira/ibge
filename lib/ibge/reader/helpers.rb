module Ibge
  module Reader
    module Helpers
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        SOURCES = {
          dtb: "DTB_2014_subdistrito.xls",
          sidra: "sidra.xls"
        }.freeze

        attr_accessor :selected_source, :defined_columns

        def columns(columns)
          if columns.empty?
            raise ArgumentError,
                  "Columns must be provided as hash which contains " /
                  "the index and field name"
          end

          selected_columns = columns.select { |_, v| v.is_a?(Hash) }

          distinct_sources = define_distinct_sources(selected_columns)

          defined_columns = generate_columns(distinct_sources, selected_columns)

          if selected_source
            defined_columns[selected_source] = columns.select do |_, v|
              v.is_a?(Symbol)
            end
          end
        end

        def source(selected_source = :dtb)
          informed_source_is_valid?(selected_source)

          @selected_source = selected_source
        end

        def sources
          SOURCES
        end

        def informed_source_is_valid?(informed_source)
          source_keys = sources.keys

          unless source_keys.include?(informed_source)
            raise ArgumentError,
                  "Source must be one of those '#{source_keys.join(', ')}'"
          end

          true
        end

        def selected_source
          @selected_source ||= :dtb
        end

        def defined_columns
          @defined_columns ||= {}
        end

        protected

        def define_distinct_sources(selected_columns)
          distinct_sources = []

          selected_columns.each do |_, v|
            hash_column_definition = v.values.first

            unless hash_column_definition.key?(:from_source)
              raise ArgumentError, "#{v.key} must have the key from_source"
            end

            from_source = hash_column_definition[:from_source]

            if informed_source_is_valid?(from_source)
              distinct_sources << from_source
            end
          end

          distinct_sources = distinct_sources.compact.uniq.sort
        end

        def generate_columns(distinct_sources, selected_columns)
          distinct_sources.each do |source|
            extracted_columns = selected_columns.select do |_, v|
              v.values.first[:from_source] == source
            end

            hash = extracted_columns.inject({}) do |h, (k, v)|
              value = v.is_a?(Hash) ? v.keys.first : v

              h[k.to_s.to_sym] = value

              h
            end

            defined_columns[source] = hash
          end

          defined_columns
        end
      end

      def default_filename_to(source)
        sources[source.to_sym]
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
