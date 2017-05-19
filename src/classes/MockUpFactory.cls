@isTest
public class MockUpFactory {

    private static Map<String, Id> rtMember;

    public static Account createFieloAccount(Id ownerId){
        //creates an account with a specific owner
        Account a = new Account(name = 'Fielo', OwnerId = ownerId);
        insert a;
        return a;
    }

    public static List<FieloPLT__Program__c> createPrograms(String basename, Integer count) {
        List<FieloPLT__Program__c> results = new List<FieloPLT__Program__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Program__c p = new FieloPLT__Program__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__OnlineTransactionProcessing__c = true;
            results.add(p);
        }
        return results;
    }

    //Created for FieloPRP
    public static List<FieloPLT__Member__c> createMembers(String programId, Integer count){
        List<FieloPLT__Member__c> membersToCreate = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            membersToCreate.add(new FieloPLT__Member__c(
                    Name='Member '+String.valueOf(x),
                    FieloPLT__Email__c='email'+String.valueOf(x)+'l@example.com',
                    FieloPLT__Type__c='Individual Account',
                    FieloPLT__Program__c=programId
                )
            );
        }
        return membersToCreate;
    }

    public static List<FieloELR__Course__c> createCourses(String programId, String segmentId, Integer count){
        List<FieloELR__Course__c> coursesToCreate = new List<FieloELR__Course__c>();
        for(Integer x = 0; x < count; x++){
            coursesToCreate.add(new FieloELR__Course__c(
            		Name = 'Course ' + x,
                    FieloELR__Program__c = programId,
                    FieloELR__Description__c = 'Description',
                    FieloELR__SubscriptionMode__c = 'Manual',
                    FieloELR__Segment__c = segmentId
                )
            );
        }
        return coursesToCreate;
    }

    public static List<FieloPLT__Promotion__c> createPromotions(String basename, Integer count, Id programId){
        List<FieloPLT__Promotion__c> results = new List<FieloPLT__Promotion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Promotion__c p = new FieloPLT__Promotion__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__Program__c = programId;
            results.add(p);
        }
        return results;
    }

    public static List<FieloPLT__Rule__c> createRules(String basename, Integer count, Id promotionId){
        List<FieloPLT__Rule__c> results = new List<FieloPLT__Rule__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Rule__c r = new FieloPLT__Rule__c();
            r.Name = basename + String.valueOf(x);
            r.FieloPLT__Promotion__c = promotionId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Rule__c> createRules(String basename, Integer count, Id promotionId, Id pointTypeId){
        List<FieloPLT__Rule__c> results = new List<FieloPLT__Rule__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Rule__c r = new FieloPLT__Rule__c();
            r.Name = basename + String.valueOf(x);
            r.FieloPLT__Promotion__c = promotionId;
            r.FieloPLT__PointType__c = pointTypeId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Rule__c> createRules(String basename, Integer count, Id promotionId, Id pointTypeId, Id actionId){
        List<FieloPLT__Rule__c> results = new List<FieloPLT__Rule__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Rule__c r = new FieloPLT__Rule__c();
            r.Name = basename + String.valueOf(x);
            r.FieloPLT__Promotion__c = promotionId;
            r.FieloPLT__PointType__c = pointTypeId;
            r.FieloPLT__Action__c = actionId;
            results.add(r);
        }
        return results;
    }

    public static FieloPLT__RuleTrigger__c createRuleTrigger(String name, String objectName, String conditionField, String conditionValue, String dateField, String lookUpFromTransaction, String lookUpFromTracker){
        FieloPLT__RuleTrigger__c rt = new FieloPLT__RuleTrigger__c();
        rt.Name = name;
        rt.FieloPLT__Object__c = objectName;
        rt.FieloPLT__ConditionField__c = conditionField;
        rt.FieloPLT__ConditionValue__c = conditionValue;
        rt.FieloPLT__Date__c = dateField;
        rt.FieloPLT__LookupFromTransaction__c = lookUpFromTransaction;
        rt.FieloPLT__LookupFromTracker__c = lookUpFromTracker;
        rt.FieloPLT__Prefix__c = Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix();
        return rt;
    }

    public static FieloPLT__Action__c createAction(String targetMember, Id ruleTriggerId){
        return new FieloPLT__Action__c(FieloPLT__TargetMember__c = targetMember, FieloPLT__RuleTrigger__c = ruleTriggerId, FieloPLT__DeveloperName__c = targetMember+String.valueOf(ruleTriggerId));
    }

    public static List<FieloPLT__Criterion__c> createMissionCriteria(Id missionId, Integer count){
        List<FieloPLT__Criterion__c> results = new List<FieloPLT__Criterion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Criterion__c r = new FieloPLT__Criterion__c();
            r.FieloPLT__Mission__c = missionId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__RewardItem__c> createRewardItems(Integer count, Id rewardId){
        List<FieloPLT__RewardItem__c> results = new List<FieloPLT__RewardItem__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__RewardItem__c r = new FieloPLT__RewardItem__c();
            r.FieloPLT__Code__c = String.valueOf(x);
            r.FieloPLT__Reward__c = rewardId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Criterion__c> createRulesCriteria(Id ruleId, Integer count){
        List<FieloPLT__Criterion__c> results = new List<FieloPLT__Criterion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Criterion__c r = new FieloPLT__Criterion__c();
            r.FieloPLT__Rule__c = ruleId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__CriterionGroup__c> createRulesCriteriaGroup(Id ruleId, Integer count){
        List<FieloPLT__CriterionGroup__c> results = new List<FieloPLT__CriterionGroup__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__CriterionGroup__c r = new FieloPLT__CriterionGroup__c();
            r.FieloPLT__Rule__c = ruleId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Criterion__c> createCriteria(Id cGroupId, Integer count){
        List<FieloPLT__Criterion__c> results = new List<FieloPLT__Criterion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Criterion__c r = new FieloPLT__Criterion__c();
            r.FieloPLT__CriterionGroup__c = cGroupId;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Member__c> createIndividualAccounts(String basename, Integer count, Id programId){
        List<FieloPLT__Member__c> results = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Member__c m = new FieloPLT__Member__c();
            m.Name = basename + String.valueOf(x);
            m.FieloPLT__Email__c = m.Name.deleteWhitespace() + Datetime.now().getTime() + '@fielo.com';//se agrega el datetime para que si se crean más de 200 registros los mails sean distintos
            m.FieloPLT__Program__c = programId;
            m.FieloPLT__Type__c = 'Individual Account';
            results.add(m);
        }
        return results;
    }

    public static List<FieloPLT__Member__c> createContributorAccounts(String basename, Integer count, Id orgAccountId){
        List<FieloPLT__Member__c> results = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Member__c m = new FieloPLT__Member__c();
            m.Name = basename + String.valueOf(x);
            m.FieloPLT__Email__c = m.Name.deleteWhitespace() + Datetime.now().getTime() + '@fielo.com';//se agrega el datetime para que si se crean más de 200 registros los mails sean distintos
            m.FieloPLT__OrganizationAccount__c = orgAccountId;
            m.FieloPLT__Type__c = 'Organization Contributor';
            results.add(m);
        }
        return results;
    }

    public static FieloPLT__Member__c createOrganizationAccount(String name, Id programId, Id accountId){
        FieloPLT__Member__c orgAccount = new FieloPLT__Member__c();
        orgAccount.Name = name;
        orgAccount.FieloPLT__Account__c = accountId;
        orgAccount.FieloPLT__Program__c = programId;
        orgAccount.FieloPLT__Type__c = 'Organization Account';
        return orgAccount;
    }

    public static List<FieloPLT__Transaction__c> createTransactions(Integer count, Id memberId, Integer points){
        List<FieloPLT__Transaction__c> results = new List<FieloPLT__Transaction__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Transaction__c t = new FieloPLT__Transaction__c();
            t.FieloPLT__Member__c = memberId;
            t.FieloPLT__Value__c = points;
            t.FieloPLT__Points__c = points;
            t.FieloPLT__SkipEngine__c = false;
            results.add(t);
        }
        return results;
    }

    public static List<FieloPLT__Reward__c> createRewards(String basename, Integer count, Id programId, Integer points){
        List<FieloPLT__Reward__c> results = new List<FieloPLT__Reward__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Reward__c r = new FieloPLT__Reward__c();
            r.Name = basename + String.valueOf(x);
            r.FieloPLT__Program__c = programId;
            r.FieloPLT__Points__c = points;
            r.FieloPLT__Stock__c = count;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Reward__c> createRewards(String basename, Integer count, Integer points){
        List<FieloPLT__Reward__c> results = new List<FieloPLT__Reward__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Reward__c r = new FieloPLT__Reward__c();
            r.Name = basename + String.valueOf(x);
            r.FieloPLT__Points__c = points;
            r.FieloPLT__Stock__c = count;
            results.add(r);
        }
        return results;
    }

    public static List<FieloPLT__Agreement__c> createAgreements(Integer count, Id programId){
        RecordType draftRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Draft'];
        List<FieloPLT__Agreement__c> results = new List<FieloPLT__Agreement__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Agreement__c a = new FieloPLT__Agreement__c();
            a.RecordTypeId = draftRecordType.Id;
            a.FieloPLT__Program__c = programId;
            results.add(a);
        }
        return results;
    }

    public static List<FieloPLT__Badge__c> createBadges(Integer count, Id programId){
        List<FieloPLT__Badge__c> results = new List<FieloPLT__Badge__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Badge__c a = new FieloPLT__Badge__c();
            a.FieloPLT__Program__c = programId;
            results.add(a);
        }
        return results;
    }

    public static List<FieloPLT__Level__c> createLevels(String basename, Integer count, Id programId){
        List<FieloPLT__Level__c> results = new List<FieloPLT__Level__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Level__c l = new FieloPLT__Level__c();
            l.Name = basename + String.valueOf(x);
            l.FieloPLT__Program__c = programId;
            results.add(l);
        }
        return results;
    }

    public static List<FieloPLT__Criterion__c> createLevelCriteria(Id levelId, Integer count){
        List<FieloPLT__Criterion__c> results = new List<FieloPLT__Criterion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Criterion__c lc = new FieloPLT__Criterion__c();
            lc.FieloPLT__Level__c = levelId;
            results.add(lc);
        }
        return results;
    }

    public static List<FieloPLT__CriterionGroup__c> createLevelCriteriaGroup(Id levelId, Integer count){
        List<FieloPLT__CriterionGroup__c> results = new List<FieloPLT__CriterionGroup__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__CriterionGroup__c lc = new FieloPLT__CriterionGroup__c();
            lc.FieloPLT__Level__c = levelId;
            results.add(lc);
        }
        return results;
    }

    public static List<FieloPLT__Segment__c> createSegments(String basename, Integer count, String type){
        List<FieloPLT__Segment__c> results = new List<FieloPLT__Segment__c>();
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName =: type].Id;
        for(Integer x = 0; x < count; x++){
            FieloPLT__Segment__c s = new FieloPLT__Segment__c();
            s.Name = basename + String.valueOf(x);
            s.RecordTypeId = rtId;
            results.add(s);
        }
        return results;
    }

    public static List<FieloPLT__Criterion__c> createSegmentsCriteria(Id segmentId, Integer count){
        List<FieloPLT__Criterion__c> results = new List<FieloPLT__Criterion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Criterion__c sc = new FieloPLT__Criterion__c();
            sc.FieloPLT__Segment__c = segmentId;
            results.add(sc);
        }
        return results;
    }

    public static List<FieloPLT__CriterionGroup__c> createSegmentCriteriaGroup(Id segmentId, Integer count){
        List<FieloPLT__CriterionGroup__c> results = new List<FieloPLT__CriterionGroup__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__CriterionGroup__c sc = new FieloPLT__CriterionGroup__c();
            sc.FieloPLT__Segment__c = segmentId;
            results.add(sc);
        }
        return results;
    }

    public static List<FieloPLT__Challenge__c> createChallenges(String basename, Integer count, Id programId){
        List<FieloPLT__Challenge__c> results = new List<FieloPLT__Challenge__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Challenge__c c = new FieloPLT__Challenge__c();
            c.Name = basename + String.valueOf(x);
            c.FieloPLT__Program__c = programId;
            c.FieloPLT__StartDate__c = Date.today();
            results.add(c);
        }
        return results;
    }

    public static List<FieloPLT__Mission__c> createMissions(String basename, Integer count, Id actionId, Id challengeId){
        List<FieloPLT__Mission__c> results = new List<FieloPLT__Mission__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Mission__c m = new FieloPLT__Mission__c();
            m.Name = basename + String.valueOf(x);
            m.FieloPLT__Challenge__c = challengeId;
            m.FieloPLT__Action__c = actionId;
            results.add(m);
        }
        return results;
    }

    public static List<FieloPLT__CriterionGroup__c> createMissionCriteriaGroup(Id missionId, Integer count){
        List<FieloPLT__CriterionGroup__c> results = new List<FieloPLT__CriterionGroup__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__CriterionGroup__c mc = new FieloPLT__CriterionGroup__c();
            mc.FieloPLT__Mission__c = missionId;
            results.add(mc);
        }
        return results;
    }

    public static List<FieloPLT__Mission__c> createMissions(String basename, Integer count, Id challengeId){
        List<FieloPLT__Mission__c> results = new List<FieloPLT__Mission__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Mission__c m = new FieloPLT__Mission__c();
            m.Name = basename + String.valueOf(x);
            m.FieloPLT__Challenge__c = challengeId;
            results.add(m);
        }
        return results;
    }

    public static List<FieloPLT__ChallengeReward__c> createChallengesRewards(Integer count, Id challengeId, Id badgeId, Id rewardId, Integer points){
        List<FieloPLT__ChallengeReward__c> results = new List<FieloPLT__ChallengeReward__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__ChallengeReward__c cr = new FieloPLT__ChallengeReward__c();
            cr.FieloPLT__Challenge__c = challengeId;
            cr.FieloPLT__Badge__c = badgeId;
            cr.FieloPLT__Reward__c = rewardId;
            cr.FieloPLT__Points__c = points;
            results.add(cr);
        }
        return results;
    }

    public static FieloPLT__ChallengeMember__c createChallengeMember(Id challengeId, Id memberId){
        return new FieloPLT__ChallengeMember__c(FieloPLT__Challenge__c = challengeId, FieloPLT__Member__c = memberId);
    }

    public static User createUser(String username, UserRole userRole){
       //looks for the standard profile
       List<Profile> profiles = [SELECT id FROM profile WHERE Name = 'Standard User' OR Name = 'Usuário Padrão' limit 1];

       if(!profiles.isEmpty()){
           String shortUserName = username.substring(0,username.indexOf('@'));
           String alias =(shortUserName.length()>8)?shortUserName.substring(0,5):shortUserName;
           User u = new User(Username = username,LastName = shortUserName, FirstName = 'test',
                           CommunityNickname = username, alias=alias,
                           Email = username, emailencodingkey = 'UTF-8',
                           localesidkey = 'en_US', languagelocalekey = 'en_US',
                           timezonesidkey = 'America/Los_Angeles', profileId=profiles.get(0).id,userRoleId = userRole.Id);
           insert u;
           return u;
       }

       return null;
   }
}