public class Programs_TriggerHandler {

    public static void DuplicateCheck(Programs__c[] newRows){
        List<Id> AccountIDs = new List<Id>();
        if (newRows <> null){
            for (Programs__c p : newRows){
                if(p.Account__c <> null && CLS_StaticUtils.RecordTypeMap.get(p.RecordTypeID).DeveloperName <> 'AgriClime_Soybeans' && CLS_StaticUtils.RecordTypeMap.get(p.RecordTypeID).DeveloperName <> 'AgriClime_Lentils' && CLS_StaticUtils.RecordTypeMap.get(p.RecordTypeID).DeveloperName <> 'AgriClime_Payout_Backend'){
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

    Public static void AgriclimeFulfilmentEmail(Programs__c[] listofAgriclimeProgramsRecord){ 
        Map<Id,Contact> conList = new Map<Id,Contact>();
        Double actualCashback = 0;
        List<Programs__c> records = [SELECT Id, AgriClimePayoutEmailActualRainfall__c, AgriClimePayoutCampaignorOfferName__c, Contact__c, Payout_Status__c, AgriClimePayoutEmailActualCashback__c, AgriClimePayoutEmailLatitude__c, AgriClimePayoutEmailLongitude__c, AgriClimePayoutEmailRainfallExitPoint__c,AgriClimePayoutEmailRainfallThreshold__c,AgriClimePayoutEmailRiskStartPeriod__c, AgriClimePayoutRecordIdentifier__c FROM Programs__c WHERE Id =: listofAgriclimeProgramsRecord];        
        Map<Id, List<Programs__c>> LentilsUploadedProgramsMap = new Map<Id, List<Programs__c>>();
        Map<Id, List<Programs__c>> testMap = new Map<Id, List<Programs__c>>();
            {
    }
        Set<Id> contactIds = new Set<Id>();
        //Map<Id,Contact> conList = new Map<Id,Contact>();

        Map<Id, List<Programs__c>> contactLentilsProgramsMap = new Map<Id, List<Programs__c>>();
        List<Programs__c> updatedPrograms =  new List<Programs__c>();
        
        Id agriClimeLentilsRecordTypeId = Schema.SObjectType.Programs__c.getRecordTypeInfosByName().get('AgriClime Lentils').getRecordTypeId();                
        Id agriClimeLentilsBackendRecordTypeId = Schema.SObjectType.Programs__c.getRecordTypeInfosByName().get('AgriClime Payout Backend').getRecordTypeId();                        
        List<CampaignMember> cm = new List<CampaignMember>();
        
        for(Programs__c programrecord : records){ 
            List<Contact> listofContacts = [SELECT id, (SELECT Id, AgriClimePayoutEmailActualRainfall__c, AgriClimePayoutCampaignorOfferName__c, Contact__c, Payout_Status__c, AgriClimePayoutEmailActualCashback__c, AgriClimePayoutEmailLatitude__c, AgriClimePayoutEmailLongitude__c, AgriClimePayoutEmailRainfallExitPoint__c,AgriClimePayoutEmailRainfallThreshold__c,AgriClimePayoutEmailRiskStartPeriod__c, AgriClimePayoutRecordIdentifier__c FROM Programs__r WHERE RecordTypeId =:agriClimeLentilsBackendRecordTypeId), AgriclimeLentilsPayoutDetails__c, AgriclimeLentilsTotalPayout__c,Agriclime_Payout_Details__c,Agriclime_Total_Payout__c FROM Contact WHERE id =: programrecord.Contact__c ];
            //if(Trigger.isInsert){ this has to enable before deploymment
            for(Contact e : listofContacts){
                if(e.AgriclimeLentilsPayoutDetails__c == null){
                e.AgriclimeLentilsPayoutDetails__c = ('');
                }
                if(e.Agriclime_Payout_Details__c ==null){
                    e.Agriclime_Payout_Details__c = ('');
                }
                if(e.AgriclimeLentilsTotalPayout__c == null){
                    e.AgriclimeLentilsTotalPayout__c = 0;
                }
                if(e.Agriclime_Total_Payout__c == null){
                    e.Agriclime_Total_Payout__c = 0;
                }
            }
            // }
                if(programrecord.Contact__c != null){
                    for(Contact f : listofContacts){
                        List<CampaignMember> cmList =  [SELECT id, status FROM CampaignMember WHERE ContactId =: f.Id AND CampaignId =: '7013m000001dDvB' ];  
                        if ((programrecord.Payout_Status__c == 'FINISH_PAYOUT' && programrecord.AgriClimePayoutCampaignorOfferName__c == 'AgriClime Lentils 2021')|| (programrecord.Payout_Status__c == 'FINISH_NO_PAYOUT' && f.AgriclimeLentilsTotalPayout__c <> 0 && programrecord.AgriClimePayoutCampaignorOfferName__c == 'AgriClime Lentils 2021')) {
                        //f.AgriclimeLentilsPayoutDetails__c+= '<span style="font-size:16px;"><span style="color:#71840a;">Field: <strong> </strong></span></span><br><span style="font-size:15px;"><span style="font-size: 15px; ">Longitude: <strong>'+programrecord.AgriClimeLentilsPayoutLongitude__c+'</strong><br><span style="font-size: 15px;">Latitude: <strong>'+programrecord.AgriclimeLentilsPayoutLatitude__c+'</strong><br><span style="font-size: 15px;">Risk Period Start Date: <strong>'+programrecord.AgriclimeLentilsPayoutRiskStartPeriod__c+ ' (duration of 35 days)'+'</strong><br> <span style="font-size: 15px;">Rainfall Threshold: <strong>'+programrecord.AgriclimeLentilsPayoutRainfallThreshold__c+'&nbsp;mm</strong><br><span style="font-size: 15px;">Rainfall Exit Point: <strong>'+programrecord.AgriclimeLentilsPayoutRainfallExitPoint__c+'&nbsp;mm</strong><br><span style="font-size: 15px;">Actual Rainfall: <strong>'+'&nbsp;mm</strong><br>Actual Cashback: <strong>'+'$'+programrecord.AgriclimeLentilsPayoutActualCashback__c+'&nbsp;CAD</strong><br><br>';            
                        f.AgriclimeLentilsPayoutDetails__c+= '<span style="font-size:16px;"><span style="color: #E94E1B;"><strong>Field: </strong></span></span><br><span style="font-size:14px;"><strong>Longitude:</strong> '+programrecord.AgriClimePayoutEmailLongitude__c+', <span style="font-size: 14px;"><strong>Latitude:</strong> '+programrecord.AgriClimePayoutEmailLatitude__c+'<br><span style="font-size: 14px;"><strong>Risk Period Start Date:</strong> '+programrecord.AgriClimePayoutEmailRiskStartPeriod__c+ ' (duration of 35 days)'+'<br> <span style="font-size: 14px;"><strong>Rainfall Threshold:</strong> '+programrecord.AgriClimePayoutEmailRainfallThreshold__c+'&nbsp;mm<br><span style="font-size: 14px;"><strong>Rainfall Exit Point:</strong> '+programrecord.AgriClimePayoutEmailRainfallExitPoint__c+'&nbsp;mm<br><span style="font-size: 14px;"><strong>Actual Rainfall:</strong> '+programrecord.AgriClimePayoutEmailActualRainfall__c+'&nbsp;mm<br><strong>Actual Cashback:</strong> '+'$'+programrecord.AgriClimePayoutEmailActualCashback__c+'&nbsp;<br></span>';            
                        //f.AgriclimeLentilsPayoutDetails__c+= '<span style="font-size:16px;"><span style="color: #E94E1B;"><strong>Field: </strong></span></span><br><span style="font-size:14px;"><strong>Longitude:</strong> '+programrecord.AgriClimePayoutEmailLongitude__c+', <span style="font-size: 14px;"><strong>Latitude:</strong> '+programrecord.AgriClimePayoutEmailLatitude__c+'<br><span style="font-size: 14px;"><strong>Risk Period Start Date:</strong> '+programrecord.AgriClimePayoutEmailRiskStartPeriod__c+ ' (duration of 35 days)'+'<br> <span style="font-size: 14px;"><strong>Rainfall Threshold:</strong> '+programrecord.AgriClimePayoutEmailRainfallThreshold__c+'&nbsp;mm<br><span style="font-size: 14px;"><strong>Rainfall Exit Point:</strong> '+programrecord.AgriClimePayoutEmailRainfallExitPoint__c+'&nbsp;mm<br><span style="font-size: 14px;"><strong>Actual Rainfall:</strong> '+programrecord.AgriClimePayoutEmailActualRainfall__c+'&nbsp;mm<br><strong>Actual Cashback:</strong> '+'$'+programrecord.AgriClimePayoutEmailActualCashback__c+'&nbsp;<br></span>';            
                        f.AgriclimeLentilsTotalPayout__c+= programrecord.AgriClimePayoutEmailActualCashback__c;
                        
                        
                        if (programrecord.AgriClimePayoutCampaignorOfferName__c == 'AgriClime Lentils 2021' && programrecord.Payout_Status__c == 'FINISH_PAYOUT' && f.AgriclimeLentilsTotalPayout__c <> 0) {
                            for(CampaignMember cms : cmList){
                                cms.status = 'Qualified Payout';
                                //cmList.add(cms);
                            }
                            update cmList; 
                        }
                }
                else if(programrecord.AgriClimePayoutCampaignorOfferName__c == 'AgriClime Lentils 2021' && programrecord.Payout_Status__c == 'FINISH_NO_PAYOUT' && f.AgriclimeLentilsTotalPayout__c == 0 ){
                        
                    for(CampaignMember cms : cmList){
                        cms.status = 'Qualified No-Payout';
                        //cmList.add(cms);
                    }
                    update cmList;

                }        
                
                    if((programrecord.Payout_Status__c == 'FINISH_PAYOUT' && programrecord.AgriClimePayoutCampaignorOfferName__c == 'Canada_Soy_2021')|| (programrecord.Payout_Status__c == 'FINISH_NO_PAYOUT' && f.AgriclimeLentilsTotalPayout__c <> 0 && programrecord.AgriClimePayoutCampaignorOfferName__c == 'Canada_Soy_2021')){
                        f.Agriclime_Payout_Details__c += '<span style="font-size:16px;"><span style="color:#138DCD;"><strong>Field: </strong></span></span><br><span style="font-size:14px;"><strong>Longitude:</strong> '+ programrecord.AgriClimePayoutEmailLongitude__c +', <span style="font-size: 14px;"><strong>Latitude:</strong> '+ programrecord.AgriClimePayoutEmailLatitude__c +'<br><span style="font-size: 14px;"><strong>Risk Period Start Date:</strong> '+ programrecord.AgriClimePayoutEmailRiskStartPeriod__c + ' (duration of 35 days)'+'<br> <span style="font-size: 14px;"><strong>Rainfall Threshold:</strong> '+ programrecord.AgriClimePayoutEmailRainfallThreshold__c +'&nbsp;mm<br><span style="font-size: 14px;"><strong>Rainfall Exit Point:</strong> '+ programrecord.AgriClimePayoutEmailRainfallExitPoint__c +'&nbsp;mm<br><span style="font-size: 14px;"><strong>Actual Rainfall:</strong> '+programrecord.AgriClimePayoutEmailActualRainfall__c+ '&nbsp;mm<br><strong>Actual Cashback:</strong> '+'$'+ programrecord.AgriClimePayoutEmailActualCashback__c +'&nbsp;<br><br></span>';            
                        f.Agriclime_Total_Payout__c += programrecord.AgriClimePayoutEmailActualCashback__c;
                    
                        List<CampaignMember> cmList1 =  [SELECT id, status FROM CampaignMember WHERE ContactId =: f.Id AND CampaignId =: '7013m000001dDv6' ];    
                        if(programrecord.AgriClimePayoutCampaignorOfferName__c == 'Canada_Soy_2021' && programrecord.Payout_Status__c == 'FINISH_NO_PAYOUT' && f.AgriclimeLentilsTotalPayout__c == 0 ){
                        
                        for(CampaignMember cms : cmList1){
                            cms.status = 'Qualified No-Payout';
                            //cmList.add(cms);
                        }
                        update cmList1;
                        

                    }
                        else if(programrecord.AgriClimePayoutCampaignorOfferName__c == 'Canada_Soy_2021' && programrecord.Payout_Status__c == 'FINISH_PAYOUT' && f.AgriclimeLentilsTotalPayout__c <> 0 ){
                            for(CampaignMember cms : cmList1){
                                cms.status = 'Qualified Payout';
                                //cmList.add(cms);
                            }
                            update cmList1;
                    }
                }
                    
                    conList.put(f.Id,f);
                    
                    
                }
            }Update conList.values();
          
        }
        
    
    
}

}