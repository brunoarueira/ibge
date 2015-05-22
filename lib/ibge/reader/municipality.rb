module Ibge
  module Reader
    class Municipality < Base
      columns "0": :state_code,
              "2": :meso_region_code,
              "4": :micro_region_code,
              "6": :code,
              "7": :full_code,
              "8": :name
    end
  end
end
