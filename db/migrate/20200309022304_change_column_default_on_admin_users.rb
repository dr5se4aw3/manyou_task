class ChangeColumnDefaultOnAdminUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :admin, :boolean, default: false, null: false
  end
end
