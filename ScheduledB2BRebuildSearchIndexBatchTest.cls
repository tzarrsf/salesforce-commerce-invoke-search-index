@isTest
public with sharing class ScheduledB2BRebuildSearchIndexBatchTest {
    @testSetup
    static void setup() {
        WebStore webStore = new WebStore(Name='TestWebStore');
        insert webStore;
    }

    @isTest
    static void testScheduledB2BRebuildSearchIndexBatch(){
        Test.startTest();

        DateTime now  = DateTime.now().addMinutes(12);
        String cronString = '0 0 0 * * ?';

        String jobId = System.schedule('test ScheduledB2BRebuildSearchIndexBatchTest', cronString
            , new ScheduledB2BRebuildSearchIndexBatch('TestWebStore'));

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,  NextFireTime
            FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(cronString, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }

}