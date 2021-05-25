public with sharing class AppointmentTriggerHelper {
    List<Appointment__c> sameDateAppointments;
    public AppointmentTriggerHandler(List<Datetime> dates) {
        //select records with the same date
        sameDateAppointments = [
                SELECT Appointment_Date__c,Doctor__r,Duration_in_minutes__c
                FROM Appointment__c
                WHERE Appointment_Date__c IN :dates
        ];
    }
    public  List<Appointment__c>getDoctorAppointmentsForDate(Doctors__c doc, Date dateOfAppointment) {
        List<Appointment__c>doctorAppointmentsForDate=new List<Appointment__c>();
        for (Appointment__c appointment:sameDateAppointments){
            if (appointment.Doctor__r==Doctors__c) {

            }
        }
        return doctorAppointmentsForDate;
    }
}
