public class Contact_TriggerHandler {

    /* Function for managing updates to the Primary Contact checkbox */
    public static void updatePrimaryContact(Contact[] newList, Contact[] oldList){

        List<Id> primaryAccountIds = new List<Id>();
        List<Id> deadAMCAccountIds = new List<Id>();
        Set<Id> allAccountIds = new Set<Id>();
        List<Account> allAccounts = new List<Account>();
        List<Contact> newContacts = new List<Contact>();
        Set<Contact> updateContactSet = new Set<Contact>();
        List<Contact> updateContactList = new List<Contact>();
        List<Account> updateAccountList = new List<Account>();
        Set<Account> updateAccountSet = new Set<Account>();
        List<Contact> primaryContactList = new List<Contact>();
        Map<Id, Id> deadAMCRelationshipMap = new Map<Id, Id>();
        List<Contact> primaryContactsToUncheck = new List<Contact>();
        List<Contact> recordsOfPrimaryContactsToUncheck = new List<Contact>();
        Map<Id,Contact> oldContactMap = new Map<Id,Contact>();
        boolean oldPrimaryContactValue = false;
        
        /* For an update or a delete, create a way to access the old Contact records by Id through a Map. */
        if (oldList <> null){
            for(Contact oldCon : oldList){
                oldContactMap.put(oldCon.Id, oldCon);
            }
        }
        
        if(newList <> null){
            newContacts = [select Id, AccountId, Primary_Contact__c, FirstName, LastName, MobilePhone from Contact where Id in :newList];
        }
        
        
        /* Update transaction */
        if (newList <> null && oldList <> null){
            
            for (Contact c : newContacts){
                /* Get a list of all Contacts that were just changed to be a Primary Contact */
                if(c.Primary_Contact__c == true && oldContactMap.get(c.Id).Primary_Contact__c == false){
                    primaryContactList.add(c);
                    primaryAccountIds.Add(c.AccountId);
                    /* Collective list of accounts attached to all Contacts where Primary was updated */
                    if(!allAccountIds.contains(c.AccountId)){
                        allAccountIds.Add(c.AccountId);
                    }
                }
                /* All Contacts that were just changed to not be a primary Contact, but they have not moved accounts */
                if(c.Primary_Contact__c == false && oldContactMap.get(c.Id).Primary_Contact__c == true && c.AccountId == oldContactMap.get(c.Id).AccountId){
                    deadAMCRelationshipMap.put(c.AccountId, c.Id);
                    /* Collective list of accounts attached to all Contacts where Primary was updated */
                    if(!allAccountIds.contains(c.AccountId)){
                        allAccountIds.Add(c.AccountId);
                    }
                }
                /* 1 - If a contact moved to a different account, add it to the demoted list so the old Account has its Main Contact relationship severed 
                   2 - Also add the current contact to a list of contacts whose Primary Contact checkboxes will be cleared
                */
                if(c.AccountId != oldContactMap.get(c.Id).AccountId && c.Primary_Contact__c == true){
                        deadAMCRelationshipMap.put(oldContactMap.get(c.Id).AccountId, c.Id);
                        if(!allAccountIds.contains(oldContactMap.get(c.Id).AccountId)){
                            allAccountIds.Add(oldContactMap.get(c.Id).AccountId);
                        }    
                        primaryContactsToUncheck.Add(c);
                        
                }
                
            }
    
        }
        

        /* Insert transaction where Primary is checked.  Add to the list of Primary Contacts so that the 
        Account Main Contact relationship gets created 
        */
        if (newList <> null && oldList == null)
        {
            for (Contact c : newContacts){
                if(c.Primary_Contact__c == true){
                    primaryContactList.add(c);
                    primaryAccountIds.Add(c.AccountId);
                    if(!allAccountIds.contains(c.AccountId)){
                        allAccountIds.Add(c.AccountId);
                    }
                }                
            }
        }
        /* Delete transaction - if a Contact is deleted, add it to the demoted list so its former Account 
        will have its Account Main Contact relationship blanked out. Do not run for merged contacts.
        */
        if(newList == null && oldList <> null)
        {
            for (Contact c : oldList){
                    if(c.Primary_Contact__c == true){
                        deadAMCRelationshipMap.put(c.AccountId, c.Id);
                        if(!allAccountIds.contains(c.AccountId)){
                            allAccountIds.Add(c.AccountId);
                        }
                    }   
            }
        }
        
        
       /* Create a map for all accounts attached to Contacts with a changed Primary Contact field to access the Account Main Contact relationship */
       if(allAccountIDs.size() > 0){
           allAccounts = [Select Id, Account_Main_Contact__c, Account_Main_Contact_Name_Static__c, Account_Main_Contact_Mobile__c from Account where id in :allAccountIds];
           Map<Id,Account> AccountMap = new Map<Id,Account>();
           for(Account a : allAccounts)
           {
               AccountMap.put(a.Id, a);
           }
           Account a;
           /* For all Contacts that just had a Primary Contact enabled, update the associated Account Main Contact 
           field on the account to show the relationship and point to the new Primary Contact 
           */
           for(Contact c : primaryContactList)
           {
               a = AccountMap.get(c.AccountId);
               a.Account_Main_Contact__c = c.Id;
               if(!updateAccountSet.contains(a)){
                   updateAccountSet.add(a);
               }    
           }
           /* For all Contact to Account links on the demoted list (manually unchecked Primary Contacts and Primary Contacts 
           that moved accounts), delete the Account Main Contact relationship. 
           */
           
           deadAMCAccountIds.addAll(deadAMCRelationshipMap.keySet());
           
           for(Id acct: deadAMCAccountIds)
           {
               a = AccountMap.get(acct);
               if(a.Account_Main_Contact__c == deadAMCRelationshipMap.get(acct)){
                   a.Account_Main_Contact__c = null;
                   a.Account_Main_Contact_Name_Static__c = null;
                   a.Account_Main_Contact_Mobile__c = null;
                   if(!updateAccountSet.contains(a)){
                       updateAccountSet.add(a);
                   }    
               }
           }
       }    
      
       
       /* Primary Contacts to Uncheck */
       if (primaryContactsToUncheck.size() > 0){
           recordsOfPrimaryContactsToUncheck  = [Select Id, Primary_Contact__c from Contact where Id in :primaryContactsToUncheck];
           
           for(Contact c: recordsOfPrimaryContactsToUncheck){
               if(c.Primary_Contact__c == true){
                   c.Primary_Contact__c = false;
                   if(!updateContactSet.contains(c)){
                       updateContactSet.add(c);               
                   }    
               }
            } 
       }
       
       /* For all other contacts on accounts that just had a primary enabled, find any other Contacts that are marked as 
       Primary and clear the Primary Contact checkbox.  For inserts and updates only. 
       */ 
       if (newList <> null && primaryContactList.size() > 0){
           List<Contact> relatedContactList = [Select Id, Primary_Contact__c from Contact where AccountId in :primaryAccountIds and Id not in :newList];
    
           for(Contact c: relatedContactList){
               if(c.Primary_Contact__c == true){
                   c.Primary_Contact__c = false;
                   if(!updateContactSet.contains(c)){
                       updateContactSet.add(c);               
                   }    
               }
            } 
        }    
            
        /* Run all cumulative updates to accounts and contacts made in this function */
        updateAccountList.addAll(updateAccountSet);
        if(updateAccountList.size() > 0){
            update (updateAccountList);   
        }    
        updateContactList.addAll(updateContactSet);
        if(updateContactList.size() > 0){
            update (updateContactList);
        }    
    }

    /* Function for updating the Contact Type field on Contact with the Account Record Type name */
    public static void updateContactType(Contact[] newList){
       // get all the affected accounts
        List<Id> AccountIds = new List<Id>();
        List<Account> relatedAccountList = new List <Account>();
        Map<Id,Account> relatedAccountMap = new Map<Id,Account>();

        if (newList <> null){
            for (Contact c : newList){
                AccountIds.Add(c.AccountId);
            }
        }
        
        relatedAccountList = [SELECT Id, RecordType.Name FROM Account where Id in :AccountIds];
          
        for(Account a: relatedAccountList){
            if (RelatedAccountMap.get(a.Id) == null){
                RelatedAccountMap.put(a.Id, a);
            }
        }   
        
        for(Contact c: newList){
            if(c.Contact_Type__c != RelatedAccountMap.get(c.AccountId).RecordType.Name){
                c.Contact_Type__c = RelatedAccountMap.get(c.AccountId).RecordType.Name;
            }    
        }
    }
    
    /* Move any inactive contacts to a master inactive account and populate their original account field*/
    /*Public static void updateContactDetailsonInactive(Contact[] newList, Contact[] oldList){
        //get all the affected Contacts
        List<Contact> UpdatedList = new List<Contact>(); 
        List<Contact> changedContact = [SELECT id, Inactive__c, AccountId, Original_Account__c FROM Contact WHERE ID in :newList]; 
        //get the affected Account Id
        List<Id> AccountIds = new List<Id>();
        //get the Account of an affected Contact
        boolean UpdateDone;
        List<Account> relatedAccountList = new List <Account>();
        Map<Id, Contact> oldContactMap = new Map<Id, Contact>();
        Map<Id,Account> relatedAccountMap = new Map<Id,Account>();

        //Check if there is an update to the Contact
        if(oldList <> null){
            for(Contact c : oldList)
            {
                oldContactMap.put(c.Id, c);
            }
        } 
        //Add the Accountids of the updated Contact    
        if (newList <> null){
            for (Contact c : newList){
                AccountIds.Add(c.AccountId);
            }
        }
        //get the required fields of the affected Account
        relatedAccountList = [SELECT Id, Inactive__c FROM Account where Id in :AccountIds];
        for(Account a: relatedAccountList){
            if (RelatedAccountMap.get(a.Id) == null){    
                RelatedAccountMap.put(a.Id, a);
            }
        }
        for(Contact con : changedContact){
            UpdateDone = false;
                if(con.Inactive__c  == true && relatedAccountMap.get(con.AccountId).Inactive__c == false ){
                System.debug('Coming into the loop');
                con.Original_Account__c = oldContactMap.get(con.Id).AccountId;
                con.AccountId =  '001o0000010sviy';
                con.Date_Inactivated__c = Date.today();
                con.Inactivated_By__c = UserInfo.getUserId();
                con.Primary_Contact__c = false;
                UpdateDone = true;
            }           
            else if (con.Inactive__c == false) {
                if(oldContactMap.get(con.Id).Original_Account__c <> null){
                    con.AccountId = oldContactMap.get(con.Id).Original_Account__c;
                    con.Original_Account__c = null;
                    con.Date_Inactivated__c = null;
                    con.Inactivated_By__c = null;  
                    con.Inactive_Reason__c = null;
                    UpdateDone = true;        
                }
                else {
                    con.Original_Account__c = null;
                con.Date_Inactivated__c = null;
                con.Inactivated_By__c = null;  
                con.Inactive_Reason__c = null;
                UpdateDone = true;
                }
                if(UpdateDone){
                    UpdatedList.add(con);
                }
            }
        }update(UpdatedList);
    }*/

   
    /* Function for updating the Account with details from all related Contacts */
    public static void updateAccountContactDetails(Contact[] newList, Contact[] oldList){
        // get all the affected accounts
        List<Id> AccountIds = new List<Id>();
        List<Id> oldAccountIds = new List<Id>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        List<Account> newAccountList = new List<Account>();
        Map<Id, Account> newAccountMap = new Map<Id, Account>();
        List<Account> updateAccountList = new List<Account>();

        if(newList <> null){
            for (Contact c : newList){
                if(!AccountIds.contains(c.AccountId)){
                     AccountIds.Add(c.AccountId);
                }
                if(!contactMap.containsKey(c.Id)){
                    contactMap.put(c.Id, c);
                }
                //System.Debug('Contact Map and Account ID list');
            }
        }
        newAccountList= [select Id, Account_Main_Contact_Name_Static__c, Account_Main_Contact_Mobile__c from Account where Id in :AccountIds];
        for(Account a : newAccountList){
            //System.Debug('Add account to account list');
            if(!newAccountMap.containsKey(a.Id)){
                newAccountMap.put(a.Id, a);
            }
        }
        if(newList <> null){
            for(Contact c: newList){
                //System.Debug('Entered newList');
                if(c.FirstName <> null && c.Primary_Contact__c == true){
                    //System.Debug('tried to update PC');
                    if(newAccountMap.get(c.AccountId) <> null){
                        //System.Debug('Map to Account ID not null');
                        if(newAccountMap.get(c.AccountId).Account_Main_Contact_Name_Static__c <> c.FirstName + ' ' + c.LastName  ){
                            newAccountMap.get(c.AccountId).Account_Main_Contact_Name_Static__c = c.FirstName + ' ' + c.LastName;
                            if(!updateAccountList.contains(newAccountMap.get(c.AccountId))){
                                updateAccountList.add(newAccountMap.get(c.AccountId));
                            }
                        }    
                    }
                }
                if(c.MobilePhone <> null && c.Primary_Contact__c == true){
                     if(newAccountMap.get(c.AccountId) <> null){
                        if(newAccountMap.get(c.AccountId).Account_Main_Contact_Mobile__c <> c.MobilePhone ){
                            newAccountMap.get(c.AccountId).Account_Main_Contact_Mobile__c = c.MobilePhone;
                            if(!updateAccountList.contains(newAccountMap.get(c.AccountId))){
                                updateAccountList.add(newAccountMap.get(c.AccountId));
                            }
                        }    
                    }
                }
            }    
        }

        if(oldList <> null){
            for(Contact c : oldList){
                if(!AccountIds.contains(c.AccountId)){
                        AccountIds.Add(c.AccountId);
                }
            }
        }
        
        if(updateAccountList.size() > 0){
            update updateAccountList;
        }
        
        // Send all accounts to account function for evaluation */
        Account_TriggerHandler.updateContactInfoOnAccount(AccountIds);

    }
    
    public static void updateEmailMarketingFieldsExpressConsent(Contact[] newList, Contact[] oldList){

        Map<Id,Contact> relatedContactMap = new Map<Id,Contact>();
        Map<Id,Contact> oldContactMap = new Map<Id,Contact>();
        
        List<Contact> updateList = new List<Contact>(); 
        /*List<Contact> relatedContactList = [Select Id, Email, Email_Bounced__c, Pardot_Opt_In_Email_Communications__c, Pardot_Hard_Bounce__c, Pardot_Do_Not_Email__c, Opt_in_ECom__c, Do_Not_Email__c, Pardot_Email_Bounced_Date__c, Pardot_DNE_Reset_Required__c from Contact where Id in :newList];*/
        Set<String> emailSet = new Set<String>();
        boolean UpdateMade;
        
        
        /* For an update or a delete, create a way to access the old Contact records by Email through a Map. This will find a unique record since Pardot only has one record per email.*/
        if (oldList <> null){
            for(Contact oldCon : oldList){
                oldContactMap.put(oldCon.Id, oldCon);
            }
        }


        // group the related contacts into a Map with Email as the key
        for(Contact c: newList){
            UpdateMade = false;
            /*if (relatedContactMap.get(c.Id) == null && c.Email <> null){
                relatedContactMap.put(c.Id,c);               */
        }
                
        for(Contact ce: newList){
              UpdateMade = false;
              /*if (RelatedContactMap.get(ce.Id) <> null){*/

                  /* When a prospect gets marked as do not email in Pardot, set them as DNE in Salesforce */
                  if(oldContactMap.get(ce.Id).Pardot_Do_Not_Email__c == false && ce.Pardot_Do_Not_Email__c == true){
                      ce.Do_Not_Email__c = true;
                      UpdateMade = true;
                      /*Pardot Do Not Email causes bounce reset */
                  }                                       
                  
                  /* Express Consent Status Changed */
                  if(ce.Pardot_Opt_In_Email_Communications__c== 'Yes (Express)' && oldContactMap.get(ce.Id).Pardot_Opt_In_Email_Communications__c <> 'Yes (Express)'  && (ce.Opt_in_ECom__c<> 'Yes (Opted-in)')){
                      ce.Opt_in_ECom__c= 'Yes (Opted-in)';
                      ce.Do_Not_Email__c = false;
                      if(ce.Pardot_Do_Not_Email__c != false){
                          ce.Pardot_DNE_Reset_Required__c = true;
                      }
                      ce.Pardot_Mailable__c = 'Yes';                      
                      UpdateMade = true;
                  }else if(ce.Pardot_Opt_In_Email_Communications__c== 'No' && (ce.Opt_in_ECom__c<> 'No (Opted-out)'  || ce.Pardot_Do_Not_Email__c <> true)){
                      ce.Opt_in_ECom__c= 'No (Opted-out)';
                      ce.Do_Not_Email__c = true;
                      ce.Pardot_Do_Not_Email__c = true;
                      ce.Pardot_Mailable__c = 'No';
                      UpdateMade = true;
                  }                                    
                                        
        }
            
    }
    
    public static void updateEmailMarketingFieldsImpliedConsent(Contact[] newList, Map<Id, Contact> oldMap){

// take newList, get another list of contacts that contain the email addresses represented by newList contacts
// for each of the contacts on sameEmailList, set Do Not Email, Email Bounced, Opt in Ecom
        
        List<Contact> updateList = new List<Contact>(); 
        List<Contact> relatedContactList = [Select Id, Email, Email_Bounced__c, Pardot_Opt_In_Email_Communications__c, Pardot_Do_Not_Email__c, Opt_in_ECom__c, Do_Not_Email__c, Pardot_Implied_Consent__c, Pardot_Mailable__c, Pardot_DNE_Reset_Required__c from Contact where Id in :newList];
        Set<String> emailSet = new Set<String>();
        boolean UpdateMade;


        for(Contact ce: newList){
              UpdateMade = false;
              if (ce.Email <> null){
                  
                  /* Set Implied Consent Status */
                  if((ce.Pardot_Opt_In_Email_Communications__c== 'No Response' || ce.Pardot_Opt_In_Email_Communications__c== 'Yes (Express)') && ce.Pardot_Implied_Consent__c == 'Yes' && ce.Opt_in_ECom__c<> 'Yes (Implied)'){
                      ce.Opt_in_ECom__c= 'Yes (Implied)';
                      if(ce.Do_Not_Email__c == true){
                          ce.Pardot_DNE_Reset_Required__c = true;
                      }
                      UpdateMade = true;
                  }else if(ce.Pardot_Opt_In_Email_Communications__c== 'No Response' && ce.Pardot_Implied_Consent__c == 'No' && ce.Opt_in_ECom__c<> 'No (Implied)'){
                      ce.Opt_in_ECom__c= 'No (Implied)';
                      ce.Do_Not_Email__c = true;
                      ce.Pardot_Mailable__c = 'No';
                      UpdateMade = true;
                  }else if(ce.Pardot_Opt_In_Email_Communications__c=='No'){
                      ce.Do_Not_Email__c = true;
                      ce.Pardot_Mailable__c = 'No';
                      ce.Pardot_Do_Not_Email__c = true;
                  }
                  
                  /* Reset */
                  if(oldMap != null){
                      if(oldMap.get(ce.Id) != null){
                          if(ce.Do_Not_Email__c == false && oldMap.get(ce.Id).Do_Not_Email__c == true && (ce.Opt_in_ECom__c== 'Yes (Implied)' || ce.Opt_in_ECom__c== 'Yes (Opted-in)')){
                              ce.Pardot_DNE_Reset_Required__c = true;
                              UpdateMade = true;
                          }
                          /*Reset because of Email change */
                          if(ce.Do_Not_Email__c == true && ce.email != oldMap.get(ce.Id).email && ce.email != null){
                              ce.Pardot_DNE_Reset_Required__c = true;
                              ce.Opt_in_ECom__c= 'Yes (Implied)';
                              ce.Pardot_Implied_Consent__c = 'Yes';
                              ce.Pardot_Implied_Consent_Expiry_Date__c = null;
                          }
                      }
                  }    
                  
                  /* Bounce reset but still unmailable due to No Implied */
                  if(ce.Opt_in_ECom__c== 'No (Implied)' && ce.Pardot_Do_Not_Email__c <> true){
                      ce.Pardot_Do_Not_Email__c = true;
                      ce.Do_Not_Email__c = true;
                      ce.Pardot_Do_Not_Email__c = true;
                      ce.Pardot_Mailable__c = 'No';
                      UpdateMade = true;
                  }                                  
                  if(ce.Pardot_DNE_Reset_Required__c == true && !System.IsBatch() && !System.IsQueueable()){
                      ce.Pardot_Mailable__c = 'Yes';                      
                      ce.Pardot_DNE_Reset_Required__c = false;
                      ce.Pardot_Do_Not_Email__c = false;
                      ce.Do_Not_Email__c = false;
                      ce.Pardot_Email_Bounced_Date__c = null;
                      ce.Pardot_Email_Bounced_Reason__c = '';
                      UpdateMade = true;
                      if(!Test.isRunningTest()){
                          resetDoNotEmail(ce.Id);
                      }
                  }               
              }              
        }
    }
   
    public static void resetDoNotEmail(Id contactId){
        String business_unit_id = '';
        String sandboxURL='';
        
        if(URL.getSalesforceBaseUrl().toExternalForm().contains('syngentacanada.my.salesforce.com') ){
            business_unit_id ='0Uv1N000000PAscSAG';
        }
        else if(URL.getSalesforceBaseUrl().toExternalForm().contains('syngentacanada--full.my.salesforce.com') ){
            business_unit_id ='0Uv7j0000008ONjCAM';
            sandboxURL = 'demo.';
        }
        if(contactId != null){
            //System.Debug('SendToPardot: https://pi.' + sandboxURL + 'pardot.com/api/prospect/version/4/do/update/fid/' + contactId + business_unit_id + 'fid=' + contactId + '&is_do_not_email=false');
            sendToPardot('https://pi.' + sandboxURL + 'pardot.com/api/prospect/version/4/do/update/fid/' + contactId, business_unit_id, 'fid=' + contactId + '&is_do_not_email=false');
        }
         
           
    }

    Public static HttpResponse httpCallout(String url, String body, String accessToken, String business_unit_id){
        //  
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setHeader('Authorization','Bearer ' + accessToken );
        req.setHeader('Pardot-Business-Unit-Id', +business_unit_id);
        req.setEndPoint(url);
        req.setBody(body);
        System.debug('::REQUEST::'+req.getBody());
        req.setMethod('POST');
        req.setTimeout(20000);
        try{
            res = http.send(req);
            System.debug('::RESPONSE::'+res.getBody());
            return res;
            
        } 
        catch(System.CalloutException e){
            // Allow for CalloutExceptions for timeout on request send
            return null;
        }
        
   }
    //@future (callout=true)
    public static void queueCreateInPardot(Contact[] newList){
        
        Integer i = 0;
        for(Contact c: newList){
            if(i > 50){
                break;
            }
        
            // if(c.email <> null && c.pi__url__c == null && !System.IsBatch() && !System.IsQueueable() && !Test.isRunningTest()){
            String business_unit_id = '';
            String sandboxURL='';
            if(URL.getSalesforceBaseUrl().toExternalForm().contains('syngentacanada.my.salesforce.com') ){
               business_unit_id ='0Uv1N000000PAscSAG';
            }
            else if(URL.getSalesforceBaseUrl().toExternalForm().contains('syngentacanada--full.my.salesforce.com') ){
               business_unit_id ='0Uv7j0000008ONjCAM';
               sandboxURL = 'demo.';
            }
            
            if(c.email <> null && c.pi__url__c == null && !System.IsBatch() && !System.IsQueueable() && !Test.isRunningTest()){
               sendToPardot('https://pi.' + sandboxURL + 'pardot.com/api/prospect/version/4/do/create',business_unit_id, 'email='+c.Email + '&fid='+c.id );
               i++;
            }

        }   
    }  
    @future (callout=true)
    public static void sendToPardot(String url, String business_unit_id, String body){
        
        String accessToken = loginToPardot();        
       
        
        HttpResponse res = httpCallout( url,'&'+ body, + accessToken, +business_unit_id );
        //System.debug('Response from Server in Salesforce: '+res);
    }
  
    public class deserializeResponse
    {
       public String id;
       public String access_token;
    }
    public static String loginToPardot(){ 
    
        String client_id = '';
        String client_secret='';
        String username ='';
        
        if(URL.getSalesforceBaseUrl().toExternalForm().contains('syngentacanada.my.salesforce.com') ){
            client_id = '3MVG9xOCXq4ID1uHvwm0tHbSjh3ZZZ87gbnrjVD3fa7hKxq2Y2u4TQAvwuO3XeuQGb4Th3ewiaAl_jEFf.g7n';
            client_secret = '0B962F809E320FE9A2CA3D6344813188F9B45B05A81D0E9C8016D8E58D3823C5';
            username = 'pardot.user@syngenta.com.ca';
        }
        else if(URL.getSalesforceBaseUrl().toExternalForm().contains('syngentacanada--full.my.salesforce.com') ){
            client_id = '3MVG9M6Iz6p_Vt2xTZYciaJsvx6znj1ufbsvCZZQNFitKcnUuk6.7XqKNUTJcIaAjiBSurMMQP8hgqbcjag1y';
            client_secret = '829367A36ABD211EEB489AB4FDC304ED33844AA2DE467CD6394D81E4CDA20812';
            username = 'pardot.user@syngenta.com.ca.full';            
        }
            
        String password = 'r1299130013011302';

         String bodyReturn = '';
         HttpRequest req = new HttpRequest();
         HttpResponse res = new HttpResponse();
         Http http = new Http();
         String loginErrorMessage = '';
         String accessToken = '';
         String result;    
         req.setEndPoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/oauth2/token');
         req.setBody('grant_type=password&client_id='+client_id+'&client_secret='+client_secret+'&username='+username+'&password='+password);
         req.setMethod('POST');
         req.setTimeout(20000);
         //req.setHeader('Accept', 'application/json');
         req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
         req.setHeader('Content-Type','application/x-www-form-urlencoded');
         res = http.send(req);
         if(res.getStatusCode() >= 200 && res.getStatusCode() < 300){
            system.debug('Response body result is+++: ' + res.getBody());
            deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
             accessToken = resp1.access_token;
         } 
         return accessToken;
}

}