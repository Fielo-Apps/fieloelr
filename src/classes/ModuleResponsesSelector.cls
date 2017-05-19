public with sharing class ModuleResponsesSelector extends SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                ModuleResponse__c.Id,
                ModuleResponse__c.Name,
                ModuleResponse__c.Date__c,
                ModuleResponse__c.GradePercent__c,
                ModuleResponse__c.GradeValue__c,
                ModuleResponse__c.IsApproved__c,
                ModuleResponse__c.IsSubmitted__c,
                ModuleResponse__c.Module__c,
                ModuleResponse__c.NumberOfAttempt__c
            };
    }

    public ModuleResponsesSelector(Set<String> fields){
        super(fields);
    }

    public ModuleResponsesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return ModuleResponse__c.sObjectType;
    }

    public List<ModuleResponse__c> selectById(Set<Id> moduleResponseIds){
        return (List<ModuleResponse__c>) selectSObjectsById(moduleResponseIds);
    }

    public List<ModuleResponse__c> selectByIdAndSubmitted(Set<Id> recordIds) {
        return (List<ModuleResponse__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE Id IN : recordIds AND IsSubmitted__c = true ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<ModuleResponse__c> selectByIdWithQuestionResponses(Set<Id> moduleResponseIds) {
    	return (List<ModuleResponse__c>) Database.query(String.format(
                'SELECT {0} ' +
                  ', (SELECT Id, ' +
                  	'IsCorrect__c, ' +
                  	'IsSubmitted__c, ' +
                    'NumberOfAttempt__c, ' +
                    'Question__c, ' +
                  	'PartialGradeValue__c, ' +
                  	'Name FROM QuestionResponses__r) ' +
                  'FROM {1} ' +
                  'WHERE Id IN :moduleResponseIds ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<ModuleResponse__c> selectByKeyAndApproved(Set<String> keys) {
        return (List<ModuleResponse__c>) Database.query(String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE Key__c IN : keys AND IsApproved__c = true ' +
                  'ORDER BY {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<ModuleResponse__c> selectByKeyAndApproved(Set<String> keys, Set<Id> moduleExcludeIds) {
        String query = 'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE Key__c IN : keys AND IsApproved__c = true ';
        if(moduleExcludeIds != null){
            query += ' AND Id NOT in : moduleExcludeIds ';
        }
                  
        query += 'ORDER BY {2}';
        system.debug('query: ' + query);
        return (List<ModuleResponse__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}