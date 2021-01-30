class AddUsernamePasswordToLibrarians < ActiveRecord::Migration[6.1]
  def change
    add_column :librarians, :username, :string
    add_column :librarians, :password, :string
  end
end
