class DbBase < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :password, :null => false
      t.string :digest_md5_nonce, :default => nil
      t.integer :digest_md5_nc, :null => false, :default => 0

      t.timestamps
    end
    
    create_table :roster_groups do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false
      
      t.timestamps
    end
    
    create_table :roster_entries do |t|
      t.integer :roster_group_id, :null => false
      t.string :jid, :null => false
      t.string :name
      t.integer :subscription, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
    drop_table :roster_groups
    drop_table :roster_entries
  end
end
