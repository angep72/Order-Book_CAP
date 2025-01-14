// srv/client-service.js
const cds = require('@sap/cds')

module.exports = cds.service.impl(async function() {
    const { Appointments } = this.entities
    
    this.on('cancelAppointment', async (req) => {
        const { appointmentId } = req.data
        
        const result = await UPDATE(Appointments)
            .set({ status: 'cancelled' })
            .where({ ID: appointmentId })
        
        return result > 0
    })
    
    this.before('CREATE', 'Appointments', async (req) => {
        const { date, time } = req.data
        
        // Validate appointment date is in the future
        if (new Date(`${date}T${time}`) <= new Date()) {
            req.error(400, 'Appointment must be scheduled for a future date')
        }
    })
})
