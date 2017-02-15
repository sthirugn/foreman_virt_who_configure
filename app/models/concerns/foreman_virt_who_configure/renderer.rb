module ForemanVirtWhoConfigure
  module Renderer
    extend ActiveSupport::Concern

    def virt_who_config_file(id)
      ForemanVirtWhoConfigure::Config.find(id).virt_who_config_file
    end
  end
end
