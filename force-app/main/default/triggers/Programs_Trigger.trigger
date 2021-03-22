trigger Programs_Trigger on Programs__c (before insert, before update, after insert, after update) {


    Programs_TriggerHandler.DuplicateCheck(Trigger.new);
    if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)){
    /**Id recordTypeId = [Select Id FROM RecordType Where DeveloperName = 'AgriClime_Payout_Backend'].Id;
    List<Programs__c> programsList = new List<Programs__c>();
    for(Programs__c program : Trigger.new){
        if(program.RecordTypeId == recordTypeId)
          programsList.add(program);
          //System.debug('Changed Agriclime Program is' , +programsList);
    }
    **/
    Programs_TriggerHandler.AgriclimeFulfilmentEmail(Trigger.new);
}


}