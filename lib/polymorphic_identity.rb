module PluginAWeek
  # Adds dynamic attributes for polymorphic associations based on the name of
  # the class for the polymorphic record.  For example,
  # 
  #   class Tag < ActiveRecord::Base
  #     belongs_to :taggable, :polymorphic => true
  #   end
  #   
  #   class Article < ActiveRecord::Base
  #     has_many :tags, :as => :taggable
  #   end
  #   
  #   >> t = Tag.find(1)
  #   => #<Tag:0xb784d32c @attributes={"id"=>"1", "taggable_type"=>"Article", "taggable_id"=>"1"}>
  #   >> t.taggable
  #   => #<Article:0xb779d5a8 @attributes={"id"=>"1"}>
  #   >> t.article
  #   => #<Article:0xb779d5a8 @attributes={"id"=>"1"}>
  module PolymorphicIdentity
    def self.included(base) #:nodoc:
      base.class_eval do
        alias_method_chain :method_missing, :polymorphic_identity
        alias_method_chain :respond_to?, :polymorphic_identity
      end
    end
    
    def method_missing_with_polymorphic_identity(method_id, *args, &block) #:nodoc:
      if association_name = find_polymorphic_association_name(method_id)
        send(association_name, *args, &block)
      else
        method_missing_without_polymorphic_identity(method_id, *args, &block)
      end
    end
    
    # True if a polymorphic association can be found whose foreign type is set
    # to the name of the method
    def respond_to_with_polymorphic_identity?(method, include_priv = false) #:nodoc:
      respond_to_without_polymorphic_identity?(method, include_priv) || !find_polymorphic_association_name(method).nil?
    end
    
    private
      # Finds the name of the polymorphic association whose foreign type is set to
      # the value specified.
      def find_polymorphic_association_name(foreign_type_value)
        foreign_type_value = foreign_type_value.to_s.camelize
        reflection = self.class.reflections.values.find do |reflection|
          reflection.options[:polymorphic] && self[reflection.options[:foreign_type]] == foreign_type_value
        end
        
        reflection ? reflection.name : nil
      end
  end
end

ActiveRecord::Base.class_eval do
  include PluginAWeek::PolymorphicIdentity
end
