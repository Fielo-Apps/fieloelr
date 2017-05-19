public class ModuleResponses extends SObjectDomain {
    public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;

    public ModuleResponses(List<ModuleResponse__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<ModuleResponse__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new ModuleResponses(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        Set<String> mrKeys = new Set<String>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            moduleResponse.IsSubmitted__c = false;
            moduleResponse.IsApproved__c = false;
            moduleResponse.Key__c = String.valueOf(moduleResponse.Module__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
            mrKeys.add(moduleResponse.Key__c);
        }

        List<AggregateResult> aggResult = [SELECT MAX(NumberOfAttempt__c) attemptNumber, Key__c FROM ModuleResponse__c WHERE Key__c in : mrKeys GROUP BY Key__c];
        Map<String,Integer> maxNumbByKey = new Map<String,Integer>();
        for(AggregateResult mr : aggResult){
            maxNumbByKey.put((String)mr.get('Key__c'), (Integer)mr.get('attemptNumber'));
        }
        
        for(ModuleResponse__c moduleResp : (List<ModuleResponse__c>)records){
            if(maxNumbByKey.containsKey(moduleResp.Key__c)){
                Integer maxAttempt = maxNumbByKey.get(moduleResp.Key__c);
                moduleResp.NumberOfAttempt__c = ++maxAttempt;
                maxNumbByKey.put(moduleResp.Key__c, maxAttempt);
            }else{
                moduleResp.NumberOfAttempt__c = 1;
                maxNumbByKey.put(moduleResp.Key__c, 1);
            }
        }
    }

    public override void onValidate(){
        //store module Ids
        Set<Id> moduleIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            moduleIds.add(moduleResponse.Module__c);                
        }

        //Creates a set to know wich are the required modules to be approved for each of the related members
        Map<Id,Module__c> modulesMap = new Map<Id,Module__c>(new ModulesSelector(new Set<String>{'Id','Course__c','Course__r.SubscriptionMode__c'}).selectByIdHavingDependencies(moduleIds));
        Set<String> mrKeysRequired = new Set<String>();
        Set<String> csKeysRequired = new Set<String>();
        Set<Id> modulesProcessedIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            if(!modulesProcessedIds.contains(moduleResponse.Module__c)){
                for(ModuleDependency__c md : modulesMap.get(moduleResponse.Module__c).PredecessorModules__r){
                    mrKeysRequired.add(String.valueOf(md.Predecessor__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15));
                }
                modulesProcessedIds.add(moduleResponse.Module__c);
            }

            //checks manual courses to verify if the status was already created
            if(modulesMap.get(moduleResponse.Module__c).Course__r.SubscriptionMode__c == 'Manual'){
                csKeysRequired.add(String.valueOf(modulesMap.get(moduleResponse.Module__c).Course__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15));
            }
        }

        //query in the database only the moduleResponses that were approved for the related members
        List<ModuleResponse__c> predecessorModuleResponses = new ModuleResponsesSelector(new Set<String>{'Key__c'}).selectByKeyAndApproved(mrKeysRequired);
        Set<String> approvedMRKeys = new Set<String>();
        for(ModuleResponse__c mr : predecessorModuleResponses){
            approvedMRKeys.add(mr.Key__c);
        }

        //query in the database only the courseStatus that exist for the related members
        List<CourseStatus__c> manualCourseStatus = new CourseStatusSelector(new Set<String>{'Key__c'}).selectByKey(csKeysRequired);
        Set<String> existingCSKeys = new Set<String>();
        for(CourseStatus__c cs : manualCourseStatus){
            existingCSKeys.add(cs.Key__c);
        }

        //verifies for each module response if the related modules where approved for the member
        Set<String> mrKeysWithError = new Set<String>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            String cskey = String.valueOf(modulesMap.get(moduleResponse.Module__c).Course__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
            if(!existingCSKeys.contains(cskey)){
                moduleResponse.addError('The member is not registered in the related course.');
            }

            if(mrKeysWithError.contains(moduleResponse.Key__c)){
                moduleResponse.addError('The member didn\'t approve the dependent Modules');
                continue;
            }
            
            for(ModuleDependency__c md : modulesMap.get(moduleResponse.Module__c).PredecessorModules__r){
                String dependentKey = String.valueOf(md.Predecessor__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
                if(!approvedMRKeys.contains(dependentKey)){
                    moduleResponse.addError('The member didn\'t approve the dependent Modules');
                    mrKeysWithError.add(moduleResponse.Key__c);
                    break;
                }
            }            
        }
    }

    public override void onValidate(Map<Id,SObject> existingRecords){
        if(validateAdminFields){
            for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
                if(((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).IsSubmitted__c){
                    moduleResponse.addError('Cannot modify a moduleResponse that was already submitted.');
                }
                if(moduleResponse.IsApproved__c != ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).IsApproved__c){
                    moduleResponse.IsApproved__c = ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).IsApproved__c;
                }
                if(moduleResponse.GradeValue__c != ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).GradeValue__c){
                    moduleResponse.GradeValue__c = ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).GradeValue__c;
                }
                if(moduleResponse.GradePercent__c != ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).GradePercent__c){
                    moduleResponse.GradePercent__c = ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).GradePercent__c;
                }
                if(moduleResponse.Key__c != ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).Key__c){
                    moduleResponse.Key__c = ((ModuleResponse__c)existingRecords.get(moduleResponse.Id)).Key__c;
                }
            }
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        List<ModuleResponse__c> submittedRecords = new List<ModuleResponse__c>();

        for(ModuleResponse__c moduleResp: (List<ModuleResponse__c>)records){
            //Add only submitted records.
            if( moduleResp.IsSubmitted__c ){
                if( !((ModuleResponse__c)existingRecords.get(moduleResp.Id)).IsSubmitted__c){
                    submittedRecords.add(moduleResp);
                }
            }
        }

        if(!submittedRecords.isEmpty()){
            setGradeAndApprovalFlag(submittedRecords);
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<ModuleResponse__c> recordsToProcess = new List<ModuleResponse__c>();
        List<ModuleResponse__c> approvedRecords = new List<ModuleResponse__c>();
        Map<Id,ModuleResponse__c> mapExistingRecordsToProcess = new Map<Id,ModuleResponse__c>();

        for(ModuleResponse__c record : (List<ModuleResponse__c>)records){
            if(!processedIds.contains(record.Id)){
                recordsToProcess.add(record);
                mapExistingRecordsToProcess.put(record.Id,(ModuleResponse__c)existingRecords.get(record.Id));                
                processedIds.add(record.Id);

                if(record.IsApproved__c && !((ModuleResponse__c)existingRecords.get(record.Id)).IsApproved__c){
                    approvedRecords.add(record);
                }
            }
        }
        if(!recordsToProcess.isEmpty()){
            FieloPLT.SObjectService.processRecords(recordsToProcess, mapExistingRecordsToProcess);
        }
        if(!approvedRecords.isEmpty()){
            calculateCourseStatusProgress(approvedRecords, true);
        }
    }

    public override void onBeforeDelete(){
        List<ModuleResponse__c> approvedRecords = new List<ModuleResponse__c>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            if(moduleResponse.IsApproved__c){
                approvedRecords.add(moduleResponse);
            }
        }

        calculateCourseStatusProgress(approvedRecords, false);
    }

    public static void setGradeAndApprovalFlag(List<ModuleResponse__c> records) {
        Set<Id> moduleResponseIds = new Map<Id,ModuleResponse__c>(records).keySet();
        Set<Id> moduleIds = new Set<Id>();
        for(ModuleResponse__c moduleResponse: records) {
            moduleIds.add(moduleResponse.Module__c);
        }
        Map<Id,ModuleResponse__c> existingModuleResponseMap = new Map<Id,ModuleResponse__c>(new ModuleResponsesSelector().selectByIdWithQuestionResponses(moduleResponseIds));
        Map<Id,Module__c> modulesMap = new Map<Id,Module__c>(new ModulesSelector(new Set<String>{'Course__c','TotalValue__c','ApprovalGrade__c'}).selectByIdWithQuestions(moduleIds));
        Map<Id,Question__c> questionMap;

        List<QuestionResponse__c> unsubmitedQuestionResponses = new List<QuestionResponse__c>();
        // Checking for unsubmitted questions
        for (ModuleResponse__c moduleResponse: existingModuleResponseMap.values()) {
            for (QuestionResponse__c questionResponse: moduleResponse.QuestionResponses__r) {
                if ( !questionResponse.IsSubmitted__c ) {
                    unsubmitedQuestionResponses.add(questionResponse);
                }
            }
        }

        if (!unsubmitedQuestionResponses.isEmpty()) {
            QuestionResponses.disableSubmit = true;
            QuestionResponses.setIsCorrect(unsubmitedQuestionResponses);

            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{QuestionResponse__c.SObjectType});
            for(QuestionResponse__c questionResponse : unsubmitedQuestionResponses){
                questionResponse.IsSubmitted__c = true;
                uow.registerDirty(questionResponse);
            }
            uow.commitWork();
            QuestionResponses.disableSubmit = false;
        }

        Set<String> mrKeys = new Set<String>();
        List<ModuleResponse__c> approvedResponses = new List<ModuleResponse__c>();
        for (ModuleResponse__c moduleResponse: (List<ModuleResponse__c>)records) {
            moduleResponse.GradeValue__c = 0.0;
            questionMap = new Map<Id,Question__c>(modulesMap.get(moduleResponse.Module__c).Questions__r);

            for (QuestionResponse__c questionResponse: existingModuleResponseMap.get(moduleResponse.Id).QuestionResponses__r) {
                moduleResponse.GradeValue__c += questionResponse.PartialGradevalue__c;
            }
            moduleResponse.GradePercent__c = (moduleResponse.GradeValue__c / modulesMap.get(moduleResponse.Module__c).TotalValue__c) * 100;
            moduleResponse.IsApproved__c = moduleResponse.GradePercent__c >= modulesMap.get(moduleResponse.Module__c).ApprovalGrade__c;

            if(moduleResponse.IsApproved__c){
                mrKeys.add(moduleResponse.Key__c);
                approvedResponses.add(moduleResponse);
            }
        }

        if(!mrKeys.isEmpty()){
            List<AggregateResult> aggResult = [SELECT MAX(NumberOfApprove__c) approveNumber, Key__c FROM ModuleResponse__c WHERE Key__c in : mrKeys GROUP BY Key__c];
            Map<String,Integer> maxAppByKey = new Map<String,Integer>();
            for(AggregateResult mr : aggResult){
                maxAppByKey.put((String)mr.get('Key__c'), (Integer)mr.get('approveNumber'));
            }

            for(ModuleResponse__c moduleResponse : approvedResponses){
                if(maxAppByKey.containsKey(moduleResponse.Key__c)){
                    Integer maxApprove = maxAppByKey.get(moduleResponse.Key__c);
                    moduleResponse.NumberOfApprove__c = ++maxApprove;
                    maxAppByKey.put(moduleResponse.Key__c, maxApprove);
                }else{
                    moduleResponse.NumberOfApprove__c = 1;
                    maxAppByKey.put(moduleResponse.Key__c, 1);
                }
            }
        }
    }

    private static void calculateCourseStatusProgress(List<ModuleResponse__c> records, Boolean isUpdate) {
        //store module Ids and mr keys
        Set<Id> moduleIds = new Set<Id>();
        Set<String> mrKeys = new Set<String>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            moduleIds.add(moduleResponse.Module__c);                
            mrKeys.add(moduleResponse.Key__c);
        }

        //Creates a set to know wich are the required modules to be approved for each of the related members
        Map<Id,Module__c> modulesMap = new Map<Id,Module__c>(new ModulesSelector(new Set<String>{'Id','Course__c','Course__r.SubscriptionMode__c'}).selectById(moduleIds));

        //look for already approved modules
        ModuleResponsesSelector mrSelector = new ModuleResponsesSelector(new Set<String>{'Id','Key__c'});
        List<ModuleResponse__c> approvedModuleResponses = isUpdate ? mrSelector.selectByKeyAndApproved(mrKeys, new Map<Id,ModuleResponse__c>(records).keySet()) : mrSelector.selectByKeyAndApproved(mrKeys, null);
        Set<String> approvedMRKeys = new Set<String>();
        for(ModuleResponse__c mr : approvedModuleResponses){
            approvedMRKeys.add(mr.Key__c);
        }
        
        //store course status keys
        Set<String> csKeys = new Set<String>();
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            csKeys.add(String.valueOf(modulesMap.get(moduleResponse.Module__c).Course__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15));
        }

        //look for existing course status
        Map<String,CourseStatus__c> csMap = new Map<String,CourseStatus__c>();
        for(CourseStatus__c cs : new CourseStatusSelector(new Set<String>{'Key__c','ApprovedModules__c'}).selectByKey(csKeys)){
            csMap.put(cs.Key__c, cs);
        }

        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{CourseStatus__c.SObjectType});
        for(ModuleResponse__c moduleResponse : (List<ModuleResponse__c>)records){
            //verifies if the module was not approved previously
            if(approvedMRKeys.contains(moduleResponse.Key__c)){
                continue;
            }else{
                approvedMRKeys.add(moduleResponse.Key__c);
            }

            //looks for the course status where needs to update the progress
            CourseStatus__c cs;
            Module__c module = modulesMap.get(moduleResponse.Module__c);
            String csKey = String.valueOf(modulesMap.get(moduleResponse.Module__c).Course__c).subString(0,15) + String.valueOf(moduleResponse.Member__c).subString(0,15);
            
            if(isUpdate){
                if(module.Course__r.SubscriptionMode__c == 'Manual'){
                    if(csMap.containsKey(csKey)){
                        cs = csMap.get(csKey);
                        if(cs.Id != null){
                            uow.registerDirty(cs);
                        }
                    }
                }else{
                    if(csMap.containsKey(csKey)){
                        cs = csMap.get(csKey);
                        if(cs.Id != null){
                            uow.registerDirty(cs);
                        }
                    }else{
                        cs = new CourseStatus__c(Course__c = module.Course__c, ApprovedModules__c = 0, Member__c = moduleResponse.Member__c);
                        csMap.put(csKey, cs);
                        uow.registerNew(cs);
                    }
                }
                
                cs.ApprovedModules__c++;
            }else{
                if(csMap.containsKey(csKey)){
                    cs = csMap.get(csKey);
                    cs.ApprovedModules__c--;
                    uow.registerDirty(cs);
                }
            }
        }

        //CourseStatus.validateAdminFields = false;
        uow.commitWork();
    }
}