public class Questions extends SObjectDomain {

	public Questions(List<Question__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Question__c> sObjectList) {
            return new Questions(sObjectList);
        }
    }

    public override void onApplyDefaults() {
    	// If both IncorrectWeight or PenaltyPerAttempt are null, replace them by 0 (zero)
    	checkNullValues(records);
    }

    public override void onBeforeInsert() {
		// If the module is active, questions cannot be deleted, updated or added.
    	checkModule(records);
    	
    	// Do some module related actions upon insert
		onInsertModuleRelatedActions(records);

	    // If the type is "Fill in the blanks", must validate {} and []
    	validateFormat(records);

    	//If the MetadataAnswer field is set, convert it to plain text.
    	for(Question__c record: (List<Question__c>) records) {
    		formatAnswer(record);
    	}
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		// If the module is active, questions cannot be deleted, updated or added.																		
		checkModule(records);

		// If both IncorrectWeight or PenaltyPerAttempt are null, replace them by 0 (zero)
    	checkNullValues(records);

	    // If the type is "Fill in the blanks", must validate {} and []
    	validateFormat(records);

    	//If the MetadataAnswer field is set, convert it to plain text.
    	for(Question__c record: (List<Question__c>) records) {
    		if(record.MetadataAnswer__c != ((Question__c)existingRecords.get(record.Id)).MetadataAnswer__c  ) {
    			formatAnswer(record);
    		}
    	}
    }


	public override void onBeforeDelete() {
		// If the module is active, questions cannot be deleted, updated or added.																		
     	checkModule(records);
    }

    public override void onAfterDelete() {
    	// Delete related answers upon question delete
    	deleteRelatedAnswers(records);
    }

	// Check the modules
    private void checkModule(List<Question__c> questions) {

	    Set<Id> modules = new Set<Id>();
	    for(Question__c question : questions) {
			modules.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(new ModulesSelector(new Set<String> {'Id'}).selectByIdActive(modules));

		// If the module is active, questions cannot be deleted, updated or added.																		
	    for(Question__c question : questions) {
	    	if(modulesMap.containsKey(question.Module__c)) {
	        	question.addError('Active modules cannot have changes in their set of questions.');             
	    	}
	    }
    }

    // Set fields to zero if null
    private void checkNullValues(List<Question__c> questions) {
    	for (Question__c question: questions) {
    		question.IncorrectWeight__c = question.IncorrectWeight__c == null ?
    			0.0 :
    			question.IncorrectWeight__c;
    		question.PenaltyPerAttempt__c = question.PenaltyPerAttempt__c == null ?
    			0.0 :
    			question.PenaltyPerAttempt__c;
    	}
    }

    //Module related actions on Insert
    private void onInsertModuleRelatedActions(List<Question__c> questions) {

    	Set<Id> modules = new Set<Id>();
	    for(Question__c question : questions) {
			modules.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(
			new ModulesSelector(new Set<String> {'Id','WeightedQuestions__c'}).selectByIdWithQuestions(modules));

    	for (Question__c question: questions) {
    		// If Module.WeightedQuestions is false, CorrectWeight = 1
    		question.CorrectWeight__c = modulesMap.get(question.Module__c).WeightedQuestions__c ?
    			question.CorrectWeight__c :
    			1;

    		// If Order is null, calculate it automatically
    		if(question.Order__c == null) {
    			question.Order__c = modulesMap.get(question.Module__c).Questions__r.size() + 1;
    		}
    	}	
    }

    private void deleteRelatedAnswers(List<Question__c> questions) {
    	Map<Id, Question__c> existingQuestions = new Map<Id, Question__c>(
    		new QuestionsSelector().selectByModuleHavingAnswers(new Map<Id,Question__c>(questions).keySet()));

    	List<Answer__c> existingAnswers = new List<Answer__c>();

    	for (Question__c question: questions) {
    		if(existingQuestions.get(question.Id).Answers__r.size()>0) {
    			existingAnswers.addAll(existingQuestions.get(question.Id).Answers__r);
    		}
    	}

    	if (!existingAnswers.isEmpty()) {
    		delete existingAnswers;
    	}
    }

    // If the type is "Fill in the blanks", must validate {} and []
    private void validateFormat(List<Question__c> questions) {
    	String questionText;
    	for(Question__c question : questions) {
	    	if(question.Type__c == 'Fill in the Blanks') {
	    		// TODO: Validate format
	    		questionText = question.QuestionText__c;
				/*
				String answer = '{!(JavaScript),C++,Java} is also used in environments that are not {!Web}-based, such as {!PDF} documents, site-specific browsers, and desktop widgets. Newer and faster JavaScript virtual machines (VMs) and platforms built upon them have also increased the popularity of JavaScript for server-side Web {!(applications),software}.';

				System.debug('size: ' + answer.length() );

				String currChar;
				String lastChar = ''; 
				String lastCharNonSpace = ''; 
				Boolean openBrackets = false;
				Boolean openParenthesis = false;
				Boolean answerOk = true;

				for(integer i = 0; i < answer.length(); i++) {
					currChar = answer.substring(i, i + 1);
				    
				    if(lastChar == '{' && currChar != '!')
				        answerOk = false;
				    else if(currChar == '{' && openBrackets)
				        answerOk = false;
				    else if(!openBrackets && currChar == '}')
						answerOk = false;
				    else if(currChar == '(' && openParenthesis)
				        answerOk = false;
				    else if(!openParenthesis && currChar == ')')
				        answerOk = false;
				    else if(currChar == ',' && openBrackets && openParenthesis)
						answerOk = false;
				    else if(currChar == ',' && (lastCharNonSpace == ',' || lastCharNonSpace == '(' || lastCharNonSpace == '!' || lastCharNonSpace == '{'))
						answerOk = false;
				    
				    System.debug(lastChar + ' >>> ' + lastCharNonSpace + ' => ' + currChar + ' -> ' + answerOk);
				    if(!answerOk)
				        break;
				    
				    if(lastChar == '{' && currChar == '!')
				        openBrackets = true;
					else if(currChar == '}' && openBrackets)
				        openBrackets = false;
					else if(currChar == '(')
				        openParenthesis = true;
				    else if(currChar == ')' && openParenthesis)
						openParenthesis = false;
				    
				    lastChar = currChar;
					if(currChar != ' ')
				    	lastCharNonSpace = currChar;
				}
				if(!answerOk) {
				    System.debug('Oops!!!');
				}

				*/	    		
	    		if(false) {	
		        	question.addError('Question text is in the wrong format for a question of the type "Fill in the Blanks".');             
	    		}
	    	}
		}
	}

	// Convert an answer with markups to an plain text answer.
	private void formatAnswer(Question__c question) {
		if ( question.MetadataAnswer__c != null && question.MetadataAnswer__c != '') {
			String answer = question.MetadataAnswer__c;
			String regex = '(?<=\\{\\!)(.*?)(?=\\})';
			Pattern regexPattern = Pattern.compile(regex);
			Matcher regexMatcher = regexPattern.matcher(answer);

			List<String> subquestions = new List<String>();
			List<String> answers = new List<String>();
			List<String> correctOption = new List<String>();
			String answerText;

			while(regexMatcher.find()){
				subquestions.add(regexMatcher.group());
				answers = (regexMatcher.group()).split(',');
				if(answers.size()==1){
					correctOption.add(answers[0]);
				} else if (answers.size() > 1) {
					for (String option:answers) {
						if (option.length() < 3)
							continue;
						if (option.substring(0,1)=='(' && option.substring(option.length()-1)==')') {
							correctOption.add(option.substring(1,option.length()-1));
						}
					}
				}
			}

			if(subquestions.size() != correctOption.size()) {
				question.addError('Mismatch of number of questions and number of correct answers.');
			}

			for(String option: correctOption){
				answer = answer.replaceFirst(regex,option);
				answer = answer.replaceFirst('\\{\\!','');
				answer = answer.replaceFirst('\\}','');
			}
			question.AnswerText__c = answer;
		} else {
			question.AnswerText__c = null;
		}
    }
}