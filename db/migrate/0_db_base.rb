class DbBase < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :digest_md5_nonce, :default => nil
      t.integer :digest_md5_nc, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
