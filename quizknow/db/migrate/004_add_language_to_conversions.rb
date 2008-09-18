class AddLanguageToConversions < ActiveRecord::Migration
  def self.up
    add_column :conversions, :cue_language_code, :string
    add_column :conversions, :response_language_code, :string
  end

  def self.down
    remove_column :conversions, :cue_language_code
    remove_column :conversions, :response_language_code
  end
end
