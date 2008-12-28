ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  def assert_invalid(model, attribute, *values)
    if values.empty?
      assert ! model.valid?, "Object is valid with value: #{model.send(attribute)}"
      assert ! model.save, "Object saved."
      assert model.errors.invalid?(attribute.to_s), "#{attribute} has no attached error"
    else
      values.flatten.each do |value|
        obj = model.dup
        obj.send("#{attribute}=", value)
        assert_invalid obj, attribute
      end
    end
  end

  def assert_valid(model, attribute=nil, *values)
    if values.empty?
      unless attribute.nil?
        assert model.valid?, "Object is not valid with value: #{model.send(attribute)}"
      else
        assert model.valid?, model.errors.full_messages
      end
      assert model.errors.empty?, model.errors.full_messages
    else
      m = model.dup # the recursion was confusing mysql
      values.flatten.each do |value|
        obj = m.dup
        obj.send("#{attribute}=", value)
        assert_valid(obj, attribute)
      end
    end
  end
  
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def string_with_length(x)
    (0..x).to_a[0,(x+1)].join
  end
  
  def assert_page_title_assigns_and_success(*assigns_names)
    assert assigns(:page_title), 'page_title should exist'
    assert_response :success, 'response should be success'
    assigns_names.each {|a| assert assigns(a), "#{a} should exist"}
  end
end
