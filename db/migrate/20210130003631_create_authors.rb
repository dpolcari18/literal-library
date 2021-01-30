class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors, if_not_exists: true do |t|
      t.string :name
    end
  end
end
