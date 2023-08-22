class RenameAreaColumnToTopic < ActiveRecord::Migration[7.0]
  def change
    rename_column :feedbacks, :area, :topic
  end
end
