using { sap.capire.products as my } from '../db/schema';

service CatalogService {
    entity Products as projection on my.Products;
    entity Orders as projection on my.Orders;
    entity Users as projection on my.Users;

    // Action definition
    action submitOrder(product_ID: String, quantity: Integer, customer:String ) returns {
        orderID: String;
        status: String;
    };
        action deleteOrder(orderID: String) returns Boolean;
        action login(username: String, password: String) returns Boolean;

        

}

