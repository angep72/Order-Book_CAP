using {my.boostore as my} from '../db/schema';

service CatalogService {
    entity Authors as projection on my.Authors;
    entity Books   as projection on my.Books;

    action create(Name : String,
                                 Age : Integer,
                                 Books : array of {
        Title : String;
        Genres : String
    });
}

