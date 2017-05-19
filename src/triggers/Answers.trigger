trigger Answers on Answer__c (before insert, before update, before delete) {
	SObjectDomain.triggerHandler(Answers.class);
}