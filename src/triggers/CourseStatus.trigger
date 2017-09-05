trigger CourseStatus on CourseStatus__c (before insert, before update, before delete, after update) {
  SObjectDomain.triggerHandler(CourseStatus.class);
}