public with sharing class AppointmentTriggerHelper {
    List<Appointment__c> sameDateAppointments;
    public AppointmentTriggerHandler(List<Datetime> dates) {
        //select records with the same date
        sameDateAppointments = [
                SELECT Appointment_Date__c,Doctor__r.Id,Duration_in_minutes__c
                FROM Appointment__c
                WHERE Appointment_Date__c IN :dates
                ORDER BY Appointment_Date__c ASC
        ];
    }
    public List<Appointment__c>getDoctorAppointmentsForDateSortedByTime(Doctors__c doc, Datetime dateOfAppointment) {
        List<Appointment__c>doctorAppointmentsForDate = new List<Appointment__c>();
        for (Appointment__c appointment : sameDateAppointments) {
            if (appointment.Doctor__r.Id == doc.Id && appointment.Appointment_Date__c.date() == dateOfAppointment) {
                doctorAppointmentsForDate.add(appointment);
            }
        }
        return doctorAppointmentsForDate;
    }
    public Boolean isValidTime(Appointment__c newAppointment, List<Appointment__c>oldAppointments) {
        Time currentAppointmentTime = newAppointment.Appointment_Date__c.timeGmt();

        if (currentAppointmentTime < oldAppointments[0].Appointment_Date__c.timeGmt()) {
            return true;
        }
        if (currentAppointmentTime>oldAppointments[oldAppointments.size()-1].Appointment_Date__c.timeGmt()) {
            return true;
        }
        for (Integer i = oldAppointments.size() - 1; i > 0; i--) {
            Time prevAppointmentTime = oldAppointments[i - 1].Appointment_Date__c.addMinutes(oldAppointments[i - 1].Duration_in_minutes__c.intValue()).timeGmt();
            Time nextAppointmentTime = oldAppointments[i].Appointment_Date__c.timeGmt();

            if (prevAppointmentTime <= currentAppointmentTime &&
                    nextAppointmentTime > currentAppointmentTime.addMinutes(newAppointment.Duration_in_minutes__c.intValue())) {
                return true;
            }
        }
        return false;

    }
}
