class CreateSpreeArchivedCheckoutEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_archived_checkout_events do |t|
      t.belongs_to :actor, polymorphic: true, index: false
      t.belongs_to :target, polymorphic: true, index: false
      t.string :activity
      t.text :referrer
      t.string :previous_state
      t.string :next_state
      t.string :session_id
      t.timestamps null: false
    end

    add_index :spree_archived_checkout_events, [:actor_id, :actor_type], name: 'index_spree_archived_checkout_event_on_actor_id_actor_type'
    add_index :spree_archived_checkout_events, [:target_id, :target_type], name: 'index_spree_archived_checkout_event_on_target_id_target_type'
  end
end
