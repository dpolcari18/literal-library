class Student < ActiveRecord::Base
    belongs_to :library
    has_many :checkouts
    has_many :books, through: :checkouts
end