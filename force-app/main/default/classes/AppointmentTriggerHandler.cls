public with sharing class AppointmentTriggerHandler implements ITrigger {
    public void onBeforeInsert() {
        List<Datetime>appointmentDatesNewList = new List<Datetime>();

        for (Appointment__c appointmentNew : (List<Appointment__c>)Trigger.new) {
            appointmentDatesNewList.add(appointmentNew.Appointment_Date__c);
        }
        AppointmentTriggerHelper appointmentHelper=new  AppointmentTriggerHelper(appointmentDatesNewList);


        //compare doctors on the same dates
        for (Appointment__c appointmentNew :  (List<Appointment__c>)Trigger.new) {

            List<Appointment__c>oldDoctorAppointments= appointmentHelper.getDoctorAppointmentsForDateSortedByTime(appointmentNew.Doctor__r,appointmentNew.Appointment_Date__c);
            for (Appointment__c appointmentOld : oldDoctorAppointments) {

                if (appointmentNew.Appointment_Date__c == appointmentOld.Appointment_Date__c) {

                    appointmentNew.addError('This date is already taken,select another');

                }
            }

        }
    }
    public void onBeforeUpdate(){

    }
    public void onBeforeDelete(){

    }
    public void onAfterInsert(){

    }
    public void onAfterUpdate(){

    }
    public void onAfterDelete(){

    }
}

