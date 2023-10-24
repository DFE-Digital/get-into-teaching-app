class CreateUserFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_feedbacks do |t|
      t.string :topic, null: false
      t.integer :rating, null: false
      t.text :explanation

      t.timestamps
    end
  end
end
