## Create Course Dependency

### Objectives 
This use case describes the creation of a Course Dependency

### Preconditions
The administrator must be logged in  
Two courses were already created for the same program (Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md) already run)

### Postconditions
A course dependency is created

### Flow of Events

### Basic Flow
   1. The system receives the dependency information
   2. The administrator presses the Save button
   3. The system verifies that Course field is not null
   4. The system verifies that Predecessor field is not null
   5. The system verifies that Course and Predecessor are different
   6. The system verifies that both course and predecessor are related to the same program
   7. The system verifies that there is no equal dependency already created (Course + Predecessor)
   8. The system saves the course dependency
   9. The system displays the module dependency detail page
   10. End of flow
 
### Alternative flows

##### 1. Course field is null (step 3 of basic flow)
   1. The system verifies that Course field is null
   2. The system does not save the course dependency
   3. The system displays an error message
   4. End of flow

##### 2. Predecessor field is null (step 4 of basic flow)
   1. The system verifies that Predecessor field is null
   2. The system does not save the course dependency
   3. The system displays an error message
   4. End of flow

##### 3. Course and Predecessor are the same (step 5 of basic flow)
   1. The system verifies that Course and Predecessor are the same
   2. The system does not save the course dependency
   3. The system displays an error message
   4. End of flow

##### 4. Course and Predecessor are not related to the same program (step 6 of basic flow)
   1. The system verifies that course and predecessor are not related to the same program
   2. The system does not save the course dependency
   3. The system displays an error message
   4. End of flow
##### 5. There is already a course dependency with the same courses (step 7 of basic flow)
   1. The system verifies that there is already a dependency with the same courses (Course + Predecessor)
   2. The system does not save the course dependency
   3. The system displays an error message
   4. End of flow

##### 6. Course dependency is edited (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the Course and/or the Predecessor
   3. Back to step 2 of basic flow
