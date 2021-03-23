public class FarmWrapper {
    public cls_id id;
    public String status;	//NEW
    public String type;	//GROWER
    public boolean deleted;
    public String createdDate;	//2019-08-05T10:29:41.616
    public String lastModifiedDate;	//2019-10-29T15:52:57.208
    public cls_partners partners;
    public cls_campaign campaign;
    public cls_farms[] farms;
    public cls_purchaseSummaryList[] purchaseSummaryList;
    public boolean sendEmail;
    public String proofStatus;
   
    public class cls_id {
        public String external;
        public String agriclime;	//23ef672f-80bf-4ac5-946b-deec3e7e3f38
    }
    public class cls_partners {
        public cls_grower grower;
        public cls_advisor advisor;
        public cls_salesManager salesManager;
    }
   public class cls_grower {
        public cls_id id;
        public String firstName;	//Simon 
        public String lastName;	//Doolin
        public String email;	//simon@doolinagriculture.com.au
        public String company;	//Doolin Agriculture
        public String mobilePhone;	//0429047197
        public cls_address address;
        public cls_extra extra;
    }
    public class cls_address {
        public cls_location location;
        public String street;	//
		public String stateCode;	//
		public String countryCode;	//CA
        public String postalCode;
        public String city;	//
    }
    class cls_extra {
        public String growerLicenseNumber;
    }
    public class cls_advisor {
        public String firstName;	//David 
        public String lastName;	//Kelly
        public String email;	//david@miag.com.au
        public String company;	//Macintyre Independent Agronomist
        public String mobilePhone;	//0407 238789
        public cls_address address;
    }
    class cls_salesManager {
        public cls_id id;
        public cls_extra extra;
		public cls_address address;
		public String email;	//sidana.aakash@gmail.com
		public String lastName;	//Sidana
		public String firstName;
    }
    public class cls_campaign {
        public cls_id id;
        public String title;	//Australia 2019
        public String countryCode;	//AU
        public String status;	//ACTIVE
        public String season;
    }
   public class cls_farms {
        public cls_id id;
        public cls_address address;
        public Decimal committedArea;	//500
        public String commitedAreaUoM;	//HECTARE
        //public String currency;	//AUD
        public Double actualCashback;	//20081.1
        //public String actualCashbackCurrency;	//AUD
        public Decimal committedSpend;	//66937
        //public String committedSpendCurrency;	//AUD
        public String weatherGuarantee;	//Rainfall Threshold: 53.72 mm
        public cls_gridCell gridCell;
        public cls_crops[] crops;
        //public cls_purchases[] purchases;
        public cls_purchaseList[] purchaseList;
        public cls_riskPeriodList[] riskPeriodList;
       
        public Decimal potentialCashback;	//20081.1
        public String name;
        public Double totalMaxPayoutPercent;
        public String optionTitle;
    }
     public class cls_location {
        public Double lat;	//-29.025
        public Double lng;	//150.47501
    }
    class cls_dms {
    }
    public class cls_gridCell {
        public cls_location location;
    }
    public class cls_crops {
        public String crop;	//Wheat
    }
  
    public class cls_purchaseList {
        public String productCode;	//VIBRANCE
        public String productLabel;	//VIBRANCE
        public String productBusiness;	//CP
        public Decimal price;	//36.4
        public String priceCurrency;	//AUD
        public Double quantity;	//540
        public String quantityUoM;	//L
        public Double totalAmount;	//18095.9
    }
    Public class cls_purchaseSummaryList { //New / entirely
		public Decimal price;	//21.25
		public String priceCurrency;	//CAD
		public String productBusiness;	//CP
		public String productCode;	//Elatus
		public String productLabel;	//Elatus
		public Double quantity;	//9880
		public String quantityUoM;	//L
		public Double totalAmount;	//209950
	}
    public class cls_riskPeriodList {
        public cls_id id;
        public String indexFunction;	//Program Period 2
        public Date start;	//2019-09-01
        public Integer duration;
        public String option;	//PUT
		public String type;	//CUMULATIVE_DAILY
		public String peril;	//PRECIPITATION	//60
        //public cls_inseasonDayList[] inseasonDayList;
        public Double measurement;
        public cls_indexValues indexValues;
        
    }
    public class cls_indexValues {
		//public Double trigger;	//47.748
        public String triggerDisplay;
        public String exitDisplay;
		//public Double exit;	//1.00260162
		public Double layer;	//46.7454
		public Double notional;	//0.4278496
		public Double maxPayoutPercent;	//20
	}
    
    /**class cls_inseasonDayList {
        public String dateValue;	//2019-09-01
        public String indexValue;	//0
        public String measurementValue;	//0
        public String measurementUnit;	//mm
    }**/
    public static FarmWrapper parse(String json){
		return (FarmWrapper) System.JSON.deserialize(json, FarmWrapper.class);
	}

    
}