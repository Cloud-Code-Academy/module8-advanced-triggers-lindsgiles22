public with sharing class AnotherOpportunityHandler {
    public static void setOppType(List<Opportunity> newOpps) {
        // Set default Type for new Opportunities
        for (Opportunity opp : newOpps) {
            if (opp.Type == null){
                opp.Type = 'New Customer';
        }
    }
}
    public static void preventOppDeletion(List<Opportunity> oldOpps) {
        // Prevent deletion of closed Opportunities
        for (Opportunity opp : oldOpps){
            if (oldOpp.IsClosed){
                oldOpp.addError('Cannot delete closed opportunity');
            }
        }
    }
    public static void createTaskForNewOpp(List<Opportunity> insertedOpps) {
        // Create a new Task for newly inserted Opportunities
        List<Task> tasksToInsert = new List<Task>();

        for (Opportunity opp : insertedOpps) {
            if (opp.Primary_Contact__c != null) {
            Task tsk = new Task();
            tsk.Subject = 'Call Primary Contact';
            tsk.WhatId = opp.Id;
            tsk.WhoId = opp.Primary_Contact__c;
            tsk.OwnerId = opp.OwnerId;
            tsk.ActivityDate = Date.today().addDays(3);
            tasksToInsert.add(task);
        }
    }
    
    if (!tasksToInsert.isEmpty()) {
    insert tsk;
    }
}
    public static void appendStageChangesToOppDescrip (List<Opportunity> newOpps) {
    List<Opportunity> oppsToUpdate = new List<Opportunity>(); 
    // Append Stage changes in Opportunity Description
     for (Opportunity opp : newOpps){
        if (opp.StageName != null){
            opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
            oppsToUpdate.add(opp);
        }
    }
    update oppsToUpdate;                
}
    
}