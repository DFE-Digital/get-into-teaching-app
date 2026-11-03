# This migration comes from stored_session (originally 20241103224006)
class CreateStoredSessions < ActiveRecord::Migration[7.2]
  def change
    config = Rails.configuration.generators
    primary_key_type = config.options.dig(config.orm, :primary_key_type) || :primary_key

    create_table :stored_sessions, id: primary_key_type do |t|
      t.timestamps
      t.string :sid, null: false, index: { unique: true }
      t.binary :data, limit: 536870912

      t.index :created_at
      t.index :updated_at
    end
  end
end
