class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :title

      t.belongs_to :user
      t.belongs_to :authorization

      t.timestamps null: false
    end
  end
end
