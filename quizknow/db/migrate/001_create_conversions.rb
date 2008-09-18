class CreateConversions < ActiveRecord::Migration
  def self.up
    create_table :conversions do |t|
      t.string  :quizlet_url
      t.string  :quizlet_name
      t.string  :quizlet_description
      t.integer :iknow_list_id
      t.text    :quizlet_definitions
      t.string  :iknow_username
      t.timestamps
    end
  end

  def self.down
    drop_table :conversions
  end
end
