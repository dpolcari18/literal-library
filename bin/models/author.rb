class Author < ActiveRecord::Base
    has_many :books
    has_many :genres, through: :books
end