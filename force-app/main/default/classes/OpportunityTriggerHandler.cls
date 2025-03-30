public with sharing class OpportunityTriggerHandler extends TriggerHandler {

    // Static variable to track loop count and prevent infinite recursion
    private static Integer loopCount = 0; 
    private static final Integer MAX_LOOP_COUNT = 5; 

    // Prevent trigger recursion using a static variable
    public static Boolean isRecursiveCall = false; 

    // Override the before insert method to handle logic before new Opportunities are inserted
    protected override void beforeInsert() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }
        
        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Logic from AnotherOpportunityTrigger: Set default Opportunity Type for new Opportunities
        AnotherOpportunityHandler.setOppType(Trigger.new);

        isRecursiveCall = false; // Reset flag after execution
    }

    // Override the before update method to handle logic before updating Opportunities
    protected override void beforeUpdate() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Logic from OpportunityTrigger: Validate that the Opportunity amount is greater than 5000
        OpportunityHandler.validateOppAmount(Trigger.new);

        // Logic from OpportunityTrigger: Set Primary Contact for Opportunities
        OpportunityHandler.setPrimaryContactOnOpp(Trigger.new);

        isRecursiveCall = false; // Reset flag after execution
    }

    // Override the before delete method to handle logic before deleting Opportunities
    protected override void beforeDelete() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Prevent deletion of closed Opportunities
        AnotherOpportunityHandler.preventOppDeletion(Trigger.old);

        isRecursiveCall = false; // Reset flag after execution
    }

    // Override the after insert method to handle logic after new Opportunities are inserted
    protected override void afterInsert() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Logic from AnotherOpportunityTrigger: Create task for new Opportunities
        AnotherOpportunityHandler.createTaskForNewOpp(Trigger.new);

        isRecursiveCall = false; // Reset flag after execution
    }

    // Override the after update method to handle logic after updating Opportunities
    protected override void afterUpdate() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Logic from AnotherOpportunityTrigger: Append stage changes to Opportunity descriptions
        AnotherOpportunityHandler.appendStageChangesToOppDescrip(Trigger.new);

        isRecursiveCall = false; // Reset flag after execution
    }

    // Override the after delete method to handle logic after deleting Opportunities
    protected override void afterDelete() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Logic from AnotherOpportunityTrigger: Send email notifications when an Opportunity is deleted
        AnotherOpportunityHandler.notifyOwnersOpportunityDeleted(Trigger.old);

        isRecursiveCall = false; // Reset flag after execution
    }

    // Override the after undelete method to handle logic after undeleting Opportunities
    protected override void afterUndelete() {
        // Prevent recursion
        if (isRecursiveCall || loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        isRecursiveCall = true;  // Set flag to true, indicating we're in the recursive call
        loopCount++;  // Increment loop count

        // Manually map the Trigger.new list into a Map<Id, Opportunity>
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :Trigger.new]) {
            oppMap.put(opp.Id, opp);
        }

        // Logic from AnotherOpportunityTrigger: Assign Primary Contact to undeleted Opportunities
        AnotherOpportunityHandler.assignPrimaryContact(oppMap);

        isRecursiveCall = false; // Reset flag after execution
    }
}

