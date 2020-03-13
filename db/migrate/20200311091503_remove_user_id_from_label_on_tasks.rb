class RemoveUserIdFromLabelOnTasks < ActiveRecord::Migration[5.2]
  def change
    remove_index :label_on_tasks, :user_id
    remove_reference :label_on_tasks, :user
    add_reference :label_on_tasks, :label, foreign_key: true
  end
end
