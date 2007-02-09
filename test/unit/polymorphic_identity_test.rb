require File.dirname(__FILE__) + '/../test_helper'

class PolymorphicIdentityTest < Test::Unit::TestCase
  fixtures :authors, :articles, :pages, :users, :comments
  
  def test_no_value
    ([Comment.new] + Comment.find(:all)).each do |c|
      c.commentable = nil if c.commentable
      c.commenter = nil if c.commenter
      
      assert !c.respond_to?(:article)
      assert !c.respond_to?(:page)
      assert !c.respond_to?(:author)
      assert !c.respond_to?(:user)
    end
  end
  
  def test_existing_value
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
  
  def test_change_value
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