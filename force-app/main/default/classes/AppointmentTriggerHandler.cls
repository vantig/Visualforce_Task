public with sharing class AppointmentTriggerHandler implements ITrigger {
    public void onBeforeInsert() {
        List<Datetime>appointmentDatesNewList = new List<Datetime>();

        for (Appointment__c appointmentNew : (List<Appointment__c>)Trigger.new) {
            appointmentDatesNewList.add(appointmentNew.Appointment_Date__c);
        }



        //compare doctors on the same dates
        for (Appointment__c appointmentNew :  (List<Appointment__c>)Trigger.new) {

            for (Appointment__c appointmentOld : sameAppointmentDates) {

                if (appointmentNew.Appointment_Date__c == appointmentOld.Appointment_Date__c && appointmentNew.Doctor__c == appointmentOld.Doctor__c) {

                    appointmentNew.addError('This time and date is already taken,select another');

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

