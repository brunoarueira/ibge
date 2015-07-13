module Ibge
  module Reader
    class Neighborhood < Base
      source :sidra

      columns "0": :state_code,
              "3": :municipality_full_code,
              "5": :name
    end
  end
end
