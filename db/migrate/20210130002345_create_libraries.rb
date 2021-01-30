class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries, if_not_exists: true do |t|
      t.string :name
    end
  end
end
