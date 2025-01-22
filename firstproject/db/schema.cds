// db/schema.cds
namespace sap.capire.products;

entity Products {
  key ID          : String;@assert.unique
      name        : String; @mandatory
      description : String;@mandatory
      stock       : Integer;@mandatory
      price       : Decimal;@mandatory
      currency    : String;@mandatory
      category    : String;@mandatory
      supplier    : String;@mandatory
      rating      : Decimal;@mandatory
      createdAt   : Timestamp;
      
}

entity Users {
        key ID: Integer;
        username: String;
        password: String;
    }

entity Orders {
  key ID          : String;@mandatory
      product_ID  : String;
      quantity    : Integer;
      status      : String;
      orderDate   : Timestamp;
      customer    : String;
      totalAmount : Decimal;
}