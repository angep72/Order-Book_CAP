// db/schema.cds
namespace appointment.db;

using { managed, cuid } from '@sap/cds/common';

entity Patients : cuid, managed {
    firstName    : String(50);
    lastName     : String(50);
    email        : String(100);
    phoneNumber  : String(20);
    appointments : Composition of many Appointments on appointments.patient = $self;
}

entity Doctors : cuid, managed {
    firstName    : String(50);
    lastName     : String(50);
    speciality   : String(100);
    appointments : Composition of many Appointments on appointments.doctor = $self;
}

entity Appointments : cuid, managed {
    patient      : Association to Patients;
    doctor       : Association to Doctors;
    date         : Date;
    time         : Time;
    status       : String(20) enum {
        scheduled; cancelled; completed;
    } default 'scheduled';
    reason       : String(500);
}