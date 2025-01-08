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

entity Orders {
  key ID          : String;@assert.unique
      product_ID  : String;@assert.notNull
      quantity    : Integer;@mandatory
      status      : String;
      orderDate   : Timestamp;
      customer    : String;@mandatory
      totalAmount : Decimal;
}