class AddCheckedOutAndDueDateToCheckouts < ActiveRecord::Migration[6.1]
  def change
    add_column :checkouts, :checked_out, :boolean, :default => true
    add_column :checkouts, :due_date, :date
  end
end
