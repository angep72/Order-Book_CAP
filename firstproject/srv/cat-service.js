const cds = require('@sap/cds');
const jwt = require('jsonwebtoken');

// Secret key for JWT signing (Use environment variables for production)
const SECRET_KEY = 'your_secret_key'; // Ensure to change this in production

module.exports = cds.service.impl(async function () {
    const { Products, Orders, Users } = this.entities;

    // Login action - Authenticate user and generate JWT token
    this.on('login', async req => {
        const { username, password } = req.data;

        // Dummy validation for username and password (You can use a real DB check here)
        const user = await cds.tx(req).read(Users).where({ username: username, password: password });

        if (user.length === 0) {
            return req.error(401, 'Invalid credentials');
        }

        // Create JWT token with user data (e.g., username and role)
        const token = jwt.sign({ user: username, role: 'customer' }, SECRET_KEY, { expiresIn: '1h' });

        return { message: 'Login successful', token };
    });

    // Middleware to check JWT token before submitting an order or deleting an order
    const checkAuth = async (req) => {
        const token = req.headers['authorization']?.split(' ')[1]; // Extract token from Authorization header

        if (!token) {
            return req.error(401, 'Authorization token is missing');
        }

        try {
            // Verify the token
            const decoded = jwt.verify(token, SECRET_KEY);
            req.user = decoded; // Attach decoded token data to the request object
        } catch (error) {
            return req.error(401, 'Invalid or expired token');
        }
    };

    // Submit order action (only available for authenticated users)
    this.on('submitOrder', async req => {
        // First check if the user is authenticated
        await checkAuth(req);

        const { product_ID, quantity, customer, totalamount } = req.data;
        const tx = cds.transaction(req);

        // Fetch the product from the Products entity
        const product = await tx.read(Products).where({ ID: product_ID });

        if (!product || product.length === 0) {
            return req.error(404, `Product ${product_ID} not found`);
        }

        if (product[0].stock < quantity) {
            return req.error(400, `Insufficient stock for product ${product_ID}`);
        }

        const currentStock = product[0].stock;
        const newStock = currentStock - quantity;

        const orderID = `ORD-${Math.floor(Math.random() * 1000)}`;

        try {
            // Insert the new order into the Orders entity
            await tx.run(
                INSERT.into(Orders).entries({
                    ID: orderID,
                    product_ID: product_ID,
                    quantity: quantity,
                    status: 'Created',
                    orderDate: new Date(),
                    customer: customer,
                    totalamount: totalamount
                })
            );

            // Update the product stock after placing the order
            await tx.run(
                UPDATE(Products)
                    .set({ stock: newStock })
                    .where({ ID: product_ID })
            );

            // Commit the transaction
            await tx.commit();

            return {
                orderID: orderID,
                status: 'Success'
            };
        } catch (error) {
            await tx.rollback();
            return req.error(500, `Order submission failed: ${error.message}`);
        }
    });

    // Delete order action (only available for authenticated users)
    this.on('deleteOrder', async (req) => {
        // First check if the user is authenticated
        await checkAuth(req);

        const { orderID } = req.data;
        const tx = cds.transaction(req);

        try {
            // Fetch the order from the Orders entity
            const order = await tx.read(Orders).where({ ID: orderID });

            if (!order || order.length === 0) {
                return req.error(404, `Order ${orderID} not found`);
            }

            // Fetch the product related to the order
            const product = await tx.read(Products).where({ ID: order[0].product_ID });

            if (!product || product.length === 0) {
                return req.error(404, `Product ${order[0].product_ID} not found`);
            }

            const currentStock = product[0].stock;
            const restoredStock = currentStock + order[0].quantity;

            // Delete the order from the Orders entity
            await tx.run(DELETE.from(Orders).where({ ID: orderID }));

            // Restore the product stock
            await tx.run(UPDATE(Products)
                .set({ stock: restoredStock })
                .where({ ID: product[0].ID })
            );

            // Commit the transaction
            await tx.commit();

            return { orderID: orderID, status: 'Order deleted successfully and stock restored' };
        } catch (error) {
            await tx.rollback();
            return req.error(500, `Order deletion failed: ${error.message}`);
        }
    });
});
