
class CreateAuthtokens < ActiveRecord::Migration

  def self.up
    create_table :authtokens do |t|
      t.string :username, :null => false
      t.string :token, :null => false
      t.string :secret, :null => false
    end
    add_index :authtokens, :username, :unique => true
  end

  def self.down
    drop_table :authtokens
  end
end
