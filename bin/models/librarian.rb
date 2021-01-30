class Librarian < ActiveRecord::Base
    belongs_to :library

    # add Book instance to library with genre and author ids
    def add_book_to_library(title, author_id, library_id, genre_id, pages)
        Book.create(title: title, author_id: author_id, library_id: library_id, genre_id: genre_id, pages: pages)
    end

    # permantly removes book from library database based on title (string)
    def remove_book_from_library(title)
        Book.find_by(title: title).destroy
    end
end