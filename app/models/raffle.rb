# == Schema Information
# Schema version: 2
#
# Table name: raffles
#
#  id         :integer(11)   not null, primary key
#  title      :string(150)   
#  created_on :datetime      
#

class Raffle < ActiveRecord::Base
  has_many :users
end
