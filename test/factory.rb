module Factory
  # Build actions for the class
  def self.build(klass, &block)
    name = klass.to_s.underscore
    define_method("#{name}_attributes", block)
    
    module_eval <<-end_eval
      def valid_#{name}_attributes(attributes = {})
        #{name}_attributes(attributes)
        attributes
      end
      
      def new_#{name}(attributes = {})
        #{klass}.new(valid_#{name}_attributes(attributes))
      end
      
      def create_#{name}(*args)
        record = new_#{name}(*args)
        record.save!
        record.reload
        record
      end
    end_eval
  end
  
  build Article do |attributes|
    attributes[:author] = create_author unless attributes.include?(:author)
    attributes.reverse_merge!(
      :content => 'Thanks for visiting my blog!'
    )
  end
  
  build Author do |attributes|
    attributes.reverse_merge!(
      :name => 'John Smith'
    )
  end
  
  build Comment do |attributes|
    attributes[:commentable] = create_article unless attributes.include?(:commentable)
    attributes[:commenter] = create_user unless attributes.include?(:commenter)
  end
  
  build Page do |attributes|
    attributes[:author] = create_author unless attributes.include?(:author)
    attributes.reverse_merge!(
      :content => 'Some information about me...'
    )
  end
  
  build User do |attributes|
    attributes.reverse_merge!(
      :name => 'Mr. Bean'
    )
  end
end
