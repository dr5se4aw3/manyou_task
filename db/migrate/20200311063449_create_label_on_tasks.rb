class CreateLabelOnTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :label_on_tasks do |t|
      t.references :task, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
