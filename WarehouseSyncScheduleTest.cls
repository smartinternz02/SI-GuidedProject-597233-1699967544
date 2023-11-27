@isTest

public class WarehouseSyncScheduleTest {

    

    @isTest static void testScheduler() {

        Test.SetMock(HttpCallOutMock.class, new WarehouseCalloutServiceMock());

        
        //To execute it monthly at day 1
        String CRON_EXP = '0 0 0 1 1/1 ? *';   

        Integer runDate = 1;

        
        //first run time
        DateTime frt = System.now();
        // next date time
        DateTime ndt;

        

        if(frt.day() < runDate) {

            ndt = frt;

        } else {

            ndt = frt.addMonths(1);

        }

        
        //next run time
        Datetime nrt = Datetime.newInstance(ndt.year(), ndt.month(), runDate);

        

        Test.startTest();

        WarehouseSyncSchedule warehouseSyncSchedule = new WarehouseSyncSchedule();

        

        String jobId = System.schedule('Test Scheduler',

                                       CRON_EXP, 

                                       warehouseSyncSchedule);

        

        Test.stopTest();

        

        // to get info from crontrigger API

        CronTrigger ct = [SELECT Id,  CronExpression,  TimesTriggered,  NextFireTime FROM CronTrigger WHERE Id = :jobId];

        

        

        System.assertEquals(CRON_EXP, ct.CronExpression);

        

        

        System.assertEquals(0, ct.TimesTriggered);

        

        

        System.assertEquals(String.valueOf(nrt), String.valueOf(ct.NextFireTime));

        

    }

    

}