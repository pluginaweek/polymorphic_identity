module PluginAWeek
  # 
  module PolymorphicIdentity
    def self.included(base)
      base.class_eval do
        alias_method_chain :method_missing, :polymorphic_identity
        alias_method_chain :respond_to?, :polymorphic_identity
      end
    end
    
    def method_missing_with_polymorphic_identity(method_id, *args, &block) #:nodoc:
      polymorphic_reflection = self.class.reflections.values.find do |reflection|
        reflection.options[:polymorphic] && read_attribute(reflection.options[:foreign_type]) == method_id.to_s.camelize
      end
      
      if polymorphic_reflection
        send(polymorphic_reflection.name, *args, &block)
      else
        method_missing_witouth_polymorphic_identity(method_id, *args, &block)
      end
    end
    
    def respond_to_with_polymorphic_identity?(method, include_priv = false) #:nodoc:
      return true if respond_to_without_polymorphic_identity?(method, include_priv)
      
      self.class.reflections.values.detect do |reflection|
        reflection.options[:polymorphic] && read_attribute(reflection.options[:foreign_type]) == method.to_s.camelize
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include PluginAWeek::PolymorphicIdentity
end