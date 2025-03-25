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
}