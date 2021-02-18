public class Programs_TriggerHandler {

    public static void DuplicateCheck(Programs__c[] newRows){
        List<Id> AccountIDs = new List<Id>();
        if (newRows <> null){
            for (Programs__c p : newRows){
                if(p.Account__c <> null && CLS_StaticUtils.RecordTypeMap.get(p.RecordTypeID).DeveloperName <> 'AgriClime_Soybeans'){
                    AccountIDs.add(p.Account__c);
                }    
            }
        }
        
        List<Programs__c> ProgramsList = [Select Id, Account__c, Program_Year__c, Offer_Type__c,
                                          RecordType.Id, RecordType.Name, RecordType.DeveloperName 
                                          from Programs__c where Account__c in :AccountIDs];
        Map<String,ID> ProgramCodeMap = new Map<String,ID>();
        for (Programs__c p : ProgramsList){
            String programCode = p.Account__c+'|'+p.RecordType.DeveloperName+'|'+p.Offer_Type__c+'|'+p.Program_Year__c;
            ProgramCodeMap.put(programCode,p.Id);
        }
        for (Programs__c p : newRows){
            String recordTypeName = CLS_StaticUtils.RecordTypeMap.get(p.RecordTypeID).DeveloperName;
            String programCode = p.Account__c+'|'+recordTypeName+'|'+p.Offer_Type__c+'|'+p.Program_Year__c;
            if (ProgramCodeMap.containsKey(programCode)){ // if the key already exists
                if (ProgramCodeMap.get(programCode) != p.Id){ // if the record is different from the one being checked
                    p.addError('Error:  Program already exists for '+recordTypeName+' in '+p.Program_Year__c);
                    System.debug('Error:  Program already exists for '+recordTypeName+' in '+p.Program_Year__c);
                }
            }
        }
    }

    /**Public static void AgriclimeFulfilmentEmail(Programs__c[] listofAgriclimeProgramsRecord){ 
        List<Programs__c> records = [SELECT Id, Contact__c, Risk_Start_Period__c, Actual_Cashback__c, Payout_Status__c, Actual_Rainfall__c, Program_Reference__c, Rainfall_Threshold__c, Rainfall_Exit_Point__c, Longitude__c, Latitude__c FROM Programs__c WHERE Id =: listofAgriclimeProgramsRecord];        
        Set<Id> contactIds = new Set<Id>();
        Map<Id,Contact> conList = new Map<Id,Contact>();
       
        for(Programs__c record : records ){
            contactIds.add(record.Contact__c);
        }
        
        List<Contact> contactId = [SELECT id, AgriclimeRefNumber__c, (SELECT Id, Risk_Start_Period__c, Actual_Cashback__c, Payout_Status__c, Actual_Rainfall__c, Program_Reference__c, Rainfall_Threshold__c, Rainfall_Exit_Point__c, Longitude__c, Latitude__c FROM Programs__r),  Payout_Email_Sent__c, Agriclime_Payout_Details__c, Agriclime_Total_Payout__c FROM Contact WHERE id =: contactIds ];
    
        for(Contact e : ContactId){
            e.Agriclime_Payout_Details__c = ('');
            e.Agriclime_Total_Payout__c = 0;
        }
        for(Contact con : contactId){
            for(Programs__c totalPayout : con.Programs__r ){
                con.Agriclime_Total_Payout__c +=totalPayout.Actual_Cashback__c;
            }
            for(Programs__c onerecord : con.Programs__r ){
                //con.Agriclime_Total_Payout__c +=onerecord.Actual_Cashback__c;
                if(con.Agriclime_Total_Payout__c != 0 && (onerecord.Payout_Status__c == 'FINISH_PAYOUT' || con.Programs__r.Size() > 1 )){
                 //con.Agriclime_Payout_Details__c+= '<span style="font-size:20px;"><span style="color:#71840a;">Field: <strong> </strong></span></span><br><span style="font-size:18px;"><span style="font-size:18px;">Longitude: <strong>'+onerecord.longitude__c+'</strong><br><span style="font-size:18px;">Latitude: <strong>'+onerecord.latitude__c+'</strong><br>Risk Period Start Date: <strong>'+onerecord.Risk_Start_Period__c+ ' (duration fo 35 days)'+'</strong><br> Rainfall Threshold: <strong>'+onerecord.Rainfall_Threshold__c+' &nbsp;mm</strong><br>Rainfall Exit Ppoint: <strong>'+onerecord.Rainfall_Exit_Point__c+' &nbsp;mm</strong><br>Actual Rainfall: <strong>'+onerecord.Actual_Rainfall__c+' &nbsp;mm</strong><br>Actual Cashback: <strong>'+'$'+onerecord.Actual_Cashback__c+'&nbsp;CAD</strong><br>&nbsp;<br>';            
                 con.Agriclime_Payout_Details__c+= '<span style="font-size:16px;"><span style="color:#71840a;">Field: <strong> </strong></span></span><br><span style="font-size:15px;"><span style="font-size: 15px; ">Longitude: <strong>'+onerecord.longitude__c+'</strong><br><span style="font-size: 15px;">Latitude: <strong>'+onerecord.latitude__c+'</strong><br><span style="font-size: 15px;">Risk Period Start Date: <strong>'+onerecord.Risk_Start_Period__c+ ' (duration of 35 days)'+'</strong><br> <span style="font-size: 15px;">Rainfall Threshold: <strong>'+onerecord.Rainfall_Threshold__c+'&nbsp;mm</strong><br><span style="font-size: 15px;">Rainfall Exit Point: <strong>'+onerecord.Rainfall_Exit_Point__c+'&nbsp;mm</strong><br><span style="font-size: 15px;">Actual Rainfall: <strong>'+onerecord.Actual_Rainfall__c+'&nbsp;mm</strong><br>Actual Cashback: <strong>'+'$'+onerecord.Actual_Cashback__c+'&nbsp;CAD</strong><br><br>';            
                 
                 //CampaignMember qualifiedMember = new CampaignMember(CampaignId  = '7013m0000012fUU', ContactId = con.Id, Status = 'Qualified-Payout');
                 //database.upsert (QualifiedMember,false);
                 System.debug('actual cashback is:' +onerecord.Actual_Cashback__c);
                 
                }
                

                else if (con.Agriclime_Total_Payout__c == 0 && oneRecord.Payout_Status__c == 'FINISH_NO_PAYOUT') { 
                        CampaignMember notQualifiedMember = new CampaignMember(CampaignId  = '7013m0000012fUU', ContactId = con.Id, Status = 'Qualified-No-Payout');
                        database.insert (notQualifiedMember,false);
                }
                CampaignMember qualifiedMember = new CampaignMember(CampaignId  = '7013m0000012fUU', ContactId = con.Id, Status = 'Qualified-Payout');
                database.upsert (QualifiedMember,false);
                con.Payout_Email_Sent__c = 'Unsent';
        }       
        conList.put(con.Id, con);     
    }
    Update ConList.values();
}**/

}