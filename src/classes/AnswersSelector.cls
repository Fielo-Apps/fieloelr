public with sharing class AnswersSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Answer__c.Id,
                Answer__c.Name,
                Answer__c.IsCorrect__c,
                Answer__c.Question__c
            };
    }

    public AnswersSelector(Set<String> fields){
        super(fields);
    }

    public AnswersSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Answer__c.sObjectType;
    }

    public List<Answer__c> selectById(Set<Id> answerIds) {
        return (List<Answer__c>) selectSObjectsById(answerIds);
    }
}