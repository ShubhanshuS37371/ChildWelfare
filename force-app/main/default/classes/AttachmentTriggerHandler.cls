public class AttachmentTriggerHandler {
	public static void contentDocumentAfterInsertHandler(List<Attachment> attachmentList){
       
        List<Attachment> courtHearingOutcomeAttachmentList = new List<Attachment>();
        
        for (Attachment file: attachmentList) {
			courtHearingOutcomeAttachmentList.add(file);

        if(!courtHearingOutcomeAttachmentList.isEmpty())
            sendCourtHearingOutcomeEmail(courtHearingOutcomeAttachmentList);
    	}
	}
    public static void sendCourtHearingOutcomeEmail(List<Attachment> attachmentList) {
		List<EmailTemplate> templates = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = 'Court_Hearing_Outcome'];
        map<id,Attachment>  mapx= new  map<id,Attachment>();
        List<vlocity_ps__Party__c> partyList = new List<vlocity_ps__Party__c>();
        List<Contact> contactList = new List<Contact>();
        for(Attachment file:attachmentList){
            mapx.put(file.ParentId,file);
        }
        // Hearing Outcome
        Map<id,Court_Hearing_Outcome__c> outcomes =new Map<id,Court_Hearing_Outcome__c>([Select Id, Ongoing_Case__c from Court_Hearing_Outcome__c where Id in :mapx.keySet()]);
        for(Id key : outcomes.keySet()){
            Court_Hearing_Outcome__c outcome = outcomes.get(key);
            // get Benefit Case Party Relationships id given ongoing_case (benefit case ID)
            Map<id, vlocity_ps__PSCasePartyRelationship__c> parties = new Map<id, vlocity_ps__PSCasePartyRelationship__c>([Select Id, vlocity_ps__PartyId__c FROM vlocity_ps__PSCasePartyRelationship__c WHERE vlocity_ps__PSCaseId__c=:outcome.Ongoing_Case__c]);
        	
            for(Id key2 : parties.keySet()){
            	vlocity_ps__PSCasePartyRelationship__c BCPRelationship = parties.get(key2);
                // get contact Id given party Id
                partyList.add([Select Id, vlocity_ps__ContactId__c FROM vlocity_ps__Party__c WHERE Id =:BCPRelationship.vlocity_ps__PartyId__c]);
        	}
        }
        
        // Retrieve list of emails to be sent
        for(vlocity_ps__Party__c party : partyList){
            contactList.add([Select Email FROM Contact WHERE Id=:party.vlocity_ps__ContactId__c]);
        }
        
        String[] EmailList;
        for(Contact c : contactList){
            EmailList.add(c.Email);
        }
        
        // Attach files to the message
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        for (Attachment file: attachmentList) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            List<Messaging.EmailFileAttachment> eattachments = new List<Messaging.EmailFileAttachment>();
            
            efa.setFileName(file.Name);
            efa.setBody(file.Body);
            efa.setContentType(file.ContentType);
            eattachments.add(efa);
            message.setFileAttachments(eattachments);
            message.setTemplateId(templates[0].Id);
            message.setSaveAsActivity(false);
            message.setSubject(templates[0].Subject);
            message.setHtmlBody(templates[0].Body);
            //message.setTargetObjectId();
            message.setReplyTo('no-reply@cloudsynapps.com');
            message.setToAddresses(EmailList);
            messages.add(message);
        }
        try {
            Messaging.sendEmail( messages );
        } catch (Exception e) {
            throw e;
        } 
	}
}