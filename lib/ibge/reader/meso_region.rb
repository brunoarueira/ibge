module Ibge
  module Reader
    class MesoRegion < Base
      columns "0": :state_code,
              "2": :code,
              "3": :name
    end
  end
end
