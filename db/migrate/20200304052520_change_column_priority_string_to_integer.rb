class ChangeColumnPriorityStringToInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :priority, :string
    add_column :tasks, :priority, :integer, default: 0, null: false
  end
end
