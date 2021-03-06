require 'spreadsheet'

require 'ibge/version'

module Ibge
  DATA_PATH = File.expand_path(File.join(__dir__, '..', 'data'))

  module Reader
    autoload :Helpers, "ibge/reader/helpers"
    autoload :Base, "ibge/reader/base"
    autoload :State, "ibge/reader/state"
    autoload :MesoRegion, "ibge/reader/meso_region"
    autoload :MicroRegion, "ibge/reader/micro_region"
    autoload :Municipality, "ibge/reader/municipality"
    autoload :District, "ibge/reader/district"
    autoload :SubDistrict, "ibge/reader/sub_district"
    autoload :Neighborhood, "ibge/reader/neighborhood"
  end
end
