# == Schema Information
# Schema version: 20081226010020
#
# Table name: raffles
#
#  id                :integer(4)      not null, primary key
#  title             :string(150)
#  created_on        :datetime
#  number_of_winners :integer(4)
#
class Raffle < ActiveRecord::Base
  has_many :users
  has_many :winners, :class_name => 'User', :conditions=>['winner = ?', true]
  
  validates_uniqueness_of :title
  validates_presence_of :title, :number_of_winners, :users
  validates_numericality_of :number_of_winners, :only_integer => true, :greater_than => 0
  
  validate do |raffle| 
    raffle.errors.add(:number_of_winners, "must be less than number of participants") if raffle.number_of_winners.to_i > 0 and raffle.users.size <= raffle.number_of_winners.to_i
  end
  
  validate do |raffle| 
    raffle.errors.add(:users, "must not contain duplicate entries") if raffle.users.collect { |user| user.name }.uniq.size < raffle.users.size
  end
  
end
