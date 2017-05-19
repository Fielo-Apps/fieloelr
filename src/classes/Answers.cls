public class Answers extends SObjectDomain {

	public Answers(List<Answer__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Answer__c> sObjectList) {
            return new Answers(sObjectList);
        }
    }

    public override void onBeforeInsert() {
    	validateAnswers(records, true);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		validateAnswers(records, true);
    }


	public override void onBeforeDelete() {
     	validateAnswers(records, false);
    }


	// General validations for a list of answers
    private void validateAnswers(List<Answer__c> answers, Boolean validateFormat) {
		
	    Set<Id> questions = new Set<Id>();
	    for(Answer__c answer : answers) {
			questions.add(answer.Question__c);
	    }

		Map<Id, Question__c> questionsMap = new Map<Id, Question__c>(
			new QuestionsSelector(new Set<String> {'Id', 'Module__r.IsActive__c', 'Type__c'}).selectByIdWithAnswers(questions));

	    for(Answer__c answer : answers) {

			// If the module is active, answers cannot be deleted, updated or added.																		
	    	if(questionsMap.get(answer.Question__c).Module__r.IsActive__c) {
	        	answer.addError('Active modules cannot have changes in their set of answers.');             
	    	}

    		// If the question type is "Matching Options", the format for Answer Text must be validated as {"xx":"yy"}
  			if(validateFormat && questionsMap.get(answer.Question__c).Type__c == 'Matching Options') {
				try {
					// If the question type is Matching, the Answer text must be in the format {"string1":"string2"}
				    Map<String, String> deserializedAnswer = (Map<String,String>)JSON.deserializeStrict(answer.AnswerText__c,Map<String,String>.class);
				    System.debug(deserializedAnswer.size() == 1);	    
				} catch(Exception e) {
		        	answer.addError('Answer is in the wrong format. It should be {"abc":"xyz"}.');             
				}
	    	}

	    	// If Order__c field is null, calculate it automatically
    		if( Trigger.isInsert && answer.Order__c == null) {
    			answer.Order__c = questionsMap.get(answer.Question__c).Answers__r.size() + 1;
    		}
	    }
    }

}