public class CourseStatus extends SObjectDomain {
    public static Set<Id> processedIds = new Set<Id>();
    
    public static Boolean validateAdminFields = true;
    
    public CourseStatus(List<CourseStatus__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<CourseStatus__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }
            return new CourseStatus(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        for(CourseStatus__c cStatus : (List<CourseStatus__c>)records){
            cStatus.ApprovedModules__c = 0;
            cStatus.Key__c = String.valueOf(cStatus.Course__c).subString(0,15) + String.valueOf(cStatus.Member__c).subString(0,15);
        }
    }

    public override void onValidate() {
        // Validate that course predecessor has a course status progress at 100 per cent
        validatePredecessorAndSegments(records);    
        
        // The course status cannot be created if the subscription mode of the course is "Automatic"
        // Can be skipped if Admin       
        if(validateAdminFields) {
            validateCourseStatusSubscriptionMode(records);
        }      
    }

    public static void validateCourseStatusSubscriptionMode(List<CourseStatus__c> records){
        Set<Id> courseIds = new Set<Id>();
        Set<Id> courseAutomaticIds = new Set<Id>();
        for (CourseStatus__c courseStatus : records){
            courseIds.add(courseStatus.Course__c);
        }
        
        // List of courses with subscription field
        Map<Id,Course__c> coursesMap = new Map<Id,Course__c>(new CoursesSelector(new Set<String>{'Id, SubscriptionMode__c'}).selectByIdBeingAutomatic(courseIds));        
               
        // Adding errors if those courses are in a course status
        for (CourseStatus__c courseStatus : records){
            if (coursesMap.containsKey(courseStatus.Course__c)){
                courseStatus.addError(Label.ValidateCourseStatusErrorSubscriptionMode);
            }
        }
        
    }

    public static void validatePredecessorAndSegments(List<CourseStatus__c> records){
        // Courses to validate
        Set<Id> courseIds = new Set<Id>();
        Set<Id> memberIds = new Set<Id>();
        for (CourseStatus__c courseStatus : records){
            courseIds.add(courseStatus.Course__c);
            memberIds.add(courseStatus.Member__c);
        }

        // Receive members
        Map<Id,FieloPLT__Member__c> membersMap = 
                    new Map<Id,FieloPLT__Member__c>(new MembersSelector(new Set<String>{'Id','Name','FieloPLT__Program__c'}).selectById(memberIds));

        // Receive courses with predecessor
        Map<Id,Course__c> coursesMap = 
                    new Map<Id,Course__c>(new CoursesSelector(new Set<String>{'Id','Name','Program__c','Segment__c'}).selectByIdHavingPredecessor(courseIds));
        Set<String> keysPredecessors = new Set<String>();   

        List<CourseStatus__c> selectedRecords = new List<CourseStatus__c>();
        for (CourseStatus__c courseStatus : records){
            if(membersMap.get(courseStatus.Member__c).FieloPLT__Program__c != coursesMap.get(courseStatus.Course__c).Program__c) {
                courseStatus.addError(Label.MemberShouldBelongToCourseProgram);
            } else {
                selectedRecords.add(courseStatus);
            }
        }
        
        // Iterate over new Course Status
        Map<Id,Set<Id>> segmentsByMember = new Map<Id,Set<Id>>();
        for (CourseStatus__c courseStatus : selectedRecords){             
            Course__c course = coursesMap.get(courseStatus.Course__c);
            for(CourseDependency__c cd : course.PredecessorCourses__r){
               // Course ID of Predecessor +  Member ID of New Course Status
               String cskey = String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15);
               keysPredecessors.add(cskey);
            }

            if(course.Segment__c != null){
                if(segmentsByMember.containsKey(courseStatus.Member__c)){
                    segmentsByMember.get(courseStatus.Member__c).add(course.Segment__c);
                }else{
                    segmentsByMember.put(courseStatus.Member__c, new Set<Id>{course.Segment__c});
                }
            }
        }               
       
        //evaluate segments
        if(!segmentsByMember.isEmpty()){
            FieloPLT.SegmentService.verifySegments(segmentsByMember);
        }

        // Query to get all the course status of the predecessors 100 per cent
        List<CourseStatus__c> predecessorCourses = new CourseStatusSelector(new Set<String>{'Id,Progress__c,Key__c,Course__c'}).selectByKeyCompleted(keysPredecessors);
        Set<String> keysPredecessorsCompleted = new Set<String>();
        for(CourseStatus__c cs : predecessorCourses){
            keysPredecessorsCompleted.add(cs.Key__c);
        }
            
        //Adding errors
        Set<String> keysPredecessorsError = new Set<String>();
        for (CourseStatus__c courseStatus : selectedRecords){             
            Course__c course = coursesMap.get(courseStatus.Course__c);
            //validate segmentation
            if(course.Segment__c != null && segmentsByMember.containsKey(courseStatus.Member__c)){
                if(!segmentsByMember.get(courseStatus.Member__c).contains(course.Segment__c)){
                    courseStatus.addError(Label.MemberDoesntApplyToCourseSegment);
                }
            }

            //validate dependencies
            for(CourseDependency__c cd : course.PredecessorCourses__r){
                String cskey = String.valueOf(cd.Predecessor__c).subString(0,15) + String.valueOf(courseStatus.Member__c).subString(0,15);
                if(!keysPredecessorsCompleted.contains(cskey)){
                    courseStatus.addError(Label.ValidateCourseStatusErrorPredecessorIncomplete);
                    break;
                }
            }
        }        
    }
  
    public override void onValidate(Map<Id,SObject> existingRecords) {
        //before update
        if(validateAdminFields){
            for(CourseStatus__c courseStatus : (List<CourseStatus__c>)records){
                if(courseStatus.ApprovedModules__c != ((CourseStatus__c)(existingRecords.get(courseStatus.Id))).ApprovedModules__c) {
                    courseStatus.ApprovedModules__c = ((CourseStatus__c)(existingRecords.get(courseStatus.Id))).ApprovedModules__c;
                }
            }
        }        
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<CourseStatus__c> recordsToProcess = new List<CourseStatus__c>();
        
        Map<Id,CourseStatus__c> mapExistingRecordsToProcess = new Map<Id,CourseStatus__c>();

        for(CourseStatus__c record : (List<CourseStatus__c>)records){
            if(!processedIds.contains(record.Id)){
                recordsToProcess.add(record);
                mapExistingRecordsToProcess.put(record.Id,(CourseStatus__c)existingRecords.get(record.Id));
                processedIds.add(record.Id);
            }
        }
        if(!recordsToProcess.isEmpty()){
            FieloPLT.SObjectService.processRecords(recordsToProcess, mapExistingRecordsToProcess);
        }
    }
        
    public override void onBeforeDelete() {
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{ModuleResponse__c.SObjectType}, true);
        
        Map<Id,CourseStatus__c> courseStatusMap = new Map<Id, CourseStatus__c>((List<CourseStatus__c>)records);
        // When the course status is deleted, must delete related module responses
        deleteCourseStatusModuleResponses(courseStatusMap, uow);

        uow.commitWork();

        Map<Id,SObject> deletedModuleResponses = uow.m_deletedMapByType.get('FieloELR__ModuleResponse__c');
        for (Database.DeleteResult dr : uow.getResults(ModuleResponse__c.SObjectType).deleteResults) {
            if (!dr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    courseStatusMap.get(((ModuleResponse__c)deletedModuleResponses.get(dr.getId())).CourseStatus__c).addError(err.getMessage());
                }
            }
        }        
    }

    private void deleteCourseStatusModuleResponses(Map<Id,CourseStatus__c> courseStatusMap, SObjectUnitOfWork uow){
        // Looks up for course status IDs contained in module responses
        List<ModuleResponse__c> moduleResponsesToDelete = new ModuleResponsesSelector(new Set<String>{'Id','CourseStatus__c'}).selectByIdHavingCourseStatus(courseStatusMap.KeySet());  
  
        // Delete related modules
        uow.registerDeleted(moduleResponsesToDelete);
    }
}