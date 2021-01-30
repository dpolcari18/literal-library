class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres, if_not_exists: true do |t|
      t.string :genre
    end
  end
end
