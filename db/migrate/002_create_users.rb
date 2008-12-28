class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name, :string, :limit => 150, :null => false
      t.column :raffle_id, :integer, :null => false
      t.column :winner, :boolean, :null => false, :default => false
    end
  end

  def self.down
    drop_table :users
  end
end
