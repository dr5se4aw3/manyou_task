class AddColumnPriorityOnTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :string, null: false, default: '低'
  end
end
