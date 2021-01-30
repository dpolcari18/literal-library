class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books, if_not_exists: true do |t|
      t.string :title
      t.integer :pages
      t.references :library
      t.references :genre
      t.references :author
    end
  end
end
