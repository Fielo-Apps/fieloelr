public class Modules extends SObjectDomain {

	public static Boolean validateAdminFields = true;

	public Modules(List<Module__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Module__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new Modules(sObjectList);
        }
    }

	public override void onApplyDefaults() {
       for(Module__c module : (List<Module__c>)records){
           module.IsActive__c = false;
       }
    }    

    public override void onValidate() {
    }

    public override void onValidate(Map<Id,SObject> existingRecords) {
		if(validateAdminFields) {
            for(Module__c module : (List<Module__c>)records) {
                if(((Module__c)(existingRecords.get(module.Id))).IsActive__c) {
                	module.addError('An active module cannot be modified.');
                }
            }
        }
    }

    public override void onBeforeInsert() {
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {

   		List<Module__c> activatedModules = new List<Module__c>();
    	List<Module__c> inactivatedModules = new List<Module__c>();

		for(Module__c module : (List<Module__c>)records) {
			// Select only modules that are being activated
			if(!(((Module__c)(existingRecords.get(module.Id))).IsActive__c) && module.IsActive__c) {
				activatedModules.add(module);
			}
			// Select only modules that are being inactivated
			if(((Module__c)(existingRecords.get(module.Id))).IsActive__c && !(module.IsActive__c)) {
				inactivatedModules.add(module);
			}	
		}

		// When the module is changed to active, must validate that has at least one question.
   		checkQuestions(activatedModules);

		// An active module with related module responses cannot be inactivated.
		checkModuleResponses(inactivatedModules);

   		// When the module is activated, should verify, for the question types "statement" and "single choice", that it has a correct answer.
   		checkAnswers(activatedModules);
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
    	List<Module__c> activatedModules = new List<Module__c>();
    	List<Module__c> inactivatedModules = new List<Module__c>();
		for(Module__c module : (List<Module__c>)records) {
			// Select only modules that are being activated
			if(!(((Module__c)(existingRecords.get(module.Id))).IsActive__c) && module.IsActive__c) {
				activatedModules.add(module);
			}
			// Select only modules that are being inactivated
			if(((Module__c)(existingRecords.get(module.Id))).IsActive__c && !(module.IsActive__c)) {
				inactivatedModules.add(module);
			}	
		}

		updateCourses(activatedModules, inactivatedModules);
    }

    // Check the responses for a list of modules
    private void updateCourses(List<Module__c> activatedModules, List<Module__c> inactivatedModules) {
	    
	    Set<Id> courseIds = new Set<Id>();
	    if(activatedModules != null){
		    for(Module__c module : activatedModules) {
		        courseIds.add(module.Course__c);
		    }
		}

		if(inactivatedModules != null){
		    for(Module__c module : inactivatedModules) {
		        courseIds.add(module.Course__c);
		    }
		}

	    Map<Id,Course__c> coursesMap = new Map<Id,Course__c>(new CoursesSelector(new Set<String> {'Id','ActiveModules__c'}).selectById(courseIds));
	    if(activatedModules != null){
		    for(Module__c module : activatedModules) {
		        Course__c course = coursesMap.get(module.Course__c);
		        course.ActiveModules__c++;
		    }
		}

		if(inactivatedModules != null){
		    for(Module__c module : inactivatedModules) {
		        Course__c course = coursesMap.get(module.Course__c);
		        course.ActiveModules__c--;
		    }
		}

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType});
		uow.registerDirty(coursesMap.values());
		Courses.validateAdminFields = false;
		uow.commitWork();
    }

	public override void onBeforeDelete() {

   		List<Module__c> activeModules = new List<Module__c>();

		for(Module__c module : (List<Module__c>)records) {
   			// Select only active modules
			if(module.IsActive__c) {
				activeModules.add(module);
			}
		}

		// An active module with related module responses cannot be deleted.
     	checkModuleResponses(activeModules);

     	updateCourses(null, activeModules);
    }


	// Check the questions for a list of modules
    private void checkQuestions(List<Module__c> activatedModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(activatedModules);

	    List<Module__c> modulesWithQuestion = new ModulesSelector(new Set<String> {'Id'}).selectByIdHavingQuestions(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithQuestion) {
	        if(module.Questions__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot activate a module without any question.');        
	        }        
	    }
    }


	// Check the responses for a list of modules
    private void checkModuleResponses(List<Module__c> inactivatedModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(inactivatedModules);

	    List<Module__c> modulesWithResponse = new ModulesSelector(new Set<String> {'Id'}).selectByIdHavingModuleResponses(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithResponse) {
	        if(!module.ModuleResponses__r.isEmpty()){
	        	modulesMap.get(module.Id).addError('Cannot delete or inactivate a module with response.');        
	        }        
	    }
    }


	// Check the answers for a list of modules
    private void checkAnswers(List<Module__c> activatedModules) {

    	Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(activatedModules);

		// Then check for answers for those questions
	    List<Question__c> questionsWithCorrectAnswer = new QuestionsSelector(new Set<String> {'Id', 'Name', 'Module__c', 'Type__c'}).selectByModuleHavingAnswers(modulesMap.KeySet()); 
	    																		
	    for(Question__c question : questionsWithCorrectAnswer) {
	        if(question.Type__c == 'Statement' || question.Type__c == 'Single Choice' || question.Type__c == 'Multiple Choice' || question.Type__c == 'Matching Options') {
	    		// Question types "statement", "single choice","multiple choice" and "Matching" must have at least one answer.
	        	if(question.Answers__r.isEmpty()) {
					modulesMap.get(question.Module__c).addError('Cannot activate a module with questions of the type ' + question.Type__c + ' without any answer. Question: ' + question.Name);    
	        	} 
        		// Question types "statement" and "single choice" must have a correct answer.
        		if((question.Type__c == 'Statement' || question.Type__c == 'Single Choice') && question.Answers__r[0].IsCorrect__c != true) {
					modulesMap.get(question.Module__c).addError('Cannot activate a module with questions of the type ' + question.Type__c + ' without a correct answer. Question: ' + question.Name);    
        		}
	        } 
	    }
    }
}