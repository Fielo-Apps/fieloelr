/**
* @description Class to Control the Incentives Landing Page.
*/
public with sharing class ELearningLandingController extends PageSettingsSetController {

	public String currentView {get;set;}
    public FieloPLT__PageSettings__c newCourse {get;set;}
    public FieloPLT__PageSettings__c landingCourse {get;set;}
    public static String secondaryParameters {get;set;}
    public static String saveController {get;set;}

    public FieloPLT__Program__c currentProgram { get {
        if ( currentProgram == null) {
            currentProgram = ProgramService.getActiveProgram();
        }
        return currentProgram;
    }set;}

	public ELearningLandingController() {
		if( currentProgram != null ){
            String standardTools  = '';
            String standardButtons = '';

            PageReference exportPage = Page.FieloPLT__XMLExport;
            exportPage.getParameters().put( 'retURL', System.currentPageReference().getUrl() );
            exportPage.getParameters().put( 'type', 'elearning' );
            PageReference importPage = Page.FieloPLT__XMLImport;
            importPage.getParameters().put( 'retURL', System.currentPageReference().getUrl() );
            importPage.getParameters().put( 'type', 'elearning' );

            standardTools = '{"Label": "Export", "Type": "Link", "Action": "' + exportPage.getUrl() + '" }';
            standardTools += ',{"Label": "Import", "Type": "Link", "Action": "' + importPage.getUrl() + '" }';

            initPageSettings( 'FieloELR__Course__c', standardButtons, standardTools, 'utility-sprite/svg/symbols.svg#people' );
            newCourse = newSettings.clone();
            landingCourse = landingSettings;

            newCourse.FieloPLT__Sections__c = getSectionsWithSegmentWhereCondition(newCourse.FieloPLT__Sections__c);

            if ( Apexpages.currentPage().getParameters().containsKey('view') ) {
                currentView = Apexpages.currentPage().getParameters().get('view');
            } else {
                currentView = 'Draft';
            }
        }
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

    public static String getSectionsWithSegmentWhereCondition(String sectionsString){
        
        saveController = 'ELearningLandingController.createCourseWithoutSegments';

        List<Section> sections = (List<Section>) JSON.deserialize( sectionsString, List<ELearningLandingController.Section>.class );
        for ( Section s :sections ) {
          for ( List<FormField> r :s.rows ) {
            for ( FormField f :r ) {
              if(f.Name != null) {
                if(f.Name == 'FieloELR__Segment__c') {
                    f.WhereCondition = ' FieloPLT__Program__c IN ( //, /' + ProgramService.getActiveProgram().Id + '/ ) AND RecordType.Name <> /Metasegment/ ';
                    secondaryParameters = 'FieloELR__Segment__c';
                    saveController = 'ELearningLandingController.createCourseWithSegments';
                }
              }
            }
          }
        }
        return JSON.serialize(sections);
    }

    public static List<SelectOption> getStatusViews(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Draft', 'Draft'));
        options.add(new SelectOption('Active', 'Active'));
        options.add(new SelectOption('Inactive', 'Inactive'));
        return options;
    }

    private static Set<String> getViewStatus(String currentView) {
        return new Set<String> {currentView};
    }

    @RemoteAction
    public static List<SObject> getCourses( String objectName, String fields, Integer offset, String orderBy, String filter, Integer recordsPerPage ) {
        Set<String> fieldset = new Set<String> { 'Name', 'SubscriptionMode__c', 'Status__c', 'Program__r.Name' };
        Map<String,Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped( filter);
        Id programId = (String)jsonObject.get('Program__c');
        String currentView =  (String)jsonObject.get('viewName');
        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }

        return CourseService.getCourses( fieldset, getViewStatus(currentView), programId, recordsPerPage,  offset, orderBy);
    }

    /*
        Create Courses Method with 3 parameters
        in the case that segments are not used.
    */
    @RemoteAction
    public static RemoteActionResult createCourseWithoutSegments(sObject objectRecord, List<String> nullFields) {
        return createCourseWithSegments(objectRecord,nullFields,new List<String>());
    }

    /*
        Create Courses Method
    */
    @RemoteAction
    public static RemoteActionResult createCourseWithSegments(sObject objectRecord, List<String> nullFields, List<String> segments) {
        Savepoint sp;
        RemoteActionResult result = new RemoteActionResult();

        try{
            Course__c record = (Course__c) objectRecord;
            sp = Database.setSavepoint();
            // nullFields is not used becouse its an insert
            // Si tiene mas de un Segmento pasa por Metasegments

            if ( segments.size() == 1 ) {
                record.segment__c = segments.get(0);
            } else if ( segments.size() > 1 ) {
                record.segment__c = SegmentService.getMetaSegmentId( segments, record.Program__c ) ;
            } else {
              record.segment__c = null;
            }
            //TODO Change to ELR Create API

            insert record;
            
            //TODO Crear Label DataSavedSuccessfully
            if ( record.Id != null ) {
                result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Course was created successfully') );
                result.redirectURL = '/' + record.Id;
            }
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
    public static List<SObject> getSegments( String programId ) {
        return new SegmentsSelector(new Set<String>{'Id','Name'}).selectByProgramAndWithoutProgramWithCriteria(programId, new Set<String>{'Id','Name'});
    }
}