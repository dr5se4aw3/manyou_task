class ChangeDefaultDeadlineOnTask < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :deadline, :date, default: -> {'NOW()'}
  end
end
