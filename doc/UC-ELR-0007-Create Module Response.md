## Create Module Response

### Objectives 
This use case describes the creation of a Module Response

### Preconditions
The administrator must be logged in  
The related module is already created (Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md) already run)

### Postconditions
A module response was created

### Flow of Events

### Basic Flow
   1. The system receives the field values for the module response
   2. The administrator presses the Save button
   3. The system verifies that the “Module” lookup field is not null
   4. The system automatically completes the “Number of Attempts” field
   5. The system verifies that the “Number of Attempts” is equal or less than the “Attempts Allowed” of the related module
   6. The system verifies that “Member” field is not null
   7. The system verifies that the member is approved in the predecessors modules
   8. The system verifies that the related course subscription mode is manual and the related course status already exists
   9. The system saves the module response
   10 The system displays the module response detail page
   11. End of flow

### Alternative flows

##### 1. Module lookup field is null (step 3 of basic flow)
   1. The system verifies that the Module field is null
   2. The system does not create the module response
   3. The system displays an error message
   4. End of flow

##### 2. Number of Attempts is greater than the “Attempts Allowed” of related module (step 5 of basic flow)
   1. The system verifies that the “Number of Attempts” is greater than the “Attempts Allowed” of related module
   2. The system does not create the module response
   3. The system displays an error message
   4. End of flow

##### 3. Member field is null (step 6 of basic flow)
   1. The system verifies that the Member field is null
   2. The system does not create the module response
   3. The system displays an error message
   4. End of flow

##### 4. Member is not approved in the predecessors modules (step 7 of basic flow)
   1. The system verifies that the Member is not approved in the predecessors modules
   2. The system does not create the module response
   3. The system displays an error message
   4. End of flow

##### 5. The related course subscription mode is manual and the course status does not exist (step 8 of basic flow)
   1. The system verifies that the related course subscription mode is manual and the related course status does not exists
   2. The system does not create the module response
   3. The system displays an error message
   4. End of flow
   
##### 6. The related course subscription mode is automatic and the course status already exists (step 8 of basic flow)
   1. The system verifies that the related course subscription mode is automatic and the related course status already exists
   2. Back to step 9 of basic flow

##### 7. The related course subscription mode is automatic and the course status does not exist (step 8 of basic flow)
   1. The system verifies that the related course subscription mode is automatic and the related course status does not exists
   2. The system saves the module response
   3. The system displays the module response detail page
   4. The system automatically creates the related course status
   5. End of flow
   
##### 8. Delete a module response not submitted (step 10 of basic flow)
   1. The administrator presses the Delete button of a module response not submitted 
   2. The system deletes the module response
   3. The system deletes all related questions responses and answers responses
   4. End of flow

##### 9. Delete a module response already submitted (step 10 of basic flow)
   1. The administrator presses the Delete button of a module response already submitted
   2. The system does not delete the module response
   3. The system displays an error message
   4. End of flow
   
##### 10. Edit a module response not submitted (step 10 of basic flow)
   1. The administrator presses the Edit button of a module response not submitted 
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system saves the module response
   5. The system displays the module response detail page
   6. End of flow
   
##### 11. Edit a module response already submitted (step 10 of basic flow)
   1. The administrator presses the Edit button of a module response already submitted 
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system does not save the module response
   5. The system displays an error message
   6. End of flow

##### 12. Submit a module response (step 10 of basic flow)
   1. The administrator presses the Edit button of a module response not submitted
   2. The administrator changes the field “IsSubmitted” from “false” to “true”
   3. The system calls the use case [*Submit Module Response*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0010-Submit%20Module%20Response.md)
   4. End of flow
