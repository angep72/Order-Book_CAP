using { hospital as db } from '../db/schema';

@requires: { role: 'admin' }
service UserService @(path:'/user') {
    @readonly entity Doctors as projection on db.Doctors;
    @readonly entity Departments as projection on db.Departments;
    
    entity Appointments as projection on db.Appointments;

    action confirmAppointment(appointmentId: UUID) returns {
        success : Boolean;
        message : String;
    };
    
    action cancelAppointment(appointmentId: UUID) returns {
        success : Boolean;
        message : String;
    };
    
    action rescheduleAppointment(appointmentId: UUID, newDateTime: DateTime) returns {
        success : Boolean;
        message : String;
    };
    
    @readonly entity MedicalRecords as projection on db.MedicalRecords {
        ID,
        diagnosis,
        prescription,
        notes,
        doctor: redirected to Doctors
    };
    
    function getAvailableSlots(doctorId: UUID, date: Date) returns array of {
        startTime : Time;
        endTime   : Time;
        available : Boolean;
    };
}