class Book < ActiveRecord::Base
    belongs_to :library
    belongs_to :author
    belongs_to :genre
    has_many :checkouts
    has_many :students, through: :checkouts
end