const cds = require('@sap/cds')

class AdminService extends cds.ApplicationService {
    async init() {
        const { 
            Appointments, 
            Doctors, 
            Departments 
        } = this.entities

        this.before('CREATE', 'Doctors', async (req) => {
            const { licenseNumber } = req.data
            const exists = await SELECT.one.from(Doctors).where({ licenseNumber })
            if (exists) throw new Error(`Doctor with license ${licenseNumber} already exists`)
        })

        this.on('assignDoctorToDepartment', async (req) => {
            const { doctorId, departmentId } = req.data
            await UPDATE(Doctors).set({ department_ID: departmentId }).where({ ID: doctorId })
            return 'Doctor assigned successfully'
        })

        this.on('generateMonthlyReport', async () => {
            // Report generation logic
            return 'Report generated successfully'
        })

        await super.init()
    }
}

module.exports = AdminService