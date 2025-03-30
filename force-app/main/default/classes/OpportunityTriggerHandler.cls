public with sharing class OpportunityTriggerHandler extends TriggerHandler {

    // Static variable to prevent recursion
    private static Boolean isUpdating = false;

    // Override the before insert method to handle logic before new Opportunities are inserted
    protected override void beforeInsert() {
        // Logic from AnotherOpportunityTrigger: Set default Opportunity Type for new Opportunities
        AnotherOpportunityHandler.setOppType(Trigger.new);
    }

    // Override the before update method to handle logic before updating Opportunities
    protected override void beforeUpdate() {
        // Logic from OpportunityTrigger: Validate that the Opportunity amount is greater than 5000
        OpportunityHandler.validateOppAmount(Trigger.new);

        // Logic from OpportunityTrigger: Set Primary Contact for Opportunities
        OpportunityHandler.setPrimaryContactOnOpp(Trigger.new);
    }

    // Override the before delete method to handle logic before deleting Opportunities
    protected override void beforeDelete() {
        // Prevent deletion of closed Opportunities
        AnotherOpportunityHandler.preventOppDeletion(Trigger.old);
    }

    // Override the after insert method to handle logic after new Opportunities are inserted
    protected override void afterInsert() {
        // Logic from AnotherOpportunityTrigger: Create task for new Opportunities
        AnotherOpportunityHandler.createTaskForNewOpp(Trigger.new);
    }

    // Override the after update method to handle logic after updating Opportunities
    protected override void afterUpdate() {
        // Prevent recursion by checking the static variable
        if (isUpdating) {
            return;
        }

        isUpdating = true; // Set flag to true to prevent further updates

        // Logic from AnotherOpportunityTrigger: Append stage changes to Opportunity descriptions
        AnotherOpportunityHandler.appendStageChangesToOppDescrip(Trigger.new);

        isUpdating = false; // Reset the flag after execution
    }

    // Override the after delete method to handle logic after deleting Opportunities
    protected override void afterDelete() {
        // Logic from AnotherOpportunityTrigger: Send email notifications when an Opportunity is deleted
        AnotherOpportunityHandler.notifyOwnersOpportunityDeleted(Trigger.old);
    }

    // Override the after undelete method to handle logic after undeleting Opportunities
    protected override void afterUndelete() {
        // Manually map the Trigger.new list into a Map<Id, Opportunity>
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :Trigger.new]) {
            oppMap.put(opp.Id, opp);
        }

        // Logic from AnotherOpportunityTrigger: Assign Primary Contact to undeleted Opportunities
        AnotherOpportunityHandler.assignPrimaryContact(oppMap);
    }
}