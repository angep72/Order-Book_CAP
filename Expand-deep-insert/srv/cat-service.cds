using my.bookstore as my from '../db/schema';

service CatalogService {
    entity Authors as projection on my.Authors actions {
        action addBook(title: String, genres: String) returns Books;
    };
    entity Books  as projection on my.Books;
}

