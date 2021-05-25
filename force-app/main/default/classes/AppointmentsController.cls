public class AppointmentsController {

    private List<Doctors__c>doctorList = new List<Doctors__c>();
    private List<Patient__c>patientList = new List<Patient__c>();
    public Doctors__c selectedDoctor { get; set; }
    public Appointment__c newAppointment { get; set; }
    public Id selectedPatientId { get; set; }
    public Id selectedDoctorId {
        get;
        set {
            selectedDoctorId = value;
            updateDoctor();
        }
    }
    public AppointmentsController() {
        newAppointment = new Appointment__c();
        patientList = [SELECT Id,Name FROM Patient__c ORDER BY Name ASC];
        doctorList = [SELECT Id,Name,Working_Hours_Start__c,Working_Hours_End__c FROM Doctors__c ORDER BY Name ASC];
        selectedDoctor = doctorList.isEmpty() ? null : doctorList[0];
        selectedDoctorId = selectedDoctor.Id;
        selectedPatientId = patientList.isEmpty() ? null : patientList[0].Id;
    }


    private void updateDoctor() {
        for (Doctors__c doctor : doctorList) {

            if (selectedDoctorId == doctor.Id) {
                selectedDoctor = doctor;
            }

        }
    }

    public List<SelectOption> getDoctorOptionList() {
        List<SelectOption>doctorOptionList = new List<SelectOption>();

        for (Doctors__c doctor : doctorList) {

            doctorOptionList.add(new SelectOption(doctor.Id, doctor.Name));

        }

        return doctorOptionList;
    }

    public List<SelectOption> getPatientOptionList() {
        List<SelectOption>patientOptionList = new List<SelectOption>();

        for (Patient__c patient : patientList) {

            patientOptionList.add(new SelectOption(patient.Id, patient.Name));

        }

        return patientOptionList;
    }

    public Datetime getWorkingHoursStart() {
        return (selectedDoctor != null && selectedDoctor.Working_Hours_Start__c != null) ? Datetime.newInstanceGmt(System.today(), selectedDoctor.Working_Hours_Start__c) : null;
    }

    public Datetime getWorkingHoursEnd() {
        return (selectedDoctor != null && selectedDoctor.Working_Hours_End__c != null) ? Datetime.newInstanceGmt(System.today(), selectedDoctor.Working_Hours_End__c) : null;
    }


    public Integer size { get {return 20;} }
    public Integer countOfRecords { get; set; }
    public Doctors__c selectedDoctorOld { get; set; }
    public ApexPages.StandardSetController setCon {
        get {
            if (setCon == null || selectedDoctorOld != selectedDoctor) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                [SELECT Id,Name,Doctor__c,Appointment_Date__c,Duration_in_minutes__c,Patient__c FROM Appointment__c WHERE Doctor__c = :selectedDoctorId]));
                countOfRecords = setCon.getResultSize();
                setCon.setPageSize(size);
                selectedDoctorOld = selectedDoctor;
            }
            return setCon;
        }
        set;
    }

    public List<Appointment__c> getDoctorAppointmentsList() {

        return (List<Appointment__c>) setCon.getRecords();
    }

    public void saveAppointment() {

        newAppointment.Doctor__c = selectedDoctorId;
        newAppointment.Patient__c = selectedPatientId;
        insert newAppointment;
        newAppointment = new Appointment__c();
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
        [SELECT Id,Name,Doctor__c,Appointment_Date__c,Duration_in_minutes__c,Patient__c FROM Appointment__c WHERE Doctor__c = :selectedDoctorId]));

    }
}