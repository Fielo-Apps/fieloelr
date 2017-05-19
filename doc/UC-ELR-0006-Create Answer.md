## Create Answer

### Objectives 
This use case describes the creation of an Answer

### Preconditions
The administrator must be logged in  
The related question is already created (Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md) already run)

### Postconditions
An answer was created

### Flow of Events

### Basic Flow
   1. The The system receives the field values for the answer
   2. The administrator presses the Save button
   3. The system verifies that the related module is not active
   4. The system verifies that the “Answer Text” field is not null
   5. The system verifies that the “Order” field is valid
   6. The system verifies that the related question “Type” is “Multiple Choice”
   7. The system saves the answer
   8. The system displays the answer detail page
   9. End of flow

### Alternative flows

##### 1. The related module is active (step 3 of basic flow)
   1. The system verifies that the related module is active
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow

##### 2. “Answer Text” field is null (step 4 of basic flow)
   1. The system verifies that the “Answer Text” field is null
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow

##### 3. “Order” field is null (step 5 of basic flow)
   1. The system verifies that the Order field is null
   2. The system automatically numbers the Order field
   3. Back to step 6 of basic flow

##### 4. Related question “Type” is “Statement” (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Statement”
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow

##### 5. Related question “Type” is “Single Choice” and no other answer was defined as correct (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Single Choice”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that no other answer of the same related question has its “IsCorrect” field set to “true”
   4. Back to step 7 of basic flow
   
##### 6. Related question “Type” is “Single Choice” and another answer was defined as correct (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Single Choice”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that there is another answer of the same related question that has its “IsCorrect” field set to “true”
   4. The system does not create the answer
   5. The system displays an error message
   6. End of flow

##### 7. Related question “Type” is “Short Answer” (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Short Answer”
   2. Back to step 7 of basic flow

##### 8. Related question “Type” is “Matching Options” and “Answer Text” format is correct (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the format of “Answer Text” field is correct (validates {"xx":"yy"})
   3. Back to step 7 of basic flow

##### 9. Related question “Type” is “Matching Options” and “Answer Text” format is incorrect (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the format of “Answer Text” field is incorrect
   3. The system does not create the answer
   4. The system displays an error message
   5. End of flow

##### 10. Delete answer when related module is not active (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is not active
   3. The system deletes the answer
   4. End of flow

##### 11. Delete answer when related module is active (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is active
   3. The system does not delete the answer
   4. The system displays an error message
   5. End of flow

##### 12. Edit answer when related module is not active (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is not active
   5. The system verifies that all other validations succeed
   6. The system updates the answer
   7. The system displays the answer detail page
   8. End of flow

##### 13. Edit answer when related module is active (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is active
   5. The system does not save the answer
   6. The system displays an error message
   7. End of flow
   
##### 14. Set correct answer for question Type “Statement” and no other answer is defined as correct (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsCorrect” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the related question “Type” is “Statement”
   5. The system verifies that no other answer of the same related question has its “IsCorrect” field set to “true”
   6. The system updates the answer
   7. The system displays the answer detail page
   8. End of flow

##### 15. Set correct answer for question Type “Statement” and another answer is defined as correct (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsCorrect” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the related question “Type” is “Statement”
   5. The system verifies that there is another answer of the same related question that has its “IsCorrect” field set to “true”
   6. The system does not create the answer
   7. The system displays an error message
   8. End of flow
