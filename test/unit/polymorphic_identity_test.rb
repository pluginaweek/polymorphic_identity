require File.dirname(__FILE__) + '/../test_helper'

class PolymorphicIdentityTest < Test::Unit::TestCase
  fixtures :authors, :articles, :pages, :users, :comments
  
  def test_should_find_polymorphic_association_name_for_valid_symbolized_association
    c = Comment.new
    c.commenter_type = 'Article'
    assert_equal :commenter, c.send(:find_polymorphic_association_name, :article)
  end
  
  def test_should_find_polymorphic_association_name_for_valid_stringified_association
    c = Comment.new
    c.commenter_type = 'Article'
    assert_equal :commenter, c.send(:find_polymorphic_association_name, 'article')
  end
  
  def test_should_not_find_polymorphic_association_name_for_invalid_association
    c = Comment.new
    c.commenter_type = 'Article'
    assert_equal nil, c.send(:find_polymorphic_association_name, 'page')
  end
  
  def test_should_not_respond_to_polymorhic_association_name_if_association_is_nil
    ([Comment.new] + Comment.find(:all)).each do |c|
      c.commentable = nil if c.commentable
      c.commenter = nil if c.commenter
      
      assert !c.respond_to?(:article)
      assert !c.respond_to?(:page)
      assert !c.respond_to?(:author)
      assert !c.respond_to?(:user)
    end
  end
  
  def test_should_respond_to_polymorphic_association_name_if_association_exists
    c = comments(:article_test_author_john_doe)
    assert c.respond_to?(:article)
    assert c.respond_to?(:author)
    assert_equal articles(:test), c.article
    assert_equal authors(:john_doe), c.author
    
    c = comments(:page_about_user_anonymous)
    assert c.respond_to?(:page)
    assert c.respond_to?(:user)
    assert_equal pages(:about), c.page
    assert_equal users(:anonymous), c.user
  end
  
  def test_should_update_response_when_changing_polymorphic_association
    c = comments(:article_test_author_john_doe)
    c.commentable = pages(:about)
    c.commenter = users(:anonymous)
    
    assert !c.respond_to?(:article)
    assert !c.respond_to?(:author)
    assert c.respond_to?(:page)
    assert c.respond_to?(:user)
    assert_equal pages(:about), c.page
    assert_equal users(:anonymous), c.user
  end
end
