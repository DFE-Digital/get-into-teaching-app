class AddAreaToFeedback < ActiveRecord::Migration[7.0]
  def change
    change_table :feedbacks, bulk: true do |t|
      t.string :area
    end
    change_column_default :feedbacks, :successful_visit, from: false, to: true
  end
end
