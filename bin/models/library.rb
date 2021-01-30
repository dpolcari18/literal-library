class Library < ActiveRecord::Base
    has_many :librarians
    has_many :students
    has_many :books
    has_many :authors, through: :books
    has_many :genres, through: :books
    has_many :checkouts, through: :books
end