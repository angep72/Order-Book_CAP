const cds = require('@sap/cds');

module.exports = async (srv) => {
  const { Patients, Appointments } = srv.entities;

  // Handle patient registration
  srv.on('registerPatient', async (req) => {
    try {
      const { firstName, lastName, dateOfBirth, gender, email, phone, address } = req.data;
      
      // Create a patient object with a UUID
      const patient = {
        patientId: cds.UUID,  // Generate a new UUID
        firstName,
        lastName,
        dateOfBirth,
        gender,
        email,
        phone,
        address
      };

      // Insert the new patient into the database
      await cds.transaction(req).run(
        INSERT.into(Patients).entries(patient)
      );

      // Return a success message after successfully registering the patient
      return { message: 'Patient registered successfully', patientId: patient.patientId };

    } catch (err) {
      // Handle any errors that occur during registration
      req.error(500, `Error registering patient: ${err.message}`);
    }
  });

  // Handle appointment booking
  srv.on('bookAppointment', async (req) => {
    try {
      const { patientId, dateTime, reason } = req.data;

      // Create an appointment object with a UUID
      const appointment = {
        appointmentId: cds.UUID(),  // Generate a new UUID
        patient_patientId: patientId,
        dateTime,
        reason,
        status: 'PENDING'
      };

      // Insert the new appointment into the database
      await cds.transaction(req).run(
        INSERT.into(Appointments).entries(appointment)
      );

      // Return a success message after successfully booking the appointment
      return { message: 'Appointment booked successfully', appointmentId: appointment.appointmentId };

    } catch (err) {
      // Handle any errors that occur during booking
      req.error(500, `Error booking appointment: ${err.message}`);
    }
  });

  // Handle updating appointment status
  srv.on('updateAppointmentStatus', async (req) => {
    try {
      const { appointmentId, status } = req.data;

      // Validate the status
      if (!['PENDING', 'ACCEPTED', 'REJECTED'].includes(status)) {
        req.error(400, 'Invalid status value');
      }

      // Update the appointment status in the database
      await cds.transaction(req).run(
        UPDATE(Appointments)
          .set({ status: status })
          .where({ appointmentId: appointmentId })
      );

      // Return a success message after successfully updating the status
      return { message: `Appointment status updated to ${status}`, appointmentId: appointmentId };

    } catch (err) {
      // Handle any errors that occur during the update
      req.error(500, `Error updating appointment status: ${err.message}`);
    }
  });
};
