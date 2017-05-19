public class CourseStatus extends SObjectDomain {
	
	public CourseStatus(List<CourseStatus__c> records) {
		super(records);
	}

	public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<CourseStatus__c> sObjectList) {
            return new CourseStatus(sObjectList);
        }
    }

    public override void onValidate() {
    	//before insert
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
    	//before update
    }
}