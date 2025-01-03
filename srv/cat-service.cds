using { sap.capire.products as my } from '../db/schema';

service CatalogService {
    entity Products as projection on my.Products;
    entity Orders as projection on my.Orders;

    // Action definition
    action submitOrder(product_ID: String, quantity: Integer) returns {
        orderID: String;
        status: String;
    };
}