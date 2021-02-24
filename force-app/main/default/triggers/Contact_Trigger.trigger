/** 2016-08-31  Trevor Cornfield
 *  Trigger for Contact related updates.
 * 
 *  After:
 *      Step 1: If Pardot is updating the Contact, update all Email marketing fields on other contacts with the same email address.
 *      Step 2: Update Account Details such as "has phone" and "has email", based on related contacts
 *
 *  Before:
 *      Step 1: Update Contact Type
 *
 */ 
trigger Contact_Trigger on Contact (before insert, before update, after insert, after update, after delete) {
    //if(!System.IsBatch()){
    if(UserInfo.getFirstName() <> 'Global' ){
        if (Trigger.isBefore){   
            if(UserInfo.getProfileId()<>'00eo0000000K5iJAAS'){ 
               Contact_TriggerHandler.updateContactType(Trigger.new);
            }
            if(UserInfo.getFirstName()<>'Pardot'){        
                Contact_TriggerHandler.updateEmailMarketingFieldsImpliedConsent(Trigger.new, Trigger.oldMap);                        
            }            
            if(UserInfo.getFirstName()=='Pardot'){
                Contact_TriggerHandler.updateEmailMarketingFieldsExpressConsent(Trigger.new, Trigger.old);        
            } 
            if(Trigger.isUpdate || Trigger.isInsert){
                Contact_TriggerHandler.queueCreateInPardot(Trigger.new);
            }     
        } 
    
        if (Trigger.isAfter){
            
                
            /**if(Trigger.isUpdate || Trigger.isInsert){
                    Contact_TriggerHandler.queueCreateInPardot(Trigger.new);
            }**/
            Contact_TriggerHandler.updatePrimaryContact(Trigger.new, Trigger.old);
            Contact_TriggerHandler.updateAccountContactDetails(Trigger.new, Trigger.old);
            
            }
     }    
}