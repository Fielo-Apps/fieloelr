## Create Course

### Objectives 
This use case describes the creation of a Course

### Preconditions
The administrator must be logged in

### Postconditions
A course is created

### Flow of Events

### Basic Flow

   1. The system receives the field values for the course
   2. The administrator presses the Save button
   3. The system verifies that the “Program” field is filled
   4. The system verifies that the “Segment” belongs to the “Program” already set
   5. The system sets the course status to “Draft”
   6. The system saves the course
   7. The system displays the course detail page with the options to Edit or Delete
   8. End of flow

### Alternative flows

##### 1. The Program is not filled (step 3 of basic flow)
   1. The system verifies that the Program is not set
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow

##### 2. The segment is not from the same program (step 4 of basic flow)
   1. The system verifies that the segment does not belong to the program set to the course
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow

##### 3. Activate a course that has active related modules (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Active”
   3. The administrator presses the Save button
   4. The system verifies that there is, at least, one active related module
   5. The system verifies that all other validations succeed
   6. The system activates the course
   7. The system displays the course detail page
   8. End of flow

##### 4. Activate a course that has no active related modules (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Active”
   3. The administrator presses the Save button
   4. The system verifies that there is no active related modules
   5. The system does not activate the course
   6. The system displays an error message 
   7. End of flow

##### 5. Edit a draft course (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except change the status)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Draft”
   5. The system verifies that all other validations succeed
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow

##### 6. Edit an active course with no related course statuses (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has no related course status
   6. The system verifies that all other validations succeed
   7. The system updates the course
   8. The system displays the course detail page
   9. End of flow

##### 7. Edit an active course with related course statuses (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the course
   7. The system displays an error message
   8. End of flow

##### 8. Delete an active course with no related course statuses (step 7 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the course has no related course status
   3. The system deletes the course
   4. The system deletes the related course dependencies
   5. The system deletes the related course modules
   6. End of flow

##### 9. Delete an active course with related course statuses (step 7 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the course has related course status
   3. The system does not delete the course
   4. The system displays an error message
   5. End of flow

##### 10. Inactivate an active course with no related course statuses (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Inactive” 
   3. The administrator presses the Save button
   4. The system verifies that the course has no related course status
   5. The system verifies that all other validations succeed
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow

##### 11. Inactivate an active course with related course statuses (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Inactive” 
   3. The administrator presses the Save button
   4. The system verifies that the course has related course status
   5. The system does not update the course
   6. The system displays an error message
   7. End of flow

##### 12. Edit an inactive course (step 7 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except change the status)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Inactive”
   5. The system verifies that all other validations succeed
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow
