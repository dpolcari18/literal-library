class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students, if_not_exists: true do |t|
      t.string :name
      t.string :username
      t.string :password
      t.references :library
    end
  end
end
