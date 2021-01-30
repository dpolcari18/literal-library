class CreateLibrarians < ActiveRecord::Migration[6.1]
  def change
    create_table :librarians, if_not_exists: true do |t|
      t.string :name
      t.references :library
    end
  end
end
