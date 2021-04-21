/**************************************************************************************
* Apex Class Name    :  OpportunityLineItemSPAclass
* Version            :  1.0
* Created Date       :  11/Jan/2018
* Function           :  This is Functionality class for SalesPlanActualsTrigger 
* Developer          :  Hema Latha   
*************************************************************************************/
public class OpportunityLineItemSPA {
    /****************************************
* Method name : updateOpportunityLineItem
* Description : Method to get sales plan actuals unique key and update OLIs
* Developer   : Hema Latha
* Date        : 11th January 2018
****************************************/  
    public void updateOpportunityLineItemspa(List<Sales_Plan_Actual__c> newlist)
    {
        // Query to fetch opportunity line item which has to be updated. 
        
        List<Sales_Plan_Actual__c> spalist = newlist;
        List<String> keylist = new List<String>();
        for(Sales_Plan_Actual__c uniqueKeyList : spalist ){
            keylist.add(uniqueKeyList.UniqueKey__c);
        }
        List<OpportunityLineItem> opplist = new List<OpportunityLineItem>();
        List<OpportunityLineItem> updateList = new List<OpportunityLineItem>();
        boolean updated = false;
        try{
            opplist=[select Id,SalesPlanActual__c,Sales_Plan_Actual_1__c,Sales_Plan_Actual_2__c,SP_Matching_Key__c,SP_Matching_Key_1__c,SP_Matching_Key_2__c from OpportunityLineItem where /*(Opportunity.RecordType.DeveloperName = : Label.Seeds_Allocation_Dist_RT or Opportunity.RecordType.DeveloperName = : Label.Seeds_Allocation_Territory
                                                                                                                                                                                            or Opportunity.RecordType.DeveloperName = : Label.Account_Seeds_Allocation) AND*/SP_Matching_Key__c in:keylist or SP_Matching_Key_1__c in:keylist or SP_Matching_Key_2__c in:keylist];
        }
        catch(Exception e)
        {
            Exception_Log__c exceptionLogRecord = ExceptionLogHelperClass.createExceptionLogRecord('OpportunityLineItem','NA','OpportunityLineItemSPA','updateOpportunityLineItemspa','Technical exception',UserInfo.getUserId(),e.getStackTraceString(),e.getMessage());
            insert exceptionLogRecord;
        }
        // To Map Matchingkey with opportunity line item
        
        if(!opplist.isEmpty()){
            for(OpportunityLineItem newopplist: opplist)
            {
                for(Sales_Plan_Actual__c newspalist : spalist ){
                    updated = false;
                    if(newopplist.SP_Matching_Key__c == newspalist.UniqueKey__c && newopplist.SalesPlanActual__c == null){
                        newopplist.SalesPlanActual__c = newspalist.id;
                        updated = true;
                    }
                    else if(newopplist.SP_Matching_Key_1__c == newspalist.UniqueKey__c && newopplist.Sales_Plan_Actual_1__c == null ){
                        newopplist.Sales_Plan_Actual_1__c = newspalist.id;
                        updated = true;
                    }
                    else if(newopplist.SP_Matching_Key_2__c == newspalist.UniqueKey__c && newopplist.Sales_Plan_Actual_2__c == null){
                        newopplist.Sales_Plan_Actual_2__c = newspalist.id;
                        updated = true;                   
                    }
                    
                    if(updated){
                        updateList.add(newopplist);  
                    }    
                }
            }
            if(!opplist.isEmpty()){
                /*update updateList;*/
                update oppList;
            }
        }
        
    }
}