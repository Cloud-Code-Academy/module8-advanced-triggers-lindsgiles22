public with sharing class OpportunityTriggerHandler extends TriggerHandler {

    // Add a static variable to track loop count
    public static Integer loopCount = 0; // Track loop count
    public static final Integer MAX_LOOP_COUNT = 5; // Set max loop count to 5

    // Prevent recursion flag (to be used in the createTaskForNewOpp logic)
    public static Boolean isAfterInsertExecuted = false;

    // Override the before insert method to handle logic before new Opportunities are inserted
    protected override void beforeInsert() {
        // Prevent further execution if max loop count is reached
        if (loopCount >= MAX_LOOP_COUNT) {
            return;
        }

        loopCount++;  // Increment loop count

        // Logic from AnotherOpportunityTrigger: Set default Opportunity Type for new Opportunities
        AnotherOpportunityHandler.setOppType(Trigger.new);
    }

    // Override the after insert method to handle logic after new Opportunities are inserted
    protected override void afterInsert() {
        // Prevent further execution if max loop count is reached
        if (loopCount >= MAX_LOOP_COUNT || isAfterInsertExecuted) {
            return;
        }

        loopCount++;  // Increment loop count

        // Prevent multiple executions of afterInsert within the same context
        isAfterInsertExecuted = true;

        // Logic from AnotherOpportunityTrigger: Create task for new Opportunities
        AnotherOpportunityHandler.createTaskForNewOpp(Trigger.new);
    }
}