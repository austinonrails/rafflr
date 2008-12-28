class CreateRaffles < ActiveRecord::Migration
  def self.up
    create_table :raffles do |t|
      t.column :title, :string, :limit => 150
      t.column :created_on, :datetime
    end
  end

  def self.down
    drop_table :raffles
  end
end
