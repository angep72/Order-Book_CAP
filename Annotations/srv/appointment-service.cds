// srv/appointment-service.cds
using appointment.db as db from '../db/schema';

@path: 'service/appointment'
service AppointmentService {
    @readonly entity Doctors as projection on db.Doctors;
    
    @insertonly entity Appointments as projection on db.Appointments;
    
    entity Patients @(restrict: [
        { grant: ['READ', 'CREATE'], to: 'authenticated-user' }
    ]) as projection on db.Patients;
    
    action cancelAppointment(appointmentId: UUID) returns Boolean;
}