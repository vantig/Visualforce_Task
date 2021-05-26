@IsTest
private class AppointmentTriggerTest {
    @IsTest static void TriggerTestSameTimeSameDoctorUpdate() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );

        insert doctor;

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );

        insert patient;

        Appointment__c appointment = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 10
        );
        Appointment__c appointment2 = new Appointment__c (
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 10, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );


        insert new List<Appointment__c>{
                appointment, appointment2
        };

        Integer count = [
                SELECT COUNT()
                FROM Appointment__c
        ];

        System.assertEquals(2, count);

        appointment2.Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 9, 0, 0));

        try {
            update appointment2;
        } catch (Exception e) {

        }

        System.assertEquals(Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 10, 0, 0)), [SELECT Appointment_Date__c FROM Appointment__c WHERE Id = :appointment2.Id].Appointment_Date__c);
    }

    @IsTest static void TriggerTestSameTimeSameDoctorInsert() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );

        insert doctor;

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );

        insert patient;

        Appointment__c appointment = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );
        Appointment__c appointment2 = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 10, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );


        try {
            insert appointment;
            insert appointment2;
        } catch (DmlException e) {
        }


        System.assertEquals(1, [
                SELECT COUNT()
                FROM Appointment__c
        ]);
        appointment2.Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 30, 0, 0));
        insert appointment2;
        Appointment__c appointment3 = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 15, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 10
        );

        insert appointment3;

        System.assertEquals(3, [
                SELECT COUNT()
                FROM Appointment__c
        ]);
    }
    @IsTest static void TriggerTestDifTimeSameDoctorInsert() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );

        insert doctor;

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );
        Patient__c patient2 = new Patient__c(
                Name = 'Patient2'
        );

        insert patient;
        insert patient2;

        Appointment__c appointment = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 10
        );
        Appointment__c appointment2 = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 10, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient2.Id,
                Duration_in_minutes__c = 10
        );
        Appointment__c appointment3 = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 19, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient2.Id,
                Duration_in_minutes__c = 10
        );

        try {
            insert appointment;
            insert appointment2;
            insert appointment3;
        } catch (DmlException e) {
        }

        Integer count = [
                SELECT COUNT()
                FROM Appointment__c
        ];

        System.assertEquals(2, count);
    }
    @IsTest static void TriggerTestSamePatientSameTimeDifferentDoctorsInsert() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );
        Doctors__c doctor2 = new Doctors__c(
                Name = 'Doctor2',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );


        insert doctor;
        insert doctor2;

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );
        insert patient;

        Appointment__c appointment = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );
        Appointment__c appointment2 = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
                Doctor__c = doctor2.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );
        try {
            insert appointment;
            insert appointment2;
        } catch (Exception e) {

        }


        Integer count = [
                SELECT Id
                FROM Appointment__c
        ].size();

        System.assertEquals(1, count);
    }
    @IsTest static void TriggerTestSamePatientDifTimeDifferentDoctorsInsert() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );
        Doctors__c doctor2 = new Doctors__c(
                Name = 'Doctor2',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );


        insert doctor;
        insert doctor2;

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );
        insert patient;

        Appointment__c appointment = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );
        Appointment__c appointment2 = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(11, 0, 0, 0)),
                Doctor__c = doctor2.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 15
        );
        try {
            insert appointment;
            insert appointment2;
        } catch (Exception e) {

        }


        Integer count = [
                SELECT Id
                FROM Appointment__c
        ].size();

        System.assertEquals(2, count);
    }
    @IsTest static void TriggerTestDoctorWorkingHours() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );


        insert doctor;

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );
        insert patient;

        Appointment__c appointment = new Appointment__c(
                Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(7, 0, 0, 0)),
                Doctor__c = doctor.Id,
                Patient__c = patient.Id,
                Duration_in_minutes__c = 10
        );
        try {
            insert appointment;
        } catch (Exception e) {

        }


        System.assertEquals(0, [
                SELECT Id
                FROM Appointment__c
        ].size());

        appointment.Appointment_Date__c = Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(9, 0, 0, 0));

        try {
            insert appointment;
        } catch (Exception e) {

        }

        System.assertEquals(1, [
                SELECT Id
                FROM Appointment__c
        ].size());
    }
}