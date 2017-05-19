## Create Question Response

### Objectives 
This use case describes the creation of a Question Response

### Preconditions
The administrator must be logged in  
The module response is already created (Use Case [*Create Module Response*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0007-Create%20Module%20Response.md) already run)

### Postconditions
A question response was created

### Flow of Events

### Basic Flow
   1. The system receives the field values for the question response
   2. The administrator presses the Save button
   3. The system verifies that the related module response is not submitted
   4. The system verifies that the “Question” lookup field is not null
   5. The system automatically completes the “Number of Attempts” field
   6. The system verifies that the “Number of Attempts” is equal or less than the “Attempts Allowed per Question” of the related module
   7. The system saves the question response
   8. The system displays the question response detail page 
   9. End of flow

### Alternative flows
##### 1. The related module is already submitted (step 3 of basic flow)
   1. The system verifies that the related module is submitted
   2. The system does not create the question response
   3. The system displays an error message
   4. End of flow
##### 2. Question lookup field is null (step 4 of basic flow)
   1. The system verifies that the Question field is null
   2. The system does not create the question response
   3. The system displays an error message
   4. End of flow

##### 3. Number of Attempts is greater than the “Attempts Allowed per Question” of related module (step 6 of basic flow)
   1. The system verifies that the “Number of Attempts” is greater than the “Attempts Allowed per Question” of related module
   2. The system does not create the question response
   3. The system displays an error message
   4. End of flow

##### 4. Delete a question response not submitted (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the question response is not submitted
   3. The system deletes the question response
   4. The system deletes all related answers responses
   5. End of flow

##### 5. Delete a question response already submitted (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the question response is submitted
   3. The system does not delete the question response
   4. The system displays an error message
   5. End of flow

##### 6. Edit a question response not submitted (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the question response is not submitted
   5. The system verifies that all other validations succeed
   6. The system updates the question response
   7. The system displays the question response detail page 
   8. End of flow

##### 7. Edit a question response already submitted (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the question response is submitted
   5. The system does not update the question response
   6. The system displays an error message
   7. End of flow

##### 8. Submit a question response when there is no correct question response for the related question (step 8 of basic flow)
   1. The administrator presses the Edit button 
   2. The administrator changes the field “IsSubmitted” from “false” to “true”
   3. The system verifies that the related question doesn’t have another correct question response
   4. The system calls the use case [*Submit Question Response*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0012-Submit%20Question%20Response.md)
   5. The system updates the question response
   6. The system displays the question response detail page
   7. End of flow

##### 9. Submit a question response when there is already another correct question response for the related question (step 7 of basic flow)
   1. The administrator presses the Edit button 
   2. The administrator changes the field “IsSubmitted” from “false” to “true”
   3. The system verifies that the related question has already another correct question response
   4. The system does not update the question response
   5. The system displays an error message
   6. End of flow
