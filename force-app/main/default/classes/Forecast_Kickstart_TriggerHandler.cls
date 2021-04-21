public class Forecast_Kickstart_TriggerHandler {

    /* Update all the related Settlement and Settlement Payments Status as set on the Cheque Run*/
    public static void createBPandForecast(Forecast_Kickstart__c[] newList){
    
        for(Forecast_Kickstart__c f : newList){
     
            List<Account> AccountList = new List<Account>();
            List<Account_Territory__c> AccTerrList = new List<Account_Territory__c>();
            List<Business_Plan__c> allBusinessPlanList = new List<Business_Plan__c>();
            List<Business_Plan__c> insertBusinessPlanList = new List<Business_Plan__c>();            
            List<Business_Plan__c> existingBusinessPlanList = new List<Business_Plan__c>();            
            List<Opportunity> OpportunityList = new List<Opportunity>();
            List<Opportunity> existingOpportunityList = new List<Opportunity>();            
            List<Opportunity> allOpportunityList = new List<Opportunity>();
            Map<Id, Account> AccountMap = new Map<Id, Account>();
            Map<Id, Account_Territory__c> AccountTerritoryMap = new Map<Id, Account_Territory__c>();
            AccountList = [select Id, Territory_Lookup__c, OwnerId, Retailer_Head_Office_Rel__c from Account where NSAP_ID__c = :f.NSAP_ID__c];
            Map<String, Business_Plan__c> existBPMap = new Map<String, Business_Plan__c>();
            Map<String, Opportunity> existOppMap = new Map<String, Opportunity>();            
            
            existingBusinessPlanList = [select Id, Account__c, OwnerId, Unique_Key__c from Business_Plan__c where RecordTypeId = '0121N0000012dXNQAY'];
            for(Business_Plan__c b : existingBusinessPlanList){
                if(existBPMap.get(b.Unique_Key__c)== null){
                    existBPMap.put(b.Unique_Key__c,b);
                }
            }
            existingOpportunityList = [select Id, AccountId, OwnerId, RecordTypeId, Year__c,PriceBook2Id,Related_Business_Plan_Locked__c,CountofOppProducts__c,CommercialUnit__c,Opportunity.RecordType.DeveloperName,Product_Type__c,Territory__c from Opportunity where RecordTypeId = '0121N0000012dXcQAI' and Year__c =:f.Year__c];
            for(Opportunity o : existingOpportunityList){
                if(existOppMap.get(o.AccountId + '|0121N0000012dXcQAI|' + o.Year__c)== null){
                    existOppMap.put(o.AccountId + '|0121N0000012dXcQAI|' + o.Year__c,o);
                }
            }
            
            for(Account a : AccountList){
                if(existBPMap.get(a.Id + '|' + f.Year__c + '|0121N0000012dXNQAY') == null){
                    Business_Plan__c bp = new Business_Plan__c(Account__c=a.Id, RecordTypeId = '0121N0000012dXNQAY', OwnerId = a.OwnerId, Year__c=f.Year__c );
                    insertBusinessPlanList.add(bp);
                    allBusinessPlanList.add(bp);
                }
                else allBusinessPlanList.add(existBPMap.get(a.Id + '|' + f.Year__c + '|0121N0000012dXNQAY'));            
                
                   
                AccountMap.put(a.Id, a);
            }
            
            
            AccTerrList = [Select Id, Account__c, Territory__c, Head_Office_Account__c from Account_Territory__c where Sales_Org__c = '1000'];
            for(Account_Territory__c at : AccTerrList){
                AccountTerritoryMap.put(at.Account__c, at);
            }
            
            insert insertBusinessPlanList;
            for(Business_Plan__c b : allBusinessPlanList){
            
                if(existOppMap.get(b.Account__c + '|0121N0000012dXcQAI|' + f.Year__c) == null){
                    Opportunity SalesPlan =  new Opportunity (AccountId=b.Account__c, RecordTypeId='0121N0000012dXcQAI', Name = 'Foo', AccountBusinessPlan__c = b.Id, StageName = 'Closed', Year__c = f.Year__c, OwnerId = b.OwnerId, Territory__c = AccountMap.get(b.Account__c).Territory_Lookup__c, Account_Territory__c = AccountTerritoryMap.get(b.Account__c).Id,CloseDate = Date.newInstance(Integer.valueOf(f.Year__c), 12, 31), Sales_Plan_Type__c = 'ASP', Type = 'Sales Plan', Product_Type__c = 'CP', Pricebook2Id = Label.CP_Price_Book, RelatedDistributor__c=f.Related_Distributor__c);
                    OpportunityList.add(SalesPlan);
                    allOpportunityList.add(SalesPlan);
                }
                else allOpportunityList.add(existOppMap.get(b.Account__c + '|0121N0000012dXcQAI|' + f.Year__c));         
            
            }
            insert OpportunityList;
            for(Opportunity oppty : allOpportunityList){
                ToUpdateRelatedPlan.UpdateDSPRelatedPlan(oppty);    
            
             List<OpportunitylineItem > InsertOppList = new List<OpportunitylineItem >();
             try{
                        if(oppty.PriceBook2Id != null){
                            //     List<opportunityLineItem> Nplus1InsList = new List<opportunityLineItem>();
                            Set<Id> existingOLIProdIds = new Set<Id>();
                            if(Oppty.CountofOppProducts__c > 0){
                                //To check whether the opp already have some line items and to ignore them in insert
                                for(OpportunityLineItem oli: [Select Product2Id from OpportunityLineItem where OpportunityId = :Oppty.Id]){
                                    existingOLIProdIds.add(oli.Product2Id);
                                }
                            }
                            System.debug('Going in to SalesPlanCreationHandler class');
                            InsertOppList = SalesPlanCreationHandler.getInsertOLIList(Oppty, existingOLIProdIds, false, true);//remove true
                            
                            if(!InsertOppList.isEmpty())
                            {
                                set<opportunitylineitem> insertOppSet = new set<opportunityLineItem>();
                                insertOppSet.addAll(InsertOppList);
                                InsertOppList.clear();
                                InsertOppList.addAll(insertOppSet);
                            }
                            Database.upsert(InsertOppList);
                                                     
                        }
                    }catch(Exception e){
                        Exception_Log__c exceptionLogRecord = ExceptionLogHelperClass.createExceptionLogRecord('OpportunityLineItem','NA','PopulatOliHandler','createOLIsFromPastData','Technical exception',UserInfo.getUserId(),e.getStackTraceString(),'',e.getMessage());
                        insert exceptionLogRecord;
                    }
            }
             
        }             
             
    }
            
}