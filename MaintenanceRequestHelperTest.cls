@isTest
public with sharing class MaintenanceRequestHelperTest {
private static final string STATUS_NEW = 'New';
private static final string WORKING = 'Working';
private static final string CLOSED = 'Closed';
private static final string REPAIR = 'Repair';
private static final string REQUEST_TYPE = 'Routine Maintenance';
private static final string REQUEST_SUBJECT = 'Maintenance Request Testing subject';
// to create a new vehicle
private static Vehicle__c createVehicle(){
    Vehicle__c newV = new Vehicle__C();
    newV.Name =  'Truck';
    return newV;
}        
//to create a new equipment
private static Product2 createEquipment(){
    Product2 ne = new product2();
    ne.Name = 'SuperBadgeEquipment';
    ne.isActive = True;
    ne.Maintenance_Cycle__c = 5;
    ne.Replacement_Part__c = True;
    return ne;
}
// to create new maitenance request
private static Case createMaintenanceRequest(Id vehicleId, Id equipmentId){
    Case nmr = new Case();
    nmr.Type=REPAIR;
    nmr.Status=STATUS_NEW;
    nmr.Subject=REQUEST_SUBJECT;
    nmr.Vehicle__c=vehicleId;
    nmr.Product__c=equipmentId;
    
    return nmr;
}
//to create new equipment item
private static Equipment_Maintenance_Item__c createEquipmentMaintenanceItem(Id equipmentId,Id maintenanceReportId){
    Equipment_Maintenance_Item__c nemi = new Equipment_Maintenance_Item__c();
    nemi.Equipment__c = equipmentId;
    nemi.Maintenance_Request__c = maintenanceReportID;
    return nemi;
}


@isTest
private static void testMaintenanceRequestPositiveWithDueDateAsToday(){
    //nv=new vehicle
    Vehicle__c nv = createVehicle();
    Insert nv;
    Id vehicleId = nv.Id;
    //new equipment
    Product2 ne = createEquipment();
    Insert ne;
    Id equipmentId = ne.Id;
    //new maintenance report
    Case newmr = createMaintenanceRequest(vehicleId,equipmentId);
    Insert newmr;
    Id mrId = newmr.Id;
    Equipment_Maintenance_Item__c nemi = createEquipmentMaintenanceItem(equipmentId,mrId);
    Insert nemi;
    
    Test.startTest();
    newmr.Status = CLOSED;
    Update newmr;
    Test.stopTest();
    // new report
    Case newR = [Select Id, Subject, Type, Date_Due__c, Date_Reported__c, Status
                       From Case
                       Where Status =:STATUS_NEW];
    // new item
    Equipment_Maintenance_Item__c newi = [Select id
                                             From Equipment_Maintenance_Item__c
                                             Where Maintenance_Request__c =:newR.Id];
    
    SYSTEM.assert(newi != null);
    SYSTEM.assert(newR.Subject != null);
    SYSTEM.assertEquals(newR.Type, REQUEST_TYPE);
    SYSTEM.assertEquals(newR.Date_Reported__c, system.today());
    SYSTEM.assertEquals(newR.Date_Due__c, system.today());
}

@isTest
private static void testMaintenanceRequestPositiveWithDueDateNotAsToday(){
    
    Vehicle__c newV = createVehicle();
    Insert newV;
    Id vehicleId = newV.Id;
    Product2 newE = createEquipment();
    Insert newE;
    Id equipmentId = newE.Id;
    Case newM = createMaintenanceRequest(vehicleId,equipmentId);
    Insert newM;
    Id maintenanceReportId = newM.Id;
    Equipment_Maintenance_Item__c newEMI1 = createEquipmentMaintenanceItem(equipmentId,maintenanceReportId);
    Insert newEMI1;
    Equipment_Maintenance_Item__c newEMI2 = createEquipmentMaintenanceItem(equipmentId,maintenanceReportId);
    Insert newEMI2;
    
    Test.startTest();
    
    newM.Status = CLOSED;
    Update newM;
    
    Test.stopTest();
    
    Case newR = [Select Id, Subject, Type, Date_Due__c, Date_Reported__c, Status
                       From Case
                       Where Status =:STATUS_NEW];

    SYSTEM.assertEquals(newR.Date_Due__c, Date.today().addDays(5));
    
}
}