module ForemanVirtWhoConfigure
  class ConfigsController < ::ForemanVirtWhoConfigure::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanVirtWhoConfigure::Concerns::ConfigParameters if defined?(Foreman::ParameterFilter)
    before_action :find_resource, :only => [:edit, :update, :destroy, :show]

    # in 1.11 we can't use welcome from application controller since it does not work with namespaces
    def welcome
      if model_of_controller.first.nil?
        @welcome = true
        render :action => :welcome
      end
    end

    def index
      if respond_to?(:resource_base_search_and_page)
        @configs = resource_base_search_and_page
      else
        base = resource_base.search_for(params[:search], :order => params[:order])
        @configs = base.paginate(:page => params[:page], :per_page => params[:per_page])
      end
    end

    def new
      @config = Config.new
      if params.key?(:organization_id)
        @config.organization = Organization.authorized(:view_organizations).where(:id => params[:organization_id]).first
      end
      @config.hypervisor_type ||= Config::HYPERVISOR_DEFAULT_TYPE
      @config.organization ||= Organization.current
      @config.satellite_url ||= Setting.foreman_url
    end

    def create
      @config = Config.new(config_params)
      if @config.save
        process_success :success_redirect => foreman_virt_who_configure_config_path(@config)
      else
        render 'new'
      end
    end

    def show

    end

    def edit
    end

    def update
      if @config.update_attributes(config_params)
        process_success :object => @config
      else
        process_error :object => @config
      end
    end

    def destroy
      if @config.destroy
        process_success :object => @config
      else
        process_error :object => @config
      end
    end

    def auto_complete_controller_name
      'foreman_virt_who_configure_configs'
    end

    def controller_name
      'foreman_virt_who_configure_configs'
    end

    # compatibility layer for 1.11 - pre strong params patch
    def config_params
      if defined?(super)
        super
      else
        params[:foreman_virt_who_configure_config]
      end
    end
  end
end
