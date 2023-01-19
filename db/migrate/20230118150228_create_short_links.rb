class CreateShortLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :short_links do |t|
      t.string :original_url, null: false
      t.string :slug, null: false, index: { unique: true }
      t.integer :use_counter, default: 0
      t.integer :last_use
      t.timestamps
    end
  end
end
