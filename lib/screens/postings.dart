// ignore_for_file: unused_field, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiitcorridor/components/sidemenu.dart';

class Posting extends StatefulWidget {
  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  bool BTechPass = false;
  bool MTechPass = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _jobDescriptionController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _applicationDeadlineController =
      TextEditingController();
  TextEditingController _howToApplyController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _educationRequirementsController =
      TextEditingController();
  TextEditingController _companyCultureController = TextEditingController();
  TextEditingController _contactInformationPhoneController =
      TextEditingController();
  TextEditingController _contactInformationEmailController =
      TextEditingController();
  TextEditingController _experienceLevelController = TextEditingController();

  List<String> _skillsTags = [];
  String _selectedExperienceLevel = "Select Below";
  String _internshipType = "Select Below";

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('job_postings').add({
        'jobTitle': _jobTitleController.text,
        'jobDescription': _jobDescriptionController.text,
        'companyName': _companyNameController.text,
        'experienceLevel': _experienceLevelController.text,
        'skills': _skillsController.text,
        'location': _locationController.text,
        'duration': _durationController.text,
        'applicationDeadline': _applicationDeadlineController.text,
        'howToApply': _howToApplyController.text,
        'salary': _salaryController.text,
        'educationRequirements': _educationRequirementsController.text,
        'companyCulture': _companyCultureController.text,
        'contactInformation_Email': _contactInformationEmailController.text,
        'contactInformation_Phone': _contactInformationPhoneController.text,
        'experienceLevel': _selectedExperienceLevel,
        'internshipType': _internshipType,
      });
      _jobTitleController.clear();
      _jobDescriptionController.clear();
      _companyNameController.clear();
      _locationController.clear();
      _durationController.clear();
      _skillsController.clear();
      _applicationDeadlineController.clear();
      _howToApplyController.clear();
      _salaryController.clear();
      _educationRequirementsController.clear();
      _companyCultureController.clear();
      _contactInformationEmailController.clear();
      _contactInformationPhoneController.clear();
      setState(() {
        _selectedExperienceLevel = "Select Below";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Job/Internship'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the job title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 3,
                controller: _jobDescriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the job description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Company Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedExperienceLevel,
                onChanged: (newValue) {
                  setState(() {
                    _selectedExperienceLevel = newValue!;
                  });
                },
                items: ['Select Below', 'Entry Level', 'Intern', 'Senior']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Experience Level'),
                validator: (value) {
                  if (value == 'Select Below') {
                    return 'Please select the experience level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _selectedExperienceLevel == "Intern",
                child: DropdownButtonFormField<String>(
                  value: _internshipType,
                  onChanged: (newValue) {
                    setState(() {
                      _internshipType = newValue!;
                    });
                  },
                  items: [
                    'Select Below',
                    'Summer',
                    'Winter',
                    'Yearlong',
                    'Training Program'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Internship Type'),
                  validator: (value) {
                    if (value == 'Select Below') {
                      return 'Please select the type of internship';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary/Stipend'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter salary';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _selectedExperienceLevel == 'Intern',
                child: TextFormField(
                  controller: _durationController,
                  decoration:
                      InputDecoration(labelText: 'Duration (in months)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the duration';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _applicationDeadlineController,
                decoration: InputDecoration(labelText: 'Application Deadline'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      DateTime selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      setState(() {
                        _applicationDeadlineController.text =
                            selectedDateTime.toString();
                      });
                    }
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the deadline date and time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _buildSkillsTags(),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(labelText: 'Enter Skills'),
                onChanged: (value) {
                  if (value.endsWith(' ') || value.startsWith(" ")) {
                    if (value.contains(RegExp(r'[a-zA-Z0-9]')) &&
                        value.endsWith(' ')) {
                      setState(() {
                        _skillsTags.add(value.trim().toLowerCase());
                        _skillsController.clear();
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactInformationEmailController,
                decoration:
                    InputDecoration(labelText: 'Contact Information - Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter valid contact details';
                  }
                  RegExp emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactInformationPhoneController,
                decoration:
                    InputDecoration(labelText: 'Contact Information - Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter valid contact details';
                  }
                  RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              // PopupMenuButton(
              //   child: Text(
              //     "Select Eligibilty",
              //     style: TextStyle(fontSize: 20),
              //   ), // Display the text as the button
              //   itemBuilder: (context) => [
              //     PopupMenuItem(
              //       child: CheckboxListTile(
              //         title: Text('BTech Candidates'),
              //         value: BTechPass,
              //         onChanged: (value) {
              //           setState(() {
              //             BTechPass = value ?? false;
              //           });
              //         },
              //       ),
              //     ),
              //     PopupMenuItem(
              //       child: CheckboxListTile(
              //         title: Text('MTech Candidates'),
              //         value: MTechPass,
              //         onChanged: (value) {
              //           setState(() {
              //             MTechPass = value ?? false;
              //           });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSkillsTags() {
    return _skillsTags.map((skill) {
      return Chip(
        label: Text(skill),
        onDeleted: () {
          setState(() {
            _skillsTags.remove(skill);
          });
        },
      );
    }).toList();
  }
}
