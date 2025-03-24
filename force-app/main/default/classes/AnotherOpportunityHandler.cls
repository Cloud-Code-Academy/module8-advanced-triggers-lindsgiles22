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