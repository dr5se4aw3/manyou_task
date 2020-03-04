class ChangeColumnPriorityOnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :priority, from: "低", to: 0
  end
end
