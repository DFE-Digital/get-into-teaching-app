class CreatePageModifications < ActiveRecord::Migration[7.0]
  def change
    create_table :page_modifications do |t|
      t.string :path, null: false, index: { unique: true }
      t.string :content_hash, null: false
      t.timestamps
    end
  end
end
