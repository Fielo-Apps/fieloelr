## Create Answer Response

### Objectives 
This use case describes the creation of an Answer Response

### Preconditions
The administrator must be logged in  
The question reponse was created

### Postconditions
An Answer response was created

### Flow of Events

### Basic Flow
   1. The system receives the field values for the answer response
   2. The administrator presses the Save button
   3. The system verifies that the related question type is not “Matching Options”
   4. The system verifies that the “Answer” lookup field is not null
   5. The system saves the answer response
   6. The system displays the answer response detail page
   7. End of flow

### Alternative flows

##### 1. The related question type is “Matching Options” (step 3 of basic flow)
   1. The system verifies that the related question type is “Matching Options”
   2. Back to step 5 of basic flow

##### 2. The “Answer” lookup field is null (step 4 of basic flow)
   1. The system verifies that the “Answer” lookup field is null
   2. The system does not create the answer response
   3. The system displays an error message
   4. End of flow

##### 3. Delete answer response when the related question response is not submitted (step 6 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related question response is not submitted
   3. The system deletes the answer response
   4. End of flow

##### 4. Delete answer response when the related question response is already submitted (step 6 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related question response is submitted
   3. The system does not delete the answer response
   4. The system displays an error message
   5. End of flow

##### 5. Edit answer response when the related question response is not submitted (step 6 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related question response is not submitted
   5. The system verifies that all other validations succeed
   6. The system updates the answer response
   7. The system displays the answer response detail page 
   8. End of flow

##### 6. Edit answer response when the related question response is already submitted (step 6 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related question response is submitted
   5. The system does not update the answer response
   6. The system displays an error message
   7. End of flow
