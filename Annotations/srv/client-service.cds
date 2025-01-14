using appointment.db as db from '../db/schema';

@path: 'service/client'
@requires: 'authenticated-user'
service ClientService {
    @readonly entity Doctors as projection on db.Doctors
        where available = true;
    
    entity Appointments as projection on db.Appointments;
    
    entity Patients @(restrict: [
        { grant: ['READ', 'CREATE'], to: 'authenticated-user' }
    ]) as projection on db.Patients;
    
    action cancelAppointment(appointmentId: UUID) returns Boolean;
}