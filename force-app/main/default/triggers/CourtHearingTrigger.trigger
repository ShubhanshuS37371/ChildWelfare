trigger CourtHearingTrigger on Court_Hearing__c (after insert) {
	CourtHearingHandler.handleAfterInsert(Trigger.New);
}