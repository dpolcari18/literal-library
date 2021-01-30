
Author.delete_all
Book.delete_all
Checkout.delete_all
Genre.delete_all
Librarian.delete_all
Library.delete_all
Student.delete_all



jkr = Author.create(name: "JK Rowling")
grrm = Author.create(name: "George RR Martin")

wizards = Genre.create(genre: "Wizards")
dragons = Genre.create(genre: "Dragons")

ttu = Library.create(name: "Texas Tech")
pesh = Library.create(name: "Plano East")

david = Student.create(name: "David", username: "dpolcari", password: "123", library_id: ttu.id)
evan = Student.create(name: "Evan", username: "ebillings", password: "123", library_id: ttu.id)

dorothy = Librarian.create(name: "Dotty", username: "dwhite", password: "123", library_id: ttu.id)

hp = Book.create(title: "Harry Potter", pages: 1000, library_id: ttu.id, genre_id: wizards.id, author_id: jkr.id)
got = Book.create(title: "Game of Thrones", pages: 3000, library_id: ttu.id, genre_id: dragons.id, author_id: grrm.id)

binding.pry