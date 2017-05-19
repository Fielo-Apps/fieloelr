## Submit Module Response

### Objectives
This use case describes the module response calculations performed when it is submitted (IsSubmitted = TRUE)

### Preconditions
The module response is submitted (IsSubmitted = TRUE)

### Postconditions
The grade % was calculated for the module response  
The approval status was determined  
The course status progress was calculated

### Flow of Events

### Basic Flow
   1. The system verifies that the module dependency is correct 
   2. The system verifies that the related module status is active
   3. The system verifies that the “Number of Attempts” is equal or less than the “Attempts Allowed” per module
   4. The system verifies that the submission date is within the allowed period for the active related courses
   5. The system verifies that there are unsubmitted related questions and that the Question Pool is set to “null”
   6. The system sets, for each question response, its “IsSubmitted” field to “true”
   7. The system calls, for each question, the Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0011-Determine%20Question%20Response%20Correction.md)
   8. The system calls, for each question, the Use Case [*Submit Question Response*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0002-Submit%20Question%20Response.md)
   9. The system updates the “Grade Value” field by adding each question “Partial Grade Value”
   10. The system calculates the “Grade %” by dividing the “Grade Value” by the “Total Value”
   11. The system verifies that the “Grade %” is equal or higher than the “Approval Grade”
   12. The system sets the “IsApproved” field to “true”
   13. The system verifies that there is no other module response already approved for the member
   14. The system sets the “First Approved” field to “true”
   15. The system updates the Date with the submission date
   16. The system updates the module response
   17. The system calculates the quantity of modules that have one related module response where the “First Approved” field is set to “true” (the system considers only the first approval)
   18. The system calculates the course progress by dividing the quantity determined in the previous step by the course total number of modules
   19. The system verifies that the related course subscription mode is "Automatic" and the related course status already exists
   20. The system updates the “% Completed” field in Course Status with the previous step calculated value
   21. End of flow

### Alternative Flows

##### 1. The submission date is not within the course period (step 4 of basic flow)
   1. The system verifies that the submission date is out of the allowed period for the active related course
   2. The system does not update the module response
   3. The system displays an error message
   4. End of flow

##### 2. The module fails when not all the related questions are submitted and the Question Pool is set to “null” (step 11 of basic flow)
   1. The system verifies that the “Grade %” is less than the “Approval Grade”
   2. The system sets the “IsApproved” field to “false”
   3. The system updates the Date with the submission date
   4. The system updates the module response
   5. End of flow
   
##### 3. The module is approved when there are unsubmitted related questions and the Question Pool is not “null” (step 5 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” value is equal or greater than 1
   2. The system sets, for each question response, its “IsSubmitted” field to “true”
   3. The system calls, for each question, the Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0011-Determine%20Question%20Response%20Correction.md)
   4. The system calls, for each question, the Use Case [Submit Question Response](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0002-Submit%20Question%20Response.md)
   5. The system updates the “Grade Value” field by adding each question “Partial Grade Value”
   6. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   7. Back to step 11 of basic flow
   
##### 4. The module fails when there are unsubmitted related questions and the Question Pool is not “null” (step 5 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” value is equal or greater than 1
   2. The system sets, for each question response, its “IsSubmitted” field to “true”
   3. The system calls, for each question, the Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0011-Determine%20Question%20Response%20Correction.md)
   4. The system calls, for each question, the Use Case [Submit Question Response](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0002-Submit%20Question%20Response.md)
   5. The system updates the “Grade Value” field by adding each question “Partial Grade Value”
   6. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   7. The system verifies that the “Grade %” is less than the “Approval Grade”
   8. The system sets the “IsApproved” field to “false”
   9. End of flow   
   
##### 5. The module is approved when all the related questions are submitted and the Question Pool is set to “null” (step 5 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” is “null”
   2. Back to step 9 of basic flow
   
##### 6. The module fails when all the related questions are submitted and the Question Pool is set to “null” (step 5 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” is “null”
   2. The system updates the “Grade Value” field by adding each question “Partial Grade Value”  
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Total Value”
   4. The system verifies that the “Grade %” is less than the “Approval Grade”
   5. The system sets the “IsApproved” field to “false”
   6. End of flow

##### 7. The module is approved when all the related questions are submitted and the “Question Pool” is not null (step 5 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” value is equal or greater than 1
   2. The system calculates the “Grade Value” field by adding the partial grades of the questions
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   4. Back to step 11 of basic flow
   
##### 8. The module fails when all the related questions are submitted and the “Question Pool” is not null (step 5 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” value is equal or greater than 1
   2. The system calculates the “Grade Value” field by adding the partial grades of the questions
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   4. The system verifies that the “Grade %” is less than the “Approval Grade”
   5. The system sets the “IsApproved” field to “false”
   6. End of flow

##### 9. Related course subscription mode is "Automatic" and the related course status does not exist (step 19 of basic flow)
   1. The system verifies that the related course subscription mode is "Automatic" and the related course status does not exist
   2. The system automatically creates the Course status
   3. Back to step 20 of basic flow
