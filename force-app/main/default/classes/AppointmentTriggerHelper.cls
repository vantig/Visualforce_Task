public with sharing class AppointmentTriggerHelper {
    List<Appointment__c> sameDateAppointments = new List<Appointment__c>();
    List<Doctors__c>doctors = new List<Doctors__c>();
    public AppointmentTriggerHelper(List<Date> dates, List<Id>doctorIds) {
        //select records with the same date
        sameDateAppointments = [
                SELECT Id,Appointment_Date__c,Doctor__c,Duration_in_minutes__c,Patient__c
                FROM Appointment__c
                WHERE DAY_ONLY(Appointment_Date__c) IN :dates
                ORDER BY Appointment_Date__c ASC
        ];

        doctors = [SELECT Working_Hours_Start__c,Working_Hours_End__c FROM Doctors__c WHERE Id IN :doctorIds];
    }
    public Doctors__c getDoctor(Id docId) {
        for (Doctors__c doc : doctors) {
            if (doc.Id == docId) {
                return doc;
            }
        }
        return null;
    }
    public List<Appointment__c>getDoctorAppointmentsForDateSortedByTime(Appointment__c app, Date dateOfAppointment) {
        List<Appointment__c>doctorAppointmentsForDate = new List<Appointment__c>();
        for (Appointment__c appointment : sameDateAppointments) {
            if (appointment.Doctor__c == app.Doctor__c && appointment.Appointment_Date__c.date() == dateOfAppointment && app.Id != appointment.Id) {
                doctorAppointmentsForDate.add(appointment);
            }
        }
        return doctorAppointmentsForDate;
    }
    public List<Appointment__c>getPatientAppointmentsForDateSortedByTime(Appointment__c app, Date dateOfAppointment) {
        List<Appointment__c>patientAppointmentsForDate = new List<Appointment__c>();
        for (Appointment__c appointment : sameDateAppointments) {
            if (appointment.Patient__c == app.Patient__c && appointment.Appointment_Date__c.date() == dateOfAppointment && app.Id != appointment.Id) {
                patientAppointmentsForDate.add(appointment);
            }
        }
        return patientAppointmentsForDate;
    }
    public Boolean isValidAppointmentTime(Appointment__c newAppointment, List<Appointment__c>oldAppointments) {
        Time currentAppointmentTimeStart = newAppointment.Appointment_Date__c.timeGmt();
        Time currentAppointmentTimeEnd = currentAppointmentTimeStart.addMinutes(newAppointment.Duration_in_minutes__c.intValue());
        if (oldAppointments == null || oldAppointments.size() == 0) {
            return true;
        }
        if (currentAppointmentTimeEnd <= oldAppointments[0].Appointment_Date__c.timeGmt()) {
            return true;
        }
        if (currentAppointmentTimeStart >= oldAppointments[oldAppointments.size() - 1].Appointment_Date__c.addMinutes(oldAppointments[oldAppointments.size() - 1].Duration_in_minutes__c.intValue()).timeGmt()) {
            return true;
        }
        if (oldAppointments.size() > 1) {
            for (Integer i = 0; i < oldAppointments.size() - 1; i++) {
                Time prevAppointmentTime = oldAppointments[i].Appointment_Date__c.timeGmt();
                Time nextAppointmentTime = oldAppointments[i + 1].Appointment_Date__c.timeGmt();

                if (prevAppointmentTime < currentAppointmentTimeStart && currentAppointmentTimeStart < nextAppointmentTime) {
                    if (prevAppointmentTime.addMinutes(oldAppointments[i].Duration_in_minutes__c.intValue()) <= currentAppointmentTimeStart &&
                            currentAppointmentTimeEnd <= nextAppointmentTime) {
                        return true;
                    } else {
                        return false;
                    }

                }
            }
        }
        return false;

    }
}
