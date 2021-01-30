require 'date'

class Student < ActiveRecord::Base
    belongs_to :library
    has_many :checkouts
    has_many :books, through: :checkouts

    # Student instance checks out Book instance based on title (string)
    def checkout_book(title)
        # find book instance by title
        searched_book = Book.find_by(title: title)
        # change book.available to false
        searched_book.update_column(:available, false)
        # create Checkout instance with student id, book id, due date, checked_out defaults to true
        Checkout.create(student_id: self.id, book_id: searched_book.id, due_date: ((Date.today)+7))
    end

    # Student instance sees list of book titles that are currently checked out
    def currently_checked_out_books
        # Select all checkouts that are active (checked out) and returns array of titles (strings)
        self.checkouts.select {|check_outs| check_outs.checked_out == true}.map{|books| books.book.title}
    end

    # Student instance returns Book instance based on title (string)
    def return_book(title)
        # find book instance by title
        searched_book = Book.find_by(title: title)
        # change book.available to true
        searched_book.update_column(:available, true)
        # checks to see if title is in checkouts and .checked_out == true then changes checkout.checked_out to false
        self.checkouts.find{|checkout| checkout.book.title == title && checkout.checked_out == true}.update_column(:checked_out, false)
    end
end