@isTest
private class TestELearningLandingController
{
	@testSetup 
	static void pageSettingsSetup() {
        List<FieloPLT__PageSettings__c> pageSettings = new List<FieloPLT__PageSettings__c>();

		pageSettings.add( new FieloPLT__PageSettings__c(
				Name = 'Course > Landing',
				FieloPLT__Object__c = 'FieloELR__Course__c',
				FieloPLT__Fieldset__c = '{"Name":"FieloELR__SubscriptionMode__c"},{"Name":"FieloELR__Status__c"},{"Name":"FieloELR__Program__r.Name"}',
				FieloPLT__IsActive__c = true,
				FieloPLT__Type__c = 'Landing'
			)
		);

		pageSettings.add( new FieloPLT__PageSettings__c(
				Name = 'Course > New',
				FieloPLT__Object__c = 'FieloELR__Course__c',
				FieloPLT__Sections__c = '{"Name":"Information","Rows":[[{"Name":"Name","Type":"input"}],[{"Name":"FieloELR__Program__c","Type":"lookup","onchange":"RefreshSegments"}],[{"Name":"FieloELR__Segment__c","Type":"multiselect"}],[{"Name":"FieloELR__SubscriptionMode__c","Type":"picklist"},{"Name":"FieloELR__Status__c","Type":"picklist"}],[{"Name":"FieloELR__Description__c","Type":"input"}],[{"Name":"FieloELR__StartDate__c","Type":"input"},{"Name":"FieloELR__EndDate__c","Type":"input"}]]}',
				FieloPLT__IsActive__c = true,
				FieloPLT__Type__c = 'New'
			)
		);

		insert pageSettings;
    }

	@isTest
	static void itShouldInitPage() {
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

		ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(
			new List<FieloELR__Course__c>{course}
		);
        
        ELearningLandingController controller = new ELearningLandingController();

        List<SelectOption> views = ELearningLandingController.getStatusViews();        
	}

	@isTest
	static void itShouldGetCourses() {
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

		List<FieloELR__Course__c> courses = ELearningLandingController.getCourses(
			'FieloELR__Course__c',
			fields,
			null,
			null,
			'{"FieloELR__Program__c":"'+programs[0].Id+'"}',
			10
		);    
	}

	@isTest
	static void itShouldCreateCourseWithoutSegments() {
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

		RemoteActionResult result = ELearningLandingController.createCourseWithoutSegments(
			course,
			new List<String>{
				'FieloELR__StartDate__c',
				'FieloELR__EndDate__c'
			}
		);
	}

	@isTest
	static void itShouldCreateCourseWithSegments() {
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

		RemoteActionResult result = ELearningLandingController.createCourseWithSegments(
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
	static void itShouldGetSegments() {
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

		segments = ELearningLandingController.getSegments(programs[0].Id);
	}
}