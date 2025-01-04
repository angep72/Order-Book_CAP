// db/schema.cds
namespace sap.capire.products;

entity Products {
  key ID          : String;
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

entity Orders {
  key ID          : String;
      product_ID  : String;
      quantity    : Integer;
      status      : String;
      orderDate   : Timestamp;
      customer    : String;
      totalAmount : Decimal;
}