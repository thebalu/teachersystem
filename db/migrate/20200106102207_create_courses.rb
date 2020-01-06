class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :ctype
      t.text :description
      t.decimal :ects, scale: 2, precision: 4
      t.integer :limit

      t.timestamps
    end
  end
end
