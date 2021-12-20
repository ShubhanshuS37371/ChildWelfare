trigger AttachmentTrigger on Attachment (after insert) {
    AttachmentTriggerHandler.contentDocumentAfterInsertHandler(trigger.new);
}