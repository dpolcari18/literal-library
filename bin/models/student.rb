require 'date'

class Student < ActiveRecord::Base
    belongs_to :library
    has_many :checkouts
    has_many :books, through: :checkouts

    # Student instance checks out Book instance based on title (string)
    def checkout_book(title)
        # find book instance by title
        searched_book = Book.find_by(title: title)
        # if book is available:
        if searched_book.available
            # change book.available to false
            searched_book.update_column(:available, false)
            # create Checkout instance with student id, book id, due date, checked_out defaults to true
            Checkout.create(student_id: self.id, book_id: searched_book.id, due_date: ((Date.today)+7))
        else
            # if book is not available:
            puts "Sorry this book is not avaialable at this time. Please try again later."
        end
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
        # checks to see if Student instance has book checked out
        if self.currently_checked_out_books.include?(title)
            # change book.available to true
            searched_book.update_column(:available, true)
            self.checkouts.find{|checkout| checkout.book.title == title && checkout.checked_out == true}.update_column(:checked_out, false)
        else
            puts "Sorry you don't have this book checked out."
        end
    end
end