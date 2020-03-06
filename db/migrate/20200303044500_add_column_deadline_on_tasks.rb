class AddColumnDeadlineOnTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :date, null: false, default: '1000-01-01'
  end
end
