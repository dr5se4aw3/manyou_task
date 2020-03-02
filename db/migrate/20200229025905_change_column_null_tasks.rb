class ChangeColumnNullTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :detail, false
  end
end
