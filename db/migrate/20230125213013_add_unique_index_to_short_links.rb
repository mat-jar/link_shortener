class AddUniqueIndexToShortLinks < ActiveRecord::Migration[7.0]
  def change
    add_index :short_links, [:original_url, :user_id], unique: true
  end
end
