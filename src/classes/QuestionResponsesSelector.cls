public with sharing class QuestionResponsesSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                QuestionResponse__c.Id,
                QuestionResponse__c.Name,
                QuestionResponse__c.ModuleResponse__c,
                QuestionResponse__c.IsCorrect__c,
                QuestionResponse__c.IsSubmitted__c,
                QuestionResponse__c.NumberOfAttempt__c,
                QuestionResponse__c.TextValue__c,
                QuestionResponse__c.Question__c
            };
    }

    public QuestionResponsesSelector(Set<String> fields){
        super(fields);
    }

    public QuestionResponsesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return QuestionResponse__c.sObjectType;
    }

    public List<QuestionResponse__c> selectById(Set<Id> questionResponseIds){
        return (List<QuestionResponse__c>) selectSObjectsById(questionResponseIds);
    }

    public List<QuestionResponse__c> selectByIdWithAnswersResponses(Set<Id> questionResponseIds) {
    	return (List<QuestionResponse__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, Answer__c, Name FROM AnswerResponses__r) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :questionResponseIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<QuestionResponse__c> selectByKeyAndCorrect(Set<String> keys) {
        return (List<QuestionResponse__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE Key__c IN : keys AND IsCorrect__c = true ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}