class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.text :title
      t.text :original
      t.text :words, :default => {}
      t.text :exceptions, :default => []
      t.string :url
      t.integer :count

      t.timestamps
    end
  end
end
