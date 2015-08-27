module Ibge
  module Reader
    class State < Base
      columns "0": :code,
              "1": :state_name,
              "2": { state_federative_unit: { from_source: :sidra } }
    end
  end
end
