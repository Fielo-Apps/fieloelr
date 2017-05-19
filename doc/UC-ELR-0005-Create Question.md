## Create Question

### Objectives 
This use case describes the creation of a Question

### Preconditions
The administrator must be logged in  
The related module is already created (Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md) already run)

### Postconditions
A question was created

### Flow of Events

### Basic Flow

1. The system receives the field values for the question
2. The administrator presses the Save button
3. The system verifies that the related module is not active
4. The system verifies that the Question Text field is not null
5. The system verifies that the Order field is not null
6. The system verifies that the “Correct Weight” field is valid
7. The system verifies that the “Incorrect Weight” field is valid
8. The system verifies that the “Penalty per Attempt” field is valid
9. The system verifies that the Type is “Single Choice” 
10. The system saves the question
11. The system displays the question detail page with the options to Edit or Delete
12. End of flow

### Alternative flows

##### 1. The related module is active (step 3 of basic flow)
   1. The system verifies that the related module is active
   2. The system does not save the question
   3. The system displays an error message
   4. End of flow

##### 2. “Question Text” field is null (step 4 of basic flow)
   1. The system verifies that the “Question Text” field is null
   2. The system does not save the question
   3. The system displays an error message
   4. End of flow

##### 3. "Order" field is null (step 5 of basic flow)
   1. The system verifies that the Order field is null
   2. The system automatically numbers the field Order
   3. Back to step 6 of basic flow

##### 4.“Correct Weight” field is null (step 6 of basic flow)
   1. The system verifies that the “Correct Weight” field is null
   2. The system automatically updates the “Correct Weight” field with value = 1
   3. Back to step 7 of basic flow

##### 5. “Correct Weight” field is negative (step 6 of basic flow)
   1. The system verifies that the "Correct Weight" field is not greater 0
   2. The system does not save the question
   3. The system displays an error message
   4. End of flow

##### 6. “Correct Weight” field is greater than zero and “Weighted Questions” of related module is “false” (step 6 of basic flow)
   1. The system verifies that the "Correct Weight" field is greater 0
   2. The system verifies that the “Weighted Questions” field of the related module is set to “false” 
   3. The system automatically updates the “Correct Weight” field with value = 1
   4. Back to step 7 of basic flow

##### 7. “Correct Weight” field is greater than zero and “Question Pool” of related module is different from null (step 6 of basic flow)
   1. The system verifies that the "Correct Weight" field is greater 0
   2. The system verifies that the “Question Pool” field of the related module is different from “null” 
   3. The system automatically updates the “Correct Weight” field with value = 1
   4. Back to step 7 of basic flow

##### 8. “Incorrect Weight” field is null (step 7 of basic flow)
   1. The system verifies that the “Incorrect Weight” field is null
   2. The system automatically updates the “Incorrect Weight” field with value = 0
   3. Back to step 8 of basic flow

##### 9. “Penalty per Attempt” field is null (step 8 of basic flow)
   1. The system verifies that the “Penalty per Attempt” field is null
   2. The system automatically updates the “Penalty per Attempt” field with value = 0
   3. Back to step 9 of basic flow

##### 10. “Penalty per Attempt” field is not valid (step 8 of basic flow)
   1. The system verifies that the "Penalty per attempt" field is not between 0 - 100
   2. The system does not save the question
   3. The system displays an error message
   4. End of flow

##### 11. Question “Type” is null (step 9 of basic flow)
   1. The system verifies that the Type field is null
   2. The system does not save the question
   3. The system displays an error message
   4. End of flow

##### 12. Question “Type” is “Statement” (step 9 of basic flow)
   1. The system verifies that the Type field is “Statement”
   2. The system saves the question
   3. The system displays the question detail page
   4. The system automatically creates the related answers “True” and “False”
   5. End of flow

##### 13. Question “Type” is “Multiple Choice” (step  9 of basic flow)
   1. The system verifies that the Type field is “Multiple Choice”
   2. Back to step 10 of basic flow

##### 14. Question “Type” is “Short Answer” (step 9 of basic flow)
   1. The system verifies that the Type field is “Short Answer”
   2. Back to step 10 of basic flow

##### 15. Question “Type” is “Fill in the blanks” and “Metadata Answer” is correctly filled (step 9 of basic flow)
   1. The system verifies that the Type field is “Fill in the blanks”
   2. The system verifies that “Metadata Answer” field is correctly filled (validate {} and [] characters)
   3. The system automatically fills the “Answer” field with the value of "Metadata Answer" field, where the metadata is replaced by the respective correct answers
   4. Back to step 10 of basic flow

##### 16. Question “Type” is “Fill in the blanks” and “Metadata Answer” is null (step 9 of basic flow)
   1. The system verifies that the Type field is “Fill in the blanks”
   2. The system verifies that “Metadata Answer” field is null
   3. The system does not save the question
   4. The system displays an error message
   5. End of flow

##### 17. Question “Type” is “Fill in the blanks” and “Metadata Answer” is not correct (step 9 of basic flow)
   1. The system verifies that the Type field is “Fill in the blanks”
   2. The system verifies that “Metadata Answer” field is not correctly filled (validation for {} and [] characters fails)
   3. The system does not save the question
   4. The system displays an error message
   5. End of flow
   
##### 18. Question “Type” is “Matching Options” (step 9 of basic flow)
   1. The system verifies that the Type field is “Matching Options”
   2. Back to step 10 of basic flow

##### 19. Delete question when related module is not active (step 11 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is not active
   3. The system deletes the question
   4. The system deletes all related answers
   5. End of flow

##### 20. Delete question when related module is active (step 11 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is active
   3. The system does not delete the question
   4. The system displays an error message
   5. End of flow

##### 21. Edit question when related module is not active (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is not active
   5. The system verifies that all other validations succeed
   6. The system updates the question
   7. The system displays the question detail page
   8. End of flow

##### 22. Edit question when related module is active (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is active
   5. The system does not update the question
   6. The system displays an error message
   7. End of flow

##### 23. Edit question when related module is not active (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is not active
   5. The system verifies that all other validations succeed
   6. The system updates the question
   7. Back to step 11 of basic flow

##### 24. Edit question when “Question Pool” of related module is different from null (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Correct Weight” to a value greater than 1
   3. The administrator presses the Save button
   4. The system verifies that the “Question Pool” field of the related module is different from null
   5. The system verifies that all other validations succeed
   6. The system automatically updates the “Correct Weight” field with value = 1
   7. The system updates the question
   8. The system displays the question detail page
   9. End of flow

##### 25. Edit question type (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Type” 
   3. The administrator presses the Save button
   4. The system does not update the question
   5. The system displays an error message
   6. End of flow
