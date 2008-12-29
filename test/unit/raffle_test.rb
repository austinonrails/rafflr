require File.dirname(__FILE__) + '/../test_helper'

class RaffleTest < Test::Unit::TestCase
  should_have_many :users
  should_require_unique_attributes :title
  should_require_attributes :number_of_winners
  should_only_allow_numeric_values_for :number_of_winners
  
  context "A Raffl instance" do
    setup do
      @raffl = raffles(:one)
    end

    should "return its title" do
      assert_equal 'First Raffl', @raffl.title
    end 
    
    should "return its number of winners" do
      assert_equal 1, @raffl.number_of_winners
    end
    
    should "have at least one participant" do
       r = Raffle.create({ :title => 'lotto', :number_of_winners => 1 })
       assert_equal "can't be blank", r.errors.on(:users)
       r.users << User.new({ :name => 'User 1' })
       r.users << User.new({ :name => 'User 2' })
       assert_valid r
    end
    
    should "have at least one potential winner" do
      r = Raffle.create({ :title => 'lotto', :number_of_winners => 0})
      assert_equal "must be greater than 0", r.errors.on(:number_of_winners)
      r.users << User.new({ :name => 'User 1' })
      r.users << User.new({ :name => 'User 2' })
      r.update_attributes({ :number_of_winners => 1})
      assert_valid r
      r.update_attributes({ :number_of_winners => 0})
      assert_equal "must be greater than 0", r.errors.on(:number_of_winners)
    end
    
    should "have more participants than potential winners" do
      r = Raffle.create({:title => 'lotto', :number_of_winners => 2})
      r.users << User.new({ :name => 'User 1' })
      assert_equal "must be less than number of participants", r.errors.on(:number_of_winners)
      r.users << User.new({ :name => 'User 2' })
      assert_equal "must be less than number of participants", r.errors.on(:number_of_winners)
      r.users << User.new({ :name => 'User 3' })
      assert_valid r
      r.update_attributes({:number_of_winners => 3})
      assert_equal "must be less than number of participants", r.errors.on(:number_of_winners)
      r.update_attributes({:number_of_winners => 1})
      assert_valid r
    end
    
    should "not have duplicate participants" do
      r = Raffle.create({:title => 'lotto', :number_of_winners => 1})
      r.users << User.new({ :name => 'User 1' })
      r.users << User.new({ :name => 'User 2' })
      r.users << User.new({ :name => 'User 1' })
      r.save
      assert_equal "must not contain duplicate entries", r.errors.on(:users)
      r.users.last.name = 'I meant User 3 of course'
      r.save
      assert_valid r
    end
    
  end
end