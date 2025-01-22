namespace hospital;

using { managed, cuid } from '@sap/cds/common';


@assert.unique: {email: [email]}
entity Users: managed, cuid {
    firstName    : String(50) @mandatory;
    lastName     : String(50) @mandatory;
    email        : String(100) @mandatory;
    phoneNumber  : String(15);
    role         : String enum {
        admin;
        doctor;
        patient;
        staff;
    };
    password     : String(100) @mandatory @personal;
}

entity Patients : managed, cuid {
    firstName     : String(50) @mandatory;
    lastName      : String(50) @mandatory;
    dateOfBirth   : Date @mandatory;
    gender        : String enum {
        male;
        female;
        other;
    };
    email         : String(100) @mandatory;
    phoneNumber   : String(15) @mandatory;
    bloodGroup    : String(5);
    address       : {
         street  : String(60);
    city    : String(40);
    country : String(40);
    zipCode : String(10);
    };
    emergencyContact : {
        name        : String(100) @mandatory;
        phoneNumber : String(15) @mandatory;
        relation    : String(50) @mandatory;
    };
    appointments  : Association to many Appointments on appointments.patient = $self;
    medicalRecords : Association to many MedicalRecords on medicalRecords.patient = $self;
}

@assert.unique: {licenseNumber: [licenseNumber]}
entity Doctors : managed, cuid {
    firstName      : String(50) @mandatory;
    lastName       : String(50) @mandatory;
    specialization : String(100) @mandatory;
    licenseNumber  : String(20) @mandatory;
    email         : String(100) @mandatory;
    phoneNumber   : String(15) @mandatory;
    address       : {
    street  : String(60);
    city    : String(40);
    country : String(40);
    zipCode : String(10);
    };
    department    : Association to Departments @mandatory;
    availability  : Composition of many DoctorSchedule;
    appointments  : Association to many Appointments on appointments.doctor = $self;
}

entity Departments : managed, cuid {
    name        : String(100) @mandatory @assert.unique;
    description : String(500);
    head        : Association to Doctors;
    doctors     : Association to many Doctors on doctors.department = $self;
}

entity DoctorSchedule : managed, cuid {
    doctor      : Association to Doctors;
    dayOfWeek   : Integer @mandatory;  // 1=Monday, 7=Sunday
    startTime   : Time @mandatory;
    endTime     : Time @mandatory;
    maxPatients : Integer @mandatory;
}

entity Appointments : managed, cuid {
    patient      : Association to Patients;
    doctor       : Association to Doctors;
    dateTime     : DateTime @mandatory;
    status       : String enum {
        scheduled;
        confirmed;
        completed;
        cancelled;
    } ;
    type         : String enum {
        regular;
        emergency;
        followup;
    };
    symptoms     : String(1000);
    notes        : String(1000);
}

entity MedicalRecords : managed, cuid {
    patient       : Association to Patients;
    doctor        : Association to Doctors;
    diagnosis     : String(500) @mandatory;
    prescription  : String(1000);
    notes         : String(2000);
    attachments   : LargeBinary @Core.MediaType: 'application/pdf';
}

