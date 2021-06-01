@IsTest
private class AppointmentsControllerTest {
    @IsTest static void getDoctorAppointmentsListTest() {

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

        Appointment__c appointment2 = appointment.clone(false, false, false, false);
        appointment2.Appointment_Date__c = appointment2.Appointment_Date__c.addHours(1);

        Database.insert(new List<Appointment__c>{
                appointment, appointment2
        }, false);

        AppointmentsController controller = new AppointmentsController();
        controller.selectedDoctorId = doctor.Id;
        System.assertEquals(2,controller.setCon.getRecords().size());
    }

    @IsTest static void getPatientOptionListsTest() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );

        Doctors__c doctor2 = doctor.clone(false, false, false, false);
        Database.insert(new List<Doctors__c>{
                doctor, doctor2
        }, false);

        Patient__c patient = new Patient__c(
                Name = 'Patient'
        );

        Patient__c patient2 = patient.clone(false, false, false, false);
        Database.insert(new List<Patient__c>{
                patient, patient2
        }, false);

        AppointmentsController controller = new AppointmentsController();
        List<SelectOption>patientOptionList = controller.getPatientOptionList();
        List<SelectOption>doctorOptionList = controller.getDoctorOptionList();
        System.assertEquals(3, patientOptionList.size());
        System.assertEquals(3, doctorOptionList.size());
    }

    @IsTest static void getWorkingHoursTest() {
        Doctors__c doctor = new Doctors__c(
                Name = 'Doctor',
                Working_Hours_Start__c = Time.newInstance(9, 0, 0, 0),
                Working_Hours_End__c = Time.newInstance(19, 0, 0, 0)
        );

        insert doctor;

        AppointmentsController controller = new AppointmentsController();
        controller.selectedDoctor = doctor;
        System.assertEquals(controller.getWorkingHoursStart(), Datetime.newInstanceGmt(System.today(), doctor.Working_Hours_Start__c));
        System.assertEquals(controller.getWorkingHoursEnd(), Datetime.newInstanceGmt(System.today(), doctor.Working_Hours_End__c));
    }

    @IsTest static void saveAppointmentTest() {
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

        AppointmentsController controller = new AppointmentsController();
        controller.newAppointment.Appointment_Date__c = Datetime.newInstance(Date.today(), Time.newInstance(10, 0, 0, 0));
        controller.newAppointment.Duration_in_minutes__c = 15;
        controller.selectedDoctorId = doctor.Id;
        controller.selectedPatientId = patient.Id;
        controller.saveAppointment();

        System.assertEquals(1, [SELECT Id FROM Appointment__c].size());
    }
}