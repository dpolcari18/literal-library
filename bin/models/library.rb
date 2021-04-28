class Library < ActiveRecord::Base
    has_many :librarians
    has_many :students
    has_many :books
    has_many :authors, through: :books
    has_many :genres, through: :books
    has_many :checkouts, through: :books

    def see_students_with_books
        self.students.select{|student| student.books.length != 0}.map{|student| puts student.name}
    end
end