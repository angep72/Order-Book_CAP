const cds = require('@sap/cds');

module.exports = class UserService extends cds.ApplicationService {
    async init() {
        const { MedicalRecords } = this.entities;

        // Handle READ of MedicalRecords
        this.before('READ', 'MedicalRecords', async (req) => {
            const user = req.user;
            if (!user) return req.reject(403, 'Not authorized');

            // Get user's email from the authenticated context
            const userEmail = user.id;  // or user.email depending on your auth setup

            // Modify the query to filter records based on user's email
            req.query.where('patient.email =', userEmail);
        });

        await super.init();
    }
}