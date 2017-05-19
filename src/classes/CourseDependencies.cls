public class CourseDependencies extends SObjectDomain{
    
    public CourseDependencies(List<CourseDependency__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<CourseDependency__c> sObjectList) {
            return new CourseDependencies(sObjectList);
        }
    }

    public override void onValidate() {
        //before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
        //before update
    }

    public override void onBeforeDelete() {

    }
    public override void onBeforeInsert() {

        for(CourseDependency__c courseDependency : (List<CourseDependency__c>)records){
            courseDependency.Key__C = ((string)courseDependency.Course__c).substring(0, 15) + ((string)courseDependency.Predecessor__c).substring(0, 15);

        }
    }
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {

        for(CourseDependency__c courseDependency : (List<CourseDependency__c>)records){
            courseDependency.Key__C = ((string)courseDependency.Course__c).substring(0, 15) + ((string)courseDependency.Predecessor__c).substring(0, 15);

        }
    }
}