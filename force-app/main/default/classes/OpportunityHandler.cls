public with sharing class OpportunityHandler {
     /*
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Trigger should only fire on update.
    */
    public static void validateOppAmount(List<Opportunity> newOpps){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity opp : newOpps){
            if(opp.Amount < 5000){
                opp.addError('Opportunity amount must be greater than 5000');
            }
            oppsToUpdate.add(opp);
        }
        update oppsToUpdate;
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
                if(accounts.get(opp.AccountId).Industry == 'Banking'){
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
                    Account relatedAccount = AccountMap.get(opp.AccountId);
                    if (related Account != null && relatedAccount.Industry == 'Banking') {
                        opp.addError('Cannot delete closed opportunity for a banking account that is won';)
                    }
                }
            }
        }
    }
}