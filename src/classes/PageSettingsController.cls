// TODO: Ver que pasa cuando hay registros para un program y registros sin program
public with sharing abstract class PageSettingsController {
	public String objectName { get; set; }

/* Para los page settings de un view */
	private SObject record { get; set; }
	private List<FieloPLT__PageSettings__c> relatedPS {get;set;}
	private List<FieloPLT__PageSettings__c> relatedFormsPS {get;set;}
	private FieloPLT__PageSettings__c editPS {get;set;}
	private FieloPLT__PageSettings__c viewPS {get;set;}
	private FieloPLT__PageSettings__c detailPS {get;set;}
	private Set<String> standardRelated {get;set;} 

	private Boolean hasEditForm {get;set;} 
	private Boolean hasDetail {get;set;} 

	public Boolean getHasEditForm () {
		return hasEditForm;
	}
	public Boolean getHasDetail () {
		return hasDetail;
	}


/* 
	Constructor para los Views
*/
	public void setRecord( SObject r ) { 
		this.record = r;		
	}

	public Set<String> fieldList { get {
		if ( fieldList == null ) {
			fieldList = new Set<String>();
			if ( !String.isBlank(viewPS.FieloPLT__Fieldset__c) ) {
				for ( BackendHeaderRecordController.HeaderColumn c:  (List<BackendHeaderRecordController.HeaderColumn>)JSON.deserialize( '[' + viewPS.FieloPLT__Fieldset__c + ']', List<BackendHeaderRecordController.HeaderColumn>.class ) ) {
					fieldList.add(c.Name.toLowerCase() );
				}
			}
			if ( !String.isBlank(detailPS.FieloPLT__Sections__c) ) {
				for ( FormController.Section s:  (List<FormController.Section>) JSON.deserialize( '[' + detailPS.FieloPLT__Sections__c + ']', List<FormController.Section>.class ) ) {
		          for ( List<FormController.FormField> r :s.rows ) {
		            for ( FormController.FormField f :r ) {
		              if ( !String.isBlank(f.Name) ) {
		              	fieldList.add(f.Name.toLowerCase() );
		              }
		            }
		          }
				}
			}
		}
		return fieldList;
	} set ;}

	public Set<String> relatedStandard { get {
		if ( relatedStandard == null ) {
			relatedStandard = standardRelated;
		}
		return relatedStandard;
	} set; }

	public List<FieloPLT__PageSettings__c> relatedSettings { get {
		if ( relatedSettings == null ) {
			relatedSettings = relatedPS;
		}
		return relatedSettings;
	} set; }
	public List<FieloPLT__PageSettings__c> relatedFormsSettings { get {
		if ( relatedFormsSettings == null ) {
			relatedFormsSettings = relatedFormsPS;
		}
		return relatedFormsSettings;

	} set; }
	public FieloPLT__PageSettings__c editSettings { get {
		if ( editSettings == null ) {
			// Quita la primer , que concatena los settings
			if ( !String.isBlank(editPS.FieloPLT__Sections__c) ) {
				editPS.FieloPLT__Sections__c = '[' + PageSettingsController.replaceFormula( editPS.FieloPLT__Sections__c, record ) + ']';
			}
			
			editSettings = editPS;
		}
		return editSettings;

	} set; }
	public FieloPLT__PageSettings__c viewSettings { get {
		if ( viewSettings == null ) {
			if ( !String.isBlank(viewPS.FieloPLT__Fieldset__c) ) {
				viewPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula( viewPS.FieloPLT__Fieldset__c, record ) + ']';
			}
			if ( !String.isBlank(viewPS.FieloPLT__Buttons__c) ) {
				viewPS.FieloPLT__Buttons__c =  '[' + PageSettingsController.replaceFormula(  viewPS.FieloPLT__Buttons__c, record) + ']';
			}
			if ( !String.isBlank(viewPS.FieloPLT__Tools__c) ) {
				viewPS.FieloPLT__Tools__c =  '[' + PageSettingsController.replaceFormula( viewPS.FieloPLT__Tools__c, record) + ']';
			}
			viewSettings = viewPS;
		}
		return viewSettings;

	} set; }

	public FieloPLT__PageSettings__c detailSettings{ get {
		if ( detailSettings == null ) {
			if ( !String.isBlank(detailPS.FieloPLT__Sections__c) ) {
				detailPS.FieloPLT__Sections__c = '[' + PageSettingsController.replaceFormula( detailPS.FieloPLT__Sections__c, record ) + ']';
			}
			detailSettings = detailPS;
		}
		return detailSettings;

	} set; }

	public void initPageSettings( String objectName, SObject record, String standardButtons, String standardTools, String defaultIcon  ) {
		this.objectName = objectName;
		hasEditForm = hasDetail = false;
		this.record = record;
		if ( defaultIcon == null ) {
			defaultIcon = 'action-sprite/svg/symbols.svg#record';
		}
		// 
		List<String> recordTypeNames = new List<String>();
		String recordTypeName;
		try {			
			recordTypeName = (String) record.getSObject('RecordType').get('DeveloperName');
		} catch ( Exception e) {}
		if ( recordTypeName != null ) {
  			recordTypeNames.add( recordTypeName);
		}			
		List<FieloPLT__PageSettings__c> settings =  PageSettingsController.getPageSettings( new List<String>{ 'Edit', 'Related', 'View', 'Detail' }, recordTypeNames, objectName );

		if(standardButtons == null){
			standardButtons = '';
		}
		if(standardTools == null){
			standardTools = '';
		}
		relatedPS = new List<FieloPLT__PageSettings__c>();
		editPS = new FieloPLT__PageSettings__c( FieloPLT__Sections__c = '', FieloPLT__Buttons__c = '', FieloPLT__Tools__c = '');
		detailPS = new FieloPLT__PageSettings__c( FieloPLT__Sections__c = '', FieloPLT__Buttons__c = '', FieloPLT__Tools__c = '');
		viewPS = new FieloPLT__PageSettings__c( FieloPLT__Icon__c = defaultIcon,  FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = standardButtons, FieloPLT__Tools__c = standardTools);

		Set<String> relatedObjects = new Set<String>();
		standardRelated = new Set<String>();
		String viewActions = '';
		// Por Performance dividimos la logica entre los que tienen Recordtype y los que no
		if ( recordTypeName != null ) {
			Map<String, Boolean> skipDefault = new Map<String, Boolean>();

			for ( FieloPLT__PageSettings__c p : settings ) {
				if ( !skipDefault.containsKey( p.FieloPLT__Type__c) ) {
					skipDefault.put(p.FieloPLT__Type__c, !String.isBlank(p.FieloPLT__RecordType__c) );
				}
			    if ( !String.isBlank(p.FieloPLT__RecordType__c) || !skipDefault.get(p.FieloPLT__Type__c) ) {
					if ( p.FieloPLT__Type__c == 'Related' && String.isNotBlank(p.FieloPLT__TargetObject__c) ) {
						if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
							relatedObjects.add(p.FieloPLT__TargetObject__c);
						}
						// Icono por default de las related
						if ( String.isBlank( p.FieloPLT__Icon__c )  ) {
							p.FieloPLT__Icon__c = 'action-sprite/svg/symbols.svg#goal';
						}						
			        	relatedPS.add(p);
					} else if ( p.FieloPLT__Type__c == 'Edit'  ) {
						hasEditForm = true;
						if ( p.FieloPLT__Sections__c != null ) {
							editPS.FieloPLT__Sections__c += (editPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c;
						}				
					} else if ( p.FieloPLT__Type__c == 'Detail'  ) {
						hasDetail = true;
						if ( ! String.isBlank(p.FieloPLT__Sections__c )  ) {
							detailPS.FieloPLT__Sections__c += (detailPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c;
						}			
					} else { // View
						if ( ! String.isBlank( p.FieloPLT__Icon__c )  ) {
							viewPS.FieloPLT__Icon__c = p.FieloPLT__Icon__c;
						}
						if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
							viewActions = p.FieloPLT__StandardActions__c;
						}												
						if ( ! String.isBlank(p.FieloPLT__Fieldset__c ) ) {
							viewPS.FieloPLT__Fieldset__c += (viewPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
						}
						if ( ! String.isBlank(p.FieloPLT__Buttons__c) ) {
							viewPS.FieloPLT__Buttons__c += (viewPS.FieloPLT__Buttons__c == '' ) ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
						}
						if ( ! String.isBlank(p.FieloPLT__Tools__c)  ) {
							viewPS.FieloPLT__Tools__c += (viewPS.FieloPLT__Tools__c == '') ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
						}
						if ( ! String.isBlank( p.FieloPLT__StandardRelated__c )  ) {
							standardRelated.addAll( p.FieloPLT__StandardRelated__c.split(';') );
						}						
					}
			    }
			}

		} else {
			for ( FieloPLT__PageSettings__c p : settings ) {
				if ( p.FieloPLT__Type__c == 'Related' && String.isNotBlank(p.FieloPLT__TargetObject__c)  ) {
					if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
						relatedObjects.add(p.FieloPLT__TargetObject__c);
					}
					// Icono por default de las related
					if ( String.isBlank( p.FieloPLT__Icon__c )  ) {
						p.FieloPLT__Icon__c = 'action-sprite/svg/symbols.svg#goal';
					}
		        	relatedPS.add(p);
				} else if ( p.FieloPLT__Type__c == 'Edit'  ) {
					hasEditForm = true;					
					if ( ! String.isBlank(p.FieloPLT__Sections__c) ) {
						editPS.FieloPLT__Sections__c += (editPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c;
					}			
				} else if ( p.FieloPLT__Type__c == 'Detail'  ) {
					hasDetail = true;
					if ( ! String.isBlank(p.FieloPLT__Sections__c) ) {
						detailPS.FieloPLT__Sections__c += (detailPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c; 
					}				
				} else {
					if ( ! String.isBlank( p.FieloPLT__Icon__c )  ) {
						viewPS.FieloPLT__Icon__c = p.FieloPLT__Icon__c;
					}					
					if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
						viewActions = p.FieloPLT__StandardActions__c;
					}
					if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
						viewPS.FieloPLT__Fieldset__c += (viewPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
					}
					if ( ! String.isBlank(p.FieloPLT__Buttons__c)  ) {
						viewPS.FieloPLT__Buttons__c += (viewPS.FieloPLT__Buttons__c == '') ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
					}
					if ( ! String.isBlank(p.FieloPLT__Tools__c) ) {
						viewPS.FieloPLT__Tools__c += (viewPS.FieloPLT__Tools__c == '') ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
					}
					if ( ! String.isBlank( p.FieloPLT__StandardRelated__c )  ) {
						standardRelated.addAll( p.FieloPLT__StandardRelated__c.split(';') );
					}											
				}
			}
		}
		// Reemplaza las formulas y agrega las standard actions en las related
		if ( relatedPS.size() > 0 ) {			
			// Busca si Hay PageSettings Edit de los objetos en caso positivo mete el form
			Map<String, FieloPLT__PageSettings__c> mapForms = new Map<String, FieloPLT__PageSettings__c>();
			Map<String, Schema.DescribeSObjectResult> mapDescribes = new Map<String, Schema.DescribeSObjectResult>();

			if ( relatedObjects.size() > 0 ) {
				Schema.DescribeSObjectResult[] describes = SObjectDescribe.describeSObjects(  new List<String>(relatedObjects) );
				for ( Schema.DescribeSObjectResult d: describes) {
					mapDescribes.put(d.getName(), d);
				}

				List<FieloPLT__PageSettings__c> forms = getRelatedForms( relatedObjects );
				if ( forms.size() > 0 ) {
					for ( FieloPLT__PageSettings__c p : forms ) {
						String key = p.FieloPLT__Object__c;
						if ( p.FieloPLT__Type__c == 'New' ) {
							key += 'New';
						}
						if ( String.isNotBlank(p.FieloPLT__RecordType__c) ) {
							key += p.FieloPLT__RecordType__c;
						}
						if ( mapForms.containsKey(key) ) {
							FieloPLT__PageSettings__c m = mapForms.get(key);
							m.FieloPLT__Sections__c += ',' + p.FieloPLT__Sections__c;
						} else {
							mapForms.put(key, p );
						}
					}
					this.relatedFormsPS = mapForms.values();					
				}
			}
			// Buscar si hay formularios de los relatedObjects
			for ( FieloPLT__PageSettings__c r : relatedPS ) {
				if ( !String.isBlank(r.FieloPLT__Buttons__c) ) {
					r.FieloPLT__Buttons__c = PageSettingsController.replaceFormula( r.FieloPLT__Buttons__c , record); 
				}
				if ( !String.isBlank(r.FieloPLT__Tools__c) ) {
					r.FieloPLT__Tools__c =  PageSettingsController.replaceFormula( r.FieloPLT__Tools__c , record); 
				}
				if ( !String.isBlank(r.FieloPLT__Actions__c) ) {
					r.FieloPLT__Actions__c =  PageSettingsController.replaceFormula( r.FieloPLT__Actions__c , record); 
				}
				if ( !String.isBlank(r.FieloPLT__StandardActions__c) ) {
					Set<String> opciones = new Set<String>();
					opciones.addAll( r.FieloPLT__StandardActions__c.split(';') );

					if ( opciones.contains('New') &&  mapDescribes.get(r.FieloPLT__TargetObject__c).isCreateable() ){
						if ( mapForms.containsKey(r.FieloPLT__TargetObject__c + 'New')  ) {
							r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'FormNew" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':','+ r.FieloPLT__Buttons__c);
						} else if ( mapForms.containsKey(r.FieloPLT__TargetObject__c)  ) {
							r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'Form" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':','+ r.FieloPLT__Buttons__c);
						} else {							
							r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':',' + r.FieloPLT__Buttons__c) ;
						}
					}

					if ( opciones.contains('Delete') &&  mapDescribes.get(r.FieloPLT__TargetObject__c).isDeletable()){
						r.FieloPLT__Actions__c = '{"Label": "' + Label.Delete + '", "Type": "Remote", "Action": "FieloPLT.RelatedListController.deleteRecord", "CssClass": "slds-button--destructive", "Confirm":true }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c) ;
						//r.FieloPLT__Actions__c = '{"Label": "' + Label.Delete + '", "Type": "Action", "Action": "Delete", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',') + r.FieloPLT__Actions__c;
					}									

					if ( opciones.contains('Edit') &&  mapDescribes.get(r.FieloPLT__TargetObject__c).isUpdateable() ){
						if ( mapForms.containsKey(r.FieloPLT__TargetObject__c) ) {
							r.FieloPLT__Actions__c = '{"Label": "' + Label.Edit + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'Form" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c) ;
						} else {
							r.FieloPLT__Actions__c = '{"Label": "' + Label.Edit + '", "Type": "Action", "Action": "Edit", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c);
						}
					}
				}
				// TODO: Ver si los fieldset de related necesitan
				//if ( !String.isBlank(r.FieloPLT__Fieldset__c) ) {
				//	r.FieloPLT__Fieldset__c = PageSettingsController.replaceFormula( r.FieloPLT__Fieldset__c, record );
				//}
			}			
		}

		if ( !String.isBlank(viewActions) ) {
			Set<String> opciones = new Set<String>();
			opciones.addAll( viewActions.split(';') );

			Schema.DescribeSObjectResult[] describes = SObjectDescribe.describeSObjects(  new List<String>{objectName} );			
			Schema.DescribeSObjectResult describeObject = describes.get(0);

			if ( opciones.contains('Clone') && describeObject.isCreateable() ){
				// TODO: Ver Bugfix del Clone
				//if ( hasEditForm ) {
				//	viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Clone + '", "Type": "Modal", "Parameters": "{ \'cloneId\': \'' + record.Id + '\' }", "Action": "' + objectName + 'Form" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
				//} else {
					viewPS.FieloPLT__Buttons__c = '{"Label": "Clone", "Type": "Action", "Action": "Clone", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',' + viewPS.FieloPLT__Buttons__c);
				//}	
			}

			if ( opciones.contains('Settings') ){
				viewPS.FieloPLT__Tools__c = '{"Label": "Settings", "Type": "Link", "Action": "/apex/FieloPLT__PageSettingsView?objectName=' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;

			}

			if ( opciones.contains('Edit') && describeObject.isDeletable()){
				if ( hasEditForm ) {
					viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Edit + '", "Type": "Modal", "Action": "' + objectName + 'Form" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
				} else {
					viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Edit + '", "Type": "Action", "Action": "Edit", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
				}				
			}

			if ( opciones.contains('Delete') && describeObject.isUpdateable()){
//				viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.Delete + '", "CssClass": "slds-button--destructive fielosf-button__delete", "Confirm": true, "Type": "Remote", "Action": "FieloPLT.BackendHeaderRecordController.deleteRecord" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;
				viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.Delete + '", "CssClass": "slds-button--destructive fielosf-button__delete", "Confirm": true, "Type": "Action", "Action": "Delete", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;
			}

			if ( opciones.contains('View') ){
				viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.View + '", "Type": "Link", "Action": "/' + record.Id + '?nooverride=1" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',' + viewPS.FieloPLT__Tools__c);
			}									

		}
	}


/***** METODOS DE SOPORTE *****/
	private List<FieloPLT__PageSettings__c> getRelatedForms( Set<String> objects ) {
		List<String> settingType = new List<String> { 'Edit', 'New' };
        String query = 'SELECT FieloPLT__StandardActions__c, FieloPLT__Type__c, FieloPLT__Object__c, FieloPLT__Sections__c, FieloPLT__RecordType__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c IN :settingType AND FieloPLT__Object__c IN :objects ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
        	programId = activeProgram.Id;
        	query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        // ORDER BY & LIMIT 
        query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 100 ';         	
        return Database.query(query);        
    }   

/***** METODOS STATICOS DE SOPORTE *****/
	private static Map<String, String> mapLabels { get; set; }

    private static String translateLabel(String labelName ){ 
    	String labelValue;

    	if ( PageSettingsController.mapLabels == null ) {
    		PageSettingsController.mapLabels = new Map<String, String> { 'Edit' => Label.Edit, 'Delete' => Label.Delete, 'New' => Label.New };    		
    	}

    	if ( PageSettingsController.mapLabels.containsKey(labelName) ) {
    		labelValue =  PageSettingsController.mapLabels.get(labelName);
    	} else {
    		try {
				Component.Apex.OutputText output;
				output = new Component.Apex.OutputText();
				output.expressions.value = '{!$Label.' + labelName + '}';
				labelValue = string.valueOf(output.value);
    		} catch (Exception e) {}
			PageSettingsController.mapLabels.put( labelName, labelValue );    			
    	}
    	return labelValue;
    }
    
    public static String replaceFormula(String json , SObject record) { 
    	Pattern formulaRegEx = Pattern.compile('\\{\\!record.([a-z|A-Z|0-9].*?)\\}');
    	Pattern labelRegEx = Pattern.compile('\\{\\!\\$[Ll]abel.([a-z|A-Z|0-9].*?)\\}');
        if (  !String.isBlank(json) ) {
        	if ( record != null ) {
				Matcher m = formulaRegEx.matcher(json);

				// Usa un set en caso que se repita
				Set<String> apiNames = new Set<String>();
				while (m.find()) {
				    String formula = m.group();
				    String apiName = formula.substring(9,formula.length()-1);
				    if ( !apiNames.contains(apiName) ) {
		                if(record.get(apiName) != null){
		                    json = json.replace(formula, String.valueOf(record.get(apiName)));
		                } else {
		                    json = json.replace(formula, '');
		                }
				    	apiNames.add(apiName);
				    }
				}
			}
			Matcher ml = labelRegEx.matcher(json);
			// Usa un set en caso que se repita
			Set<String> labelNames = new Set<String>();
			while (ml.find()) {
			    String formula = ml.group();
			    String labelName = formula.substring(9,formula.length()-1);
			    if ( !labelNames.contains(labelName) ) {
                    json = json.replace(formula, translateLabel( labelName ) );
			    	labelNames.add(labelName);
			    }
			}

        }
        return json;
    }

	public static FieloPLT__PageSettings__c getLookupSetting( String objectNames, String targetObject, String targetField ) {        
        String query = 'SELECT FieloPLT__Filters__c, FieloPLT__Fieldset__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c = \'Lookup\'  AND FieloPLT__Object__c = :objectNames  ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
        	programId = activeProgram.Id;
        	query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        if ( String.isNotBlank(targetObject ) ) {
	        query += ' AND FieloPLT__TargetObject__c = :targetObject';
        } 
        if ( String.isNotBlank(targetField ) ) {
	        query += ' AND FieloPLT__TargetField__c = :targetField';
        }
        // ORDER BY & LIMIT 
        query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 1 ';

        List<FieloPLT__PageSettings__c> pageSetting = Database.query(query);

        return pageSetting.isEmpty() ? null : pageSetting.get(0);       
    }

	public static List<FieloPLT__PageSettings__c> getPageSettings( List<String> settingType, List<String> recordTypes, String objectName ) {
        
        String query = 'SELECT Name, FieloPLT__isActive__c, FieloPLT__Library__r.Name, FieloPLT__Icon__c, FieloPLT__OrderBy__c, FieloPLT__StandardRelated__c, FieloPLT__StandardActions__c, FieloPLT__Type__c, FieloPLT__RecordType__c, FieloPLT__Sections__c, FieloPLT__Fieldset__c, FieloPLT__TargetObject__c, FieloPLT__TargetField__c, FieloPLT__Tools__c, FieloPLT__Buttons__c, FieloPLT__Actions__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c IN :settingType  AND FieloPLT__Object__c = :objectName  ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
        	programId = activeProgram.Id;
        	query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        if ( recordTypes.isEmpty() ) {
	        // ORDER BY & LIMIT 
	        query += ' AND FieloPLT__RecordType__c = null ORDER BY FieloPLT__Type__c, FieloPLT__Order__c LIMIT 100 ';         	
        } else {
            query += 'AND ( FieloPLT__RecordType__c IN :recordTypes  OR FieloPLT__RecordType__c = null )';
	        // ORDER BY & LIMIT 
	        query += ' ORDER BY FieloPLT__Type__c, FieloPLT__RecordType__c, FieloPLT__Order__c LIMIT 100 ';         	
        }
        return Database.query(query);        
    }

}