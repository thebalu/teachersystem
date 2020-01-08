class AddEndTimeToSession < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :ends, :datetime
  end
end
