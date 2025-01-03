const cds = require('@sap/cds')

module.exports = cds.service.impl(async function() {
    // Get the service entities (Products and Orders from the model)
    const { Products, Orders } = this.entities

    // Implement the submitOrder action
    this.on('submitOrder', async req => {
        const { product_ID, quantity } = req.data
        
        // Start a transaction
        const tx = cds.transaction(req)

        // Fetch the product from the database (actual Products entity)
        const product = await tx.read(Products).where({ ID: product_ID })
        
        // Validate product existence
        if (!product || product.length === 0) {
            return req.error(404, `Product ${product_ID} not found`)
        }

        // Check stock availability
        if (product[0].stock < quantity) {
            return req.error(400, `Insufficient stock for product ${product_ID}`)
        }

        const currentStock = product[0].stock
        const newStock = currentStock - quantity

        // Create a new order with a generated orderID
        const orderID = `ORD-${Math.floor(Math.random() * 1000)}`

        try {
            // Insert the new order into the Orders entity
            await tx.run(
                INSERT.into(Orders).entries({
                    ID: orderID,
                    product_ID: product_ID,
                    quantity: quantity,
                    status: 'Created'
                })
            )

            // Update the product stock after placing the order
            await tx.run(
                UPDATE(Products)
                    .set({ stock: newStock })  // Decrease the stock
                    .where({ ID: product_ID })  // Update the stock of the ordered product
            ) 
            console.log(newStock)

            // Commit the transaction
            await tx.commit()
            console.log('Product:', product);
            console.log('Current Stock:', currentStock);
            console.log('New Stock:', newStock);
            
            // Return order confirmation
            return {
                orderID: orderID,
                status: 'Success'
            }
        } catch (error) {
            // Rollback transaction in case of an error
            await tx.rollback()
            return req.error(500, `Order submission failed: ${error.message}`)
        }
    })
})
