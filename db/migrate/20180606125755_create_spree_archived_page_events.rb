class CreateSpreeArchivedPageEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_archived_page_events do |t|
      t.belongs_to :actor, polymorphic: true, index: true
      t.belongs_to :target, polymorphic: true, index: true
      t.string :activity
      t.text :referrer
      t.string :search_keywords
      t.string :session_id
      t.text :query_string
      t.timestamps null: false
    end
  end
end
