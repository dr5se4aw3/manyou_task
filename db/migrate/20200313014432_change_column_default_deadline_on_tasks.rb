class ChangeColumnDefaultDeadlineOnTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :deadline, from: -> {'NOW()'}, to: -> {%Q(CURRENT_DATE + interval '1day')}
  end
end
