using {my.boostore as my } from '../db/schema';
service catalogService {
    entity Books as projection on my.Books;
    entity Authors as projection on my.Authors;
}