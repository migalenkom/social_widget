class AddColumnAndStateToWidgets < ActiveRecord::Migration
  def change

    add_column :widgets , :col, :integer
    add_column :widgets , :state, :boolean

  end
end
