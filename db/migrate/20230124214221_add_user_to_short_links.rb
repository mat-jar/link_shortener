class AddUserToShortLinks < ActiveRecord::Migration[7.0]
  def change
    add_reference :short_links, :user, null: false, foreign_key: true
  end
end
