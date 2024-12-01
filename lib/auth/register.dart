import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_schedule/auth/login.dart';
import 'package:my_schedule/box/boxes.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/screens/schedule_screen.dart';
import 'package:my_schedule/shared/alert.dart';
import 'package:my_schedule/shared/button.dart';
import 'package:my_schedule/shared/constants.dart';
import 'package:my_schedule/shared/text_field.dart';
import 'package:my_schedule/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterScreen> {

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    
    getAllAvailableSections();
    getAllAvailableCourses();
  }

  final _studentNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _sectionController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();

  final registerFormKey = GlobalKey<FormState>();

  
  bool isStudentBonafide = false;

  // Function to validate student if bonafide or not based on the enrollment records
  // Queries the database using the student's provided credentials.
  // If it has a result, `isStudentBonafide` will be set to true.
  Future<void> validateStudent() async{  

    try {
      final studentToSearch = await 
        Supabase.instance.client
        .from('tbl_bonafide_students')
        .select()
        .eq('student_number', _studentNumberController.text.trim().toUpperCase())
        .eq('first_name', _firstNameController.text.trim().toUpperCase())
        .eq('last_name', _lastNameController.text.trim().toUpperCase());
    
      if(studentToSearch.isNotEmpty) {
        print("STUDENT IS BONAFIDE");
        print("STUDENT TO SEARCH :::: $studentToSearch");
        setState(() {
          isStudentBonafide = true;
        });

      } 
      else {
        print("NOT BONAFIDE");
        print(" BONAFIDE");
        print("STUDENT TO SEARCH :::: $studentToSearch");
      } 
    } catch (e) {
      Alert.of(context).showError("$e");
    }
  }

  // FUNCTION TO CREATE A NEW ACCOUNT
  void  registerAccount () async{
    await validateStudent();

    if(registerFormKey.currentState!.validate()) {

      if( isStudentBonafide ) {

        try{

          LoadingDialog.showLoading(context);
          await Future.delayed(const Duration(seconds: 2));

          final AuthResponse res = await supabase.auth.signUp(
            email: _emailController.text.trim(),
            password: _birthDateController.text.trim(),
          );

          final User? user = res.user; // get authenticated user data object 
          final String userId = user!.id;  // get user id

          print("NEW USER UIID::: $userId");
          boxUserCredentials.put("userId", userId);
          
          await createUser(
            _studentNumberController.text.trim(),
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _sectionController.text.trim(),
            _birthDateController.text.trim(),
            _emailController.text.trim(), 
            userId
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ScheduleScreen()),
            (route) => false,
          );


        } on AuthException catch(e) {
          LoadingDialog.hideLoading(context);
          Alert.of(context).showError(e.message);
          print("ERROR ::: ${e.code}");

        }

      } else {
          
        Alert.of(context).showError("Student not found, please retry");

      }

    }

  }   

  // FUNCTION TO INSERT THE NEW USER INTO THE DB
  createUser(idNumber, firstName, lastName, section, birthdate, email, userId ) async {
    await Supabase.instance.client
    .from('tbl_users')
    .insert({
      'first_name': firstName,
      'last_name' : lastName,
      'email' : email,
      'section' : section,
      'id_number' : idNumber,
      'user_type' : 'student',
      'birthday' : birthdate,
      'auth_id' : userId
    });

    print("USER CREATED SUCCESSFULLY");
  }

  DateTime birthDay = DateTime.now();
  selectDate() async{

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDay,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birthDay = picked;
      var formattedBirthDay = DateFormat('yyyy-MM-dd');
      _birthDateController.text = formattedBirthDay.format(birthDay);

      print('BIRTHDAYYYY ::::: ${formattedBirthDay.format(birthDay)}'); 
    }
  }

  

  // Function to get all availabe courses
  // Function to show the section picker

  final List<String> _courses = [];
  Future<void> getAllAvailableCourses() async {
    
    try{
      
      final selectAllSection = await 
      Supabase.instance.client
      .from('tbl_courses')
      .select();
      for(var s in selectAllSection) {
        _courses.add(s['course']);
      }

      for(var c in _courses) {
        print("COURSES ::: $c");
      }

    } catch (e) {
      print("ERROR ::: $e");
    }

  }
  Future<void> selectCourse() async {
    // Show the Cupertino modal popup
    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          height: 250,
          child: CupertinoPicker(
            onSelectedItemChanged: (int value) {
              
              setState(() {
                _courseController.text = _courses[value - 1];
                _sectionController.text = '';
                _sections.clear();
              });
              print('COURSE :::: ${_courses[value - 1]}'); 
              getAllAvailableSections();
            },
            backgroundColor: Colors.white,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
              initialItem: 0, 
            ),
            children: [
              const Text('Select a Course', style: TextStyle(color: MAROON, fontWeight: FontWeight.bold)),
              ..._courses.map((course) => Text(course))
            ] 
          ),
        );
      },
    );
  }



  
  // Function to get all availabe section
  // Function to show the section picker
  final List<String> _sections = [];
  Future<void> getAllAvailableSections() async {

    try{
      
      _sections.clear();
      final selectAllSection = await 
      Supabase.instance.client
      .from('tbl_section')
      .select()
      .eq('course', _courseController.text);
      
      for(var s in selectAllSection) {
        _sections.add(s['section']);
      }

      for(var s in _sections) {
        print("SECTION ::: $s");
      }

    } catch (e) {
      print("ERROR ::: $e");
    }

  }

  Future<void> selectSection() async {
    // Show the Cupertino modal popup

    if(_courseController.text.isEmpty || _courseController.text == "") {
      return Alert.of(context).showError("Please select your course first. 😊");
    }

    await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) {
        return SizedBox(
          width: double.infinity,
          height: 250,
          child: CupertinoPicker(
            onSelectedItemChanged: (int value)async {
              
              setState(() {
                _sectionController.text = _sections[value - 1];

              });

              print('SECTION :::: ${_sections[value - 1]}'); 
            },
            backgroundColor: Colors.white,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
              initialItem: 0, 
            ),
            children: [

              const Text('Select a Section', style: TextStyle(color: MAROON, fontWeight: FontWeight.bold)),
              ..._sections.map((section) => Text(section))

            ] 
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MAROON,
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // TOP WHITE CONTAINER
            Container(
              
              color: MAROON,
              height: MediaQuery.of(context).size.height * 0.2, 

              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,         
                children: [

                  SizedBox(height: 50),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        
                  SizedBox(height: 10),
                ],
              ),
            ),
        
            // BOTTOM WHITE CONTAINER
            Container(
              
              height: MediaQuery.of(context).size.height * 0.8, 
              // padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              padding: const EdgeInsets.symmetric( horizontal: 20),
              
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.23),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: registerFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      const SizedBox(height: 40),

                      MyTextFormField(
                        controller: _studentNumberController,
                        hintText: "Student Number",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateWithRegex(
                          value,
                          'ID number cannot found',
                          'Student Number',
                          RegExp(r'^A\d{2}-\d{4}$'),
                        ),
                      ),
                  
                      const SizedBox(height: 20),
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: MyTextFormFieldForName(
                                controller: _firstNameController,
                                hintText: "First Name",
                                obscureText: false,
                                validator: (value)=> Validator.of(context).validateTextField(value, "First name"),
                              ),
                            ),
                  
                            const SizedBox(width: 5),
                  
                            Expanded(
                              child: MyTextFormFieldForName(
                                controller: _lastNameController,
                                hintText: "Last Name",
                                obscureText: false,
                                validator: (value)=> Validator.of(context).validateTextField(value, "Last name"),
                              ),
                            ),
                        
                        
                          ],
                        ),
                      ),
                  
                  
                      
                      const SizedBox(height: 20),
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: MyTextFormFieldShortReadOnly(
                                onTap: selectCourse,
                                controller: _courseController,
                                hintText: "Course",
                                obscureText: false,
                                validator: (value)=> Validator.of(context).validateTextField(value, "Course"),
                              ),
                            ),
                  
                            const SizedBox(width: 5),
                  
                            Expanded(
                              child: MyTextFormFieldShortReadOnly(
                                onTap: selectSection,
                                controller: _sectionController,
                                hintText: "Section",
                                obscureText: false,
                                validator: (value)=> Validator.of(context).validateTextField(value, "Section"),
                              ),
                            ),
                        
                        
                          ],
                        ),
                      ),
                  
                      const SizedBox(height: 20),
                  
                      ReadOnlyTextFormField(
                        onTap: () => selectDate(),
                        controller: _birthDateController,
                        hintText: "Birthdate",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateTextField(value, "Birthdate"),
                      ),
                      const SizedBox(height: 20),
                      
                      MyTextFormField(
                        controller: _emailController,
                        hintText: "Email addres",
                        obscureText: false,
                        validator: Validator.of(context).validateEmail,
                      ),
                      const SizedBox(height: 20),
                      
                      MyTextFormField(
                        controller: _confirmEmailController,
                        hintText: "Confirm email address",
                        obscureText: false,
                        validator: (value)=> Validator.of(context).validateConfirmation(
                          value, 
                          _emailController.text, 
                          "Confirm Email"
                        )
                      ),
                      const SizedBox(height: 20),
                  
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          const SizedBox(width: 18),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen())
                              );
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                color: MAROON,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                  
                      ),
                      const SizedBox(height: 25),
                          
                      MyButton(
                        onTap: () {
                          registerAccount();
                        },
                        buttonName: "Create",
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Your initial password will be your birthdate\nin this format YYYY-MM-DD",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}