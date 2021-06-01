public with sharing class AppointmentTriggerHandler implements ITrigger {
    public void onBeforeInsert() {

        appointmentValidation();
    }
    public void onBeforeUpdate() {

        appointmentValidation();
    }
    public void onBeforeDelete() {

    }
    public void onAfterInsert() {

    }
    public void onAfterUpdate() {

    }
    public void onAfterDelete() {

    }
    private void appointmentValidation() {
        List<Date>appointmentDatesNewList = new List<Date>();
        List<Id>doctorIds = new List<Id>();

        for (Appointment__c appointmentNew : (List<Appointment__c>) Trigger.new) {
            appointmentDatesNewList.add(appointmentNew.Appointment_Date__c.date());

            doctorIds.add(appointmentNew.Doctor__c);
        }
        AppointmentTriggerHelper appointmentHelper = new AppointmentTriggerHelper(appointmentDatesNewList, doctorIds);


        for (Appointment__c appointmentNew : (List<Appointment__c>) Trigger.new) {

            //compare patient appointments on the same date and time
            List<Appointment__c>oldSameDatePatientAppointments = appointmentHelper.getPatientAppointmentsForDateSortedByTime(appointmentNew, appointmentNew.Appointment_Date__c.date());
            if (!appointmentHelper.isValidAppointmentTime(appointmentNew, oldSameDatePatientAppointments)) {
                appointmentNew.addError('You already have an appointment for this date and time');
            }

            //compare doctor working hours with appointment time
            Doctors__c doctor = appointmentHelper.getDoctor(appointmentNew.Doctor__c);

            if (appointmentNew.Appointment_Date__c.time() < doctor.Working_Hours_Start__c || appointmentNew.Appointment_Date__c.time() > doctor.Working_Hours_End__c) {
                String startWorkingHors = Datetime.newInstance(Date.today(), doctor.Working_Hours_Start__c).format('h:mm a');
                String endWorkingHors = Datetime.newInstance(Date.today(), doctor.Working_Hours_End__c).format('h:mm a');
                appointmentNew.addError(Appointment__c.Appointment_Date__c, 'This doctor works from ' + startWorkingHors + ' to ' + endWorkingHors + ', choose a different time');
            }

            //compare doctor appointments time on the same date
            List<Appointment__c>oldSameDateDoctorAppointments = appointmentHelper.getDoctorAppointmentsForDateSortedByTime(appointmentNew, appointmentNew.Appointment_Date__c.date());

            if (!appointmentHelper.isValidAppointmentTime(appointmentNew, oldSameDateDoctorAppointments)) {
                appointmentNew.addError('This date and time is already taken,select another');
            }
        }

    }
}