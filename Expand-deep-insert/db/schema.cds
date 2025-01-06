namespace my.boostore;
entity Authors{
    key ID:UUID;
    Name:String;
    Age:Integer;
    Books:Association to many Books;
}
entity Books{
    key ID:UUID;
    Title:String;
    Genres:String;
    Author:Association to Authors;
}

