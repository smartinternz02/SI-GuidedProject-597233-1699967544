@isTest
private class WarehouseCalloutServiceTest {
  //  mock callout test
	@isTest
    static void WarehouseEquipmentSync(){
        Test.startTest();
       
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();        
        System.assertEquals(1, [SELECT count() FROM Product2]);        
    }
}