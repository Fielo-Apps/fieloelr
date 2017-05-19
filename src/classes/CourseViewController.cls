public with sharing class CourseViewController extends PageSettingsController {
	public Course__c record {get;set;}
	public String buttonString {get;set;}
	// public String toolsString {get;set;}
	public static String secondaryParameters {get;set;}
	public List<Map<String,Object>> buttonList {get;set;}
	private ApexPages.StandardController controller;

	/**
    * @brief constructor
    */
	public CourseViewController(ApexPages.StandardController controller) {
		String objectName = 'FieloELR__Course__c';
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

        record = (FieloELR__Course__c)controller.getRecord();

		buttonList = new List<Map<String,Object>>();

		if( getshowActivate() ){
			buttonList.add(new Map<String,Object>{
                'Label' => 'Activate',
                'Type' => 'Remote',
                'Action' => 'FieloELR.CourseViewController.activate',
                'Confirm' => true
            });
		}
		if( getShowInactivate() ){
			buttonList.add(new Map<String,Object>{
                'Label' => 'Inactivate',
                'Type' => 'Remote',
                'Action' => 'FieloELR.CourseViewController.inactivate',
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

		editSettings.FieloPLT__Sections__c = getSectionsWithSegmentWhereCondition(editSettings.FieloPLT__Sections__c, record.Program__c);

		for(FieloPLT__PageSettings__c settings:relatedFormsSettings) {
			if(settings.FieloPLT__Object__c == 'FieloELR__CourseDependency__c') {
				settings.FieloPLT__Sections__c = getSectionsWithCourseWhereCondition(
					settings.FieloPLT__Sections__c,
					record.Program__c,
					record.Id
				);
			}
		}

		if ( fieldList.size() > 0  ) {
			for(String fieldName:fieldList) {
				fields.add(fieldName);
			}
			if (fields.contains('fieloelr__segment__c') || fields.contains('fieloelr__segment__r.name')) {
				secondaryParameters = 'FieloELR__Segment__c';
			}
			String query = String.format(
				'SELECT {0} FROM {1} WHERE Id = :recordId',
				new String[]{
					String.join(new List<String>(fields), ','),
					objectName
				}
			);
			System.debug('init query: '+query);
			record = Database.query(query);
			setRecord(record);
		}
	}

	public Boolean getShowActivate() {
		return this.record.FieloELR__Status__c == 'Draft' ||
			this.record.FieloELR__Status__c == 'Inactive';
	}

	public Boolean getShowInActivate() {
		return this.record.FieloELR__Status__c == 'Active';
	}

	@RemoteAction
	public static sObject retrieve( String objectName, String recordId, String fields ){
		String query = 'SELECT FieloELR__Segment__r.FieloPLT__RelatedSegments__c,' + fields;
		query += ' FROM ' + objectName;
		query += ' WHERE ID = :recordId' ;
		query += ' LIMIT 1';
		System.debug('retrieve query: '+query);
		List<sObject> result = Database.query(query);
		return result.get(0);
	}

	public static RemoteActionResult save( Course__c record, List<String> nullFields) {
		return save(record, nullFields, new List<String>());
	}

	@RemoteAction
  	public static RemoteActionResult save( Course__c record, List<String> nullFields, List<String> segments) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			if ( segments.size() == 1 ) {
				record.segment__c = segments.get(0);
        	} else if ( segments.size() > 1 ) {
				record.segment__c = SegmentService.getMetaSegmentId( segments, record.Program__c ) ;
			} else {
				record.segment__c = null;
        	}
        	upsert record;
			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
			result.redirectURL = '/' + record.Id;
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
  	public static RemoteActionResult saveModule( SObject record, List<String> nullFields) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			// TODO: Change to Create API
        	upsert (Module__c) record;

			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
			result.redirectURL = '/' + record.Id;
    	}catch(DMLException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }catch(Exception e){
    		system.debug('Exception: ' + e);
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
  	public static RemoteActionResult saveCourseDependency( SObject record, List<String> nullFields) {
		Savepoint sp;
		RemoteActionResult result = new RemoteActionResult();
		try{
			sp = Database.setSavepoint();
			for ( String f :nullFields ) {
         		record.put(f, null );
			}
			// TODO: Change to Create API
        	upsert (CourseDependency__c) record;

			//TODO Crear Label DataSavedSuccessfully
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
			result.redirectURL = '/' + ((CourseDependency__c)record).Course__c;
    	}catch(DMLException e){
    		if(sp != null){
	            Database.rollback(sp);
        	}
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }catch(Exception e){
    		system.debug('Exception: ' + e);
        	if(sp != null){
	            Database.rollback(sp);
        	}
        	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    	}
    	return result;
  	}

  	@RemoteAction
    public static List<SObject> getSegments( String programId ) {
        return new SegmentsSelector(new Set<String>{'Id','Name'}).selectByProgramAndWithoutProgramWithCriteria(programId, new Set<String>{'Id','Name'});
    }

    public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}
    }

    public class FormField {
        public String Type{get;set;}
        public String Name{get;set;}
        public String onchange{get;set;}
        public String Label{get;set;}
        public String Value{get;set;}
        public String WhereCondition{get;set;}
    }

    public static String getSectionsWithSegmentWhereCondition(String sectionsString, String programId){
        List<Section> sections = (List<Section>) JSON.deserialize( sectionsString, List<CourseViewController.Section>.class );
        for ( Section s :sections ) {
          for ( List<FormField> r :s.rows ) {
            for ( FormField f :r ) {
              if(f.Name != null) {
                if(f.Name == 'FieloELR__Segment__c') {
                    f.WhereCondition = ' FieloPLT__Program__c IN ( //, /' + programId + '/ ) AND RecordType.Name <> /Metasegment/ ';
                    secondaryParameters = 'FieloELR__Segment__c';
                }
              }
            }
          }
        }
        return JSON.serialize(sections);
    }

    public static String getSectionsWithCourseWhereCondition(String sectionsString, String programId, String courseId){
	    Section section = (Section) JSON.deserialize( sectionsString, CourseViewController.Section.class );
		for ( List<FormField> r :section.rows ) {
			for ( FormField f :r ) {
		  		if(f.Name != null) {
		    		if(f.Name == 'FieloELR__Predecessor__c') {
		        		f.WhereCondition = ' FieloELR__Program__c = /' + programId + '/ AND Id != /' + courseId + '/';
		    		}
		  		}
			}
		}
        return JSON.serialize(section);
    }

    @RemoteAction
  	public static RemoteActionResult activate( Id recordId ){
		RemoteActionResult result = new RemoteActionResult();
		try{
			Course__c record = new Course__c ( Id = recordId, Status__c = 'Active');
			update record;
			
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The Course has been activated') );

			result.redirectURL = '/' + recordId;

		} catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
		} catch(Exception e) {
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		}
		return result;
	}

	@RemoteAction
  	public static RemoteActionResult inactivate( Id recordId ){
		RemoteActionResult result = new RemoteActionResult();
		try{
			Course__c record = new Course__c ( Id = recordId, Status__c = 'Inactive');
			update record;
			
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The Course has been inactivated') );

			result.redirectURL = '/' + recordId;

		} catch(DmlException e){
			result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
		} catch(Exception e) {
			result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
		}
		return result;
	}
}