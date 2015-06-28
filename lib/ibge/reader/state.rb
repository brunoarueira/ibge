module Ibge
  module Reader
    class State < Base
      source :sidra

      columns "0": :code,
              "1": :state_name,
              "2": :state_federative_unit
    end
  end
end
