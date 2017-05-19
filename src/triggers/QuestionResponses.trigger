trigger QuestionResponses on QuestionResponse__c (before insert, after insert, before update, after update, before delete, after delete) {
	SObjectDomain.triggerHandler(QuestionResponses.class);
}