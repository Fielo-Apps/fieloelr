trigger CourseStatus on CourseStatus__c (before insert, after insert, before update, after update, before delete, after delete) {
  SObjectDomain.triggerHandler(CourseStatus.class);
}