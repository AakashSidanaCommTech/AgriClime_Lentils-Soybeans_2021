/***************************************************************************************************************
 *  Date            Modified By            User Story              Description
                        `                           
 *  18-Dec-2017    Pooja Joshi             TKT-009431              Created
***************************************************************************************************************/

public class GB_Helper {

  public string TabOnePage {get;set;}
  public string TabOneField {get;set;}
  public string TabOneLabel {get;set;}
  public string TabOneFieldValue {get;set;}

  public boolean ShowTabTwo {get;set;}
  public string TabTwoPage {get;set;}
  public string TabTwoField {get;set;}
  public string TabTwoLabel {get;set;}
  public string TabTwoFieldValue {get;set;}

  public boolean ShowTabThree {get;set;}
  public string TabThreePage {get;set;}
  public string TabThreeField {get;set;}
  public string TabThreeLabel {get;set;}
  public string TabThreeFieldValue {get;set;}

  public boolean ShowTabFour {get;set;}
  public string TabFourPage {get;set;}
  public string TabFourField {get;set;}
  public string TabFourLabel {get;set;}
  public string TabFourFieldValue {get;set;}

  public boolean ShowTabFive {get;set;}
  public string TabFivePage {get;set;}
  public string TabFiveField {get;set;}
  public string TabFiveLabel {get;set;}
  public string TabFiveFieldValue {get;set;}

  public boolean ShowTabSix {get;set;}
  public string TabSixPage {get;set;}
  public string TabSixField {get;set;}
  public string TabSixLabel {get;set;}
  public string TabSixFieldValue {get;set;}

  public boolean ShowTabSeven {get;set;}
  public string TabSevenPage {get;set;}
  public string TabSevenField {get;set;}
  public string TabSevenLabel {get;set;}
  public string TabSevenFieldValue {get;set;}

  public boolean ShowTabEight {get;set;}
  public string TabEightPage {get;set;}
  public string TabEightField {get;set;}
  public string TabEightLabel {get;set;}
  public string TabEightFieldValue {get;set;}

  public boolean ShowTabNine {get;set;}
  public string TabNinePage {get;set;}
  public string TabNineField {get;set;}
  public string TabNineLabel {get;set;}
  public string TabNineFieldValue {get;set;}

  public boolean ShowTabTen {get;set;}
  public string TabTenPage {get;set;}
  public string TabTenField {get;set;}
  public string TabTenLabel {get;set;}
  public string TabTenFieldValue {get;set;}
  
  public boolean ShowTabEleven {get;set;}
  public string TabElevenPage {get;set;}
  public string TabElevenField {get;set;}
  public string TabElevenLabel {get;set;}
  public string TabElevenFieldValue {get;set;}
  
  public boolean ShowTabTwelve {get;set;}
  public string TabTwelvePage {get;set;}
  public string TabTwelveField {get;set;}
  public string TabTwelveLabel {get;set;}
  public string TabTwelveFieldValue {get;set;}
  
  public boolean ShowTabThirteen {get;set;}
  public string TabThirteenPage {get;set;}
  public string TabThirteenField {get;set;}
  public string TabThirteenLabel {get;set;}
  public string TabThirteenFieldValue {get;set;}
  
  public boolean ShowTabFourteen {get;set;}
  public string TabFourteenPage {get;set;}
  public string TabFourteenField {get;set;}
  public string TabFourteenLabel {get;set;}
  public string TabFourteenFieldValue {get;set;}
  
  public boolean ShowTabFifteen {get;set;}
  public string TabFifteenPage {get;set;}
  public string TabFifteenField {get;set;}
  public string TabFifteenLabel {get;set;}
  public string TabFifteenFieldValue {get;set;}
  
  public boolean ShowTabSixteen {get;set;}
  public string TabSixteenPage {get;set;}
  public string TabSixteenField {get;set;}
  public string TabSixteenLabel {get;set;}
  public string TabSixteenFieldValue {get;set;}
  
  public GB_Helper(ApexPages.StandardController controller) {

    string ObjectType = controller.getRecord().getSObjectType().getDescribe().getName();
    string RType = 'Default';
    
    string queryString = 'SELECT RecordType.Name FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getId()) + '\'';
    List<sObject> rtIds;
    
    try{
        rtIds = Database.query(queryString);
    }
    Catch(Exception e){
    
    }
    if (rtIds != null && !rtIds .isEmpty() && rtIds.size() == 1) {
      RType = (String)rtIds[0].getSObject('RecordType').get('Name');
    }
	System.debug('RType:::'+RType);
    System.debug('ObjectType:::'+ObjectType);
    string Setting = 'Default';
    Id UserId = UserInfo.getUserId();
    list<user> users = [SELECT Id, User_Country__c FROM User WHERE Id = :UserId];
    If(users.size() > 0) { Setting = users[0].User_Country__c; }
	System.debug('users::'+users);
    GridBuddy_Visibility__c gv = new GridBuddy_Visibility__c();
    list<GridBuddy_Visibility__c> gvs = [SELECT Id, Record_Type__c, Country__c, Tab_One_Label_Type__c, Tab_One_Label_Source__c, Tab_One_Page__c, 
                                                Tab_One_Field__c, Tab_One_Relation__c, Tab_Two_Label_Type__c, Tab_Two_Label_Source__c, Tab_Two_Page__c, 
                                                Tab_Two_Field__c, Tab_Two_Visible__c, Tab_Two_Relation__c, Tab_Three_Label_Type__c, 
                                                Tab_Three_Label_Source__c, Tab_Three_Page__c, Tab_Three_Field__c, Tab_Three_Visible__c, 
                                                Tab_Three_Relation__c, Tab_Four_Label_Type__c, Tab_Four_Label_Source__c, Tab_Four_Page__c, 
                                                Tab_Four_Field__c, Tab_Four_Visible__c, Tab_Four_Relation__c, Tab_Five_Label_Type__c, 
                                                Tab_Five_Label_Source__c, Tab_Five_Page__c, Tab_Five_Field__c, Tab_Five_Visible__c, Tab_Five_Relation__c, 
                                                Tab_Six_Label_Type__c, Tab_Six_Label_Source__c, Tab_Six_Page__c, Tab_Six_Field__c, Tab_Six_Visible__c, 
                                                Tab_Six_Relation__c, Tab_Seven_Label_Type__c, Tab_Seven_Label_Source__c, Tab_Seven_Page__c, 
                                                Tab_Seven_Field__c, Tab_Seven_Visible__c, Tab_Seven_Relation__c, Tab_Eight_Label_Type__c, 
                                                Tab_Eight_Label_Source__c, Tab_Eight_Page__c, Tab_Eight_Field__c, Tab_Eight_Visible__c, 
                                                Tab_Eight_Relation__c, Tab_Nine_Label_Type__c, Tab_Nine_Label_Source__c, Tab_Nine_Page__c, 
                                                Tab_Nine_Field__c, Tab_Nine_Visible__c, Tab_Nine_Relation__c, Tab_Ten_Label_Type__c, 
                                                Tab_Ten_Label_Source__c, Tab_Ten_Page__c, Tab_Ten_Field__c, Tab_Ten_Visible__c, Tab_Ten_Relation__c,
                                                Tab_Eleven_Label_Type__c,Tab_Eleven_Label_Source__c, Tab_Eleven_Page__c, Tab_Eleven_Field__c, 
                                                Tab_Eleven_Visible__c, Tab_Eleven_Relation__c,Tab_Twelve_Label_Type__c,Tab_Twelve_Label_Source__c, 
                                                Tab_Twelve_Page__c, Tab_Twelve_Field__c, Tab_Twelve_Visible__c, Tab_Twelve_Relation__c,
                                                Tab_Thirteen_Label_Type__c,Tab_Thirteen_Label_Source__c, Tab_Thirteen_Page__c, Tab_Thirteen_Field__c, 
                                                Tab_Thirteen_Visible__c, Tab_Thirteen_Relation__c,Tab_Fourteen_Label_Type__c,Tab_Fourteen_Label_Source__c, 
                                                Tab_Fourteen_Page__c, Tab_Fourteen_Field__c, Tab_Fourteen_Visible__c, Tab_Fourteen_Relation__c,
                                                Tab_Fifteen_Label_Type__c,Tab_Fifteen_Label_Source__c, Tab_Fifteen_Page__c, Tab_Fifteen_Field__c, 
                                                Tab_Fifteen_Visible__c, Tab_Fifteen_Relation__c, Tab_Sixteen_Label_Type__c,Tab_Sixteen_Label_Source__c, 
                                                Tab_Sixteen_Page__c, Tab_Sixteen_Field__c, Tab_Sixteen_Visible__c, Tab_Sixteen_Relation__c
                                           FROM GridBuddy_Visibility__c
                                          WHERE IsActive__c = true
                                            AND Object__c = :ObjectType
                                            AND (   Record_Type__c = :RType
                                                 OR Record_Type__c = 'Default')
                                            AND (   Country__c = 'CA')];

    /*for (GridBuddy_Visibility__c g : gvs) {
      if(g.Country__c == 'Default') {
        if(g.Record_Type__c == 'Default') {
          gv = g;
        }
        if(g.Record_Type__c == RType) {
          gv = g;
          break;
        }
      }
    }  
    for (GridBuddy_Visibility__c g1 : gvs) {
      if(g1.Country__c != 'Default') {
        if(g1.Record_Type__c == 'Default') {
          gv = g1;
        }
        if(g1.Record_Type__c == RType) {
          gv = g1;
          break;
        }
      }
    } */ 
    gv=gvs[0];
    if(gv != null) {

      string idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_One_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
      System.debug('Query:::'+idquery);
        System.debug('Database.query(idquery);:::'+Database.query(idquery));
      List<sObject> Objs = Database.query(idquery);
      if(Objs.size() > 0) {
        TabOneFieldValue = (string)Objs[0].get(gv.Tab_One_Relation__c);
      }

      TabOnePage = gv.Tab_One_Page__c;
      TabOneField = gv.Tab_One_Field__c;
      if(gv.Tab_One_Label_Type__c == 'Custom Label') {
          System.debug('Test 100 '+gv.Tab_One_Label_Source__c);
        TabOneLabel = getLabelString(gv.Tab_One_Label_Source__c);
      } 
	  else if(gv.Tab_One_Label_Type__c == 'Explicit Value'){
		TabOneLabel = gv.Tab_One_Label_Source__c;
      }
      else {
        TabOneLabel = getObjectLabel(gv.Tab_One_Label_Source__c);
      }

      if(gv.Tab_Two_Visible__c == true) {
        ShowTabTwo = true;
        TabTwoPage = gv.Tab_Two_Page__c;
        TabTwoField = gv.Tab_Two_Field__c;
        if(gv.Tab_Two_Label_Type__c == 'Custom Label') {
          TabTwoLabel = getLabelString(gv.Tab_Two_Label_Source__c);
        } 
		else if(gv.Tab_Two_Label_Type__c == 'Explicit Value'){
          TabTwoLabel = gv.Tab_Two_Label_Source__c;
		}
         else {
          TabTwoLabel = getObjectLabel(gv.Tab_Two_Label_Source__c);
        }
        Objs.clear();
        TabTwoFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Two_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabTwoFieldValue = (string)Objs[0].get(gv.Tab_Two_Relation__c);
        }
      } else { 
        ShowTabTwo = false;
      }

      if(gv.Tab_Three_Visible__c == true) {
        ShowTabThree = true;
        TabThreePage = gv.Tab_Three_Page__c;
        TabThreeField = gv.Tab_Three_Field__c;
        if(gv.Tab_Three_Label_Type__c == 'Custom Label') {
          TabThreeLabel = getLabelString(gv.Tab_Three_Label_Source__c);
        } else if(gv.Tab_Three_Label_Type__c == 'Explicit Value'){
          TabThreeLabel = gv.Tab_Three_Label_Source__c;
          }
        else {
          TabThreeLabel = getObjectLabel(gv.Tab_Three_Label_Source__c);
        }
        Objs.clear();
        TabThreeFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Three_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabThreeFieldValue = (string)Objs[0].get(gv.Tab_Three_Relation__c);
        }
      } else { 
        ShowTabThree = false;
      }

      if(gv.Tab_Four_Visible__c == true) {
        ShowTabFour = true;
        TabFourPage = gv.Tab_Four_Page__c;
        TabFourField = gv.Tab_Four_Field__c;
        if(gv.Tab_Four_Label_Type__c == 'Custom Label') {
          TabFourLabel = getLabelString(gv.Tab_Four_Label_Source__c);
        } else if(gv.Tab_Four_Label_Type__c == 'Explicit Value'){
          TabFourLabel = gv.Tab_Four_Label_Source__c;
          } 
        else {
          TabFourLabel = getObjectLabel(gv.Tab_Four_Label_Source__c);
        }
        Objs.clear();
        TabFourFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Four_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabFourFieldValue = (string)Objs[0].get(gv.Tab_Four_Relation__c);
        }
      } else { 
        ShowTabFour = false;
      }

      if(gv.Tab_Five_Visible__c == true) {
        ShowTabFive = true;
        TabFivePage = gv.Tab_Five_Page__c;
        TabFiveField = gv.Tab_Five_Field__c;
        if(gv.Tab_Five_Label_Type__c == 'Custom Label') {
          TabFiveLabel = getLabelString(gv.Tab_Five_Label_Source__c);
        } else if(gv.Tab_Five_Label_Type__c == 'Explicit Value'){
          TabFiveLabel = gv.Tab_Five_Label_Source__c;
          } 
        else {
          TabFiveLabel = getObjectLabel(gv.Tab_Five_Label_Source__c);
        }
        Objs.clear();
        TabFiveFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Five_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabFiveFieldValue = (string)Objs[0].get(gv.Tab_Five_Relation__c);
        }
      } else { 
        ShowTabFive = false;
      }

      if(gv.Tab_Six_Visible__c == true) {
        ShowTabSix = true;
        TabSixPage = gv.Tab_Six_Page__c;
        TabSixField = gv.Tab_Six_Field__c;
        if(gv.Tab_Six_Label_Type__c == 'Custom Label') {
          TabSixLabel = getLabelString(gv.Tab_Six_Label_Source__c);
        } else if(gv.Tab_Six_Label_Type__c == 'Explicit Value'){
          TabSixLabel = gv.Tab_Six_Label_Source__c;
          } 
        else {
          TabSixLabel = getObjectLabel(gv.Tab_Six_Label_Source__c);
        }
        Objs.clear();
        TabSixFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Six_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabSixFieldValue = (string)Objs[0].get(gv.Tab_Six_Relation__c);
        }
      } else { 
        ShowTabSix = false;
      }

      if(gv.Tab_Seven_Visible__c == true) {
        ShowTabSeven = true;
        TabSevenPage = gv.Tab_Seven_Page__c;
        TabSevenField = gv.Tab_Seven_Field__c;
        if(gv.Tab_Seven_Label_Type__c == 'Custom Label') {
          TabSevenLabel = getLabelString(gv.Tab_Seven_Label_Source__c);
        } else if(gv.Tab_Seven_Label_Type__c == 'Explicit Value'){
          TabSevenLabel = gv.Tab_Seven_Label_Source__c;
          } 
        else {
          TabSevenLabel = getObjectLabel(gv.Tab_Seven_Label_Source__c);
        }
        Objs.clear();
        TabSevenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Seven_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabSevenFieldValue = (string)Objs[0].get(gv.Tab_Seven_Relation__c);
        }
      } else { 
        ShowTabSeven = false;
      }

      if(gv.Tab_Eight_Visible__c == true) {
        ShowTabEight = true;
        TabEightPage = gv.Tab_Eight_Page__c;
        TabEightField = gv.Tab_Eight_Field__c;
        if(gv.Tab_Eight_Label_Type__c == 'Custom Label') {
          TabEightLabel = getLabelString(gv.Tab_Eight_Label_Source__c);
        } else if(gv.Tab_Eight_Label_Type__c == 'Explicit Value'){
          TabEightLabel = gv.Tab_Eight_Label_Source__c;
          } else {
          TabEightLabel = getObjectLabel(gv.Tab_Eight_Label_Source__c);
        }
        Objs.clear();
        TabEightFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Eight_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabEightFieldValue = (string)Objs[0].get(gv.Tab_Eight_Relation__c);
        }
      } else { 
        ShowTabEight = false;
      }

      if(gv.Tab_Nine_Visible__c == true) {
        ShowTabNine = true;
        TabNinePage = gv.Tab_Nine_Page__c;
        TabNineField = gv.Tab_Nine_Field__c;
        if(gv.Tab_Nine_Label_Type__c == 'Custom Label') {
          TabNineLabel = getLabelString(gv.Tab_Nine_Label_Source__c);
        } else if(gv.Tab_Nine_Label_Type__c == 'Explicit Value'){
          TabNineLabel = gv.Tab_Nine_Label_Source__c;
      }
        else {
          TabNineLabel = getObjectLabel(gv.Tab_Nine_Label_Source__c);
        }
        Objs.clear();
        TabNineFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Nine_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabNineFieldValue = (string)Objs[0].get(gv.Tab_Nine_Relation__c);
        }
      } else { 
        ShowTabNine = false;
      }

      if(gv.Tab_Ten_Visible__c == true) {
        ShowTabTen = true;
        TabTenPage = gv.Tab_Ten_Page__c;
        TabTenField = gv.Tab_Ten_Field__c;
        if(gv.Tab_Ten_Label_Type__c == 'Custom Label') {
          TabTenLabel = getLabelString(gv.Tab_Ten_Label_Source__c);
        } else if(gv.Tab_Ten_Label_Type__c == 'Explicit Value'){
      TabTenLabel = gv.Tab_Ten_Label_Source__c;
      } 
        else {
          TabTenLabel = getObjectLabel(gv.Tab_Ten_Label_Source__c);
        }
        Objs.clear();
        TabTenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Ten_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabTenFieldValue = (string)Objs[0].get(gv.Tab_Ten_Relation__c);
        }
      } else { 
        ShowTabTen = false;
      }
      
 
      if(gv.Tab_Eleven_Visible__c == true) {
        ShowTabEleven = true;
        TabElevenPage = gv.Tab_Eleven_Page__c;
        TabElevenField = gv.Tab_Eleven_Field__c;
        if(gv.Tab_Eleven_Label_Type__c == 'Custom Label') {
          TabElevenLabel = getLabelString(gv.Tab_Eleven_Label_Source__c);
        } else if(gv.Tab_Eleven_Label_Type__c == 'Explicit Value'){
          TabElevenLabel = gv.Tab_Eleven_Label_Source__c;
          }
        else {
          TabElevenLabel = getObjectLabel(gv.Tab_Eleven_Label_Source__c);
        }
        Objs.clear();
        TabElevenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Eleven_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabElevenFieldValue = (string)Objs[0].get(gv.Tab_Eleven_Relation__c);
        }
      } else { 
        ShowTabEleven = false;
      }
      
      if(gv.Tab_Twelve_Visible__c == true) {
        ShowTabTwelve = true;
        TabTwelvePage = gv.Tab_Twelve_Page__c;
        TabTwelveField = gv.Tab_Twelve_Field__c;
        if(gv.Tab_Twelve_Label_Type__c == 'Custom Label') {
          TabTwelveLabel = getLabelString(gv.Tab_Twelve_Label_Source__c);
        } else if(gv.Tab_Twelve_Label_Type__c == 'Explicit Value'){
          TabTwelveLabel = gv.Tab_Twelve_Label_Source__c;
          } 
        else {
          TabTwelveLabel = getObjectLabel(gv.Tab_Twelve_Label_Source__c);
        }
        Objs.clear();
        TabTwelveFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Twelve_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabTwelveFieldValue = (string)Objs[0].get(gv.Tab_Twelve_Relation__c);
        }
      } else { 
        ShowTabTwelve = false;
      }
      
      if(gv.Tab_Thirteen_Visible__c == true) {
        ShowTabThirteen = true;
        TabThirteenPage = gv.Tab_Thirteen_Page__c;
        TabThirteenField = gv.Tab_Thirteen_Field__c;
        if(gv.Tab_Thirteen_Label_Type__c == 'Custom Label') {
          TabThirteenLabel = getLabelString(gv.Tab_Thirteen_Label_Source__c);
        } else if(gv.Tab_Thirteen_Label_Type__c == 'Explicit Value'){
          TabThirteenLabel = gv.Tab_Thirteen_Label_Source__c;
      } 
        else {
          TabThirteenLabel = getObjectLabel(gv.Tab_Thirteen_Label_Source__c);
        }
        Objs.clear();
        TabThirteenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Thirteen_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabThirteenFieldValue = (string)Objs[0].get(gv.Tab_Thirteen_Relation__c);
        }
      } else { 
        ShowTabThirteen = false;
      }
      
      if(gv.Tab_Fourteen_Visible__c == true) {
        ShowTabFourteen = true;
        TabFourteenPage = gv.Tab_Fourteen_Page__c;
        TabFourteenField = gv.Tab_Fourteen_Field__c;
        if(gv.Tab_Fourteen_Label_Type__c == 'Custom Label') {
          TabFourteenLabel = getLabelString(gv.Tab_Fourteen_Label_Source__c);
        } else if(gv.Tab_Fourteen_Label_Type__c == 'Explicit Value'){
      TabFourteenLabel = gv.Tab_Fourteen_Label_Source__c;
      } else {
          TabFourteenLabel = getObjectLabel(gv.Tab_Fourteen_Label_Source__c);
        }
        Objs.clear();
        TabFourteenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Fourteen_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabFourteenFieldValue = (string)Objs[0].get(gv.Tab_Fourteen_Relation__c);
        }
      } else { 
        ShowTabFourteen = false;
      }
      
      
      if(gv.Tab_Fifteen_Visible__c == true) {
        ShowTabFifteen = true;
        TabFifteenPage = gv.Tab_Fifteen_Page__c;
        TabFifteenField = gv.Tab_Fifteen_Field__c;
        if(gv.Tab_Fifteen_Label_Type__c == 'Custom Label') {
          TabFifteenLabel = getLabelString(gv.Tab_Fifteen_Label_Source__c);
        }  else if(gv.Tab_Fifteen_Label_Type__c == 'Explicit Value'){
          TabFifteenLabel = gv.Tab_Fifteen_Label_Source__c;
      }
         else {
          TabFifteenLabel = getObjectLabel(gv.Tab_Fifteen_Label_Source__c);
        }
        Objs.clear();
        TabFifteenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Fifteen_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabFifteenFieldValue = (string)Objs[0].get(gv.Tab_Fifteen_Relation__c);
        }
      } else { 
        ShowTabFifteen = false;
      }
      
      
      if(gv.Tab_Sixteen_Visible__c == true) {
        ShowTabSixteen = true;
        TabSixteenPage = gv.Tab_Sixteen_Page__c;
        TabSixteenField = gv.Tab_Sixteen_Field__c;
        if(gv.Tab_Sixteen_Label_Type__c == 'Custom Label') {
          TabSixteenLabel = getLabelString(gv.Tab_Sixteen_Label_Source__c);
        } else if(gv.Tab_Sixteen_Label_Type__c == 'Explicit Value'){
          TabSixteenLabel = gv.Tab_Sixteen_Label_Source__c;
          } 
        else {
          TabSixteenLabel = getObjectLabel(gv.Tab_Sixteen_Label_Source__c);
        }
        Objs.clear();
        TabSixteenFieldValue = TabOneFieldValue;
        idquery = 'SELECT ' +  String.escapeSingleQuotes(gv.Tab_Sixteen_Relation__c) + ' FROM ' +  String.escapeSingleQuotes(ObjectType) + ' WHERE Id = \'' +  String.escapeSingleQuotes(controller.getRecord().Id) + '\'';
        Objs = Database.query(idquery);
        if(Objs.size() > 0) {
          TabSixteenFieldValue = (string)Objs[0].get(gv.Tab_Sixteen_Relation__c);
        }
      } else { 
        ShowTabSixteen = false;
      }
      
    }
  }
  
  public string getLabelString(string labelName) {
    Component.Apex.OutputText output = new Component.Apex.OutputText();
    try {
      output.expressions.value = '{!$Label.' + labelName + '}';
      System.debug('test1111' + output.value);
      if(output.value == null) {
        return ' '; 
      } else {
        return string.valueOf(output.value);
      }
    } catch (exception e) {
        return 'No Label Found';
    }      
  }

  public string getObjectLabel(string labelName) {
    list<string> Objects = new list<string>();
    Objects.add(labelName);
    try {
      schema.describeSobjectResult[] results = schema.describeSObjects(Objects);
      if(results.size() > 0) {
        return results[0].getLabelPlural();
      } else {
        return ' '; 
      }
    } catch (exception e) {
        return 'No SObject Found';
    }
  }  
}