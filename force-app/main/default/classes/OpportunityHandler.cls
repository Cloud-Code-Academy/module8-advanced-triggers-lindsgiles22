public with sharing class OpportunityHandler {
     /*
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Trigger should only fire on update.
    */
    public static void validateOppAmount(List<Opportunity> newOpps){
        for(Opportunity opp : newOpps){
            if(opp.Amount < 5000){
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }

    /*
    * Opportunity Trigger
    * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
    * Trigger should only fire on delete.
    */
    public static void preventOppDeletionForBanking(List<Opportunity> oldOpps) {
        // Collect Account Ids from Opportunities being deleted
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : oldOpps) {
            if(opp.StageName == 'Closed Won' && opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
            }
        }
            // Query all relevant Accounts at once
            Map<Id, Account> accountMap = new Map<Id, Account>(
                [SELECT Id, Industry FROM Account WHERE ID in :accountIds]
            );

            // Check conditions and throw error if necessary
            for (Opportunity opp : oldOpps) {
                if (opp.StageName == 'Closed Won' && opp.AccountId != null) {
                    Account relatedAccount = accountMap.get(opp.AccountId);
                    if (relatedAccount != null && relatedAccount.Industry == 'Banking') {
                        opp.addError('Cannot delete closed opportunity for a banking account that is won');
                    }
                }
            }
        }
    
    /*
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact with the title of 'CEO'.
    * Trigger should only fire on update.
    */
    public static void setPrimaryContactOnOpp(List<Opportunity> newOpps) {
        //Get contacts related to the opportunity account
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : newOpps) {
            if (opp.AccountId != null) {
            accountIds.add(opp.AccountId);
        }
    }
        
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();

        for (Contact cont : [SELECT Id, FirstName, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' ORDER BY FirstName ASC]) {
            if (!accountIdToContact.containsKey(cont.AccountId)) {
                accountIdToContact.put(cont.AccountId, cont);
            }
        }

        for(Opportunity opp : newOpps){
            if(opp.Primary_Contact__c == null){
                if (accountIdToContact.containsKey(opp.AccountId)){
                    opp.Primary_Contact__c = accountIdToContact.get(opp.AccountId).Id;
                }
            }
        }
    }
}