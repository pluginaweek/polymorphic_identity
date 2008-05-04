require File.dirname(__FILE__) + '/../test_helper'

class PolymorphicIdentityTest < Test::Unit::TestCase
  def setup
    @comment = Comment.new
    @comment.commenter_type = 'Article'
  end
  
  def test_should_find_polymorphic_association_name_for_valid_symbolized_association
    assert_equal :commenter, @comment.send(:find_polymorphic_association_name, :article)
  end
  
  def test_should_find_polymorphic_association_name_for_valid_stringified_association
    assert_equal :commenter, @comment.send(:find_polymorphic_association_name, 'article')
  end
  
  def test_should_not_find_polymorphic_association_name_for_invalid_association
    assert_equal nil, @comment.send(:find_polymorphic_association_name, 'page')
  end
end

class PolymorphicAssociationWithNoValueTest < Test::Unit::TestCase
  def setup
    @comment = create_comment(:commentable => nil, :commenter => nil)
  end
  
  def test_should_not_respond_to_polymorphic_association_name
    assert !@comment.respond_to?(:article)
    assert !@comment.respond_to?(:page)
    assert !@comment.respond_to?(:author)
    assert !@comment.respond_to?(:user)
  end
end

class PolymorphicAssociationsWithValueTest < Test::Unit::TestCase
  def setup
    @author = create_author
    @article = create_article(:author => @author)
    @comment = create_comment(:commentable => @article, :commenter => @author)
  end
  
  def test_should_respond_to_polymorphic_association_name_if_association_exists
    assert @comment.respond_to?(:article)
    assert @comment.respond_to?(:author)
    assert_equal @article, @comment.article
    assert_equal @author, @comment.author
  end
  
  def test_should_update_response_when_changing_polymorphic_association
    page = create_page
    user = create_user
    
    @comment.commentable = page
    @comment.commenter = user
    
    assert !@comment.respond_to?(:article)
    assert !@comment.respond_to?(:author)
    assert @comment.respond_to?(:page)
    assert @comment.respond_to?(:user)
    assert_equal page, @comment.page
    assert_equal user, @comment.user
  end
end
