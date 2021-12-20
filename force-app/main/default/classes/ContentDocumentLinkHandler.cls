public class ContentDocumentLinkHandler {
	public static void handleAfterInsert(List<ContentDocumentLink> cdlList){
        
        Map<Id, List<Id>> caseHearingOutcomeToAttachmentsMap = new Map<Id, List<Id>>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        // Iterate on newly created ContentDocumentLinks and create a map of court hearing outcome and its related file attachment ids
        for(ContentDocumentLink cdl : cdlList){
            String objName = cdl.LinkedEntityId.getSObjectType().getDescribe().getName();
            if(objName == 'Court_Hearing_Outcome__c'){
                if(caseHearingOutcomeToAttachmentsMap.containsKey(cdl.LinkedEntityId)){
                    caseHearingOutcomeToAttachmentsMap.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
                }else{
                    caseHearingOutcomeToAttachmentsMap.put(cdl.LinkedEntityId, new List<Id>{ cdl.ContentDocumentId });
                }
            }
        }
        
        // If the map is empty then return.        
        if(caseHearingOutcomeToAttachmentsMap.isEmpty())
            return;
        
        // Get the related court hearing outcome records whose status is closed
        List<Court_Hearing_Outcome__c> courtHearingOutcomeList = [Select Id,Ongoing_Case__c From Court_Hearing_Outcome__c 
                                                                  Where Id IN :caseHearingOutcomeToAttachmentsMap.keySet() AND
                                                                  Court_Hearing__r.Status__c = 'Closed'];
        
        Map<Id, Id> benefitCaseToCourtHearingOutMap = new Map<Id, Id>();
        Set<Id> contectDocIds = New Set<Id>();
        
        if(!courtHearingOutcomeList.isEmpty()){
            
            // Create a map of Benefit Case with court hearing outcomes as benefit case is the common entity between 
            // court hearing outcome and Benefit Case Party Relationship
            for(Court_Hearing_Outcome__c cho : courtHearingOutcomeList){
                benefitCaseToCourtHearingOutMap.put(cho.Ongoing_Case__c, cho.Id);
                contectDocIds.addAll(caseHearingOutcomeToAttachmentsMap.get(cho.Id));
            }
            
            Map<Id, ContentVersion> fileAttchmentMap = new Map<Id, ContentVersion>();
            
            // Get all the attached file data and map it with the content document Id
            for (ContentVersion cversion : [SELECT ContentDocumentId, title, PathOnClient, FileType, versiondata FROM contentversion WHERE ContentDocumentId IN :contectDocIds]){
                fileAttchmentMap.put(cversion.ContentDocumentId, cversion);
            }
            
            // Get all related Benefit Case Party Relationships to whom the email needs to be sent
            List<vlocity_ps__PSCasePartyRelationship__c> benefitCaseRelationshipList = [Select Id, vlocity_ps__PSCaseId__c, 
                                                                                        vlocity_ps__PartyId__r.vlocity_ps__PartyEntityId__c 
                                                                                        From vlocity_ps__PSCasePartyRelationship__c
                                                                                   		Where vlocity_ps__PSCaseId__c IN :benefitCaseToCourtHearingOutMap.keySet()];
            
            if(!benefitCaseRelationshipList.isEmpty()){
                
                List<Messaging.Emailfileattachment> attachments;
                EmailTemplate emailTemplate = [Select Id From EmailTemplate Where DeveloperName = 'Court_Hearing_Outcome'];
                
                // Iterate over Benefit Case Party Relationships and create a email message along with the attachments
                for(vlocity_ps__PSCasePartyRelationship__c bcr : benefitCaseRelationshipList){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTemplateId(emailTemplate.Id);
                    message.setTargetObjectId(bcr.vlocity_ps__PartyId__r.vlocity_ps__PartyEntityId__c);
                    message.setWhatId(benefitCaseToCourtHearingOutMap.get(bcr.vlocity_ps__PSCaseId__c));
                    
                    attachments = new List<Messaging.Emailfileattachment>();
                    
                    // Create attachments for the email
                    for(Id contDocId : caseHearingOutcomeToAttachmentsMap.get(benefitCaseToCourtHearingOutMap.get(bcr.vlocity_ps__PSCaseId__c))){
                        ContentVersion fileVersion = fileAttchmentMap.get(contDocId);
                        Blob fileData = fileVersion.versiondata;
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        efa.setBody(fileData);
                        attachments.add(efa);
                    }
                    
                    message.setFileAttachments(attachments);
                    emailList.add(message);
                }
            }
        }       
        
        // Send email along with the attachments
        if(!emailList.isEmpty()){
            try{
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
            }catch(Exception e){
                throw e;
            }            
        }
    }
}