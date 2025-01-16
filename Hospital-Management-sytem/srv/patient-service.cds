using { hospital } from '../db/schema';

service PatientManagementService {
  @requires:'Admin'
  @restrict:[{grant:'READ'}]
  entity Patients as projection on hospital.Patients;
  @requires:'authenticated-user'
  entity Appointments as projection on hospital.Appointments;

  action registerPatient(
    firstName: String,
    lastName: String,
    dateOfBirth: Date,
    gender: String,
    email: String,
    phone: String,
    address: String
  ) returns Patients;

  action bookAppointment(
    patientId: UUID,
    dateTime: DateTime,
    reason: String
  ) returns Appointments;

  action updateAppointmentStatus(
    appointmentId: UUID,
    status: String
  ) returns Appointments;
}