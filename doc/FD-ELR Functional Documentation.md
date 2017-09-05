# ELR Functional Documentation
## 1. Creating the course
In the Courses Landing Page, click the New button and fill in the fields below:
 - **Course Name** - This field has a maximum limit of 80 characters.
 - **Program** - By default, this field is automatically filled with the program already chosen in the Program selector. If there is more than one program, the administrator can select another one. If the field is left in blank, it will be set automatically to the program already chosen in the Program selector.
 - **Segment** - Select in the left area the segments that must apply for the course, so that only members that match the conditions under the segments are eligible to join the course. After selecting each desired segment, press the right arrow.
 - **Subscription Mode** - When selecting the *Manual* option, the member is required to subscribe the Course before taking any of its modules. Selecting *Automatic* option, allows the member to directly take any of the modules, respecting their dependencies. In case that the Automatic subscription mode is selected, the system automatically subscribes the member to the course.
 > At CMS, the **Manual** subscription mode will is represented by a Join action button for the course. If the member tries to take a module before joining the course, he will receive a message. For the **Automatic** subscription mode, the course has a View action button. The course is joined automatically when the member presses the *Take* button of the one of its modules. 
 - **Description** - This field has a maximum limit of 255 characters.
 - **Start Date** - This field must be filled in if the course has a specific date to start. This date cannot be earlier than the current date.
 - **End Date** - This field must be filled in if the course has a specific date to finish. This date cannot be earlier than the current date nor earlier than the Start Date, if a period is defined.   
 
After pressing the *Save* button, the course is set to the status *Draft* and the administrator will be directed to the course detail page, Where he can proceed with the creation of course structure. 

## 2. Creating the modules
In the Course details page, go to the Modules related list and click the New button. Fill in the following fields:
- **Module Name** - This field has a maximum limit of 80 characters.
- **Description** - This field has a maximum limit of 255 characters.
- **Approval Grade** - This is the minimum percentage of module grade that member should receive in order to be approved, after finishing the module. This value may vary from 0 to 100.
- **Attempts Allowed** - Number of attempts that member can take the module. If left blank, this means that the member can resume the module indefinitely, until the course is inactivated or has reached its end date.  
 After pressing the *Save* button, the administrator will be directed to the module detail page. At this point, the administrator can go back to the course details page to create the basic details for the remaining modules or stay on the module details page in order to continuing the module creation process, creating its questions and completing the residual settings.
 
## 3. Creating the questions
 In the Module details page, go to the Questions related list and click the New button.
 The first page of the Question Wizard will be displayed for type selection.
 There are five types of questions:
- *Multiple Choice* - Multiple answer options can be defined as correct. 
- *Single Choice* - One and only one answer option can be defined as correct.  
  :point_right: If no answer option is defined as correct, the module cannot be activated.
- *Short Answer* - In this type of question, all the possible answers for the question must be configured. For example, if you have a question that can be answered with a number, set as answer options the number written in figures, in word form, in capitals and so on. All the included answer options are automatically considered correct, so there is no need to configure this.
- *Statement* - This type of question admits only two answer options: True or False. They cannot be changed, but they can have its correction defined.  
  :point_right: If no answer option is defined as correct, the module cannot be activated.
- *Matching Options* - For each answer option, there is a matching pair. Each combination of answer option x matching pair is considered correct. It's possible to set a matching pair without an answer option, in order to give the member more alternatives of combination. In this case, the combination of "no answer option" x "existing matching pair" is not considered as correct.
 
### 3.1. Creating the Multiple Choice question
In the first page of the Question Wizard, select the *Multiple Choice* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the first 20 characters of the Question Text.
- **Shuffle Answer Options** - When this field is set to "true", the system will display the answer options in a different order each time the member makes a new allowed attempt for the question.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Multiple Choice questions, the answer option text fields represent the alternatives of answers that will be displayed for the member. This field has a maximum limit of 255 characters.  
 > At CMS, these alternatives are preceded by checkboxes, enabling the member to select one or more answers.
- **Is Correct** - When it is set to "true", indicates that the answer option is correct. When it is set to "false", indicates that the answer is not correct.  

:point_right: 1. It is possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 2. Any of the included answer options can be removed by clicking the *remove* icon (:heavy_multiplication_x:) in its right side.  
:point_right: 3. It's possible to reorder the answer option text fields and their corresponding corrections by dragging them and dropping them in the desired order.

It is possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### 3.2. Creating the Single Choice question
In the first page of the Question Wizard, select the *Single Choice* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the first 20 characters of the Question Text.
- **Shuffle Answer Options** - When this field is set to "true", the system will display the answer options in a different order each time the member makes a new allowed attempt for the question.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Single Choice questions, the answer option text fields represent the alternatives of answers that will be displayed for the member. This field has a maximum limit of 255 characters.  
 > At CMS, these alternatives are preceded by radio buttons, enabling the member to select only one answer.
- **Is Correct** - When it is set to "true", indicates that the answer option is correct. When it is set to "false", indicates that the answer is not correct.

:point_right: 1. As already mentioned, for Single Choice questions only one answer option can be defined as correct.  
:point_right: 2. It's possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 3. Any of the included answer options can be removed by clicking the *remove* icon (:heavy_multiplication_x:) in its right side.  
:point_right: 4. It's possible to reorder the answer option text fields and their corresponding corrections by dragging them and dropping them in the desired order.

It is possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### 3.3. Creating the Short Answer question
In the first page of the Question Wizard, select the *Short Answer* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the first 20 characters of the Question Text.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Short Answer questions, the answer option text fields represent the possible ways of response. It must be included all the alternatives of answers that will be accepted as correct. This field has a maximum limit of 255 characters.  
 > At CMS, these alternatives are not shown, but a field for the member to input the answer.

:point_right: 1. In the *Short Answer* question, the option *Shuffle Answer Options* is not displayed since the answer options are not available to the member.  
:point_right: 2. In this type of question, the *Is Correct* field is not displayed as well because all the answer options are automatically set as "true" by the system.  
:point_right: 3. It's possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 4. Any of the included answer options can be removed by clicking the *remove* icon (:heavy_multiplication_x:) in its right side.  
:point_right: 5. Since the answer options are not displayed to the member, the reorder functionality is not available for this type of question.

It is possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### 3.4. Creating the Statement question
In the first page of the Question Wizard, select the *Statement* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the first 20 characters of the Question Text.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Statement questions, the two possible answer option text fields are automatically created: True and False.    
 > At CMS, these alternatives are preceded by radio buttons, enabling the member to select only one answer.
- **Is Correct** - When it is set to "true", indicates that the answer option is correct. When it is set to "false", indicates that the answer is not correct.

:point_right: In the *Statement* question, the option *Shuffle Answer Options* is not displayed.  

It is possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### 3.5. Creating the Matching Options question
In the first page of the Question Wizard, select the *Matching Options* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the first 20 characters of the Question Text.
- **Shuffle Answer Options** - When this field is set to "true", both answer option text and matching text fields will be randomly displayed by the system, at CMS. If it is set to "false", only the matching text fields will be randomly displayed.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the *Matching Options* questions, these fields represent the items that demand correlation. This field has a maximum limit of 255 characters.  
- **Matching Text** - These are the options that will be provided for correlation. This field has a maximum limit of 255 characters.
 
:point_right: 1. The system automatically sets to "true" the *Is Correct* field of the pairs having answer option text field filled in. On the other hand, pairs which have no answer option text field filled in have their *Is Correct* field set to "false".  
:point_right: 2. It's possible to create as many answer option text fields x matching text as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 3. It's possible to have pairs which contains only the matching text, but the opposite is not allowed.  
:point_right: 4. Any of the included answer options (meaning the pair answer option text x matching text) can be removed by clicking the *remove* icon (:heavy_multiplication_x:) in its right side.  
:point_right: 5. The reorder functionality is not available for this type of question.

It is possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

## 4. Managing questions
In the Module details page, a button named *Manage* can be found. By using this functionality, the administrator will be able to settle some configurations to the Module, define few Global Question setup and assign some parameter values to individual questions.  
After configuring the items below, the administrator presses the *Save* button and the system refreshes the Module details page.

### 4.1. Choosing the Penalty Mode
Every time the member incorrectly answers a question, the system may penalize him or not for the wrong answer. There are three possible ways to deal with wrong answers:

- **None**: In this mode, no penalty is applied to the member when he incorrectly answers a question. That means that his grade for that question will be 0 (zero) every time he answers wrongly. As soon as he answers the question correctly, the grade of the question will be the full value defined for the field *Correct Weight*. 
  - Example: Suppose that a question has a *Correct Weight* set to 10. If it has 3 (three) attempts allowed per question and the member incorrectly answers the first 2 (two) attempts and correctly answers the third one, he will have the following partial grades:  
    0 + 0 + 10 = 10
- **Percent Decrease**: In this mode, the member is penalized for each attempt when he gives an incorrect answer for the question. When he finally answers correctly, his grade is given by diminishing, for each wrong attempt, a percentage value of his partial grade.  
   When selecting this mode, the system enables the global question *Penalty per Attempt* field, allowing the administrator to give the same penalty value to all questions of the module. This option applies to a module with non weighted questions - all questions have the same *Correct Weight* that equals to 1 (one).  
   For the modules where each question needs to have different weights, the administrator has to set the *Weighted Questions* field to "true". This way, the system enables the fields *Correct Weight* and *Penalty per Attempt* for each individual question.  
   The value inputted in the Penalty per Attempt field (global or individual) defines the percentage value to be decreased and must be between 0 and 100. 
   
        The formula used to calculate the grade is:
              CW x (1 - PA (%)) ⌃ (AN - 1)
       where: 
       CW = Correct Weight
       PA = Penalty per Attempt
       AN = Attempt Number
  - Example 1: Weighted Questions is "false". Global Penalty per Attempt is 10. Three attempts allowed per question. The member incorrectly answers the first 2 (two) attempts and correctly answers the third one. He will have the following partial grades:  
    0 + 0 + 0.81 = 0.81

  - Example 2: Weighted Questions is "true". Correct Weight is 10. Individual Penalty per Attempt is 20. Two attempts allowed per question. The member incorrectly answers the first attempt and correctly answers the second one. He will have the following partial grades:  
   0 + 8 = 8  

:point_right: If the member incorrectly answers all attempts allowed, his grade will be 0 (zero).
- **Negative Weight**: In this mode, the member is immediately penalized for each attempt when he gives an incorrect answer for the question. For each attempt he will receive as partial grade:  
    Correct Weight - if the member correctly answers the question  
    Incorrect weight - if the member incorrectly answers the question  
When selecting this mode, the system enables the global question *Incorrect Weight* field, allowing the administrator to give the same incorrectness value to all questions of the module. This option applies to a module with non weighted questions - all questions have the same *Correct Weight* that equals to 1 (one).  
   For the modules where each question needs to have different weights, the administrator has to set the *Weighted Questions* field to "true". This way, the system enables the fields *Correct Weight* and *Incorrect Weight* for each individual question.  
   - Example 1: - Weighted Questions is "false". Global Incorrect Weight is -0.01. Three attempts allowed per question. The member incorrectly answers the first 2 (two) attempts and correctly answers the third one. He will have the following partial grades:  
    \- 0.01 - 0.01 + 1 = 0.98

   - Example 2: - Weighted Questions is "true". Correct Weight is 10. Individual Incorrect Weight is 0.5. One attempt allowed per question.  
   If the member incorrectly answers the question, his partial grade equals to 0.5.  
   If he correctly answers the question, his partial grade equals to 10.
   
### 4.2. Setting the Attempts Allowed per Question
Here is where the administrator defines how many times the member can answer the question until he gives the right response. It may vary from *1* to *10* or be set to *Unlimited*, which means that the member will be allowed to answer the question indefinitely until he's able to give the right answer.  
:point_right: If more than 10 attempts allowed per question are required, the administrator must go to the classic view of the module.

### 4.3. Configuring the Question Pool
Suppose the module has a great quantity of questions and the administrator does not want them all to be displayed, but just a subset of them. This is the field where the administrator determines the quantity of questions that will be included in the subset to be displayed. If left blank, no subset is determined and all questions will be displayed.   
In order to determine the subset, the administrator must enter a positive number greater than 0 (zero) and less than the quantity of questions of the module. Each time the module is taken by the member, the quantity of questions defined in the question pool will be randomly displayed.  
When setting a question pool, all questions automatically have their *Correct Weight* set to 1 (one), so it's not possible to set the field *Weighted Questions* to "true".

### 4.4. Shuffling Questions
If the module has more than one attempt allowed, the administrator might want the questions not to be displayed in the same order in all attempts. By setting the field *Shuffle Questions* to "true", each time the member takes the module, the questions will be displayed in a different order. It's not possible to set this field to "true" if a question pool is defined.

### 4.5. Setting Weighted Questions
By setting this field to "true", the administrator is allowed to set a weight for each question, this is, to define the value of each question. This field is used as the basis of calculation for each Penalty Mode previously described.

### 4.6. Ordering Questions
It's possible to reorder the questions by dragging them and dropping them in the desired order. This functionality will be enabled provided the *Shuffle Questions* field is not set to "true" or there is no *Question Pool*.

## 5. Activating or Inactivating a Module
Once the module is ready to compose the course, the administrator needs to *Activate* it. This way, when the course turns to "Active" status, the module will be available as part of it.   
Active modules contribute to the progress of the course since they are considered in its calculation.  

Example:  
An active course has four modules and all of them are active ones. When the member approves the first one, his progress in the course will be 25% (1 / 4).  
If one of the four modules is not active, the member will be unable to take the inactive module. When approving the first of the three active modules, his progress will be 33% (1 / 3).  

In the Module details page, clicking the *Activate* button in the right upper corner of the page and confirming the message, makes the module active and replaces the button by the *Inactivate* one.  
The module can be inactivated at any time, even if it has already a related module response.  
When inactivating a module, some fields can be edited, like *Module Name* and *Description*, but there are some fields that compromise the course structure integrity and cannot be changed if there is already a module response for the module: *Attempts Allowed*, *Approval Grade*, *Penalty Mode*, *Question Pool*, *Attempts Allowed Per Question* and *Weighted Questions*.  
For the same reason, it's not allowed to create new questions and new answer options or delete questions and delete answer options.   

It's possible to edit questions and answer options when the module is inactive, but not the *Correct Weight*, *Penalty per Attempt* and *Incorrect Weight*,  when there is already a question response for the question.

## 6. Reordering Modules
Once all the needed modules were created, the administrator might want to change the order that was automatically given to them. In the Module details page, a button named *Reorder* can be found. When clicking this button, by dragging the modules and dropping them in the desired position, the administrator sets the order that the modules will be displayed in the course.

## 7. Creating Module Dependencies
A module can be dependent of one or more other modules, this is, it could only be taken after member approval on the predecessors modules.  
To determine which are the predecessors modules, the administrator goes to the Module details page and clicks the *New* button in the right upper corner of the Modules Dependencies related list. He can type part of the predecessor module name. The complete name of the module will be shown in the list. The administrator selects the module by clicking its name and presses the *Save* button.  
This action must be repeated for each dependency.

## 8. Activating  or Inactivating a Course
To activate a course, there must be at least one active module for the course. The administrator goes to the Course details page, clicks the *Activate* button in the right upper corner of the page and confirm the message.  
Depending on how the course period is configured, there are 3 (three) possible status to where the course can go:
- **Active** - When the course has no defined period or when the date when the course is being activated is within the period defined for the course (*Start Date* and *End Date* are equal or greater than the activation date);
- **Scheduled** - When the *Start Date* defined to the course period is later than the course activation date;
- **Completed** - When the *End Date* defined to the course period is earlier than the activation date.

:point_right: For courses in status *Scheduled*, the system automatically changes their status to *Active* as soon as the start date is reached.  
:point_right: For courses in status *Active*, the system automatically changes their status to *Completed* as soon as the end date is over.  

A course can be inactivated at any time. When inactivating a course, its status is set to *Inactive* and any of its fields can be edited.  
In order to activate the course again, the same condition must be met: at least one active module. The final status after reactivation also depends on period dates.

## 9. Creating Course Dependencies
A course can be dependent of one or more other courses, this is, it could only be joined after member approval on the predecessors courses.  
To determine which are the predecessors courses, the administrator goes to the Course details page and clicks the *New* button in the right upper corner of the Courses Dependencies related list. He can type part of the predecessor course name. The complete name of the course will be shown in the list. The administrator selects the course by clicking its name and presses the *Save* button.  
This action must be repeated for each dependency.

## 10. Cloning Courses
It may be interesting to have an already existing course structure used for another course and, to meet this need, we can clone a course.  
Being in the Course details page, the administrator presses the *Clone* button and the whole course structure with its modules, questions and answer options is duplicated.  
The cloned course must have its *Start Date* and *End Date* edited to a valid period, and all the other fields can be edited by the administrator as well. When created, the cloned course has is status set to *Draft* and its modules are *Inactive*, which allows the administrator to make all needed changes.
