trigger WebsiteAccount on wint__Website_Account__c (after update, after insert, before update, before insert) {
    //if(checkRecursive.runAfterOnce()){
    if (Trigger.isAfter && Trigger.isInsert){
        
    Set<id>websiteIdinTrigger = new Set<id>();
    for(wint__Website_Account__c webAcc : Trigger.New){
       if(webAcc.wint__Contact__c <> Trigger.oldMap.get(webAcc.id).wint__Contact__c){
            websiteIdinTrigger.add(webAcc.id);
            //System.debug('Testing if it is entering into trigger atleast');
        }
       
    }
    
    WebsiteAccountHandler.farmWrapperCalling(websiteIdinTrigger);
    
}
else if(Trigger.isAfter && Trigger.isUpdate){
        
    Set<id>websiteIdinTrigger = new Set<id>();
    for(wint__Website_Account__c webAcc : Trigger.New){
       if(webAcc.wint__Contact__c <> Trigger.oldMap.get(webAcc.id).wint__Contact__c || webAcc.wint__Any__c <> Trigger.oldMap.get(webAcc.id).wint__Any__c){
            websiteIdinTrigger.add(webAcc.id);
            //System.debug('Testing if it is entering into trigger atleast');
        }
       
    }
    
    WebsiteAccountHandler.farmWrapperCalling(websiteIdinTrigger);
    
}

//}
}