global with sharing class QuestionService {
	
	/*public static List<Question__c> getQuestions(Id moduleId,
									  Set<Id> excludedQuestionIds,
									  Set<String> fieldsQuestion,
									  Set<String> fieldsAnswerOption,
									  Integer quantity,
									  Integer offset) {
		String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestion), ',');
		if(fieldsAnswerOption != null){
			questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r ORDER BY OrderFormula__c)';
		}
		questionQuery += ' FROM Question__c WHERE Module__c =: moduleId';
		if(excludedQuestionIds != null){
			questionQuery += ' AND Id NOT in : excludedQuestionIds';
		}
		questionQuery += ' ORDER BY OrderFormula__c';
		
		Module__c module = [SELECT QuestionPool__c FROM Module__c WHERE Id =: moduleId];

		if(module.QuestionPool__c != null){
			if(quantity != null && quantity < module.QuestionPool__c){
				questionQuery += ' LIMIT ' + quantity;
			}else{
				questionQuery += ' LIMIT ' + module.QuestionPool__c;
			}
		}else{
			if(quantity != null){
				questionQuery += ' LIMIT ' + quantity;
			}
		}

		if(offset != null){
			questionQuery += ' OFFSET ' + offset;
		}

		return Database.query(questionQuery);
	}*/

	global class QuestionResponseWrapper{
		public QuestionResponse__c questionResponse {get; set;}
		public Question__c question {get; set;}
		public List<Answer__c> answers {get; private set;}
		
		global QuestionResponseWrapper(Id moduleResponseId, Question__c question){
			this.question = question;
			this.questionResponse = new QuestionResponse__c(ModuleResponse__c = moduleResponseId, Question__c = question.Id, NumberOfAttempt__c = null);
			this.answers = new List<Answer__c>();
		}

		global void setShortAnswer(String answer){
			if(question.Type__c == 'Short Answer'){
				questionResponse.TextValue__c = answer;
			}else{
				throw new FieloPLT.FieloException('This method is only for Short Answer questions.');
			}
		}

		global void setAnswer(AnswerOption__c answerOption){
			if(question.Type__c == 'Single Choice' || question.Type__c == 'Statement'){
				answers.add(new Answer__c(AnswerOption__c = answerOption.Id));
			}else{
				throw new FieloPLT.FieloException('This method is only for Single Choice or Statement questions.');
			}
		}

		global void setAnswers(List<AnswerOption__c> answerOptions){
			if(question.Type__c == 'Multiple Choice' || question.Type__c == 'Matching Options'){
				for(AnswerOption__c answerOption : answerOptions){
					answers.add(new Answer__c(AnswerOption__c = answerOption.Id));
				}
			}else{
				throw new FieloPLT.FieloException('This method is only for Multiple Choice or Matching Option questions.');
			}
		}
	}

	global class QuestionResponseResult{
		global Question__c question {get; private set;}
		global Integer numberOfAttempts {get; private set;}
		global QuestionResponse__c questionResponse {get; private set;}
		global List<AnswerWrapper> answerWrappers {get; private set;}
		global Boolean canRepeatQuestion {get; private set;}

		public QuestionResponseResult(Question__c question, List<QuestionResponse__c> questionResponses){
			this.question = question;
			this.numberOfAttempts = questionResponses.size();
			this.questionResponse = this.numberOfAttempts > 0 ? questionResponses.get(this.numberOfAttempts - 1) : null;
			setAnswerWrappers(this.questionResponse.Answers__r);
		}

		public QuestionResponseResult(Question__c question, QuestionResponse__c questionResponse, List<Answer__c> answers){
			this.question = question;
			this.numberOfAttempts = questionResponse.NumberOfAttempt__c.intValue();
			this.questionResponse = questionResponse;
			setAnswerWrappers(answers);	
		}

		public void setRepeatQuestion(Boolean canRepeatQuestion){
			this.canRepeatQuestion = canRepeatQuestion;
		}

		private void setAnswerWrappers(List<Answer__c> answers){
			if(question.Type__c != 'Short Answer'){
				Map<Id,Answer__c> answersByOption = new Map<Id,Answer__c>();
				if(questionResponse != null){
					for(Answer__c answer : answers){
						answersByOption.put(answer.AnswerOption__c, answer);
					}
				}

				this.answerWrappers = new List<AnswerWrapper>();
				for(AnswerOption__c answerOption : question.AnswerOptions__r){
					answerWrappers.add(new AnswerWrapper(answerOption, answersByOption.get(answerOption.Id), question.Type__c));
				}
			}
		}
	}

	global class AnswerWrapper{
		global AnswerOption__c answerOption {get; private set;}
		global String answerStatus {get; private set;}
		
		public AnswerWrapper(AnswerOption__c answerOption, Answer__c answer, String questionType){
			this.answerOption = answerOption;
			if(questionType != 'Matching Options'){
				if(answer != null){
					this.answerStatus = answerOption.IsCorrect__c ? 'Correct' : 'Incorrect';
				}else{
					this.answerStatus = answerOption.IsCorrect__c ? 'Incorrect' : 'Neutral';
				}
			}else{
				if(answer != null){
					this.answerStatus = answerOption.IsCorrect__c ? 'Correct' : 'Incorrect';
					this.answerOption.MatchingText__c = answer.TextValue__c;
				}else{
					this.answerStatus = answerOption.IsCorrect__c ? 'Incorrect' : 'Neutral';
					this.answerOption.MatchingText__c = null;
				}
			}
		}
	}

	global static QuestionResponseResult submitQuestion (QuestionResponseWrapper questionResponseWrapper){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		uow.registerNew(questionResponseWrapper.questionResponse);
		for(Answer__c answer : questionResponseWrapper.answers){
			uow.registerNew(answer, Answer__c.QuestionResponse__c, questionResponseWrapper.questionResponse);
		}

		SavePoint sp = Database.setSavePoint();
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType});
		QuestionResponse__c qResponseQuery = [SELECT Id, PartialGradeValue__c, NumberOfAttempt__c, IsCorrect__c, IsSubmitted__c, Question__r.Module__r.QuestionPool__c FROM QuestionResponse__c WHERE Id =: questionResponseWrapper.questionResponse.Id];
		qResponseQuery.IsSubmitted__c = true;
		uow.registerDirty(qResponseQuery);
		try{
			QuestionResponses.validateAdminFields = false;
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}
		qResponseQuery = (FieloELR__QuestionResponse__c) uow.m_dirtyMapByType.get('FieloELR__QuestionResponse__c').get(qResponseQuery.Id);
		system.debug(qResponseQuery.NumberOfAttempt__c);
		QuestionResponseResult qrResult = new QuestionResponseResult(questionResponseWrapper.question, qResponseQuery, questionResponseWrapper.answers);
		qrResult.setRepeatQuestion(qResponseQuery.IsCorrect__c || qResponseQuery.NumberOfAttempt__c >= qResponseQuery.Question__r.Module__r.QuestionPool__c);
		return qrResult;
	}
	
}