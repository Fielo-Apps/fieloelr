public class QuestionResponses extends SObjectDomain {
    public static Set<Id> processedIds = new Set<Id>();
    public static Boolean disableSubmit = false;
    public static Boolean validateAdminFields = true;

    public QuestionResponses(List<QuestionResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<QuestionResponse__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new QuestionResponses(sObjectList);
        }
    }

    public override void onApplyDefaults(){
        Set<String> qrKeys = new Set<String>();
        for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
            questionResp.IsSubmitted__c = false;
            questionResp.IsCorrect__c = false;
            questionResp.Key__c = String.valueOf(questionResp.Question__c).subString(0,15) + String.valueOf(questionResp.ModuleResponse__c).subString(0,15);
            qrKeys.add(questionResp.Key__c);
        }

        List<AggregateResult> aggResult = [SELECT MAX(NumberOfAttempt__c) attemptNumber, Key__c FROM QuestionResponse__c WHERE Key__c in : qrKeys GROUP BY Key__c];
        Map<String,Integer> maxNumbByKey = new Map<String,Integer>();
        for(AggregateResult qr : aggResult){
            maxNumbByKey.put((String)qr.get('Key__c'), (Integer)qr.get('attemptNumber'));
        }
        
        for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
            if(maxNumbByKey.containsKey(questionResp.Key__c)){
                Integer maxAttempt = maxNumbByKey.get(questionResp.Key__c);
                questionResp.NumberOfAttempt__c = ++maxAttempt;
                maxNumbByKey.put(questionResp.Key__c, maxAttempt);
            }else{
                questionResp.NumberOfAttempt__c = 1;
                maxNumbByKey.put(questionResp.Key__c, 1);
            }
        }
    }

    public override void onValidate(){
        if(validateAdminFields){
            validateModuleSubmitted(records);
        }
    }

    public override void onValidate(Map<Id,SObject> existingRecords){
        if(validateAdminFields){
            for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
                if(((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c){
                    questionResp.addError('Cannot modify a question response already submitted.');
                }

                if(questionResp.IsCorrect__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsCorrect__c){
                    questionResp.IsCorrect__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsCorrect__c;
                }
                if(questionResp.NumberOfAttempt__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).NumberOfAttempt__c){
                    questionResp.NumberOfAttempt__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).NumberOfAttempt__c;
                }
                if(questionResp.PartialGradeValue__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).PartialGradeValue__c){
                    questionResp.PartialGradeValue__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).PartialGradeValue__c;
                }
                if(questionResp.Key__c != ((QuestionResponse__c)existingRecords.get(questionResp.Id)).Key__c){
                    questionResp.Key__c = ((QuestionResponse__c)existingRecords.get(questionResp.Id)).Key__c;
                }
            }
        }

        List<QuestionResponse__c> submittedRecords = new List<QuestionResponse__c>();
        Set<String> submittedKeys = new Set<String>();
        for(QuestionResponse__c questionResp : (List<QuestionResponse__c>)records){
            //Add only submitted records.
            if( questionResp.IsSubmitted__c && !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c){
                submittedRecords.add(questionResp);
                submittedKeys.add(questionResp.Key__c);
            }
        }

        List<QuestionResponse__c> correctedQuestionResponses = new QuestionResponsesSelector().selectByKeyAndCorrect(submittedKeys);
        Set<String> existingSubmittedResponses = new Set<String>();
        for(QuestionResponse__c qr : correctedQuestionResponses){
            existingSubmittedResponses.add(qr.Key__c);
        }

        for(QuestionResponse__c questionResp : submittedRecords){
            if(existingSubmittedResponses.contains(questionResp.Key__c)){
                questionResp.addError('The question cannot be submitted because was already answered correct.');
            }
            /*//Add only submitted records.
            if( questionResp.IsSubmitted__c && !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c){
                submittedRecords.add(questionResp);
                submittedKeys.add(questionResp.Key__c);
            }*/
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        List<QuestionResponse__c> submittedRecords = new List<QuestionResponse__c>();

        for(QuestionResponse__c questionResp: (List<QuestionResponse__c>)records){
            //Add only submitted records.
            if( questionResp.IsSubmitted__c ){
                if( !((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c ||
                    ((QuestionResponse__c)existingRecords.get(questionResp.Id)).IsSubmitted__c == null){
                    submittedRecords.add(questionResp);
                }
            }
        }

        if(!submittedRecords.isEmpty() && !disableSubmit){
            setIsCorrect(submittedRecords);
        }
    }

    public override void onBeforeDelete(){
        if(validateAdminFields){
            validateModuleSubmitted(records);
        }
    }

    private static void validateModuleSubmitted(List<QuestionResponse__c> questionResponses){
        Set<Id> moduleResponseIds = new Set<Id>();
        for(QuestionResponse__c questionResp : questionResponses){
            moduleResponseIds.add(questionResp.ModuleResponse__c);
        }

        Map<Id,ModuleResponse__c> submittedModuleResponsesMap = new Map<Id,ModuleResponse__c>(new ModuleResponsesSelector(new Set<String>{'Id','IsSubmitted__c'}).selectByIdAndSubmitted(moduleResponseIds));
        for(QuestionResponse__c questionResp : questionResponses){
            if(submittedModuleResponsesMap.get(questionResp.ModuleResponse__c).IsSubmitted__c){
                questionResp.addError('Cannot add question response to a module that was already submitted.');
            }
        }
    }

    public static void setIsCorrect(List<QuestionResponse__c> records) {
        Set<Id> questionResponseIds = new Map<Id,QuestionResponse__c>(records).keySet();
        Set<Id> questionIds = new Set<Id>();
        for (QuestionResponse__c questionResponse:records) {
            questionIds.add(questionResponse.Question__c);
        }
        Map<Id,QuestionResponse__c> existingQuestionResponses = new Map<Id,QuestionResponse__c>(new QuestionResponsesSelector().selectByIdWithAnswersResponses(questionResponseIds));
        Map<Id,Question__c> questionsMap = new Map<Id,Question__c>(new QuestionsSelector(new Set<String>{'PenaltyPerAttempt__c','CorrectWeight__c','IncorrectWeight__c','Type__c','Module__r.PenaltyMode__c'}).selectByIdWithCorrectAnswers(questionIds));

        Double incorrectWeight;
        Double questionWeight;
        Double penaltyPerQuestion;
        Integer isCorrectInt;
        Integer questionRespAttempts;
        String penaltyMode;

        Set<String> correctKeys = new Set<String>();
        for (QuestionResponse__c questionResponse: records) {
            if (questionsMap.containsKey(questionResponse.Question__c)) {
                Question__c question = questionsMap.get(questionResponse.Question__c);
                if(question.Type__c == 'Multiple Choice' || question.Type__c == 'Single Choice' || question.Type__c == 'Statement'){
                    questionResponse.IsCorrect__c = true;
                    //verifies if the number of answers are the same as the correct ones
                    List<AnswerResponse__c> answerResponses = existingQuestionResponses.get(questionResponse.Id).AnswerResponses__r;
                    if (answerResponses.size() == questionsMap.get(questionResponse.Question__c).Answers__r.size()) {
                        Set<Id> correctAnswerIds = new Map<Id,Answer__c>(question.Answers__r).keySet();
                        
                        //loop the answer responses and verify that all of them are related to correct answers
                        for(AnswerResponse__c answerResponse : existingQuestionResponses.get(questionResponse.Id).AnswerResponses__r) {
                            if (!correctAnswerIds.contains(answerResponse.Answer__c)) {
                                questionResponse.IsCorrect__c = false;
                                break;
                            }
                        }
                    } else {
                        questionResponse.IsCorrect__c = false;
                    }
                }else if (question.Type__c == 'Short Answer') {
                    questionResponse.IsCorrect__c = false;
                    for (Answer__c answer: questionsMap.get(questionResponse.Question__c).Answers__r) {
                        if (answer.AnswerText__c == questionResponse.TextValue__c) {
                            questionResponse.IsCorrect__c = true;
                            break;
                        }
                    }
                }else if (question.Type__c == 'Fill in the Blanks') {
                    questionResponse.IsCorrect__c = question.AnswerText__c == questionResponse.TextValue__c;
                }else if (question.Type__c == 'Matching') {
                    questionResponse.IsCorrect__c = true;
                    List<AnswerResponse__c> answerResponses = existingQuestionResponses.get(questionResponse.Id).AnswerResponses__r;
                    if (answerResponses.size() == questionsMap.get(questionResponse.Question__c).Answers__r.size()) {
                        Set<String> correctAnswers = new Set<String>();
                        for(Answer__c answer : question.Answers__r){
                            correctAnswers.add(answer.AnswerText__c);
                        }

                        //loop the answer responses and verify that all of them are related to correct answers
                        for(AnswerResponse__c answerResponse : existingQuestionResponses.get(questionResponse.Id).AnswerResponses__r) {
                            if(!correctAnswers.contains(answerResponse.Answer__c)) {
                                questionResponse.IsCorrect__c = false;
                                break;
                            }else{
                                correctAnswers.remove(answerResponse.Answer__c);
                            }
                        }
                    } else {
                        questionResponse.IsCorrect__c = false;
                    }
                }

                if(questionResponse.IsCorrect__c && correctKeys.contains(questionResponse.Key__c)){
                    questionResponse.addError('This question was already answered correct.');
                }else{
                    if(questionResponse.IsCorrect__c){
                        correctKeys.add(questionResponse.Key__c);                        
                    }
                
                    incorrectWeight = question.IncorrectWeight__c;
                    questionWeight = question.CorrectWeight__c;
                    penaltyPerQuestion = question.PenaltyPerAttempt__c;
                    isCorrectInt = questionResponse.IsCorrect__c ? 1 : 0;
                    questionRespAttempts = Integer.valueOf(questionResponse.NumberOfAttempt__c);
                    penaltyMode = question.Module__r.PenaltyMode__c;

                    questionResponse.PartialGradeValue__c =
                        penaltyMode == 'Percent Decrease' ?
                                isCorrectInt * (questionWeight * Math.pow((1 - penaltyPerQuestion / 100),questionRespAttempts-1)) :
                                penaltyMode == 'Negative Weight' ?
                                    (isCorrectInt * questionWeight + (isCorrectInt - 1) * incorrectWeight) :
                                    isCorrectInt * questionWeight;
                }
            }
        }
    }
}