trigger CourseDependencies on FieloELR__CourseDependency__c (before insert, before update) {
	SObjectDomain.triggerHandler(CourseDependencies.class);
}