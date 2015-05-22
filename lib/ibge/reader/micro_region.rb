module Ibge
  module Reader
    class MicroRegion < Base
      columns "0": :state_code,
              "2": :meso_region_code,
              "4": :code,
              "5": :name
    end
  end
end
