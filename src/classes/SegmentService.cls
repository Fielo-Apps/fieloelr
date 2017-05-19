public with sharing class SegmentService {
	//metodo para mover a segment service
    //recibe lista (así se puede ordenar y querear más fácil) de Id's, y devuelve el metasegment indicado, puede llegar a ser uno nuevo
    public static Id getMetaSegmentId(List<String> selected, Id programId){
        if(selected.size() == 1){
            return (Id)selected[0];
        }else if(selected.isEmpty()){
            return null;
        }
        selected.sort();
        String segmentsCode = '';
        for(String segmentId : selected){
            segmentsCode += segmentId.substring(0, 15) +  ';';//siempre uso id's de 15 caracteres
        }
        segmentsCode = segmentsCode.removeEnd(';');

        List<FieloPLT__Segment__c> metasegment = [SELECT Id FROM FieloPLT__Segment__c WHERE (FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null) AND FieloPLT__RelatedSegments__c =: segmentsCode AND Recordtype.DeveloperName = 'Metasegment' ];
        if(metasegment.isEmpty()){
            Id metasegmentRTId = getRecordTypeId('FieloPLT__Segment__c', 'Metasegment');
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{FieloPLT__Segment__c.SObjectType});
            FieloPLT__Segment__c newSegment = new FieloPLT__Segment__c(
            	Name = 'Multiple',
            	FieloPLT__Program__c = programId,
            	FieloPLT__RelatedSegments__c = segmentsCode,
            	RecordtypeId = metasegmentRTId,
            	FieloPLT__IsActive__c = true
            );
            uow.registerNew(newSegment);
            uow.commitWork();
            return newSegment.Id;
        }

        return metasegment[0].Id;
    }

    public static Id getRecordTypeId(String sobjectName, String recordTypeName) {
    	try{
    		return Schema.describeSObjects(
    			new String[]{sobjectName})[0].getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    	}catch(Exception e){
    		return null;
    	}
    	
    }
}