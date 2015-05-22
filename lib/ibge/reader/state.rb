module Ibge
  module Reader
    class State < Base
      columns "0": :code,
              "1": :state_name
    end
  end
end
