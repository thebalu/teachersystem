class AddFieldsToTeacher < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :tnum, :integer
    add_column :teachers, :first, :string
    add_column :teachers, :last, :string
    add_column :teachers, :office, :string
  end
end
