const cds = require('@sap/cds')

module.exports = cds.service.impl(async function() {
    const { Doctors } = this.entities
    
    this.before('CREATE', 'Doctors', async (req) => {
        const { email } = req.data
        
        // Check for duplicate email
        const exists = await SELECT.from(Doctors).where({ email })
        if (exists.length) {
            req.error(400, 'Doctor with this email already exists')
        }
    })
})