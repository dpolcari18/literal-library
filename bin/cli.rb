require 'tty-prompt'

class Cli
    @@prompt = TTY::Prompt.new

    # Greet user - choose library - choose librarian or student
    def self.greet_user
        # choose library name (string)
        library = @@prompt.select("Welcome! Which library would you like to access?", Library.all.map{|libraries| libraries.name})
        # saves library instance that matches chosen library name above (instance)
        @@library = Library.find_by(name: library)
        # choose user type
        user_type = @@prompt.select("Are you a librarian or a student?", %w(Librarian Student Restart Exit Help))
        case user_type
        when "Librarian"
            self.librarian_login
        when "Student"
            self.student_login
        when "Restart"
            self.greet_user
        when "Exit"
            return
        when "Help"
            puts "At any time select Exit to close app or select Restart to go back to the beginning."
            self.greet_user
        end
    end

    def self.librarian_login
        # Ask if new or returning librarian
        new_returning = @@prompt.select("Are you clocking in for work or a new hire?", ["Clocking In", "New Hire", "Restart", "Exit"])
            case new_returning
            when "Clocking In"
                # Ask for username and make sure it is in system
                username = @@prompt.ask("Please enter your username:", required: true)
                @@librarian = Librarian.find_by(username: username)
                if @@librarian
                    # Ask for password and make sure it matches username
                    password = @@prompt.mask("Please enter your password:", required: true)
                    if @@librarian.password == password && @@librarian.library_id == @@library.id
                        # Go to librarian interface
                        puts "Welcome back to the #{@@library.name} library #{@@librarian.name}!"
                        self.librarian_interface
                    else
                        # Error handling if password doesn't match
                        puts "Password does not match our records. Please try again."
                        self.librarian_login
                    end
                else
                    # Error handling if librarian is not found
                    puts "Sorry we don't have you in our system. Please register as a new hire."
                    self.librarian_login
                end
            when "New Hire"
                # input name, username, password required to create Librarian instance
                name = @@prompt.ask("Welcome to onboarding. What is your name?", required: true)
                username = @@prompt.ask("Please create a username:", required: true)
                password = @@prompt.ask("Please create a password:", required: true)
                # uses class variabl @@library to input library id and create Student instance
                @@librarian = Librarian.create(name: name, username: username, password: password, library_id: @@library.id)
                puts "We hope you have a great first day at the #{@@library.name} library, #{name}!"
                self.librarian_interface
            when "Restart"
                self.greet_user
            when "Exit"
                return
            end
    end
 


    def self.student_login
        # Ask if new or returning student
        new_returning = @@prompt.select("Are you a new or returning student?", ["New", "Returning", "Restart", "Exit"])
            case new_returning
            when "Returning"
                # Ask for username and make sure it is in system
                username = @@prompt.ask("Please enter your username:", required: true)
                @@student = Student.find_by(username: username)
                if @@student
                    # Ask for password and make sure it matches username
                    password = @@prompt.mask("Please enter your password:", required: true)
                    if @@student.password == password && @@student.library_id == @@library.id
                        # Go to Student interface
                        puts "Welcome back to the #{@@library.name} library #{@@student.name}!"
                        self.student_interface
                    else
                        # Error handling if password doesn't match
                        puts "Password does not match our records. Please try again."
                        self.student_login
                    end
                else
                    # Error handling if student is not found
                    puts "Sorry we don't have you in our system. Please register as a new student."
                    self.student_login
                end
            when "New"
                # input name, username, password
                name = @@prompt.ask("Lets create an account for you.\n What is your name?", required: true)
                username = @@prompt.ask("Please create a username:", required: true)
                password = @@prompt.ask("Please create a password:", required: true)
                # uses class variable @@library to input library id and create Student instance
                @@student = Student.create(name: name, username: username, password: password, library_id: @@library.id)
                puts "Thanks for signing up. Enjoy the #{@@library.name} library, #{name}."
                self.student_interface
            when "Restart"
                self.greet_user
            when "Exit"
                return
            end
    end

    def self.librarian_interface
        while true
            command = @@prompt.select("What would you like to do?", ["See Available Books", "Add Book to Library", "Remove Book from Library", "See Students with Book(s) Checked Out", "Go Home for the Day"])
            case command
            when "See Available Books"
                # binding.pry
                Book.available_books.select {|books| books.library_id == @@library.id}.map {|book| puts book.title}
            when "Add Book to Library"
                puts "Ok lets add a book to the library! The students will loves this."
                # must be string
                title = @@prompt.ask("What is the title of this new book?", required: true)
                author = @@prompt.select("What is the authors name?", Author.all.map{|author| author.name})
                author_id = Author.find_by(name: author).id
                genre = @@prompt.select("What is the genre of the book?", Genre.all.map{|genre| genre.genre})
                genre_id = Genre.find_by(genre: genre).id
                # must be integer
                pages = @@prompt.ask("How many pages are in this book?", required: true)
                @@librarian.add_book_to_library(title, author_id, @@library.id, genre_id, pages)
                puts "Awesome! #{title} has been added to the #{@@library.name} library shelves for the students to enjoy."
            when "Remove Book from Library"
                puts "Ok, we're sorry you want to remove a book from our shelves."
                title = @@prompt.select("What is the title of the book you would like to remove?", Book.available_books.map {|book| book.title})
                @@librarian.remove_book_from_library(title)
                puts "Sadly, this book has been removed from the library..."
            when "See Students with Book(s) Checked Out"
                puts "The following students have books checked out: "
                @@library.see_students_with_books
            when "Go Home for the Day"
                puts "Ok have a great day #{@@librarian.name}!"
                break
            end
        end
    end

    def self.student_interface
        while true
            command = @@prompt.select("What would you like to do?", ["See Available Books", "Search Available Books by Author", "Search Available Books by Genre", "Checkout Book", "See My Books", "Return Book", "Go Home for the Day"])
            case command
            when "See Available Books"
                Book.available_books.map{|book| puts book.title}
            when "Search Available Books by Author"
            when "Search Available Books by Genre"
            when "Checkout Book"
                title = @@prompt.select("Which book would you like to checkout?", Book.available_books.map{|book| book.title})
                @@student.checkout_book(title)
            when "See My Books"
                @@student.books.map{|book| puts book.title}
            when "Return Book"
                title = @@prompt.select("Which book would you like to return?", @@student.currently_checked_out_books.map {|title| title})   
                @@student.return_book(title)
            when "Go Home for the Day"
                puts "Thanks for visiting the library! See you next time #{@@student.name}."
                break
            end
        end
    end
end