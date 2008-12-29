# == Schema Information
# Schema version: 20081226010020
#
# Table name: users
#
#  id        :integer(4)      not null, primary key
#  name      :string(150)     not null
#  raffle_id :integer(4)      not null
#  winner    :boolean(1)      not null
#

# == Schema Information
# Schema version: 2
#
# Table name: users
#
#  id        :integer(11)   not null, primary key
#  name      :string(150)   default(), not null
#  raffle_id :integer(11)   not null
#  winner    :boolean(1)    not null
#

class User < ActiveRecord::Base
  belongs_to :raffle
end
