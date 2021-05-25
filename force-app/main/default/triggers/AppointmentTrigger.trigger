trigger AppointmentTrigger on Appointment__c ( after delete,
        after insert,
        after undelete,
        after update,
        before delete,
        before insert,
        before update) {

    TriggerFactory.createHandler(Appointment__c.SObjectType);
    
}