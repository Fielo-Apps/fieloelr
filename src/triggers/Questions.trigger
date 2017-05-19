trigger Questions on Question__c (before insert, before update, before delete) {
	SObjectDomain.triggerHandler(Questions.class);
}