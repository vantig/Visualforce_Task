public class AppointmentsController {

    private List<Doctors__c>doctorList = new List<Doctors__c>();
    private List<Patient__c>patientList = new List<Patient__c>();
    private List<Appointment__c>appointmentList = new List<Appointment__c>();
    public Doctors__c selectedDoctor { get; set; }
    public Patient__c selectedPatient { get; set; }
    public Appointment__c newAppointment {
        get {
            if (newAppointment == null) {
                newAppointment= new Appointment__c();
                return newAppointment;
            }
            return newAppointment;
        }
        set;
    }
    public String selectedPatientId {
        get;
        set {
            selectedPatientId = value;
            updatePatient();
        }
    }
    public String selectedDoctorId {
        get;
        set {
            selectedDoctorId = value;
            updateDoctor();
        }
    }
    public AppointmentsController() {

        patientList = [SELECT Id,Name FROM Patient__c ORDER BY Name ASC];
        doctorList = [SELECT Id,Name,Working_Hours_Start__c,Working_Hours_End__c FROM Doctors__c ORDER BY Name ASC];
        appointmentList = [SELECT Id,Name,Doctor__c,Appointment_Date__c,Duration_in_minutes__c,Patient__c FROM Appointment__c];
        selectedDoctorId = null;
        selectedPatientId = null;
    }
    private void updateDoctor() {
        selectedDoctor = null;
        for (Doctors__c doctor : doctorList) {

            if (selectedDoctorId == doctor.Id) {
                selectedDoctor = doctor;
                return ;
            }

        }

    }
    private void updatePatient() {
        selectedPatient = null;
        for (Patient__c patient : patientList) {

            if (selectedPatientId == patient.Id) {
                selectedPatient = patient;
                return ;
            }

        }

    }
    public Datetime getWorkingHoursStart() {
        return (selectedDoctor != null && selectedDoctor.Working_Hours_Start__c != null) ? Datetime.newInstanceGmt(System.today(), selectedDoctor.Working_Hours_Start__c) : null;
    }

    public Datetime getWorkingHoursEnd() {
        return (selectedDoctor != null && selectedDoctor.Working_Hours_End__c != null) ? Datetime.newInstanceGmt(System.today(), selectedDoctor.Working_Hours_End__c) : null;
    }



    public List<SelectOption> getDoctorOptionList() {
        List<SelectOption>doctorOptionList = new List<SelectOption>();
        doctorOptionList.add(new SelectOption('all', 'All Doctors'));
        for (Doctors__c doctor : doctorList) {

            doctorOptionList.add(new SelectOption(doctor.Id, doctor.Name));

        }

        return doctorOptionList;
    }

    public List<SelectOption> getPatientOptionList() {
        List<SelectOption>patientOptionList = new List<SelectOption>();
        patientOptionList.add(new SelectOption('all', 'All Patients'));
        for (Patient__c patient : patientList) {

            patientOptionList.add(new SelectOption(patient.Id, patient.Name));

        }

        return patientOptionList;
    }


     List<Appointment__c> getAppointments() {
        List<Appointment__c> appointments = new List<Appointment__c>();
        if (selectedPatient == null && selectedDoctor == null) {
            return appointmentList;
        }
        for (Appointment__c app : appointmentList) {
            if ((selectedPatient == null || app.Patient__c == selectedPatientId) && (selectedDoctor == null || app.Doctor__c == selectedDoctorId)) {
                appointments.add(app);
            }
        }

        return appointments;

    }
    public List<Appointment__c> appointments { get{

        return (List<Appointment__c>)setCon.getRecords();

    } set; }


    public Integer sizeOfPage { get {return 5;} set; }
    public Integer countOfRecords { get; set; }
    public Doctors__c selectedDoctorOld { get; set; }
    public Patient__c selectedPatientOld { get; set; }
    public ApexPages.StandardSetController setCon {
        get {


            if (setCon == null || selectedDoctorOld != selectedDoctor || selectedPatientOld != selectedPatient) {
                setCon = new ApexPages.StandardSetController(getAppointments());
                countOfRecords = setCon.getResultSize();
                setCon.setPageSize(sizeOfPage);
                selectedDoctorOld = selectedDoctor;
                selectedPatientOld = selectedPatient;
            }
            return setCon;
        }
        set;
    }

    public void saveAppointment() {

        if (selectedDoctor == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Select Doctor'));
            return ;
        }
        if (selectedPatient == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Select Patient'));
            return ;
        }
        newAppointment.Doctor__c = selectedDoctor.Id;
        newAppointment.Patient__c = selectedPatient.Id;
        insert newAppointment;
        newAppointment = new Appointment__c();
        appointmentList = [SELECT Id,Name,Doctor__c,Appointment_Date__c,Duration_in_minutes__c,Patient__c FROM Appointment__c];
        setCon= new ApexPages.StandardSetController(getAppointments());

    }
}

