class AddNumberOfWinners < ActiveRecord::Migration
  def self.up
		 add_column :raffles, :number_of_winners, :integer, :null => false, :default => 1
  end

  def self.down
    remove_column :raffles, :number_of_winners
  end
end
