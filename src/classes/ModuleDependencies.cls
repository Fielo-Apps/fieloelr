public class ModuleDependencies extends SObjectDomain {

	public ModuleDependencies(List<ModuleDependency__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<ModuleDependency__c> sObjectList) {
            return new ModuleDependencies(sObjectList);
        }
    }

    public override void onBeforeInsert() {
 		setKeys((List<ModuleDependency__c>) records);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
    	setKeys((List<ModuleDependency__c>) records);
    }

    private void setKeys(List<ModuleDependency__c> records) {
    	for(ModuleDependency__c moduleDependency : records) {
			if(moduleDependency.Predecessor__c != null && moduleDependency.Module__c != null) {
				moduleDependency.Key__c = String.valueOf(moduleDependency.Predecessor__c).substring(0, 15) + String.valueOf(moduleDependency.Module__c).substring(0, 15);   
    		}
    	}
    }


}