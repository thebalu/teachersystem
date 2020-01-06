class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :description
      t.string :location
      t.datetime :when
      t.references :course_id, foreign_key: true

      t.timestamps
    end
  end
end
