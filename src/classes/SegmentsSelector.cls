public class SegmentsSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                FieloPLT__Segment__c.Id,
                FieloPLT__Segment__c.FieloPLT__Program__c,
                FieloPLT__Segment__c.FieloPLT__IsActive__c
            };
    }

    public SegmentsSelector(){
        super();
    }

    public SegmentsSelector(Set<String> fields){
        super(fields);
    }

    public Schema.SObjectType getSObjectType(){
        return FieloPLT__Segment__c.sObjectType;
    }

    public List<FieloPLT__Segment__c> selectById(Set<Id> idSet){
        return (List<FieloPLT__Segment__c>) selectSObjectsById(idSet);
    }

    public List<FieloPLT__Segment__c> selectByProgramAndWithoutProgramWithCriteria(Id programId, Set<String> criterionFields){
        String metaSegmentRTName = 'Metasegment';
        return (List<FieloPLT__Segment__c>) Database.query(
                String.format(
                'select {0}, ' +
                '(SELECT ' + String.join(new List<String>(criterionFields),',') + ' FROM FieloPLT__SegmentCriteria__r) ' +
                  'from {1} ' +
                  'where (FieloPLT__Program__c =: programId OR FieloPLT__Program__c = null) AND RecordType.DeveloperName !=: metaSegmentRTName ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ) );
    }
}