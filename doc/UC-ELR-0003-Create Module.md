## Create Module

### Objectives 
This use case describes the creation of a Module

### Preconditions
The administrator must be logged in  
The related course is already created (Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md) already run)

### Postconditions
A module is created

### Flow of Events

### Basic Flow

1. The system receives the required fields for the module
2. The system receives the optional fields for the module
3. The administrator presses the Save button
4. The system verifies that the module has a related course in status “Draft”
5. The system verifies that the Approval Grade is between 0 and 100
6. The system verifies that the “Question Pool” is not “null” and the “Weighted Questions” is set to false
7. The system verifies that the IsActive field is set to “false”
8. The system verifies that the “Attempts Allowed” is “null” or greater than 0
9. The system verifies that the “Attempts Allowed per Question” is “null” or greater than 0
10. The system creates the module
11. The system displays the module detail page 
12. End of flow

### Alternative flows

##### 1. The module does not have a related course (step 4 of basic flow)
   1. The system verifies that the module does not have a related course
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 2. The Approval Grade is invalid (step 5 of basic flow)
   1. The system verifies that the Approval Grade is not between 0 and 100
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 3. The system verifies that "question pool" is not "null" and "weighted questions" is true. (step 6 of basic flow)
   1. The system verifies that "question pool" is different from "null" and "weighted questions" is set to true
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 4. Create an active module (step 7 of basic flow)
   1. The system verifies that IsActive field is set to “true”
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 5. The number of “Attempts Allowed” is negative (step 8 of basic flow)
   1. The system verifies that the “Attempts Allowed” field value is negative
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 6. The number of “Attempts Allowed per Question” is negative (step 9 of basic flow)
   1. The system verifies that the “Attempts Allowed per Question” field value is negative
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 7. The administrator edits a non active module without changing the “Question Pool”, “Weighted Questions” or “Penalty Mode” fields (step 11 of basic module)
   1. The administrator presses the Edit button
   2. The system verifies that the IsActive field is set to “false”
   3. The system verifies that the module has a related course
   4.. The system verifies that the Approval Grade is between 0 and 100
   5. The system verifies that question pool is not used used when the questions have weighted questions
   6. The system verifies that the “Attempts Allowed” is “null” or greater than 0
   7. The system verifies that the “Attempts Allowed per Question” is “null” or greater than 0
   8. The system verifies that the “Weighted Questions” field was not changed
   9. The system verifies that the “Penalty Mode” field was not changed
   10. The administrator presses the Save button
   11. The system updates the module
   12. The system displays the module detail page
   13. End of flow

##### 8. The administrator edits a non active module changing the “Question Pool” field from “null” to “not null” (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Question Pool” field from “null” by filling it with a number greater than 0
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Correct Weight” fields from the related questions with the value 1
   6. End of flow

##### 9. The administrator edits a non active module changing the “Weighted Questions” field from “true” to “false” (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Weighted Questions” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Correct Weight” fields from the related questions with the value 1
   6. End of flow

##### 10. The administrator edits a non active module changing the “Penalty Mode” field from "Percent Decrease" to "Incorrect Weight" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Percent Decrease" to "Incorrect Weight"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Percent decrease” fields from the related questions with the value 0
   6. End of flow

##### 11. The administrator edits a non active module changing the “Penalty Mode” field from "Percent Decrease" to "None" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Percent Decrease" to "None"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Percent decrease” fields from the related questions with the value 0
   6. End of flow

##### 12. The administrator edits a non active module changing the “Penalty Mode” field from "Incorrect Weight" to "Percent decrease" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Incorrect Weight" to "Percent Decrease"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Incorrect Weight” fields from the related questions with the value 0
   6. End of flow

##### 13. The administrator edits a non active module changing the “Penalty Mode” field from "Incorrect Weight" to "None" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Incorrect Weight" to "None"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Incorrect Weight” fields from the related questions with the value 0
   6. End of flow

##### 14. The administrator edits an active module (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the value of any field except of the “IsActive” field
   3. The system verifies that the IsActive field is set to “true”
   4. The system does not update the module
   5. The system displays an error message
   6. End of flow

##### 15. The administrator activates a module (step 11 of basic module)
   1. The administrator presses the Edit button
   2. The administrator sets the IsActive field to “true”
   3. The administrator presses the Save button
   3. The system verifies that the module has a related course
   5. The system verifies that the Approval Grade is between 0 and 100
   6. The system verifies that question pool is not used used when the questions have weighted questions
   7. The system verifies that the “Attempts Allowed” is “null” or greater than 0
   8. The system verifies that the “Attempts Allowed per Question” is “null” or greater than 0
   9. The system verifies that the weighted questions field was not changed
   10. The system verifies that the Penalty mode field was not changed
   11. The system verifies that the module has, at least, one related question
   12. The system verifies that the related questions from type “Statement”, “Single Choice”, “Multiple Choice” and “Matching” have at least one related answer
   13. The system verifies that the related questions from type “Statement” and “Single Choice” have a correct answer
   14. The system updates the module
   15. End of flow

##### 16. The administrator deletes a non active module (step 11 of basic module)
   1. The administrator presses the Delete button of a non active module
   2. The system deletes the module
   3. The system deletes the module dependencies
   4. The system deletes all related questions and answers
   4. End of flow

##### 17. The administrator deletes an active module without related module responses (step 11 of basic flow)
   1. The administrator presses the Delete button of an active module
   2. The system verifies that the module has no related module responses
   3. The system deletes the module
   4. The system deletes the module dependencies
   5. The system deletes all related questions and answers
   6. End of flow

##### 18. The administrator deletes an active module that has related module responses (step 11 of basic flow)
   1. The administrator presses the Delete button of an active module that has related module responses
   2. The system verifies that the module has related module responses
   3. The system does not delete the module
   4. The system displays an error message
   5. End of flow

##### 19. The administrator inactivates a module without related module responses (step 11 of basic flow)
   1. The administrator presses the Edit button of an active module
   2. The administrator changes the “IsActive” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system verifies that the module has no related module responses
   5   The system updates the module
   6. End of flow

##### 20. The administrator inactivates a module that has related module responses (step 11 of basic flow)
   1. The administrator presses the Edit button of an active module
   2. The administrator changes the “IsActive” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system does not update the module
   5. The system displays an error message
   6. End of flow
