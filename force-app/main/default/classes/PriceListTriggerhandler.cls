/**************************************************************************************
* Apex Class Name    :     PriceListTriggerHandler
* Version            :     1.0
* Created Date       :     05/Feb/2018
* Function           :     Handler class for mapPriceListwithOLI
* Developer          :     Pratibha                     
*************************************************************************************/
public class PriceListTriggerhandler {
    
    private map<String,Id> PriceList = new map<String,Id>();    
    private List<opportunityLineItem> oliSDP= new List<opportunityLineItem>();
    private List<opportunityLineItem> oliNet= new List<opportunityLineItem>();    
    
    public void updateOLIPriceListRel(){
        
        for(Price_List__c p: (List<Price_List__c>)Trigger.new){        
            PriceList.put(p.Uniquekey__c, p.Id);   
            /*System.debug('UniqueKeyfound'+p.Uniquekey__c);*/
        } 
        
        /*List<opportunityLineItem> oli=[select Id, PL_MatchingKey__c, PL_NSP_Matching_Key__c, PriceList_Lookup__c, Price_List_NSP__c from opportunityLineItem where PL_MatchingKey__c In:PriceList.keySet() or PL_NSP_Matching_Key__c In:PriceList.keySet() ];     */
        List<opportunityLineItem> oliSDP=[select Id, PL_MatchingKey__c, PriceList_Lookup__c from opportunityLineItem where PL_MatchingKey__c In:PriceList.keySet()];             
        List<opportunityLineItem> oliNet=[select Id, PL_NSP_Matching_Key__c, Price_List_NSP__c from opportunityLineItem where PL_NSP_Matching_Key__c In:PriceList.keySet()];
        
        
        for(opportunityLineItem ol:oliSDP)
        {
            if(ol.PL_MatchingKey__c != Null && ol.PL_MatchingKey__c != ''){
                ol.PriceList_Lookup__c = PriceList.get(ol.PL_MatchingKey__c);               
            }
        }

        for(opportunityLineItem ol:oliNet)
        {
            if(ol.PL_NSP_Matching_Key__c != Null && ol.PL_NSP_Matching_Key__c != ''){
                ol.Price_List_NSP__c = PriceList.get(ol.PL_NSP_Matching_Key__c);               
            }
        }
        
        
        try{
            update oliSDP;
            update oliNet;
        }catch(exception e){
            system.debug('Exception:'+e);
            
        }
    }
}