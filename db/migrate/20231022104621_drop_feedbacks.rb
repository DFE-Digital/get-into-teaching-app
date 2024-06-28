class DropFeedbacks < ActiveRecord::Migration[6.0]
  def up
    drop_table :feedbacks
  end

  def down
    create_table :feedbacks do |t|
      t.integer :rating, null: false
      t.boolean :successful_visit, null: false
      t.text :unsuccessful_visit_explanation
      t.text :improvements

      t.timestamps
    end
  end
end
