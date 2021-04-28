require 'tty-prompt'

class Cli
    @@prompt = TTY::Prompt.new

    # Greet user - choose library - choose librarian or student
    def self.greet_user
        # choose library name (string)
        library = @@prompt.select("\nWelcome! Which library would you like to access?\n", Library.all.map{|libraries| libraries.name})
        # saves library instance that matches chosen library name above (instance)
        @@library = Library.find_by(name: library)
        # choose user type
        user_type = @@prompt.select("\nAre you a librarian or a student?\n", %w(Librarian Student Restart Exit Help))
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
            puts "\nAt any time select Exit to close app or select Restart to go back to the beginning.\n"
            self.greet_user
        end
    end

    def self.librarian_login
        # Ask if new or returning librarian
        new_returning = @@prompt.select("\nAre you clocking in for work or a new hire?\n", ["Clocking In", "New Hire", "Restart", "Exit"])
            case new_returning
            when "Clocking In"
                # Ask for username and make sure it is in system
                username = @@prompt.ask("\nPlease enter your username:\n", required: true)
                @@librarian = Librarian.find_by(username: username)
                if @@librarian
                    # Ask for password and make sure it matches username
                    password = @@prompt.mask("Please enter your password:", required: true)
                    if @@librarian.password == password && @@librarian.library_id == @@library.id
                        # Go to librarian interface
                        puts "\nWelcome back to the #{@@library.name} library #{@@librarian.name}!\n"
                        self.librarian_interface
                    else
                        # Error handling if password doesn't match
                        puts "\nPassword does not match our records. Please try again.\n"
                        self.librarian_login
                    end
                else
                    # Error handling if librarian is not found
                    puts "\nSorry we don't have you in our system. Please register as a new hire.\n"
                    self.librarian_login
                end
            when "New Hire"
                # input name, username, password required to create Librarian instance
                name = @@prompt.ask("\nWelcome to onboarding. What is your name?\n", required: true)
                username = @@prompt.ask("\nPlease create a username:\n", required: true)
                password = @@prompt.ask("\nPlease create a password:\n", required: true)
                # uses class variabl @@library to input library id and create Student instance
                @@librarian = Librarian.create(name: name, username: username, password: password, library_id: @@library.id)
                puts "\nWe hope you have a great first day at the #{@@library.name} library, #{name}!\n"
                self.librarian_interface
            when "Restart"
                self.greet_user
            when "Exit"
                return
            end
    end
 


    def self.student_login
        # Ask if new or returning student
        new_returning = @@prompt.select("\nAre you a new or returning student?\n", ["New", "Returning", "Restart", "Exit"])
            case new_returning
            when "Returning"
                # Ask for username and make sure it is in system
                username = @@prompt.ask("\nPlease enter your username:\n", required: true)
                @@student = Student.find_by(username: username)
                if @@student
                    # Ask for password and make sure it matches username
                    password = @@prompt.mask("Please enter your password:", required: true)
                    if @@student.password == password && @@student.library_id == @@library.id
                        # Go to Student interface
                        puts "\nWelcome back to the #{@@library.name} library #{@@student.name}!\n"
                        self.student_interface
                    else
                        # Error handling if password doesn't match
                        puts "\nPassword does not match our records. Please try again.\n"
                        self.student_login
                    end
                else
                    # Error handling if student is not found
                    puts "\nSorry we don't have you in our system. Please register as a new student.\n"
                    self.student_login
                end
            when "New"
                # input name, username, password
                name = @@prompt.ask("\nLets create an account for you.\n What is your name?\n", required: true)
                username = @@prompt.ask("\nPlease create a username:\n", required: true)
                password = @@prompt.ask("\nPlease create a password:\n", required: true)
                # uses class variable @@library to input library id and create Student instance
                @@student = Student.create(name: name, username: username, password: password, library_id: @@library.id)
                puts "\nThanks for signing up. Enjoy the #{@@library.name} library, #{name}.\n"
                self.student_interface
            when "Restart"
                self.greet_user
            when "Exit"
                return
            end
    end

    def self.librarian_interface
        while true
            command = @@prompt.select("\nWhat would you like to do?\n", ["See Available Books", "Add Book to Library", "Remove Book from Library", "See Students with Book(s) Checked Out", "Go Home for the Day"])
            case command
            when "See Available Books"
                # binding.pry
                puts ''
                Book.available_books.select {|books| books.library_id == @@library.id}.map {|book| puts book.title}
            when "Add Book to Library"
                puts "\nOk lets add a book to the library! The students will loves this.\n"
                # must be string
                title = @@prompt.ask("\nWhat is the title of this new book?\n", required: true)
                
                # find or add author
                author_prompt = @@prompt.select("\nWhat is the authors name?\n", [*Author.all.map{|author| author.name}, "Not on the List? Add a new author."])
                if author_prompt == 'Not on the List? Add a new author.' 
                    author_name = @@prompt.ask("\nEnter a new authors name.\n", required: true)
                    author = Author.create(name: author_name)
                else
                    author = Author.find_by(name: author_prompt)
                end

                # find or add genre
                genre_prompt = @@prompt.select("\nWhat is the genre of the book?\n", [*Genre.all.map{|genre| genre.genre}, "Not on the list? Add a new genre."])
                if genre_prompt == 'Not on the list? Add a new genre.'
                    genre_name = @@prompt.ask("\nEnter a new genre.\n", require: true)
                    genre = Genre.create(genre: genre_name)
                else
                    genre = Genre.find_by(genre: genre)
                end

                # must be integer
                pages = @@prompt.ask("\nHow many pages are in this book?\n", required: true)
                @@librarian.add_book_to_library(title, author.id, @@library.id, genre.id, pages)
                puts "\nAwesome! #{title} has been added to the #{@@library.name} library shelves for the students to enjoy.\n"
            when "Remove Book from Library"
                puts "\nOk, we're sorry you want to remove a book from our shelves.\n"
                title = @@prompt.select("\nWhat is the title of the book you would like to remove?\n", Book.available_books.map {|book| book.title})
                @@librarian.remove_book_from_library(title)
                puts "\nSadly, this book has been removed from the library...\n"
            when "See Students with Book(s) Checked Out"
                puts "\nThe following students have books checked out: \n"
                @@librarian.students_with_books_checked_out.map {|student| puts "#{student.name} - #{student.currently_checked_out_books.length} book(s)"}
            when "Go Home for the Day"
                puts "\nOk have a great day #{@@librarian.name}!\n"
                break
            end
        end
    end

    def self.student_interface
        while true
            command = @@prompt.select("\nWhat would you like to do?\n", ["See Available Books", "Search Available Books by Author", "Search Available Books by Genre", "Checkout Book", "See My Books", "Return Book", "Go Home for the Day"])
            case command
            when "See Available Books"
                puts ''
                Book.available_books.map{|book| puts book.title}
            when "Search Available Books by Author"
                author = @@prompt.select("\nHere are all our authors: \n", Author.all.map{|author| author.name})
                puts "\nHere are all of #{author}'s books\n"
                puts ''
                Book.available_books.select{|book| book.author_id == Author.find_by(name: author).id}.map{|book| puts book.title}
            when "Search Available Books by Genre"
                genre = @@prompt.select("\nHere are all our genres: \n", Genre.all.map{|genre| genre.genre})
                puts "\nHere are all of our books in the #{genre} genre\n"
                puts ''
                Book.available_books.select{|book| book.genre_id == Genre.find_by(genre: genre).id}.map{|book| puts book.title}
            when "Checkout Book"
                title = @@prompt.select("\nWhich book would you like to checkout?\n", Book.available_books.map{|book| book.title})
                @@student.checkout_book(title)
                puts "\nEnjoy your new book!\n"
            when "See My Books"
                puts "\nHere are your books: \n"
                puts ''
                @@student.books.map{|book| puts book.title}
            when "Return Book"
                title = @@prompt.select("\nWhich book would you like to return?\n", @@student.currently_checked_out_books.map {|title| title})   
                puts "\nThanks for returning #{title}.\n"
                @@student.return_book(title)
            when "Go Home for the Day"
                puts "\nThanks for visiting the library! See you next time #{@@student.name}.\n"
                break
            end
        end
    end
end