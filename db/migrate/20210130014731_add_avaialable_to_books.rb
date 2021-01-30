class AddAvaialableToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :available, :boolean, :default => true
  end
end
