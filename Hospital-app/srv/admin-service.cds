// srv/admin-service.cds
using { hospital as db } from '../db/schema';

@requires: 'admin'
service AdminService @(path:'/admin') {
    entity Users as projection on db.Users;
    entity Doctors as projection on db.Doctors;
    entity Patients as projection on db.Patients;
    entity Departments as projection on db.Departments;
    entity Appointments as projection on db.Appointments;
    entity MedicalRecords as projection on db.MedicalRecords;
    
    type ReportOutput {
        message : String;
        status  : Integer;
    }

    action assignDoctorToDepartment(doctorId: UUID, departmentId: UUID) returns {
        message : String;
        success : Boolean;
    };
    action generateMonthlyReport() returns ReportOutput;
}
