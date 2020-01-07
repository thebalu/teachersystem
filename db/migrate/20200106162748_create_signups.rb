class CreateSignups < ActiveRecord::Migration[5.1]
  def change
    create_table :signups do |t|
      t.integer :snum
      t.string :first
      t.string :last
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
