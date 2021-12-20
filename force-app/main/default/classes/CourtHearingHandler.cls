public class CourtHearingHandler {
    public static void handleAfterInsert(List<Court_Hearing__c> chList){
        Map<Id, Id> benefitCaseToCourtHearingMap = new Map<Id, Id>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Court_Hearing__c ch : chList){
            if(ch.Status__c == 'Scheduled'){
                benefitCaseToCourtHearingMap.put(ch.Ongoing_Case__c, ch.Id);
            }
        }
        
        List<vlocity_ps__PSCasePartyRelationship__c> benefitCaseRelationshipList = [Select Id, vlocity_ps__PSCaseId__c, vlocity_ps__PartyId__r.vlocity_ps__PartyEntityId__c From vlocity_ps__PSCasePartyRelationship__c
                                                                                   	Where vlocity_ps__PSCaseId__c IN :benefitCaseToCourtHearingMap.keySet()];
        
        if(!benefitCaseRelationshipList.isEmpty()){
            EmailTemplate emailTemplate = [Select Id From EmailTemplate Where DeveloperName = 'Court_Hearing_Scheduled'];
            for(vlocity_ps__PSCasePartyRelationship__c bcr : benefitCaseRelationshipList){
            	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTemplateId(emailTemplate.Id);
                message.setTargetObjectId(bcr.vlocity_ps__PartyId__r.vlocity_ps__PartyEntityId__c);
                message.setWhatId(benefitCaseToCourtHearingMap.get(bcr.vlocity_ps__PSCaseId__c));
                emailList.add(message);
        	}
        }
        
        if(!emailList.isEmpty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
}