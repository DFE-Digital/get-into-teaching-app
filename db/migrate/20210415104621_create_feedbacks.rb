class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.integer :rating, null: false
      t.boolean :successful_visit, null: false
      t.text :unsuccessful_visit_explanation
      t.text :improvements

      t.timestamps
    end
  end
end
