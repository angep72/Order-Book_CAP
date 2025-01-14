// srv/admin-service.cds
using appointment.db as db from '../db/schema';

@path: 'service/admin'
@requires: 'admin'
service AdminService {
    entity Doctors as projection on db.Doctors;
    
    @readonly entity Appointments as projection on db.Appointments {
        *,
        patient: redirected to Patients
    };
    
    @readonly entity Patients as projection on db.Patients;
}
