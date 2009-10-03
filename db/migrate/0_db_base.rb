class DbBase < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
