module Ibge
  module Reader
    class SubDistrict < Base
      columns "0":  :state_code,
              "2":  :meso_region_code,
              "4":  :micro_region_code,
              "6":  :municipality_code,
              "9":  :district_code,
              "12": :code,
              "13": :full_code,
              "14": :name
    end
  end
end
