module ForemanVirtWhoConfigure
  class Config < ActiveRecord::Base
    include Authorizable
    audited
    validates_lengths_from_database

    UNLIMITED = 0
    WHITELIST = 1
    BLACKLIST = 2

    belongs_to :compute_resource
    belongs_to :organization

    # service user used by virt-who to report back
    belongs_to :service_user

    scoped_search :on => :interval, :complete_value => true
    # TODO add more related objects and attributes

    # compatibility layer for 1.11 - pre strong params patch
    if self.respond_to?(:attr_accessible)
      attr_accessible :compute_resource_id, :organization_id, :interval
    end

    def title
      compute_resource.name
    end

    # TODO convert to hours if needed
    def humanized_interval
      _("every %s minutes") % self.interval
    end
  end
end