import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentInfo {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final List<String> photoUrls;
  final List<Map<String, dynamic>> collegeExperiences;
  final List<Map<String, dynamic>> professionalExperiences;

  StudentInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.photoUrls,
    required this.collegeExperiences,
    required this.professionalExperiences,
  });

  factory StudentInfo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StudentInfo(
      id: doc.id,
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
      photoUrls: List<String>.from(data['photoUrls']),
      collegeExperiences: List<Map<String, dynamic>>.from(data['CollegeExperiences'] ?? []),
      professionalExperiences: List<Map<String, dynamic>>.from(data['ProfessionalExperiences'] ?? []),
    );
  }
}

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  bool showPaidExperienceOnly = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Checkbox(
                      value: showPaidExperienceOnly,
                      onChanged: (value) {
                        setState(() {
                          showPaidExperienceOnly = value ?? false;
                        });
                      },
                    ),
                    Text('Show Paid Internships'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {}); // Trigger rebuild to apply search filter
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('StudentInfo').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching data'),
                  );
                } else {
                  List<StudentInfo> students = snapshot.data!.docs
                      .map((doc) => StudentInfo.fromFirestore(doc))
                      .where((student) {
                    // Apply search filter
                    if (showPaidExperienceOnly) {
                      return student.professionalExperiences.any((exp) => exp['Paid'] == true) &&
                          _containsSearchText(student);
                    } else {
                      return _containsSearchText(student);
                    }
                  }).toList();
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      StudentInfo student = students[index];
                      return ListTile(
                        title: Text(student.name),
                        subtitle: Text(student.email),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetailsPage(student: student),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  bool _containsSearchText(StudentInfo student) {
    final searchText = searchController.text.toLowerCase();

    // Check if any of the fields contain the search text
    return student.name.toLowerCase().contains(searchText) ||
        student.email.toLowerCase().contains(searchText) ||
        student.phone.toLowerCase().contains(searchText) ||
        student.address.toLowerCase().contains(searchText) ||
        _containsSearchTextInList(student.photoUrls, searchText) ||
        _containsSearchTextInExperiences(student.collegeExperiences, searchText) ||
        _containsSearchTextInExperiences(student.professionalExperiences, searchText);
  }

  bool _containsSearchTextInList(List<String> list, String searchText) {
    return list.any((item) => item.toLowerCase().contains(searchText));
  }

  bool _containsSearchTextInExperiences(List<Map<String, dynamic>> experiences, String searchText) {
    return experiences.any((exp) =>
        exp.values.any((value) => value.toString().toLowerCase().contains(searchText)));
  }

}



class StudentDetailsPage extends StatelessWidget {
  final StudentInfo student;

  const StudentDetailsPage({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${student.name}'),
            Text('Phone: ${student.phone}'),
            Text('Email: ${student.email}'),
            Text('Address: ${student.address}'),
            SizedBox(height: 16),
            Text(
              'Photo URLs:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              children: student.photoUrls.map((url) => Text(url)).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'College Experiences:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: student.collegeExperiences.map((exp) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Role: ${exp['Role']}'),
                    Text('Society: ${exp['Society']}'),
                    Text('Supported Doc: ${exp['SupportedDoc']}'),
                    Text('Description: ${exp['Description']}'),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Professional Experiences:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: student.professionalExperiences.map((exp) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Role: ${exp['Role']}'),
                    Text('Company: ${exp['Company']}'),
                    Text('Supported Doc: ${exp['SupportedDoc']}'),
                    Text('Description: ${exp['Description']}'),
                    Text('Stipend: ${exp['Stipend']}'),
                    Text('Months: ${exp['Months']}'),
                    Text('Bank Statement: ${exp['BankStatement']}'),
                    Text('Competency: ${exp['Competency']}'),
                    Text('Skills: ${exp['Skills'].join(', ')}'),
                    Text('Paid: ${exp['Paid']}'),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
