@isTest(SEEALLDATA = true)
public class Programs_TriggerTest {
    
    static TestMethod void runTest(){
        Account testAcct = new Account(Name='BeefyBurrito1928475SyngengtaTest');
        Insert testAcct;
 
        Programs__c testProg = new Programs__c(Account__c=testAcct.id, Program_Year__c='2015', Offer_Type__c='TestOfferType');
        insert testProg;
        
        //Programs__c testAgriclime = [Select id, Contact__c, Risk_Start_Period__c, Actual_Cashback__c, Payout_Status__c, Actual_Rainfall__c, Program_Reference__c, Rainfall_Threshold__c, Rainfall_Exit_Point__c, RecordType.Name FROM Programs__c WHERE recordtypeid in (Select id FROM RecordType where SObjectType = 'Programs__c' and DeveloperName IN('AgriClime_Lentils')) LIMIT 1];
        //System.debug('Test Data is' +testAgriclime);
        
        //Contact testCont = [SELECT id, AgriclimeRefNumber__c, (SELECT Id, Risk_Start_Period__c, Actual_Cashback__c, Payout_Status__c, Actual_Rainfall__c, Program_Reference__c, Rainfall_Threshold__c, Rainfall_Exit_Point__c FROM Programs__r),  Payout_Email_Sent__c, Payout_Details__c, Agriclime_Total_Payout__c FROM Contact LIMIT 1 ];
        test.startTest();
        
        //Update testAgriclime;
        
        test.stopTest();

        Programs__c testProg2 = new Programs__c(Account__c=testAcct.id, Program_Year__c='2015', Offer_Type__c='TestOfferType');
        try{
        	insert testProg2;
        }catch(DMLException e){}
        
        System.AssertEquals(null,testProg2.id);
        
    }

    static TestMethod void runTest1(){

        Account testAcct1 = new Account(Name='AgriclimeFulfilmentTest');
        Insert testAcct1;

        Contact testContact1 = new Contact(LastName='SyngentaAgriClime', FirstName='Joe', Phone='5556895253', AccountId=testAcct1.Id, AgriclimeLentilsTotalPayout__c = 10000);
        Insert testContact1;
        Contact testContact2 = new Contact(LastName='SyngentaAgriClime1', FirstName='Joe', Phone='5556895253', AccountId=testAcct1.Id, Agriclime_Total_Payout__c = 0);
        Insert testContact2;
        Contact testContact3 = new Contact(LastName='SyngentaAgriClime3', FirstName='Joe3', Phone='5556895253', AccountId=testAcct1.Id, AgriclimeLentilsTotalPayout__c = 0);
        Insert testContact3;
        //Contact testContact4 = new Contact(LastName='SyngentaAgriClime4', FirstName='Joe', Phone='5556895253', AccountId=testAcct1.Id, Agriclime_Total_Payout__c = 10000);
        //Insert testContact4;
        
        Id agriClimeLentilsBackendRecordTypeId = Schema.SObjectType.Programs__c.getRecordTypeInfosByName().get('AgriClime Payout Backend').getRecordTypeId();                        
        Programs__c testProgram1 = new Programs__c(Contact__c = testContact1.Id, Payout_Status__c = 'FINISH_PAYOUT', RecordTypeId = agriClimeLentilsBackendRecordTypeId, AgriClimePayoutCampaignorOfferName__c = 'AgriClime Lentils 2021', AgriClimePayoutEmailLongitude__c = '12', AgriClimePayoutEmailLatitude__c = '10', AgriClimePayoutEmailRiskStartPeriod__c = '12-12-2021', AgriClimePayoutEmailRainfallThreshold__c = '40', AgriClimePayoutEmailRainfallExitPoint__c = '10', AgriClimePayoutEmailActualRainfall__c = '10', AgriClimePayoutEmailActualCashback__c = 10000  );
        //Programs__c testProgram2 = new Programs__c(Contact__c = testContact1.Id, Payout_Status__c = 'FINISH_PAYOUT', RecordTypeId = agriClimeLentilsBackendRecordTypeId, AgriClimePayoutCampaignorOfferName__c = 'Canada_Soy_2021' , AgriClimePayoutEmailLongitude__c = '12', AgriClimePayoutEmailLatitude__c = '10', AgriClimePayoutEmailRiskStartPeriod__c = '12-12-2021', AgriClimePayoutEmailRainfallThreshold__c = '40', AgriClimePayoutEmailRainfallExitPoint__c = '10', AgriClimePayoutEmailActualRainfall__c = '10', AgriClimePayoutEmailActualCashback__c = 10000  );

        //Programs__c testProgram3 = new Programs__c(Contact__c = testContact3.Id, Payout_Status__c = 'FINISH_NO_PAYOUT', RecordTypeId = agriClimeLentilsBackendRecordTypeId, AgriClimePayoutCampaignorOfferName__c = 'AgriClime Lentils 2021', AgriClimePayoutEmailLongitude__c = '12', AgriClimePayoutEmailLatitude__c = '10', AgriClimePayoutEmailRiskStartPeriod__c = '12-12-2021', AgriClimePayoutEmailRainfallThreshold__c = '40', AgriClimePayoutEmailRainfallExitPoint__c = '10', AgriClimePayoutEmailActualRainfall__c = '10', AgriClimePayoutEmailActualCashback__c = 0  ); 
        Programs__c testProgram4 = new Programs__c(Contact__c = testContact2.Id, Payout_Status__c = 'FINISH_NO_PAYOUT', RecordTypeId = agriClimeLentilsBackendRecordTypeId, AgriClimePayoutCampaignorOfferName__c = 'Canada_Soy_2021', AgriClimePayoutEmailLongitude__c = '12', AgriClimePayoutEmailLatitude__c = '10', AgriClimePayoutEmailRiskStartPeriod__c = '12-12-2021', AgriClimePayoutEmailRainfallThreshold__c = '40', AgriClimePayoutEmailRainfallExitPoint__c = '10', AgriClimePayoutEmailActualRainfall__c = '10', AgriClimePayoutEmailActualCashback__c = 0  ); 
        try{
        	insert testProgram1;
            //insert testProgram2;
            //insert testProgram3;
            insert testProgram4;
        }catch(DMLException e){}
        
        //System.AssertEquals(null,testProgram1.id);
        //System.AssertEquals(null,testProgram2.id);
        //System.AssertEquals(null,testProgram3.id);
        //System.AssertEquals(null,testProgram4.id);
    }

}