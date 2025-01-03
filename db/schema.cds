// db/schema.cds
namespace sap.capire.products;

entity Products {
  key ID          : String;
      name        : String;
      description : String;
      stock       : Integer;
      price       : Decimal;
      currency    : String;
      category    : String;
      supplier    : String;
      rating      : Decimal;
      createdAt   : Timestamp;
}

entity Orders {
  key ID          : String;
      product_ID  : String;
      quantity    : Integer;
      status      : String;
      orderDate   : Timestamp;
      customer    : String;
      totalAmount : Decimal;
}