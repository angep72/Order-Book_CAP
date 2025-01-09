namespace hospital;

entity Patients {
  key patientId : UUID;
  firstName    : String;
  lastName     : String;
  dateOfBirth  : Date;
  gender      : String;
  email       : String;
  phone       : String;
  address     : String;
  appointments: Association to many Appointments on appointments.patient = $self;
}
entity Appointments {
  key appointmentId : UUID;
  patient         : Association to Patients;
  dateTime        : DateTime;
  reason          : String;
  status          : String enum {
    PENDING;
    ACCEPTED;
    REJECTED;
  } default 'PENDING';
  notes           : String;
}