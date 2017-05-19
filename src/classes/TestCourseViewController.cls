@isTest
public class TestCourseViewController
{
	@testSetup 
	static void pageSettingsSetup() {
        List<FieloPLT__PageSettings__c> pageSettings = new List<FieloPLT__PageSettings__c>();

		pageSettings.add( new FieloPLT__PageSettings__c(
				Name = 'Course > View',
				FieloPLT__Object__c = 'FieloELR__Course__c',
				FieloPLT__Fieldset__c = '{"Name":"Name"},{"Name":"FieloELR__Program__r.Name"},{"Name":"FieloELR__Status__c"},{"Name":"FieloELR__Segment__r.Name"}',
				FieloPLT__IsActive__c = true,
				FieloPLT__Type__c = 'View'
			)
		);

		pageSettings.add( new FieloPLT__PageSettings__c(
				Name = 'Course > Edit',
				FieloPLT__Object__c = 'FieloELR__Course__c',
				FieloPLT__Sections__c = '{"Name":"Information","Rows":[[{"Name":"Name","Type":"input"}],[{"Name":"FieloELR__Program__c","Type":"lookup","onchange":"RefreshSegments"}],[{"Name":"FieloELR__Segment__c","Type":"multiselect"}],[{"Name":"FieloELR__SubscriptionMode__c","Type":"picklist"},{"Name":"FieloELR__Status__c","Type":"picklist"}],[{"Name":"FieloELR__Description__c","Type":"input"}],[{"Name":"FieloELR__StartDate__c","Type":"input"},{"Name":"FieloELR__EndDate__c","Type":"input"}]]}',
				FieloPLT__IsActive__c = true,
				FieloPLT__Type__c = 'Edit'
			)
		);

		insert pageSettings;
    }

	@isTest
	static void itShouldViewCouseWithActivateButton()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		FieloELR__Course__c course = new FieloELR__Course__c(
			Name = 'Developers Course'
			, Segment__c = metaSegment.Id
			, Status__c = 'Draft'
			, SubscriptionMode__c = 'Manual'
			, Program__c = programs[0].Id
		);

		insert course;

		ApexPages.StandardController standardController = new ApexPages.StandardController(course);
        CourseViewController controller = new CourseViewController(standardController);

        RemoteActionResult result = CourseViewController.activate(course.Id);
	}

	@isTest
	static void itShouldViewCouseWithInactivateButton()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		FieloELR__Course__c course = new FieloELR__Course__c(
			Name = 'Developers Course'
			, Segment__c = metaSegment.Id
			, Status__c = 'Active'
			, SubscriptionMode__c = 'Manual'
			, Program__c = programs[0].Id
		);

		insert course;

		ApexPages.StandardController standardController = new ApexPages.StandardController(course);
        CourseViewController controller = new CourseViewController(standardController);

        RemoteActionResult result = CourseViewController.inactivate(course.Id);
	}

	@isTest
	static void itShouldRetrieveCouse()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		FieloELR__Course__c course = new FieloELR__Course__c(
			Name = 'Developers Course'
			, Segment__c = metaSegment.Id
			, Status__c = 'Draft'
			, SubscriptionMode__c = 'Manual'
			, Program__c = programs[0].Id
		);

		insert course;

		String fields = String.join( new List<String>(Schema.describeSObjects(
			new String[]{'FieloELR__Course__c'})[0].fields.getMap().keySet()) ,',');

		FieloELR__Course__c retrievedCourse = (FieloELR__Course__c) CourseViewController.retrieve('FieloELR__Course__c', course.Id, fields);
	}

	@isTest
	static void itShouldSaveCourse()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		FieloELR__Course__c course = new FieloELR__Course__c(
			Name = 'Developers Course'
			, Segment__c = metaSegment.Id
			, Status__c = 'Active'
			, SubscriptionMode__c = 'Manual'
			, Program__c = programs[0].Id
		);

		RemoteActionResult result = CourseViewController.save(
			course,
			new List<String>{
				'FieloELR__StartDate__c',
				'FieloELR__EndDate__c'
			}
		);
	}

	@isTest
	static void itShouldSaveCourseWithMoreParameters()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		FieloELR__Course__c course = new FieloELR__Course__c(
			Name = 'Developers Course'
			, Segment__c = metaSegment.Id
			, Status__c = 'Active'
			, SubscriptionMode__c = 'Manual'
			, Program__c = programs[0].Id
		);

		RemoteActionResult result = CourseViewController.save(
			course,
			new List<String>{
				'FieloELR__StartDate__c',
				'FieloELR__EndDate__c'
			},
			new List<String>{
				segments[0].Id,
				segments[1].Id
			}
		);
	}

	@isTest
	static void itShouldSaveCourseWithMoreParametersAndOneSegment()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		FieloELR__Course__c course = new FieloELR__Course__c(
			Name = 'Developers Course'
			, Segment__c = metaSegment.Id
			, Status__c = 'Active'
			, SubscriptionMode__c = 'Manual'
			, Program__c = programs[0].Id
		);

		RemoteActionResult result = CourseViewController.save(
			course,
			new List<String>{
				'FieloELR__StartDate__c',
				'FieloELR__EndDate__c'
			},
			new List<String>{
				segments[0].Id
			}
		);
	}

	@isTest
	static void itShouldGetSegments()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		segments = CourseViewController.getSegments(programs[0].Id);
	}

	@isTest
	static void itShouldSaveModuleAndCourseDependency()
	{
		List<FieloPLT__Program__c> programs =
			MockUpFactory.createPrograms('Default', 1);
        insert programs;

		FieloPLT__Segment__c metaSegment =
			MockUpFactory.createSegments('Segment #', 1, 'MetaSegment')[0];
		List<FieloPLT__Segment__c> segments =
			MockUpFactory.createSegments('Segment #', 2, 'Manual');

		metaSegment.FieloPLT__RelatedSegments__c = segments[0].Id + ',' + segments[1].Id;

		segments.add(metaSegment);

		for (FieloPLT__Segment__c segment:segments) {
			segment.FieloPLT__Program__c = programs[0].Id;
		}

		insert segments;

		List<FieloELR__Course__c> courses = new List<FieloELR__Course__c>();

		courses.add(new FieloELR__Course__c(
				Name = 'Developers Course'
				, Segment__c = metaSegment.Id
				, Status__c = 'Draft'
				, SubscriptionMode__c = 'Manual'
				, Program__c = programs[0].Id
			)
		);

		courses.add(new FieloELR__Course__c(
				Name = 'Developers Course - Intermediate'
				, Segment__c = metaSegment.Id
				, Status__c = 'Draft'
				, SubscriptionMode__c = 'Manual'
				, Program__c = programs[0].Id
			)
		);

		insert courses;

		FieloELR__Module__c module = new FieloELR__Module__c(
			Name = 'Developers Module'
			, Course__c = courses[1].Id
			, ApprovalGrade__c = 80.0
			, AttemptsAllowed__c = 10
			, AttemptsAllowedPerQuestion__c = 10
			, Description__c = 'Developers Course Description'
			, Order__c = 1
			, PenaltyMode__c = 'None'
			, ShuffleQuestions__c = true
			, WeightedQuestions__c = true
		);

		RemoteActionResult result = CourseViewController.saveModule(
			module,
			new List<String>{
				'FieloELR__QuestionPool__c'
			}
		);

		FieloELR__CourseDependency__c courseDependency = new FieloELR__CourseDependency__c(
			Course__c = courses[1].Id,
			Predecessor__c = courses[0].Id
		);

		result = CourseViewController.saveCourseDependency(
			courseDependency,
			new List<String>()
		);
	}
}