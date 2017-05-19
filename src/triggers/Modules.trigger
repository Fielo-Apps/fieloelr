trigger Modules on Module__c (before insert, before update, after update, before delete) {
	SObjectDomain.triggerHandler(Modules.class);
}