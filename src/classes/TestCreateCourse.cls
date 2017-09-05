@isTest
private class TestCreateCourse{
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Segment__c> segments;
    private static List<FieloELR__Course__c> courses;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloELR__Question__c>  questions = new List<FieloELR__Question__c>();
    private static List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();
    private static List<FieloELR__AnswerOption__c> answers = new List<FieloELR__AnswerOption__c>();

    @testSetup
    static void setup(){ 

        //Programs
        programs = MockUpFactory.createPrograms('testProgram', 2);
        insert programs;

        //Segments
        segments = MockUpFactory.createSegments('testSegment',2,'Dynamic');
        segments.get(0).FieloPLT__Program__c = programs.get(0).id;
        segments.get(1).FieloPLT__Program__c = programs.get(1).id;
        insert segments;

        //Courses 
        courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 5);
        
        //course to check status
        courses.get(0).FieloELR__Description__c = 'aTestCourse';
     
        //course to activate
        courses.get(1).FieloELR__Program__c = programs.get(0).id;

        //course active
        courses.get(2).FieloELR__Program__c = programs.get(0).id;
        
        //course with course status && active
        courses.get(3).FieloELR__Program__c = programs.get(1).id;
        courses.get(3).FieloELR__Segment__c = segments.get(1).id;
        insert courses;

        //set course 4 to inactive
        courses.get(4).FieloELR__Status__c = 'Inactive';
        update courses.get(4);

        //Members
        members = MockUpFactory.createMembers(programs.get(0).id, 2);
        members.get(1).FieloPLT__Program__c = programs.get(1).id;
        insert members;

        //Module
        FieloELR__Module__c moduleTest = new FieloELR__Module__c();
        moduleTest.Name = 'testModule';
        moduleTest.FieloELR__Course__c = courses.get(3).id;
        moduleTest.FieloELR__ApprovalGrade__c = 0;
        modules.add(moduleTest);
        
        FieloELR__Module__c moduleTest2 = new FieloELR__Module__c();
        moduleTest2.Name = 'testModule';
        moduleTest2.FieloELR__Course__c = courses.get(2).id;
        moduleTest2.FieloELR__ApprovalGrade__c = 0;
        modules.add(moduleTest2);

        FieloELR__Module__c moduleTest3 = new FieloELR__Module__c();
        moduleTest3.Name = 'testModule';
        moduleTest3.FieloELR__Course__c = courses.get(1).id;
        moduleTest3.FieloELR__ApprovalGrade__c = 0;
        modules.add(moduleTest3);
        insert modules;


        //Question
        FieloELR__Question__c question1 = new FieloELR__Question__c();
        question1.Name = 'question1';
        question1.FieloELR__Module__c = modules.get(0).Id;
        question1.FieloELR__QuestionText__c = 'How are you?';
        question1.FieloELR__Type__c = 'Short Answer';
        questions.add(question1);

        FieloELR__Question__c question2 = new FieloELR__Question__c();
        question2.Name = 'question2';
        question2.FieloELR__Module__c = modules.get(1).Id;
        question2.FieloELR__QuestionText__c = 'How are you?';
        question2.FieloELR__Type__c = 'Short Answer';
        questions.add(question2);

        FieloELR__Question__c question3 = new FieloELR__Question__c();
        question3.Name = 'question3';
        question3.FieloELR__Module__c = modules.get(2).Id;
        question3.FieloELR__QuestionText__c = 'How are you?';
        question3.FieloELR__Type__c = 'Short Answer';
        questions.add(question3);
        insert questions;

        //Answer
        FieloELR__AnswerOption__c answers1 = new FieloELR__AnswerOption__c();
        answers1.FieloELR__Question__c = questions.get(0).Id;
        answers1.FieloELR__IsCorrect__c = true;
        answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
        answers.add(answers1);

        FieloELR__AnswerOption__c answers2 = new FieloELR__AnswerOption__c();
        answers2.FieloELR__Question__c = questions.get(1).Id;
        answers2.FieloELR__IsCorrect__c = true;
        answers2.FieloELR__AnswerOptionText__c = 'Esta es correcta';
        answers.add(answers2);

        FieloELR__AnswerOption__c answers3 = new FieloELR__AnswerOption__c();
        answers3.FieloELR__Question__c = questions.get(2).Id;
        answers3.FieloELR__IsCorrect__c = true;
        answers3.FieloELR__AnswerOptionText__c = 'Esta es correcta';
        answers.add(answers3);
        insert answers;

        //Active Modules
        modules.get(0).FieloELR__IsActive__c = true;
        modules.get(1).FieloELR__IsActive__c = true;
        modules.get(2).FieloELR__IsActive__c = true;
        update modules;
        //Active courses
        courses.get(3).FieloELR__Status__c = 'Active';
        courses.get(2).FieloELR__Status__c = 'Active';
        update courses.get(3);
        update courses.get(2);

          //Course Status
        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c();
        courseStatus.FieloELR__Member__c = members.get(1).id;
        courseStatus.FieloELR__Course__c = courses.get(3).id;
        insert courseStatus;
    }

//Methods
    @isTest
    static void ELR_0001_FB1(){

        courses = [SELECT id,FieloELR__Status__c,FieloELR__ActiveModules__c FROM FieloELR__Course__c WHERE Name = 'Course 0'];
        
        System.assertEquals(0,courses.get(0).FieloELR__ActiveModules__c);
        System.assertEquals('Draft',courses.get(0).FieloELR__Status__c);
    }


    @isTest
    static void ELR_0001_FA1(){
        courses = new List<FieloELR__Course__c>{new FieloELR__Course__c(Name = 'TestName')};

        try{
            insert courses.get(0);
        }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('You must select a Program'));
            }
    }


    @isTest
    static void ELR_0001_FA2(){
        courses = new List<FieloELR__Course__c>{new FieloELR__Course__c(Name = 'TestName')};

        courses.get(0).FieloELR__Program__c = [SELECT Id FROM FieloPLT__Program__c WHERE Name = 'testProgram0' LIMIT 1].id;
        courses.get(0).FieloELR__Segment__c = [SELECT Id FROM FieloPLT__Segment__c WHERE Name = 'testSegment1' LIMIT 1 ].id;

        try{
            insert courses.get(0);
        }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('Segment must be on the same program.'));
           }
        
    }


    @isTest
    static void ELR_0001_FA3(){
        courses = [SELECT Id,FieloELR__Status__c,FieloELR__ActiveModules__c FROM FieloELR__Course__c WHERE Name = 'Course 1' LIMIT 1];
        
        courses.get(0).FieloELR__Status__c = 'Active';
        
        update courses.get(0);
        courses = [SELECT Id,FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 1' LIMIT 1];

        System.assertEquals('Active', courses.get(0).FieloELR__Status__c);
        
    }


    @isTest
        static void ELR_0001_FA4(){
            courses = [SELECT Id,Name,FieloELR__ActiveModules__c FROM FieloELR__Course__c WHERE Name = 'Course 0' LIMIT 1];
            
            courses.get(0).FieloELR__Status__c = 'Active';
            
            try{
                update courses.get(0);
            }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('To activate a course, it must have at least one active related module.'));
             }
        }


    /*@isTest
        static void ELR_0001_FA5(){
                courses = [SELECT Name,FieloELR__SubscriptionMode__c,FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 2'];
                courses.get(0).FieloELR__SubscriptionMode__c = 'Automatic';

                update courses.get(0);

                courses = [SELECT FieloELR__SubscriptionMode__c FROM FieloELR__Course__c WHERE Name = 'Course 2'];

                System.assertEquals('Automatic', courses.get(0).FieloELR__SubscriptionMode__c);
        } 


    @isTest
        static void ELR_0001_FA6(){
            courses = [SELECT Id,FieloELR__Status__c,FieloELR__Program__c FROM FieloELR__Course__c WHERE Name =  'Course 2'];
            courses.get(0).Name = 'newName';
            
            update courses.get(0);

            courses = [SELECT Name FROM FieloELR__Course__c WHERE Name = 'newName'];

            System.assertEquals('newName', courses.get(0).Name);
        }

    @isTest
        static void ELR_0001_FA7(){
            courses = [SELECT Id,FieloELR__Status__c FROM FieloELR__Course__c WHERE Name =  'Course 3'];
            courses.get(0).Name = 'newTestName';

            update courses.get(0);

            courses = [SELECT Name FROM FieloELR__Course__c WHERE Name = 'newTestName'];
            System.assertEquals('newTestName', courses.get(0).Name);
        }


    @isTest
        static void ELR_0001_FA8(){
            courses = [SELECT Id,FieloELR__Status__c,FieloELR__Description__c FROM FieloELR__Course__c WHERE Name =  'Course 3'];
            courses.get(0).FieloELR__Description__c = 'new Course Description';
            
            update courses.get(0);

            courses = [SELECT FieloELR__Description__c FROM FieloELR__Course__c WHERE Name = 'Course 3'];
            System.assertEquals('new Course Description',courses.get(0).FieloELR__Description__c);
        }


    @isTest
        static void ELR_0001_FA9(){
            courses = [SELECT Id,FieloELR__Status__c,FieloELR__SubscriptionMode__c FROM FieloELR__Course__c WHERE Name = 'Course 3'];           
            courses.get(0).FieloELR__SubscriptionMode__c = 'Automatic';

            try{
                update courses.get(0);  
            }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('Cannot edit the Subscription Mode of an active Course already associated to a member.'));
             }    
                    
        }*/


    /*@isTest
        static void ELR_0001_FA10(){
            courses = [SELECT Id,FieloELR__Program__c FROM FieloELR__Course__c WHERE Name ='Course 3'];
            courses.get(0).FieloELR__Program__c = [SELECT Id FROM FieloPLT__Program__c WHERE Name = 'testProgram0' LIMIT 1].id;

            try{
                update courses.get(0); 
               }catch(System.DmlException e){
                    System.assert(e.getMessage().Contains('Cannot change the program from the course.'));
                }
            
        }


    @isTest 
        static void ELR_0001_FA11(){
            courses = [SELECT Id,FieloELR__Segment__c FROM FieloELR__Course__c WHERE Name ='Course 3'];
            courses.get(0).FieloELR__Segment__c = [SELECT Id FROM FieloPLT__Segment__c WHERE Name = 'testSegment0' LIMIT 1].id;

            try{
                update courses.get(0);
            }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('Cannot edit the Segment of an active Course already associated to a member.'));
             }
        }


    @isTest
        static void ELR_0001_FA12(){
            courses = [SELECT Id,FieloELR__StartDate__c FROM FieloELR__Course__c WHERE Name = 'Course 3'];
            courses.get(0).FieloELR__StartDate__c = Date.today() + 10;

            try{
                update courses.get(0);
            }catch(System.DmlException e){
                System.assert(e.getMessage().Contains(' Cannot edit the Start Date of an active Course already associated to a member.'));
             }
        }


    @isTest
        static void ELR_0001_FA13(){
            courses = [SELECT Id,FieloELR__EndDate__c FROM FieloELR__Course__c WHERE Name = 'Course 3'];
            courses.get(0).FieloELR__EndDate__c = Date.today() + 10;

            try{
                update courses.get(0);
            }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('Cannot edit the End Date of an active Course already associated to a member.'));
             }
        } 


    @isTest
        static void ELR_0001_FA14(){
          courses = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 2'];

          delete courses;
          
          courses = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 2'];
          
          System.assertEquals(0, courses.size());
        } 

    @isTest
        static void ELR_0001_FA15(){
            courses = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 3'];

            try{
                delete courses;
            }catch(System.DmlException e){
                System.assert(e.getMessage().Contains('Cannot delete an active Course with already associated to a member.'));
            }
        } */

    /*@isTest
        static void ELR_0001_FA16(){
            courses = [SELECT Id,FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 2'];

            courses.get(0).FieloELR__Status__c = 'Inactive';

            update courses;

            courses = [SELECT FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 2'];
            

            System.assertEquals('Inactive', courses.get(0).FieloELR__Status__c);
        }

    @isTest 
        static void ELR_0001_FA17(){
            courses  = [SELECT Id, FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 3'];

            courses.get(0).FieloELR__Status__c = 'Inactive';

            update courses;

            courses = [SELECT FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 3'];

            System.assertEquals('Inactive', courses.get(0).FieloELR__Status__c);
        }*/

    @isTest
        static void ELR_0001_FA18(){
            courses = [SELECT Id,FieloELR__Status__c FROM FieloELR__Course__c WHERE Name = 'Course 4'];
            
            courses.get(0).FieloELR__Description__c = 'newDescription';

            update courses;

            courses = [SELECT FieloELR__Description__c FROM FieloELR__Course__c WHERE Name = 'Course 4'];

            System.assertEquals('newDescription',courses.get(0).FieloELR__Description__c);
        } 

    @isTest
        static void  ELR_0001_FA19(){
            courses = new List<FieloELR__Course__c>{new FieloELR__Course__c(Name = 'TestName')};
            courses.get(0).FieloELR__Program__c = [SELECT Id FROM FieloPLT__Program__c WHERE Name = 'testProgram0' LIMIT 1].id;
            courses.get(0).FieloELR__Segment__c = [SELECT Id FROM FieloPLT__Segment__c WHERE Name = 'testSegment0' LIMIT 1 ].id;
            courses.get(0).FieloELR__StartDate__c = Date.today() - 10;

            try{
                insert courses;
                }catch(System.Dmlexception e){
                    System.assert(e.getMessage().Contains('Start Date and End Date must be equal or greater than today date.'));
                }
        }

    @isTest
        static void ELR_0001_FA20(){
            courses = new List<FieloELR__Course__c>{new FieloELR__Course__c(Name = 'TestName')};
            courses.get(0).FieloELR__Program__c = [SELECT Id FROM FieloPLT__Program__c WHERE Name = 'testProgram1' LIMIT 1].id;
            courses.get(0).FieloELR__Segment__c = [SELECT Id FROM FieloPLT__Segment__c WHERE Name = 'testSegment1' LIMIT 1 ].id;
            courses.get(0).FieloELR__EndDate__c = Date.today() - 10;

            try{
                insert courses;
                }catch(System.Dmlexception e){
                    System.assert(e.getMessage().Contains('Start Date and End Date must be equal or greater than today date.'));
                }
            
        } 

    @isTest
        static void ELR_0001_FA21(){
            courses = new List<FieloELR__Course__c>{new FieloELR__Course__c(Name = 'TestName')};
            courses.get(0).FieloELR__Program__c = [SELECT Id FROM FieloPLT__Program__c WHERE Name = 'testProgram1' LIMIT 1].id;
            courses.get(0).FieloELR__Segment__c = [SELECT Id FROM FieloPLT__Segment__c WHERE Name = 'testSegment1' LIMIT 1 ].id;
            courses.get(0).FieloELR__EndDate__c = Date.today() + 10;
            courses.get(0).FieloELR__StartDate__c = Date.today() + 20;
            
            try{
                insert courses;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains('Start Date cannot be greater than End Date'));
            }
        }             
}