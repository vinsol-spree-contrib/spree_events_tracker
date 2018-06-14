class CreateSpreeArchivedCartEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_archived_cart_events do |t|
      t.belongs_to :actor, polymorphic: true, index: true
      t.belongs_to :target, polymorphic: true, index: true
      t.string :activity
      t.text :referrer
      t.integer :quantity
      t.decimal :total, precision: 16, scale: 4
      t.string :session_id
      t.belongs_to :variant, index: true
      t.timestamps null: false
    end
  end
end
