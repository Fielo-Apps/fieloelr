@isTest
public class TestModuleViewController
{
	@testSetup static void pageSettingsSetup() {
        List<FieloPLT__PageSettings__c> pageSettings = new List<FieloPLT__PageSettings__c>();

		pageSettings.add( new FieloPLT__PageSettings__c(
				Name = 'Module > View',
				FieloPLT__Object__c = 'FieloELR__Module__c',
				FieloPLT__Fieldset__c = '{"Name":"Name"},{"Name":"FieloELR__Course__r.Name"},{"Name":"FieloELR__IsActive__c"},{"Name":"FieloELR__WeightedQuestions__c"},{"Name":"FieloELR__PenaltyMode__c"}',
				FieloPLT__IsActive__c = true,
				FieloPLT__Type__c = 'View'
			)
		);

		pageSettings.add( new FieloPLT__PageSettings__c(
				Name = 'Module > Edit',
				FieloPLT__Object__c = 'FieloELR__Module__c',
				FieloPLT__Sections__c = '{"Name":"Information","Rows":[[{"Name":"Name","Type":"input"}],[{"Name":"FieloELR__Course__c","Type":"lookup"}],[{"Name":"FieloELR__ApprovalGrade__c","Type":"input"},{"Name":"FieloELR__AttemptsAllowed__c","Type":"input"},{"Name":"FieloELR__WeightedQuestions__c","Type":"checkbox"}],[{"Name":"FieloELR__PenaltyMode__c","Type":"picklist"},{"Name":"FieloELR__QuestionPool__c","Type":"input"},{"Name":"FieloELR__ShuffleQuestions__c","Type":"checkbox"}],[{"Name":"FieloELR__AttemptsAllowedPerQuestion__c","Type":"input"},{"Name":"FieloELR__Order__c","Type":"input"},{"Name":"FieloELR__IsActive__c","Type":"checkbox"}]]}',
				FieloPLT__IsActive__c = true,
				FieloPLT__Type__c = 'Edit'
			)
		);

		insert pageSettings;
    }

	@isTest static void itShouldViewModuleWithActivateButton()
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

		FieloELR__Module__c module = new FieloELR__Module__c(
			Name = 'Developers Module'
			, Course__c = course.Id
			, ApprovalGrade__c = 80.0
			, AttemptsAllowed__c = 10
			, AttemptsAllowedPerQuestion__c = 10
			, Description__c = 'Developers Course Description'
			, Order__c = 1
			, PenaltyMode__c = 'None'
			, ShuffleQuestions__c = true
			, WeightedQuestions__c = true
		);

		insert module;

		ApexPages.StandardController standardController = new ApexPages.StandardController(module);
        ModuleViewController controller = new ModuleViewController(standardController);

        RemoteActionResult result = ModuleViewController.activate(module.Id);

        FieloELR__Question__c question = new FieloELR__Question__c(
        	Name = 'Question 1'
        	, QuestionText__c = 'Question 1 text?'
        	, CorrectWeight__c = 20
        	, Module__c = module.Id
        	, Order__c = 1
        	, ShuffleAnswers__c = false
        	, Type__c = 'Short Answer'
        );

        ModuleViewController.saveQuestion(
        	question,
        	new List<String>{
        		'FieloELR__IncorrectWeight__c',
        		'FieloELR__PenaltyPerAttempt__c'
        	}
        );

        result = ModuleViewController.activate(module.Id);
	}

	@isTest static void itShouldViewModuleWithInactivateButton()
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

		FieloELR__Module__c module = new FieloELR__Module__c(
			Name = 'Developers Module'
			, Course__c = course.Id
			, ApprovalGrade__c = 80.0
			, AttemptsAllowed__c = 10
			, AttemptsAllowedPerQuestion__c = 10
			, Description__c = 'Developers Course Description'
			, Order__c = 1
			, PenaltyMode__c = 'None'
			, ShuffleQuestions__c = true
			, WeightedQuestions__c = true
			, IsActive__c = true
		);

		ModuleViewController.save(
			module,
			new List<String>{
				'FieloELR__QuestionPool__c'
			}
		);

		ApexPages.StandardController standardController = new ApexPages.StandardController(module);
        ModuleViewController controller = new ModuleViewController(standardController);

        RemoteActionResult result = ModuleViewController.inactivate(module.Id);
	}

	@isTest static void itShouldRetrieveModule()
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

		FieloELR__Module__c module = new FieloELR__Module__c(
			Name = 'Developers Module'
			, Course__c = course.Id
			, ApprovalGrade__c = 80.0
			, AttemptsAllowed__c = 10
			, AttemptsAllowedPerQuestion__c = 10
			, Description__c = 'Developers Course Description'
			, Order__c = 1
			, PenaltyMode__c = 'None'
			, ShuffleQuestions__c = true
			, WeightedQuestions__c = true
			, IsActive__c = true
		);

		ModuleViewController.save(
			module,
			new List<String>{
				'FieloELR__QuestionPool__c'
			}
		);
        
		String fields = String.join( new List<String>(Schema.describeSObjects(
			new String[]{'FieloELR__Module__c'})[0].fields.getMap().keySet()) ,',');

        module = (FieloELR__Module__c) ModuleViewController.retrieve('FieloELR__Module__c', module.Id, fields);
	}

	@isTest static void itShouldCreateModuleDependency()
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

		List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();

		modules.add(new FieloELR__Module__c(
				Name = 'Developers Module'
				, Course__c = course.Id
				, ApprovalGrade__c = 80.0
				, AttemptsAllowed__c = 10
				, AttemptsAllowedPerQuestion__c = 10
				, Description__c = 'Developers Course Description'
				, Order__c = 1
				, PenaltyMode__c = 'None'
				, ShuffleQuestions__c = true
				, WeightedQuestions__c = true
				, IsActive__c = true
			)
		);

		modules.add(new FieloELR__Module__c(
				Name = 'Developers Module - Intermediate'
				, Course__c = course.Id
				, ApprovalGrade__c = 80.0
				, AttemptsAllowed__c = 10
				, AttemptsAllowedPerQuestion__c = 10
				, Description__c = 'Developers Course Description'
				, Order__c = 1
				, PenaltyMode__c = 'None'
				, ShuffleQuestions__c = true
				, WeightedQuestions__c = true
				, IsActive__c = true
			)
		);

		insert modules;
        
		FieloELR__ModuleDependency__c moduleDependency = new FieloELR__ModuleDependency__c(
			Module__c = modules[0].Id,
			Predecessor__c = modules[1].Id
		);

		ModuleViewController.saveModuleDependency(
			moduleDependency,
			new List<String>()
		);
	}
}