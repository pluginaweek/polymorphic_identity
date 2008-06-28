module Factory
  # Build actions for the model
  def self.build(model, &block)
    name = model.to_s.underscore
    
    define_method("#{name}_attributes", block)
    define_method("valid_#{name}_attributes") {|*args| valid_attributes_for(model, *args)}
    define_method("new_#{name}")              {|*args| new_record(model, *args)}
    define_method("create_#{name}")           {|*args| create_record(model, *args)}
  end
  
  # Get valid attributes for the model
  def valid_attributes_for(model, attributes = {})
    name = model.to_s.underscore
    send("#{name}_attributes", attributes)
    attributes
  end
  
  # Build an unsaved record
  def new_record(model, *args)
    model.new(valid_attributes_for(model, *args))
  end
  
  # Build and save/reload a record
  def create_record(model, *args)
    record = new_record(model, *args)
    record.save!
    record.reload
    record
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
