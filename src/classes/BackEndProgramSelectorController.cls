public with sharing class BackEndProgramSelectorController {

    /// Propiedad Publica del Current Program
    public FieloPLT__Program__c program{
        get{
            if(program == null){
            program = ProgramService.getActiveProgram();
            }
            return program;
        }
        set;}

    public FieloPLT__Program__c getActiveProgram (){
        return ProgramService.getActiveProgram();
    }
    public BackEndProgramSelectorController (){
        program = ProgramService.getActiveProgram();
    }


    public static List<PicklistController.Entry> programs{ get {
        if ( programs == null ) {
            programs = new List<PicklistController.Entry>();
            for ( SelectOption s:ProgramService.getProgramsLandingSelectOptions() ) {
                programs.add( new PicklistController.Entry( s.getValue(), s.getLabel() )  ) ;
            }
        }
        System.debug(programs);
        return programs;
    } set; }

    public String programsViewId {
        get{
            ApexPages.StandardSetController menuSSC = new ApexPages.StandardSetController([SELECT Name FROM FieloPLT__Program__c LIMIT 1]);
            List<SelectOption> ListViews = menuSSC.getListViewOptions();
            for(SelectOption w : ListViews ){
               if(w.getLabel().contains('All')){
                   return w.getValue().left(15);
               }
            }
           return '000000000000000';
        }
    }


    @RemoteAction
    public static RemoteActionResult selectProgram(Id programId){
        RemoteActionResult result = new RemoteActionResult();
        try{
            if ( programId != ProgramService.getActiveProgram().Id ) {
                ProgramService.selectProgram(programId);
            }
            result.addMessage(new RemoteActionResult.RemoteActionMessage(ApexPages.Severity.CONFIRM , 'Success'));
        }catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        return result;
    }
}