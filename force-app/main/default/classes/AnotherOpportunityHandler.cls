public with sharing class AnotherOpportunityHandler {
    public static void setOppType(List<Opportunity> newOpps) {
        // Set default Type for new Opportunities
        for (Opportunity opp : newOpps) {
            if (opp.Type == null) {
                opp.Type = 'New Customer';
        }
    }
}
    public static void preventOppDeletion(List<Opportunity> oldOpps) {
        // Prevent deletion of closed Opportunities
        for (Opportunity opp : oldOpps){
            if (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') {
                opp.addError('Cannot delete closed opportunity');
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
            tasksToInsert.add(tsk);
        }
    }
    
    if (!tasksToInsert.isEmpty()) {
    insert tasksToInsert;
    }
}
    public static void appendStageChangesToOppDescrip (List<Opportunity> newOpps) {
    List<Opportunity> oppsToUpdate = new List<Opportunity>(); 
    // Loop through each Opportunity in the newOpps list
     for (Opportunity opp : newOpps){
        if (opp.StageName != null){
            // Create a new opportunity instance with the Id of the original record
            Opportunity updatedOpp = new Opportunity(Id = opp.Id);

            // Append the Stage change information to the Description
            updatedOpp.Description = opp.Description + '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();

            // Add the updated Opportunity to the list for updating
            oppsToUpdate.add(updatedOpp);
        }
    }
    if (!oppsToUpdate.isEmpty()) {
    update oppsToUpdate;   
    }             
}
       /*
    notifyOwnersOpportunityDeleted:
    - Sends an email notification to the owner of the Opportunity when it gets deleted.
    - Uses Salesforce's Messaging.SingleEmailMessage to send the email.
    */
    public static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
        // Create a list to hold the user ids (owners) for the opportunities
        Set<Id> ownerIds = new Set<Id>();
        for(Opportunity opp : opps) {
            ownerIds.add(opp.OwnerId);
        }
        // Query the users associated with the opps
        Map<Id, String> ownerEmails = new Map<Id, String>();
        for (User u : [SELECT Id, Email FROM User WHERE Id IN :ownerIds]) {
            ownerEmails.put(u.Id, u.Email);
        }

        // Create email messages and add them to the list
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Opportunity opp : opps){
            if (ownerEmails.containsKey(opp.OwnerId)) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {ownerEmails.get(opp.OwnerId)};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Opportunity Deleted : ' + opp.Name);
            mail.setPlainTextBody('Your Opportunity: ' + opp.Name +' has been deleted.');
            mails.add(mail);
        }     
    }   
        
        try {
            Messaging.sendEmail(mails);
        } catch (Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
    }
        /*
    assignPrimaryContact:
    - Assigns a primary contact with the title of 'VP Sales' to undeleted Opportunities.
    - Only updates the Opportunities that don't already have a primary contact.
    */
    public static void assignPrimaryContact(Map<Id,Opportunity> oppNewMap) {        
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : oppNewMap.values()) {
            accountIds.add(opp.AccountId);
        }

        // Query for Contacts with Title 'VP Sales' for the relevant accounts
        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        for (Contact c : [SELECT Id, AccountId FROM Contact WHERE Title = 'VP Sales' AND AccountId IN :accountIds]) {
            accountToContactMap.put(c.AccountId, c);
        }

        // Prepare opps to update
        List<Opportunity> oppToUpdateList = new List<Opportunity>();
        for (Opportunity opp : oppNewMap.values()){            
            Contact primaryContact = accountToContactMap.get(opp.AccountId);
            if (opp.Primary_Contact__c == null) {
                opp.Primary_Contact__c = primaryContact.Id;
                oppToUpdateList.add(opp);
            }
        }
        if (!oppToUpdateList.isEmpty()) {
        update oppToUpdateList;
        }
    } 
}
