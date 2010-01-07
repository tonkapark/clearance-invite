require 'digest/sha1'

module Clearance
  module Invite

    # Hook for all Clearance::Invite modules.
    #
    # If you need to override parts of Clearance::Invite,
    # extend and include à la carte.
    #
    # @example
    #   extend ClassMethods
    #   include InstanceMethods
    #   include AttrAccessor
    #   include Callbacks
    #
    # @see ClassMethods
    # @see InstanceMethods
    # @see AttrAccessible
    # @see AttrAccessor
    # @see Validations
    # @see Callbacks
    def self.included(model)
      model.extend(ClassMethods)

      model.send(:include, InstanceMethods)
      model.send(:include, AttrAccessible)
      model.send(:include, AttrAccessor)
      model.send(:include, Validations)
      model.send(:include, Callbacks)
    end

    module AttrAccessible
      # Hook for attr_accessible white list.
      #
      # :email, :password, :password_confirmation
      #
      # Append other attributes that must be mass-assigned in your model.
      #
      # @example
      #   include Clearance::User
      #   attr_accessible :location, :gender
      def self.included(model)
        model.class_eval do
          attr_accessible :email, :name
        end
      end
    end

    module AttrAccessor
      # Hook for attr_accessor virtual attributes.
      #
      def self.included(model)
        model.class_eval do
          
        end
      end
    end

    module Validations
      # Hook for validations.
      #
      def self.included(model)
        model.class_eval do
          validates_presence_of     :name, :email
          validates_uniqueness_of   :email, :case_sensitive => false
          validates_format_of       :email, :with => %r{.+@.+\..+}

        end
      end
    end

    module Callbacks
      # Hook for callbacks.
      #
      def self.included(model)
        model.class_eval do

        end
      end
    end

    module InstanceMethods
      
      def invited?
        !!self.invite_code && !!self.invited_at
      end
      
      def invite!
        self.invite_code = Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--#{self.email}--")
        self.invited_at = Time.now.utc
        self.save!
      end
      
      def self.find_redeemable(invite_code)
        self.find(:first, :conditions => {:redeemed_at => nil, :invite_code => invite_code})
      end
     
      def redeemed!
        self.redeemed_at = Time.now.utc
        self.save!
      end
  
    end

    module ClassMethods

    end

  end
end
