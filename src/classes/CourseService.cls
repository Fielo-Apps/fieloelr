public with sharing class CourseService {
	public static List<Course__c> getCourses(Set<String> fields, Set<String> status, Id programId, Integer quantity, Integer offset, String orderBy) {   
		String query = 'SELECT ' + String.join(new List<String>(fields), ',') + ' FROM Course__c ';
		// WHERE CONDITION 
		String whereCondition = '';
		if (programId != null) {
			whereCondition += 'AND Program__c =: programId ';
		}
		if (status != null) {
			whereCondition += 'AND Status__c IN :status ';
		}
		if ( whereCondition != '' ) {
			query += ' WHERE ' + whereCondition.substring(4);
		}
		// ORDER BY,  LIMIT & OFFSET
		if( String.isNotBlank(orderBy) ){
			query += ' ORDER BY ' + orderBy;
		}
		if(quantity != null){
			query += ' LIMIT ' + quantity;

			if(offset != null){
				query += ' OFFSET ' + offset;
			}
		}

		return Database.query(query);
	}
}