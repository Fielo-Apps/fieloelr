public with sharing class ModuleViewController extends PageSettingsController {
	public Module__c record {get;set;}
	public String buttonString {get;set;}
	public String toolsString {get;set;}
	public static String secondaryParameters {get;set;}
	public List<Map<String,Object>> buttonList {get;set;}
	private ApexPages.StandardController controller;

	/**
    * @brief constructor
    */
	public ModuleViewController(ApexPages.StandardController controller) {
		String objectName = 'FieloELR__Module__c';
		this.controller = controller;
		Id recordId = controller.getId();
		Set<String> fields = new Set<String>();

		fields.addAll(Schema.describeSObjects(
			new String[]{objectName})[0].fields.getMap().keySet());

		if(!Test.isRunningTest()){
            this.controller.addFields(new List<String>(fields));
        }
        // Cast all fieldNames to lowercase
        for(String fieldName: fields){
			fields.remove(fieldName);
			fields.add(fieldName.toLowerCase());
		}

        record = (FieloELR__Module__c)controller.getRecord();

		buttonList = new List<Map<String,Object>>();

		if( getshowActivate() ){
			buttonList.add(new Map<String,Object>{
                'Label' => 'Activate',
                'Type' => 'Remote',
                'Action' => 'FieloELR.ModuleViewController.activate',
                'Confirm' => true
            });
		}
		if( getShowInactivate() ){
			buttonList.add(new Map<String,Object>{
                'Label' => 'Inactivate',
                'Type' => 'Remote',
                'Action' => 'FieloELR.ModuleViewController.inactivate',
                'Confirm' => true
            });
		}

		if(!buttonList.isEmpty()){
            buttonString = JSON.serialize(buttonList);
            buttonString = buttonString.substring(1,buttonString.length()-1);    
        }

        String standardTools = '';
        PageReference exportPage = Page.FieloPLT__XMLExport;
		exportPage.getParameters().put( 'retURL', System.currentPageReference().getUrl() );
		exportPage.getParameters().put( 'courseId', recordId );
		exportPage.getParameters().put( 'type', 'course' );

		/*
		buttonList = new List<Map<String,Object>>();
		buttonList.add(new Map<String,Object>{
            'Label' => 'Export',
            'Type' => 'Link', //Remote
            'Action' => exportPage.getUrl()
        });

		toolsString = JSON.serialize(buttonList);
        toolsString = toolsString.substring(1,toolsString.length()-1);
		*/

		initPageSettings(objectName, record, buttonString, '', '');

		if ( fieldList.size() > 0  ) {
			for(String fieldName:fieldList) {
				fields.add(fieldName);
			}
			String query = String.format(
				'SELECT {0} FROM {1} WHERE Id = :recordId',
				new String[]{
					String.join(new List<String>(fields), ','),
					objectName
				}
			);
			record = Database.query(query);
			setRecord(record);
		}
	}

	public Boolean getShowActivate() {
		return !this.record.FieloELR__IsActive__c;
	}

	public Boolean getShowInActivate() {
		return this.record.FieloELR__IsActive__c;
	}

	@RemoteAction
  	public static RemoteActionResult save( Module__c record, List<String> nullFields) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
        	upsert record;
			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
			result.redirectURL = '/' + record.Id;
    	}catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
    	}catch(Exception e){
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
  	public static RemoteActionResult saveQuestion(SObject record, List<String> nullFields) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
        	upsert (Question__c) record;
			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
			result.redirectURL = '/' + record.Id;
    	}catch(DmlException e){
    		result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
    	}catch(Exception e){
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
  	public static RemoteActionResult saveModuleDependency(SObject record, List<String> nullFields) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
        	upsert (ModuleDependency__c) record;
			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
			result.redirectURL = '/' + ((ModuleDependency__c)record).Module__c;
    	}catch(DmlException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
    		result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
    	}catch(Exception e){
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
	public static sObject retrieve( String objectName, String recordId, String fields ){
		String query = 'SELECT ' + fields;
		query += ' FROM ' + objectName;
		query += ' WHERE ID = :recordId' ;
		query += ' LIMIT 1';
		List<sObject> result = Database.query(query);
		return result.get(0);
	}

	@RemoteAction
  	public static RemoteActionResult activate( Id recordId ){
		RemoteActionResult result = new RemoteActionResult();
		try{
			Module__c record = new Module__c ( Id = recordId, IsActive__c = true);
			update record;
			
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The Module has been activated') );

			result.redirectURL = '/' + recordId;

		} catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		} catch(Exception e) {
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		}
		return result;
	}

	@RemoteAction
  	public static RemoteActionResult inactivate( Id recordId ){
		RemoteActionResult result = new RemoteActionResult();
		try{
			Module__c record = new Module__c ( Id = recordId, IsActive__c = false);
			update record;
			
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The Module has been inactivated') );

			result.redirectURL = '/' + recordId;

		} catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		} catch(Exception e) {
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		}
		return result;
	}
}