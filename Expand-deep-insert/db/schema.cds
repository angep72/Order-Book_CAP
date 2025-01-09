namespace my.bookstore;

entity Authors {
    key ID   : UUID;
        Name : String(100);
        Age  : Integer;
        Books: Composition of many Books on Books.Author = $self;
}

entity Books {
    key ID    : UUID;
        Title : String(200);
        Genres: String(100);
        Author: Association to Authors;
}