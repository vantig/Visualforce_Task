@IsTest
private class AppointmentTriggerTest {
	@IsTest static void TriggerTestSameTime() {
        Doctors__c doctor =new 	Doctors__c(
        	Name='Doctor',
            Working_Hours_Start__c=Time.newInstance(9, 0, 0, 0),
            Working_Hours_End__c=Time.newInstance(19, 0, 0, 0)
        );

        insert doctor;

        Patient__c patient = new Patient__c(
        	Name='Patient'
        );

        insert patient;

    	Appointment__c appointment= new Appointment__c(
        Appointment_Date__c= Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
        Doctor__c=doctor.Id,
        Patient__c=patient.Id,
        Duration_in_minutes__c=15
        );

        Appointment__c appointment2 = appointment.clone(false, false, false, false);

        try{
              insert appointment;
              insert appointment2;
    	}
        catch(DmlException e){}

        Integer count = [
        SELECT COUNT()
        FROM Appointment__c
    	];

        System.assertEquals(1, count);
    }
    @IsTest static void TriggerTestSameTimeDifferentDoctors() {
        Doctors__c doctor =new 	Doctors__c(
        	Name='Doctor',
            Working_Hours_Start__c=Time.newInstance(9, 0, 0, 0),
            Working_Hours_End__c=Time.newInstance(19, 0, 0, 0)
        );

        Doctors__c doctor2 = doctor.clone(false, false, false, false);
        doctor2.Name='Doctor2';


        insert doctor;
        insert doctor2;

        Patient__c patient = new Patient__c(
        	Name='Patient'
        );
        insert patient;

    	Appointment__c appointment= new Appointment__c(
        Appointment_Date__c= Datetime.newInstance(Date.newInstance(2021, 02, 25), Time.newInstance(10, 0, 0, 0)),
        Doctor__c=doctor.Id,
        Patient__c=patient.Id,
        Duration_in_minutes__c=15
        );

        Appointment__c appointment2=appointment.clone(false, false, false, false);
        appointment2.Doctor__c=doctor2.Id;

        try{
              insert appointment;
              insert appointment2;
    	}
        catch(DmlException e){}

        Integer count = [
        SELECT COUNT()
        FROM Appointment__c
    	];

        System.assertEquals(2, count);
    }
}