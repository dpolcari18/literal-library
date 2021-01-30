# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_30_003934) do

  create_table "authors", force: :cascade do |t|
    t.string "name"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.integer "pages"
    t.integer "library_id"
    t.integer "genre_id"
    t.integer "author_id"
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["genre_id"], name: "index_books_on_genre_id"
    t.index ["library_id"], name: "index_books_on_library_id"
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer "student_id"
    t.integer "book_id"
    t.boolean "checked_out", default: true
    t.date "due_date"
    t.index ["book_id"], name: "index_checkouts_on_book_id"
    t.index ["student_id"], name: "index_checkouts_on_student_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "genre"
  end

  create_table "librarians", force: :cascade do |t|
    t.string "name"
    t.integer "library_id"
    t.index ["library_id"], name: "index_librarians_on_library_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.integer "library_id"
    t.index ["library_id"], name: "index_students_on_library_id"
  end

end
