public class OtherLocations {
    @AuraEnabled
    public static List<Location> getAccount() {
        List< Account> accs =  [Select Id, Name,Type, Industry, BillingAddress,BillingStreet,
                                BillingCity, BillingCountry, BillingPostalCode,
                                BillingState,Phone from Account  where BillingStreet!=NULL AND
                                BillingCity!=NULL AND BillingCountry!=NULL AND  BillingPostalCode!=NULL AND
                                BillingState!=NULL AND Match_Type__c = 'Other'] ;
        
        List<Location> loc = new List<Location>();
        
               // Adding Child's location first
        GeoLocation geoInfo2 = new GeoLocation();
        geoInfo2.Street = '1716 34th Street Northwest';
        geoInfo2.PostalCode = '20007';
        geoInfo2.City = 'Washington';
        geoInfo2.State = 'DC';
        Location locDetail2 = new Location();
        locDetail2.icon = 'standard:account';
        locDetail2.title = 'Samuel Moore';
        locDetail2.description = 'Current location of Samuel Moore';
        locDetail2.location = geoInfo2;
        
        loc.add(locDetail2);

        for(Account acc :accs){
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = acc.BillingStreet;
            geoInfo.PostalCode = acc.BillingPostalCode;
            geoInfo.City = acc.BillingCity;
            geoInfo.State = acc.BillingState;
            geoInfo.Country = acc.BillingCountry;
            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.title = acc.Name;
            locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            
            loc.add(locDetail);
        }
        return loc ;
    }
    public class Location{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled 
        public GeoLocation location{get;set;} 
    }
    public class GeoLocation{
        @AuraEnabled 
        public String Street{get;set;}
        @AuraEnabled 
        public String PostalCode{get;set;}
        @AuraEnabled 
        public String City{get;set;}
        @AuraEnabled 
        public String State{get;set;}
        @AuraEnabled 
        public String Country{get;set;}
    }
}