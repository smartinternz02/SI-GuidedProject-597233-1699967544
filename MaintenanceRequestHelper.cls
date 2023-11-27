public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> eReq) {
        
        Integer count = 0;
        Map<Id, Integer> togdMap = new Map<Id, Integer>();
        Map<Id,Case> ncMap = new Map<Id,Case>();
        List<Case> cReq = new List<Case>();
        List<Case> caseList = new List<Case>();
        Map<Equipment_Maintenance_Item__c,Id> EpIds = new Map<Equipment_Maintenance_Item__c,Id>();
        
        if(!eReq.isEmpty()){
            for(Case cc : eReq){
                if((cc.Type == 'Repair' || cc.Type == 'Routine Maintenance') && cc.Status == 'Closed'){
                    caseList.add(cc);   
                }
            }    
        }
        List<Equipment_Maintenance_Item__c> equipMl = [Select id,Equipment__c,Maintenance_Request__c from Equipment_Maintenance_Item__c where Maintenance_Request__c IN : caseList];
        if(!equipMl.isEmpty()){
            for(Equipment_Maintenance_Item__c em : equipMl){
                EpIds.put(em,em.Equipment__c);
                system.debug(EpIds.size());
                if(EpIds.size() > 1){
                    count = EpIds.size();
                }
            }  
        }
      List<Equipment_Maintenance_Item__c> EMIList = [Select Equipment__r.Maintenance_Cycle__c,Equipment__c from Equipment_Maintenance_Item__c where Equipment__r.Id IN :EpIds.values() AND Maintenance_Request__c IN:caseList order By Equipment__r.Maintenance_Cycle__c ASC limit 1];
            for(Equipment_Maintenance_Item__c equip : EMIList){
                togdMap.put(equip.Id,Integer.valueOf(equip.Equipment__r.Maintenance_Cycle__c));  
                for(Case c : caseList){
                    Case mr = new Case();
                    mr.Vehicle__c = c.Vehicle__c;
                    mr.status = 'New';
                    mr.Type = 'Routine Maintenance';
                    mr.Subject = 'New Main Request For Vehicle for Apex Specialist';
                    mr.Date_Reported__c = date.today();
                    if(count > 1){
                        mr.Date_Due__c = Date.today().addDays(togdMap.get(equip.Id));
                    }
                    else{
                        mr.Date_Due__c = Date.today();
                    }
                    cReq.add(mr);
                    ncMap.put(c.Id,mr);
                }  
               insert cReq; 
                if(caseList.size()>0 && ncMap.size()>0){
                        cloneEquipItems(caseList,ncMap);
                    }
            }
    }
    public static void cloneEquipItems(List<case> ccRecords, Map<Id,case> ncMapp){
        List<Equipment_Maintenance_Item__c> neItems = new List<Equipment_Maintenance_Item__c>();
        
            if(!ccRecords.isEmpty() && ncMapp.size()>0){
                List<Equipment_Maintenance_Item__c> oeItems = [SELECT Equipment__c, Maintenance_Request__c, Quantity__c,Maintenance_Request__r.Id
                                                                     FROM Equipment_Maintenance_Item__c
                                                                     WHERE  Maintenance_Request__c IN :ccRecords];
                
                for(Equipment_Maintenance_Item__c eItem : oeItems) {
                    
                    Equipment_Maintenance_Item__c nItem = eItem.clone(false, true, false, false);
                    nItem.Maintenance_Request__c = ncMapp.get(eItem.Maintenance_Request__c).id;
                    neItems.add(nItem);
                }
                insert neItems;
            
        }
        
    }
}