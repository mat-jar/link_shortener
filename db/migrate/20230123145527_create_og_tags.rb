class CreateOgTags < ActiveRecord::Migration[7.0]
  def change
    create_table :og_tags do |t|
      t.string :property, null: false
      t.string :content, null: false
      t.references :short_link, null: false, foreign_key: true

      t.timestamps
    end
    add_index :og_tags, [:property, :short_link_id], unique: true
  end
end
