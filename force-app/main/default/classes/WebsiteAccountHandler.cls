/*********************************************************************************************
* Apex Class Name    :     WebsiteAccountHandler
* Version            :     1.0
* Created Date       :     06-Jan-2020
* Function           :     This is class is used to deserialize the JSON data coming into website account object on agriclime registration to send out an auto responder through pardot.
* Modification Log
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Aakash                    06-Jan-2020            Created
***********************************************************************************************/
 public with sharing class WebsiteAccountHandler {
    /********************************************************************************************
* Method   : farmWrapperCalling
* Description: Method to call farm wrapper class to deserialize the JSON data coming into webstie account   
* ------------------------------------------------------------------------------------------
* Date          Name                    Modification Description
* ------------------------------------------------------------------------------------------
* 06-Jan-2020 Aakash                          Created  
********************************************************************************************/
    
    public static void farmWrapperCalling(Set<id> triggernew, Map<Id, wint__Website_Account__c> weboldMap){
        FarmWrapper farmtest;
        Map<Id,Contact> conList = new Map<Id,Contact>();
        Map<Id, Programs__c> ProgramMap = new Map<Id, Programs__c>();
        List<wint__Website_Account__c> tempwebAcc = [SELECT id,wint__Contact__c,wint__Campaign__c, wint__Contact2__c, wint__Email__c, wint__Lead__c,wint__Any__c,wint__ReferenceNo__c,wint__FirstName__c,wint__LastName__c,wint__Company__c, wint__Street__c,wint__City__c, wint__Street2__c,wint__PostalCode__c, wint__State__c, wint__FarmName__c  FROM wint__Website_Account__c WHERE id IN :triggernew];      
        system.debug('Testing if it is taking contact data');
        Set<Id> setOfContactIds = new Set<Id>();
        Double totalCommittedArea;
        for(wint__Website_Account__c w : tempwebAcc){        
            if(w.wint__Contact__c != null || w.wint__Lead__c != null ){
                System.debug('Testing if it is entering into tempwebAcc');
                List <Contact> listofContacts = [SELECT id, AgriclimeProgramDetails__c, AgriclimeLentilsProgramDetails__c,AgriclimeLentilsCommittedProductDetails__c,AgriclimeSoyCommittedProductDetails__c, Account.Id, Account.BillingState, (SELECT id, Vibrance_Maxx_RFC_Committed__c,Soybean_Variety_1_Committed__c, Soybean_Variety_2_Committed__c, Soybean_Variety_3_Committed__c, Soybean_Variety_4_Committed__c, Soybean_Variety_5_Committed__c,Soybean_Variety_6_Committed__c, Soybean_Variety_7_Committed__c, Soybean_Variety_8_Committed__c,Cruiser_Maxx_Vibrance_Beans_Committed__c, VibranceMaxx_RFC_AgriClime_Lentils__c, VibranceMaxx_RTA_Agriclime_Lentils__c,VibranceMaxx_Intego_Agriclime_Lentils__c,Elatus_AgriClime_Lentils__c FROM Programs__r) FROM Contact WHERE id =: w.wint__Contact__c ];
                
                List<Lead> LeadId = [SELECT id, Name, Email FROM Lead WHERE id =: w.wint__Lead__c ];
                List<Campaign> campaigns = new List<Campaign>();
                List<CampaignMember> members = new List<CampaignMember>(); 
                List<Programs__c> listofPrograms = new List<Programs__c>();
                List<String> summaryofproductDetailsList = new List<String>();
                //List<String> varietyDetails = new List<String>();
                Id agriClimeRecordTypeId = Schema.SObjectType.Programs__c.getRecordTypeInfosByName().get('AgriClime Soybeans').getRecordTypeId();
                Id agriClimeLentilsRecordTypeId = Schema.SObjectType.Programs__c.getRecordTypeInfosByName().get('AgriClime Lentils').getRecordTypeId();                
                farmtest = (FarmWrapper)JSON.deserialize(w.wint__Any__c, FarmWrapper.class); 
                //Map<Id,Contact> conList = new Map<Id,Contact>();
                Map<Id,Lead> leadList = new Map<Id, Lead>();
                Double Area = 0;
                Double potentialCashback = 0;
                Double committedPurchase = 0;
                                
                //if(Trigger.isInsert)
                //{
                    for(Contact e: listofContacts){
                        //system.debug('Testing if it is taking contact data' +e.Name);
                        if(w.wint__Campaign__c == 'Canada_Soy_Manitoba_2021' || w.wint__Campaign__c == 'Canada_Soy_Saskatchewan_2021'){ 
                         e.AgriclimeProgramDetails__c = ('');
                         e.AgriclimeSoyCommittedProductDetails__c = ('');
                         e.AgriclimeSoyCommittedProductDetails__c = '<strong>Total Committed&nbsp;Product&nbsp;Details<span style="font-size:16px;"></strong>';
                        //campaignMember soybeansMember = new CampaignMember(CampaignId  = '7013m000001dDv6', ContactId = e.Id, Status = 'Registered');
                        //database.insert (soybeansMember,false); 
                        for(FarmWrapper.cls_purchaseSummaryList purchaseSummary : farmtest.purchaseSummaryList){
                            String summaryofProduct = purchaseSummary.productLabel;
                            String summaryofAllProductAmount = String.valueOf(purchaseSummary.totalAmount);
                            String summaryofallProduct = summaryofProduct + ':'+ (' ')+'$'+ summaryofAllProductAmount; 
                            
                            e.AgriclimeSoyCommittedProductDetails__c +='<br>'+summaryofAllProduct+'<span style="font-size:14px;">';
                            //e.AgriclimeSoyCommittedProductDetails__c +='<br>';
                            
                    } 
                        }
                        else if(w.wint__Campaign__c == 'Canada_Lentil_2021'){
                        e.AgriclimeLentilsProgramDetails__c = ('');
                        e.AgriclimeLentilsCommittedProductDetails__c = ('');
                        e.AgriclimeLentilsCommittedProductDetails__c = '<strong>Total Committed&nbsp;Product&nbsp;Details<span style="font-size:16px;"></strong>';
                        //campaignMember lentilsMember = new CampaignMember(CampaignId  = '7013m000001dDvB', ContactId = e.Id, Status = 'Registered');
                        //database.insert (lentilsMember,false);
                        for(FarmWrapper.cls_purchaseSummaryList purchaseSummary : farmtest.purchaseSummaryList){
                            String summaryofProduct = purchaseSummary.productLabel;
                            String summaryofAllProductAmount = String.valueOf(purchaseSummary.totalAmount);
                            String summaryofallProduct = summaryofProduct + ':'+ (' ')+'$'+ summaryofAllProductAmount; 
                            
                            e.AgriclimeLentilsCommittedProductDetails__c +='<br>'+summaryofAllProduct+'<span style="font-size:14px;">';
                            //e.AgriclimeLentilsCommittedProductDetails__c +='<br>';
                            
                    }
                        }                       
                        
                 }
                 
                    String title = farmtest.campaign.title;
                    system.debug('title is' +title);
                    
                    String season = farmtest.campaign.season;
                    system.debug('Season is' +season);
                
                for(FarmWrapper.cls_farms fm : farmtest.farms){
                    String farmName = (fm.name !=null ? fm.name : '*No Field Name Specified*'); //fm.name;
                    Integer committedArea = fm.committedArea.intValue();
                    Area += committedArea;
                    String commitedAreaUoM = fm.commitedAreaUoM;                    
                    Decimal CashBack = fm.potentialCashback.setScale(2);
                    potentialCashback += CashBack;
                    String pc = potentialCashback.format();                    
                    String StartPayout = fm.weatherGuarantee;
                    //String actualCashbackCurrency = fm.currency;
                    double lattitude = (Double)fm.gridCell.location.lat;                    
                    double longitude = (Double)fm.gridCell.location.lng;                   
                    Decimal committedSpend = fm.committedSpend.setScale(2);
                    committedPurchase +=committedSpend;
                    String compspend = committedPurchase.format();
                    //String committedSpendCurrency = fm.currency;
                    List<String> productLabel = new List<String>();
                    List<String> productDetails = new List<String>();
                    //List<String> seedcareDetails = new List<String>();
                    //List<String> varietyDetails = new List<String>();
                    String weGuarantee = fm.weatherGuarantee;
                    String threshold;
                    String thresholdExit; 
                   
                    //String threshold = weGuarantee.substringBetween('if the rainfall during the selected guarantee period is below ', 'mm, up to a maximum payout of 30 % of the qualifying AgriClime purchases, if the rainfall is at or below');                   
                    //String thresholdCashback = weGuarantee.substringAfter(' up to a maximum payout of 30 % of the qualifying AgriClime purchases, if the rainfall is at or below ');
                    String Prodslabel;
                    String prodsAmount;                   
                    String startPeriods;
                    Integer periodDuration;
                    
                    /**for (FarmWrapper.cls_indexValues indexValues: fm.indexValues) {
                        threshold = indexValues.triggerDisplay;
                        thresholdExit = indexValues.exitDisplay;
                        
                            
                    }**/
                    for(FarmWrapper.cls_purchaseList purchase : fm.purchaseList){
                        String prdLabel = purchase.productLabel;
                        Double quantity = purchase.quantity;
                        Decimal price = purchase.price;
                        Decimal amts = (price*quantity).setScale(2);
                        //String amounts = (amount*quantity).format();
                        String prices = amts.format();						                        
                        String quantityUoM = purchase.quantityUoM;
                        String priceCurrency = purchase.priceCurrency;
                        //String prdDetails = prdLabel +','+' '+ '$'+ amounts +' '+amountCurrency;
                        String prdDetails = prdLabel +':'+' '+ '$'+ prices; 
                        productDetails.add(prdDetails);
                        /**if(prdLabel == 'CruiserMaxx Vibrance beans' || prdLabel == 'VibranceMaxx RFC'){
                            String purchaseSeedCareSummary = prdLabel + ','+quantity;
                            seedcareDetails.add(purchaseSeedCareSummary);
                        }
                        else{
                            String purchaseVarietySummary = prdLabel + ',' +quantity;
                            varietyDetails.add(purchaseVarietySummary);
                        }**/

                    }
                    
                    for(FarmWrapper.cls_riskPeriodList Periods : fm.riskPeriodList){
                        Date startDate = Periods.start;
                        Integer duration = Periods.duration;
                        periodDuration = duration;
                        Date EndDate = startDate.addDays(duration);                       
                        startPeriods = String.valueOf(startDate).removeEnd('00:00:00'); 
                        threshold  = Periods.indexValues.triggerDisplay;
                        thresholdExit = Periods.indexValues.exitDisplay;
                                                 
                    }  
                                       
                    for(Contact d : listofContacts){ 
                        if(title == 'Canada_Soy_Manitoba_2021' || title == 'Canada_Soy_Saskatchewan_2021'){                        
                        //d.AgriclimeRefNumber__c = '<span style="font-size:18px;">Your Program Reference: <strong>' +w.wint__ReferenceNo__c+ '</strong>';
                        d.AgriclimeName__c = '<span style="font-size:14px;">Name: <strong>' +w.wint__FirstName__c + ' ' +w.wint__LastName__c+ '</strong>';
                        //d.AgriclimeCompanyName__c = '<span style="font-size:18px;">Company Name: <strong>' +w.wint__Company__c+ '</strong>';
						d.AgriclimeActualCashback__c = '<span style="font-size:14px;"><strong>Potential Cash Back Amount: ' +'$' +pc+ '</strong>';                        
                        d.AgriclimeCommittedSpend__c = '<span style="font-size:14px;"><strong>Total Committed Purchases: ' +'$' +compspend+'</strong>';                           
                        
                        //d.AgriclimeProgramDetails__c += '<br><span style="font-size:18px;"><span style="color:#009dba;"><strong>Field:</strong> '+farmName+'</span></span><br> <span style="font-size:16px;"><strong>Longitude:</strong> '+longitude+'<br><strong> Latitude:</strong> '+lattitude+'<br> &nbsp;<br> <strong>Program&nbsp;Details</strong><br><br><strong>Risk Period:</strong></span><br> <span style="font-size:16px;">Start date: '+startPeriods+ ', duration '+periodDuration+ '&nbsp;days</span><br><br><span style="font-size:16px;"><strong>Weather Guarantee:</span></strong><br><span style="font-size:16px;">Rainfall Threshold:'+' '+threshold+' &nbsp;mm<br></span><span style="font-size:16px;">Rainfall Threshold Exit (30% Cash-Back):'+' '+thresholdExit+'</span><br><br>  <span style="font-size:16px;"><strong>Committed Area:</strong></span><span style="font-size:16px;">'+String.valueOf(committedArea)+ '&nbsp;Acres</span><br><br><span style="font-size:16px;"><strong>Committed&nbsp;Product&nbsp;Details<span style="font-size:18px;"></strong><br>';
                        d.AgriclimeProgramDetails__c += '<br><span style="font-size:16px;"><span style="color:#138DCD;"><strong>Field:</strong> '+farmName+'('+String.valueOf(committedArea)+ '&nbsp;Acres)</span></span><br><br> <span style="font-size:14px;"><strong>Longitude: </strong> '+longitude+', <strong>Latitude: </strong> '+lattitude+'<br> &nbsp;<br> <strong>Risk Period: </strong></span><span style="font-size:14px;">Start date: '+startPeriods+ ', duration '+periodDuration+ '&nbsp;days</span><br><br><span style="font-size:14px;"><strong>Weather Guarantee:</span></strong><br><span style="font-size:14px;">Rainfall Threshold:'+' '+threshold+' &nbsp;mm<br></span><span style="font-size:14px;">Rainfall Threshold Exit (30% Cash-Back):'+' '+thresholdExit+' &nbsp;mm </span><br><br>  <span style="font-size:14px;"><span style="font-size:14px;"><strong>Committed&nbsp;Product&nbsp;Details</strong><br>';
                        //d.AgriclimeStatus__c = 'Unsend';
                        d.AgriclimeCommittedArea__c = '<span style="font-size:14px;"><strong>Total Committed Area: ' +Area+ '&nbsp;Acres</strong><br>';                        
                        for(String p: productDetails){
                            d.AgriclimeProgramDetails__c += +p+'<span style="font-size:14px;">';
                            d.AgriclimeProgramDetails__c +='<br>';
                        }  
                        campaignMember soybeansMember = new CampaignMember(CampaignId  = '7013m000001dDv6', ContactId = d.Id, Status = 'Registered');
                        database.insert (soybeansMember,false);                       
                        //d.AgriclimeProgramDetails__c +='</strong></span></li> </ul> <p><span style="font-size:18px;"><strong></strong><br></span>';                        
                        //System.debug(+d.Programs.Id);
                     }
                        else if(title == 'Canada_Lentil_2021'){
                            d.AgriclimeName__c = '<span style="font-size:16px;">Name: <strong>' +w.wint__FirstName__c + ' ' +w.wint__LastName__c+ '</strong>';
                            d.AgriclimeLentilsCommittedArea__c = '<span style="font-size:14px;"><strong>Total Committed Area: ' +Area+ '&nbsp;Acres</strong><br>';
                            d.AgriclimeLentilsCommittedSpend__c = '<span style="font-size:14px;"><strong>Total Committed Purchases: ' +'$' +compspend+'</strong>';
                            d.AgriclimeLentilsPotentialCashback__c = '<span style="font-size:14px;"><strong>Potential Cash Back Amount: ' +'$' +pc+'</strong>';
                            //d.AgriclimeLentilsCommittedProductDetails__c = 
                            //d.AgriclimeLentilsProgramDetails__c += '<br><span style="font-size:18px;"><span style="color:#009dba;"><strong>Field:</strong> '+farmName+'</span></span><br> <span style="font-size:16px;"><strong>Longitude:</strong> '+longitude+'<br><strong> Latitude:</strong> '+lattitude+'<br> &nbsp;<br> <strong>Program&nbsp;Details</strong><br><br><strong>Risk Period:</strong></span><br> <span style="font-size:16px;">Start date: '+startPeriods+ ', duration '+periodDuration+ '&nbsp;days</span><br><br><span style="font-size:16px;"><strong>Weather Guarantee:</span></strong><br><span style="font-size:16px;">Rainfall Threshold:'+' '+threshold+' &nbsp;mm<br></span><span style="font-size:16px;">Rainfall Threshold Exit (30% Cash-Back):'+' '+thresholdExit+'</span><br><br>  <span style="font-size:16px;"><strong>Committed Area:</strong></span><span style="font-size:16px;">'+String.valueOf(committedArea)+ '&nbsp;Acres</span><br><br><span style="font-size:16px;"><strong>Committed&nbsp;Product&nbsp;Details<span style="font-size:18px;"></strong><br>';
                            d.AgriclimeLentilsProgramDetails__c += '<br><span style="font-size:16px;"><span style="color:#138DCD;"><strong>Field:</strong> '+farmName+'('+String.valueOf(committedArea)+ '&nbsp;Acres)</span></span><br><br> <span style="font-size:14px;"><strong>Longitude: </strong> '+longitude+', <strong>Latitude: </strong> '+lattitude+'<br> &nbsp;<br> <strong>Risk Period: </strong></span><span style="font-size:14px;">Start date: '+startPeriods+ ', duration '+periodDuration+ '&nbsp;days</span><br><br><span style="font-size:14px;"><strong>Weather Guarantee:</span></strong><br><span style="font-size:14px;">Rainfall Threshold:'+' '+threshold+' &nbsp;mm<br></span><span style="font-size:14px;">Rainfall Threshold Exit (30% Cash-Back):'+' '+thresholdExit+' &nbsp;mm </span><br><br>  <span style="font-size:14px;"><span style="font-size:14px;"><strong>Committed&nbsp;Product&nbsp;Details</strong><br>';
                            
                            for(String p: productDetails){
                                d.AgriclimeLentilsProgramDetails__c += +p+'<span style="font-size:14px;">';
                                d.AgriclimeLentilsProgramDetails__c +='<br>';
                                }
                            campaignMember lentilsMember = new CampaignMember(CampaignId  = '7013m000001dDvB', ContactId = d.Id, Status = 'Registered');
                            database.insert (lentilsMember,false);
                        }
                        conList.put(d.Id,d);
                        setOfContactIds.add(d.Id);                          
                    } 
                       if(conList.size()>0 && (title == 'Canada_Soy_Manitoba_2021' || title == 'Canada_Soy_Saskatchewan_2021')){ 
                        List<Programs__c> listofUpdatePrograms = [SELECT id, Contact__r.Id, Vibrance_Maxx_RFC_Committed__c,Soybean_Variety_1_Committed__c, Soybean_Variety_2_Committed__c, Soybean_Variety_3_Committed__c, Soybean_Variety_4_Committed__c, Soybean_Variety_5_Committed__c,Soybean_Variety_6_Committed__c, Soybean_Variety_7_Committed__c, Soybean_Variety_8_Committed__c,Cruiser_Maxx_Vibrance_Beans_Committed__c,VibranceMaxx_RFC_AgriClime_Lentils__c, VibranceMaxx_RTA_Agriclime_Lentils__c, VibranceMaxx_Intego_Agriclime_Lentils__c, Elatus_AgriClime_Lentils__c FROM Programs__c WHERE Contact__r.Id IN : conList.keySet() AND RecordTypeId = :agriClimeRecordTypeId];
                       
                        if(listofUpdatePrograms.Size() > 0 ){
                     
                        for(Programs__c updatedprogramRecord : listofUpdatePrograms){
                        updatedprogramRecord.Soybean_Variety_1_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_2_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_3_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_4_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_5_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_6_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_7_Committed__c = null;
                        updatedprogramRecord.Soybean_Variety_8_Committed__c = null;
                        updatedprogramRecord.Cruiser_Maxx_Vibrance_Beans_Committed__c = null;
                        updatedprogramRecord.Vibrance_Maxx_RFC_Committed__c = null;
                        updatedprogramRecord.Total_Committed_Acres__c = Area;
                        for(FarmWrapper.cls_purchaseSummaryList purchaseSummary : farmtest.purchaseSummaryList){
                            String summaryProduct = purchaseSummary.productLabel;
                            Double quantity = purchaseSummary.quantity;

                         System.debug('Testing if it is entering into purchase summary for program record');
                        if (summaryProduct == 'S001-D8X ') {
                        
                        updatedprogramRecord.Soybean_Variety_1_Committed__c = quantity;

                        } 
                    
                         if(summaryProduct == 'S003-Z4X '){
                        
                         updatedprogramRecord.Soybean_Variety_2_Committed__c = quantity;
                        }
                    
                     if(summaryProduct == 'S005-C9X '){
                        
                        updatedprogramRecord.Soybean_Variety_3_Committed__c = quantity;
                        }
                    
                        if(summaryProduct == 'S006-M4X '){
                        //programRecord.Soybean_Variety_4__c = 'S006-M4X';
                        updatedprogramRecord.Soybean_Variety_4_Committed__c = quantity;
                         }
                   
                        if(summaryProduct == 'S007-A2XS'){
                        //programRecord.Soybean_Variety_5__c ='S007-A2XS';
                        updatedprogramRecord.Soybean_Variety_5_Committed__c = quantity;
                        }
                    
                        if(summaryProduct == 'S007-Y4 '){
                        //programRecord.Soybean_Variety_6__c ='S007-Y4';
                        updatedprogramRecord.Soybean_Variety_6_Committed__c = quantity;
                         }
                    
                        if(summaryProduct == 'S0009-F2X '){
                        
                        updatedprogramRecord.Soybean_Variety_7_Committed__c = quantity;
                         }
                    
                        if(summaryProduct == 'S0009-M2'){
                        
                        updatedprogramRecord.Soybean_Variety_8_Committed__c = quantity;
                        }
                   
                    
                        if(summaryProduct == 'CruiserMaxx Vibrance beans '){
                        
                        updatedprogramRecord.Cruiser_Maxx_Vibrance_Beans_Committed__c = quantity;
                        }
                   
                        if(summaryProduct == 'VibranceMaxx RFC '){
                       
                        updatedprogramRecord.Vibrance_Maxx_RFC_Committed__c = quantity;
                         }
                 
                    
                         } ProgramMap.put(updatedprogramRecord.Id, updatedprogramRecord);
                        } 
                            update listofUpdatePrograms;
                     }
                    }
                    if(conList.size()>0 && title == 'Canada_Lentil_2021'){ 
                        List<Programs__c> listofUpdatePrograms = [SELECT id, Contact__r.Id, Vibrance_Maxx_RFC_Committed__c,Soybean_Variety_1_Committed__c, Soybean_Variety_2_Committed__c, Soybean_Variety_3_Committed__c, Soybean_Variety_4_Committed__c, Soybean_Variety_5_Committed__c,Soybean_Variety_6_Committed__c, Soybean_Variety_7_Committed__c, Soybean_Variety_8_Committed__c,Cruiser_Maxx_Vibrance_Beans_Committed__c,VibranceMaxx_RFC_AgriClime_Lentils__c, VibranceMaxx_RTA_Agriclime_Lentils__c, VibranceMaxx_Intego_Agriclime_Lentils__c, Elatus_AgriClime_Lentils__c ,AgriClime_Lentils_Total_Committed_Acres__c FROM Programs__c WHERE Contact__r.Id IN : conList.keySet() AND RecordTypeId = :agriClimeLentilsRecordTypeId];
                       
                        if(listofUpdatePrograms.Size() > 0 ){
                             for(Programs__c updatedprogramRecord : listofUpdatePrograms){
                                 updatedprogramRecord.VibranceMaxx_RFC_AgriClime_Lentils__c = null;
                                 updatedprogramRecord.VibranceMaxx_RTA_Agriclime_Lentils__c = null;
                                 updatedprogramRecord.VibranceMaxx_Intego_Agriclime_Lentils__c = null;
                                 updatedprogramRecord.Elatus_AgriClime_Lentils__c = null;
                                 updatedprogramRecord.AgriClime_Lentils_Total_Committed_Acres__c = Area;
                             
                             for(FarmWrapper.cls_purchaseSummaryList purchaseSummary : farmtest.purchaseSummaryList){
                                String summaryProduct = purchaseSummary.productLabel;
                                Double quantity = purchaseSummary.quantity;
                                if (summaryProduct == 'VibranceMaxx RFC ') {
                                    //programRecord.Soybean_Variety_1__c = 'S001-D8X ';
                                    updatedprogramRecord.VibranceMaxx_RFC_AgriClime_Lentils__c = quantity;
            
                                } 
                                
                                if(summaryProduct == 'VibranceMaxx RTA'){
                                    
                                    updatedprogramRecord.VibranceMaxx_RTA_Agriclime_Lentils__c = quantity;
                                }
                                
                                if(summaryProduct == 'VibranceMaxx Intego'){
                                    
                                    updatedprogramRecord.VibranceMaxx_Intego_Agriclime_Lentils__c = quantity;
                                }
                                
                                if(summaryProduct == 'Elatus'){
                                    
                                    updatedprogramRecord.Elatus_AgriClime_Lentils__c = quantity;
                                }                           
                            } ProgramMap.put(updatedprogramRecord.Id, updatedprogramRecord);
                         }
                         update listofUpdatePrograms;
                        }
                     }
                    if(Area != null){
                        totalCommittedArea = Area;
                    }
                } 
                
                
                for(Contact programContact : listofContacts){                   
                    if(Trigger.isInsert || (weboldMap.get(w.id).wint__Contact__c == null && w.wint__Contact__c <> null) ){ 
                      //if(Trigger.isInsert){ 
                    Programs__c programRecord = new Programs__c();
                   
                    if(title == 'Canada_Soy_Manitoba_2021' || title == 'Canada_Soy_Saskatchewan_2021'){
                    programRecord.Program_Reference__c = +w.wint__ReferenceNo__c;
                    programRecord.Account__c = programContact.Account.Id;
                    programRecord.Contact__c = programContact.Id;
                    programRecord.RecordtypeId = agriClimeRecordTypeId;
                    programRecord.Total_Committed_Acres__c =totalCommittedArea;
                    programRecord.Province__c = programContact.Account.BillingState;
                    
                    listofPrograms.add(programRecord);
                    
                    for(FarmWrapper.cls_purchaseSummaryList purchaseSummary : farmtest.purchaseSummaryList){
                        String summaryProduct = purchaseSummary.productLabel;
                        Double quantity = purchaseSummary.quantity;
                        if (summaryProduct == 'S001-D8X ') {
                            //programRecord.Soybean_Variety_1__c = 'S001-D8X ';
                            programRecord.Soybean_Variety_1_Committed__c = quantity;
    
                        } 
                        
                        if(summaryProduct == 'S003-Z4X '){
                            
                            programRecord.Soybean_Variety_2_Committed__c = quantity;
                        }
                        
                        if(summaryProduct == 'S005-C9X '){
                            
                            programRecord.Soybean_Variety_3_Committed__c = quantity;
                        }
                        
                        if(summaryProduct == 'S006-M4X '){
                            
                            programRecord.Soybean_Variety_4_Committed__c = quantity;
                        }
                      
                        if(summaryProduct == 'S007-A2XS'){
                            
                            programRecord.Soybean_Variety_5_Committed__c = quantity;
                        }
                        
                        if(summaryProduct == 'S007-Y4 '){
                            //programRecord.Soybean_Variety_6__c ='S007-Y4';
                            programRecord.Soybean_Variety_6_Committed__c = quantity;
                        }
                        
                        if(summaryProduct == 'S0009-F2X '){
                            
                            programRecord.Soybean_Variety_7_Committed__c = quantity;
                        }
                        
                        if(summaryProduct == 'S0009-M2'){
                            
                            programRecord.Soybean_Variety_8_Committed__c = quantity;
                        }
                        
                        
                        if(summaryProduct == 'CruiserMaxx Vibrance beans '){
                            
                            programRecord.Cruiser_Maxx_Vibrance_Beans_Committed__c = quantity;
                        }
                        
                        if(summaryProduct == 'VibranceMaxx RFC '){
                            
                            programRecord.Vibrance_Maxx_RFC_Committed__c = quantity;
                        }
                           
                    } 
                    //programRecord.Total_Committed_Acres__c = programRecord.Area;
                    }
                    
                    if(title == 'Canada_Lentil_2021'){
                    programRecord.AgriClime_Lentils_Program_Reference__c = +w.wint__ReferenceNo__c;
                    programRecord.Account__c = programContact.Account.Id;
                    programRecord.Contact__c = programContact.Id;
                    programRecord.RecordtypeId = agriClimeLentilsRecordTypeId;
                    programRecord.AgriClime_Lentils_Total_Committed_Acres__c =totalCommittedArea;
                    programRecord.Province__c = programContact.Account.BillingState;
                    
                    listofPrograms.add(programRecord);
                    
                    for(FarmWrapper.cls_purchaseSummaryList purchaseSummary : farmtest.purchaseSummaryList){
                        String summaryProduct = purchaseSummary.productLabel;
                        Double quantity = purchaseSummary.quantity;
                        if (summaryProduct == 'VibranceMaxx RFC ') {
                            //programRecord.Soybean_Variety_1__c = 'S001-D8X ';
                            programRecord.VibranceMaxx_RFC_AgriClime_Lentils__c = quantity;
    
                        } 
                        
                        if(summaryProduct == 'VibranceMaxx RTA'){
                            
                            programRecord.VibranceMaxx_RTA_Agriclime_Lentils__c = quantity;
                        }
                        
                        if(summaryProduct == 'VibranceMaxx Intego'){
                            
                            programRecord.VibranceMaxx_Intego_Agriclime_Lentils__c = quantity;
                        }
                        
                        if(summaryProduct == 'Elatus'){
                            
                            programRecord.Elatus_AgriClime_Lentils__c = quantity;
                        }                           
                    } 

                    }                            
                }
            }
                Insert ListofPrograms;
                for(Lead ld : LeadId){
                    if(w.wint__Email__c != null){
                        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                        list<String> toAddresses = new List<String>{'kevin.heal@syngenta.com'};
                        singleMail.setToAddresses(toAddresses);
                        singleMail.setSubject('Lead needs to be converted for :'+' ' +ld.Name);
                        singleMail.setPlainTextBody('Please convert this lead to send out registration email to: ' +'<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+ld.Id+' >'+ ld.Name+'</a> <br/>' + '<br>' + 'Email  address:</b>' +' '+ ld.Email);
                        //singleMail.setHtmlBody('Please convert this lead to send out registration email to: <b> ' +ld.Name + '<br>' + 'Email  address:</b>' + ld.Email);
                        singleMail.setHtmlBody('Please convert this lead to send out registration email to: <b> ' +'<a href=' +System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+ld.Id+' >'+ ld.Name+'</a> <br/>' + '<br>' + 'Email  address :</b>' +' '+ ld.Email);
                        Messaging.sendEMail(new Messaging.SingleEmailMessage[]{singleMail});
                        //system.debug('lead is' +ld);
                    }
                } 
            } 
            
        }  
        update conList.values();
    } 
}