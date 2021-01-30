class CreateCheckouts < ActiveRecord::Migration[6.1]
  def change
    create_table :checkouts, if_not_exists: true do |t|
      t.references :student
      t.references :book
    end
  end
end
