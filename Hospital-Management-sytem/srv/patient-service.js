const cds = require('@sap/cds');
module.exports = async (srv) => {
  const { Patients, Appointments } = srv.entities;

  srv.on('registerPatient', async (req) => {
    const { firstName, lastName, dateOfBirth, gender, email, phone, address } = req.data;
    
    const patient = {
      patientId: UUID.random(),
      firstName,
      lastName,
      dateOfBirth,
      gender,
      email,
      phone,
      address
    };

    return await cds.transaction(req).run(
      INSERT.into(Patients).entries(patient)
    );
  });

  srv.on('bookAppointment', async (req) => {
    const { patientId, dateTime, reason } = req.data;
    
    const appointment = {
      appointmentId: UUID.random(),
      patient_patientId: patientId,
      dateTime,
      reason,
      status: 'PENDING'
    };

    return await cds.transaction(req).run(
      INSERT.into(Appointments).entries(appointment)
    );
  });

  srv.on('updateAppointmentStatus', async (req) => {
    const { appointmentId, status } = req.data;
    
    if (!['PENDING', 'ACCEPTED', 'REJECTED'].includes(status)) {
      req.error(400, 'Invalid status value');
    }

    return await cds.transaction(req).run(
      UPDATE(Appointments)
        .set({ status: status })
        .where({ appointmentId: appointmentId })
    );
  });
}