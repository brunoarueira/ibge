module Ibge
  module Reader
    class District < Base
      columns "0":  :state_code,
              "2":  :meso_region_code,
              "4":  :micro_region_code,
              "6":  :municipality_code,
              "9":  :code,
              "10": :full_code,
              "11": :name
    end
  end
end
