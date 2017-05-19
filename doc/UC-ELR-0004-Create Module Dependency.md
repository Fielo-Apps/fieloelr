## Create Module Dependency

### Objectives 
This use case describes the creation of a Module Dependency

### Preconditions
The administrator must be logged in
A module is already created (Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md) already run)

### Postconditions
A module dependency is created

### Flow of Events

### Basic Flow
   1. The system receives the dependency information
   2. The administrator presses the Save button
   3. The system verifies that Module field is not null
   4. The system verifies that Predecessor field is not null
   5. The system verifies that Module and Predecessor are different
   6. The system verifies that both module and predecessor are related to the same course
   7. The system verifies that there is no equal dependency already created (Module + Predecessor)
   8. The system saves the module dependency
   9. The system displays the module dependency detail page
   10. End of flow
 
### Alternative flows

##### 1. Module field is null (step 3 of basic flow)
   1. The system verifies that Module field is null
   2. The system does not save the module dependency
   3. The system displays an error message
   4. End of flow

##### 2. Predecessor field is null (step 4 of basic flow)
   1. The system verifies that Predecessor field is null
   2. The system does not save the module dependency
   3. The system displays an error message
   4. End of flow

##### 3. Module and Predecessor are the same (step 5 of basic flow)
   1. The system verifies that Module and Predecessor are the same
   2. The system does not save the module dependency
   3. The system displays an error message
   4. End of flow

##### 4. Module and Predecessor are not related to the same course (step 6 of basic flow)
   1. The system verifies that module and predecessor are not related to the same course
   2. The system does not save the module dependency
   3. The system displays an error message
   4. End of flow
##### 5. There is already a module dependency with the same modules (step 7 of basic flow)
   1. The system verifies that there is already a dependency with the same modules (Module + Predecessor)
   2. The system does not save the module dependency
   3. The system displays an error message
   4. End of flow

##### 6. Module dependency is edited (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the Module and/or the Predecessor
   3. Back to step 2 of basic flow
