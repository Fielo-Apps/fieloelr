## Determine Question Response Correction

### Objectives
This use case determines the question response correction when the question response is submitted (IsSubmitted = TRUE)

### Preconditions
The question response is submitted (IsSubmitted = TRUE)

### Postconditions
The question correction was determined

### Flow of Events

### Basic Flow 
   1. The system verifies that the question is from type “Single Choice”
   2. The system verifies that the answer response is the same as the correct answer
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

### Alternative Flows

##### 1. The question is from type “Single Choice” and the answer is not correct (step 2 of basic flow)
   1. The system verifies that the answer response is not the same as the correct answer
   2. The system sets the “IsCorrect” to “false”
   3. End of flow

##### 2. The question is from type “Multiple Choice” and all the answers are correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Multiple Choice”
   2. The system verifies that all answer responses match the correct answers
   3. The system verifies that no answer response is missing
   4. The system sets the “IsCorrect” field to “true”
   5. End of flow

##### 3. The question is from type “Multiple Choice” and not all the answers are correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Multiple Choice”
   2. The system verifies that at least one of the answer responses don’t match the correct answers
   3. The systems sets the “IsCorrect” field to “false”
   4. End of flow

##### 4. The question is from type “Short Answer” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Short Answer”
   2. The system verifies that the “Text Value” field in the question response matches one of the possible correct answers
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

##### 5. The question is from type “Short Answer” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Short Answer”
   2. The system verifies that the “Text Value” field in the question response does not match any of the possible correct answers
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow

##### 6. The question is from type “Statement” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Statement”
   2. The system verifies that the answer response is the same as the correct answer
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

##### 7. The question is from type “Statement” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Statement”
   2. The system verifies that the answer response is not the same as the correct answer
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow

##### 8. The question is from type “Fill in the Blanks” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Fill in the blanks”
   2. The system verifies that the “Text Value” field in the question response matches the “Answer” field in the related question
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

##### 9. The question is from type “Fill in the Blanks” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Fill in the blanks”
   2. The system verifies that the “Text Value” field in the question response does not match the “Answer” field in the related question
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow

##### 10. The question is from type “Matching Options” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Matching Options”
   2. The system verifies that “Matching Answer” field matches the “Answer text” field in the related answer
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

##### 10. The question is from type “Matching Options” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Matching Options”
   2. The system verifies that the “Matching Answer” field does not match the “Answer text” field in the related answer
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow
