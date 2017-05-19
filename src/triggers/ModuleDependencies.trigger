trigger ModuleDependencies on ModuleDependency__c (before insert, before update) {
	SObjectDomain.triggerHandler(ModuleDependencies.class);
}