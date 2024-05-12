import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentInfo {
  final Map<String, dynamic> data;

  dynamic operator [](String key) => data[key] ?? "'$key' is not a valid key";

  String get name => this['name'] ?? "Name Error";

  String get phone => this['phone'] ?? "Phone Error";

  String get email => this['email'] ?? "Email Error";

  String get address => this['address'] ?? "Address Error";

  String get photoUrl => this['photoUrl'] ?? "PhotoUrl Error";

  int get year => int.parse(this['year'] ?? "-1");

  List<Map<String, dynamic>> _w(dynamic i) => List<Map<String, dynamic>>.from(i);

  List<Map<String, dynamic>> get collegeExperiences => _w(this['CollegeExperience']) ?? [];

  List<Map<String, dynamic>> get professionalExperiences => _w(this['ProfessionalExperience']) ?? [];

  Map<String, dynamic> semester(index) => _w(this["$index${['st', 'nd', 'rd', 'th'][max(index - 1, 3)]}SemesterPerformance"])[0];

  final String id;
  late final bool hasPaidInternships;
  late final double cgpa;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StudentInfo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  StudentInfo(this.id, this.data) {
    hasPaidInternships = professionalExperiences.where((e) => e['IsItPaid']).isNotEmpty;
    cgpa = double.parse((data['8thSemesterPerformance'] ??
            data['7thSemesterPerformance'] ??
            data['6thSemesterPerformance'] ??
            data['5thSemesterPerformance'] ??
            data['4thSemesterPerformance'] ??
            data['3rdSemesterPerformance'] ??
            data['2ndSemesterPerformance'] ??
            data['1stSemesterPerformance'])[0]['Cgpa'] ??
        '-1.0');
  }

  bool somethingSomewhereMatches(String string) {
    final pattern = RegExp(string, multiLine: true, caseSensitive: false);
    return name.contains(pattern) || email.contains(pattern) || phone.contains(pattern) || address.contains(pattern) || year.toString().contains(pattern) || SuperDFS(data, pattern).$1;
    // DFS(data, pattern);
  }

  String whatAndWhereDidItMatch(String string) {
    final pattern = RegExp(string, multiLine: true, caseSensitive: false);
    return name.contains(pattern)
        ? "Name"
        : email.contains(pattern)
            ? "Email"
            : phone.contains(pattern)
                ? "Phone"
                : address.contains(pattern)
                    ? "Address"
                    : year.toString().contains(pattern)
                        ? "Year"
                        : SuperDFS(data, pattern).$2;
  }

  static bool DFS(dynamic stuff, Pattern pattern) {
    return stuff is String
        ? stuff.contains(pattern)
        : stuff is List<dynamic>
            ? stuff.where((e) => DFS(e, pattern)).isNotEmpty
            : stuff is Map<String, dynamic>
                ? stuff.values.where((e) => DFS(e, pattern)).isNotEmpty
                : stuff.toString().contains(pattern);
  }

  static (bool, String) SuperDFS(dynamic stuff, Pattern pattern, {parent = ""}) {
    return stuff is String
        ? (stuff.contains(pattern), parent)
        : stuff is List<dynamic>
            ? stuff.map((e) => SuperDFS(e, pattern, parent: parent)).where((e) => e.$1).firstOrNull ?? (false, parent)
            : stuff is Map<String, dynamic>
                ? stuff.keys.map((e) => SuperDFS(stuff[e], pattern, parent: e)).where((e) => e.$1).firstOrNull ?? (false, parent)
                : (stuff.toString().contains(pattern), parent);
  }

  factory StudentInfo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    try {
      return StudentInfo(doc.id, data);
    } catch (e) {
      print("Error\n$e\noccurred with this data:\n$data");
      rethrow;
    }
  }
}

class TitledReportView extends StatefulWidget {
  const TitledReportView({super.key});

  @override
  State<TitledReportView> createState() => _TitledReportViewState();
}

class _TitledReportViewState extends State<TitledReportView> {
  bool filterPaidIShips = false;
  Map<String, (bool, bool Function(StudentInfo))> filters = {
    'Paid Internships': (false, (si) => si.hasPaidInternships),
    'CGPA > 9': (false, (si) => si.cgpa > 8),
    'CGPA > 7.5': (false, (si) => si.cgpa > 7.5),
    'Batch of 2025': (false, (si) => si.year == 2025),
    'Dummy Filter 1': (false, (si) => si.year < 500),
    'Dummy Filter 2': (false, (si) => si.cgpa > 500),
    'Dummy Filter 3': (false, (si) => si.name.endsWith('9')),
  };
  TextEditingController searchController = TextEditingController();
  Map<StudentInfo, bool> selection = {};
  StudentInfo? focussedStudent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.filter_list_alt),
              itemBuilder: (context) => filters.keys
                  .map((e) => PopupMenuItem(
                          child: Row(children: [
                        Checkbox(
                          value: filters[e]!.$1,
                          onChanged: (value) => setState(() => filters[e] = (!filters[e]!.$1, filters[e]!.$2)),
                        ),
                        Text('Show $e')
                      ])))
                  .toList())
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Card(
            child: Row(
              children: filters.keys
                  .where((e) => filters[e]!.$1)
                  .map((e) => Card.filled(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            child: Row(
                              children: [
                                Text(e),
                                IconButton(
                                    visualDensity: const VisualDensity(vertical: -4.0, horizontal: -4.0),
                                    onPressed: () => setState(() => filters[e] = (false, filters[e]!.$2)),
                                    icon: const Icon(Icons.remove_circle_outline))
                              ],
                            )),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {}); // Trigger rebuild to apply search filter
                },
              ),
            ),
          ),
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 700,
                  height: 650,
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("StudentInfo").limit(30).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                          if (snapshot.hasError) return Center(child: Text('Error fetching data'));

                          var sl = snapshot.data!.docs.map((doc) => StudentInfo.fromFirestore(doc));
                          filters.keys
                              // Get filters which are active
                              .where((e) => filters[e]!.$1)
                              // Apply those filters
                              .forEach((e) => sl = sl.where(filters[e]!.$2));
                          List<StudentInfo> students = sl
                              // Also apply search bar string thingy
                              .where((e) => e.somethingSomewhereMatches(searchController.text))
                              .toList();

                          selection.keys.where((e) => !students.contains(e)).toList().forEach((e) => selection.remove(e));
                          students.where((e) => !selection.containsKey(e)).forEach((e) => selection[e] = false);

                          Widget buildCell(String t, StudentInfo si) =>
                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: GestureDetector(child: Text(t), onTap: () => setState(() => focussedStudent = si)));

                          return Table(
                              columnWidths: const {
                                0: FlexColumnWidth(0.3),
                                1: FlexColumnWidth(1.0),
                                2: FlexColumnWidth(0.5),
                                3: FlexColumnWidth(0.5),
                                4: FlexColumnWidth(0.7),
                              },
                              children: [
                            TableRow(
                                children: ["", "Name", "Year", "CGPA", "Match"]
                                    .map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0), child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold))))
                                    .toList()),
                            ...students.map((e) => TableRow(decoration: BoxDecoration(border: Border(top: Divider.createBorderSide(context, width: 1))), children: [
                                  Checkbox(value: selection[e]!, onChanged: (value) => setState(() => selection[e] = !selection[e]!)),
                                  buildCell(e.name, e),
                                  buildCell(e.year.toString(), e),
                                  buildCell(e.cgpa.toString(), e),
                                  buildCell(searchController.text.isEmpty ? "" : e.whatAndWhereDidItMatch(searchController.text), e),
                                ])),
                          ]);
                        }),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 650,
                    child: focussedStudent == null
                        ? Center(child: Text("Select a student"))
                        : Column(
                            children: [
                              const Text("Student Info", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              Image.network(focussedStudent!.photoUrl),
                              DataTable(
                                columns: const [DataColumn(label: Text("")), DataColumn(label: Text(""))],
                                rows: [
                                  ("Name", "${focussedStudent?.name}"),
                                  ("Roll Number", "${focussedStudent?['roll']}"),
                                  ("Phone", "${focussedStudent?.phone}"),
                                  ("Email", "${focussedStudent?.email}"),
                                  ("Year", "${focussedStudent?.year}"),
                                  ("GitHub", "${focussedStudent?['PublicProfile'][0]['GithubLink']}"),
                                  ("LinkedIn", "${focussedStudent?['PublicProfile'][0]['LinkedinId']}"),
                                  ("FOSS Contributions", "${focussedStudent?['OpenSourceContributions'].length}"),
                                  ("Professional Experiences", "${focussedStudent?.professionalExperiences.length}"),
                                ].map((e) => DataRow(cells: [DataCell(Text(e.$1)), DataCell(Text(e.$2))])).toList(),
                              ),
                              ToggleButtons(
                                isSelected: [selection[focussedStudent]!],
                                onPressed: (index) => setState(() => selection[focussedStudent!] = !selection[focussedStudent]!),
                                children: [Text(selection[focussedStudent]! ? "Selected for Review" : "Select for Review")],
                              )
                            ],
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
        Card(
          child: TextButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("See Selected Students"),
              )),
        )
      ]),
    );
  }
}
