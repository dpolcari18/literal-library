class Book < ActiveRecord::Base
    belongs_to :library
    belongs_to :author
    belongs_to :genre
    has_many :checkouts
    has_many :students, through: :checkouts

    def self.available_books
        self.all.select {|book| book.available == true}.map{|title| title.title}
    end
end