import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'SQLHelper.dart';
import 'add.dart';
import 'textt.dart';
import 'thememode.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeModel>(context).isDarkMode
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeModel>(context).isDarkMode
            ? Color(0xFF424242)
            : Color(0xFFFF603751),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Provider.of<ThemeModel>(context, listen: false).toggleTheme();
          },
          child: Icon(
            Provider.of<ThemeModel>(context).isDarkMode
                ? Icons.wb_sunny
                : Icons.nightlight_round,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMMd().format(DateTime.now()),
                          style: TextStyle(
                            color: Provider.of<ThemeModel>(context).isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Today",
                          style: TextStyle(
                            color: Provider.of<ThemeModel>(context).isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Add()),
                    );
                    // Update the UI when returning from the Add page
                    _refreshSubjects();
                  },
                  child: Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFF603751)),
                      child: Center(
                          child: Text('+ Add Subject',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)))),
                ),
              ],
            ),
            SizedBox(height:16),
            // Display the tasks using a ListView.builder
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: SQLHelper.getSubjects(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Convert the data to a mutable list
                    subjects = List<Map<String, dynamic>>.from(snapshot.data!);
                    return ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> subject = subjects[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: EdgeInsets.only(top: 4),
                                              height: subject['complete'] == 1
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.40,
                                              color: Provider.of<ThemeModel>(
                                                          context)
                                                      .isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Container(
                                                      height: 8,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Provider.of<
                                                                        ThemeModel>(
                                                                    context)
                                                                .isDarkMode
                                                            ? Colors.grey[500]
                                                            : Colors.grey[300],
                                                      ),
                                                    ),
                                                  ),
                                    
                                                  // Check for subject completion status and show buttons accordingly
                                                  subject['complete'] == 1
                                                      ? // If completed, show only "Close" button
                                                      Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Handle button press (e.g., delete the subject)
                                                                  _deleteSubject(
                                                                      subject[
                                                                          'id']);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the bottom sheet
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .red), // Set the background color to white
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          OutlinedBorder>(
                                                                    RoundedRectangleBorder(
                                                                      // Set the border color to black
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  minimumSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                                ),
                                                                child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    16), // Add some spacing between buttons
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Handle button press (e.g., close the bottom sheet)
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              Color>(
                                                                    Provider.of<ThemeModel>(
                                                                                context)
                                                                            .isDarkMode
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                  ), // Set the background color to white
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          OutlinedBorder>(
                                                                    RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        color: Provider.of<ThemeModel>(context).isDarkMode
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ), // Set the border color to black
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  minimumSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                  child: Text(
                                                                      'Close',
                                                                      style: TextStyle(
                                                                          color: Provider.of<ThemeModel>(context).isDarkMode
                                                                              ? Colors
                                                                                  .white
                                                                              : Colors
                                                                                  .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18)),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : // If not completed, show "Delete", "Update", and "Close" buttons
                                                      Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Handle button press (e.g., delete the subject)
                                                                  _deleteSubject(
                                                                      subject[
                                                                          'id']);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the bottom sheet
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .red), // Set the background color to white
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          OutlinedBorder>(
                                                                    RoundedRectangleBorder(
                                                                      // Set the border color to black
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  minimumSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                                ),
                                                                child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    16), // Add some spacing between buttons
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Add(subject: subject)),
                                                                  );
                                                                  // Update the UI when returning from Add page
                                                                  _refreshSubjects();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the bottom sheet
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              Color>(
                                                                    Color(
                                                                      0xFF000000 +
                                                                          int.parse(
                                                                            subject['colorCode'].substring(1),
                                                                            radix:
                                                                                16,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          OutlinedBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  minimumSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                  child: Text(
                                                                      'Update',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18)),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 16),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  int subjectId =
                                                                      subject[
                                                                          'id'];

                                                                  // Update the complete field in the database
                                                                  await SQLHelper.updateSubject(
                                                                      id:
                                                                          subjectId,
                                                                      complete:
                                                                          1,
                                                                      note: subject[
                                                                          'note'],
                                                                      endTime:
                                                                          subject[
                                                                              'endTime'],
                                                                      startTime:
                                                                          subject[
                                                                              'startTime'],
                                                                      name: subject[
                                                                          'name'],
                                                                      colorCode:
                                                                          subject[
                                                                              'colorCode'],
                                                                      date: subject[
                                                                          'date']);
                                                                  _refreshSubjects();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the bottom sheet
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              Color>(
                                                                    Color(
                                                                      0xFF000000 +
                                                                          int.parse(
                                                                            subject['colorCode'].substring(1),
                                                                            radix:
                                                                                16,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          OutlinedBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  minimumSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                  child: Text(
                                                                      'Completed',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18)),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    16), // Add some spacing between buttons
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  // Handle button press (e.g., close the bottom sheet)
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              Color>(
                                                                    Provider.of<ThemeModel>(
                                                                                context)
                                                                            .isDarkMode
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                  ), // Set the background color to white
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          OutlinedBorder>(
                                                                    RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        color: Provider.of<ThemeModel>(context).isDarkMode
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ), // Set the border color to black
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                    ),
                                                                  ),
                                                                  minimumSize: MaterialStateProperty.all<
                                                                          Size>(
                                                                      Size(
                                                                          double
                                                                              .infinity,
                                                                          50)),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                  child: Text(
                                                                      'Close',
                                                                      style: TextStyle(
                                                                          color: Provider.of<ThemeModel>(context).isDarkMode
                                                                              ? Colors
                                                                                  .white
                                                                              : Colors
                                                                                  .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              18)),
                                                                ),
                                                              ),
                                                            ),

                                                            SizedBox(
                                                                height:
                                                                    16), // Add some spacing between buttons
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        margin: EdgeInsets.only(bottom: 12),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Color(
                                              0xFF000000 +
                                                  int.parse(
                                                    subject['colorCode']
                                                        .substring(1),
                                                    radix: 16,
                                                  ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    txt(
                                                      name:
                                                          subject['name'] ?? '',
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_rounded,
                                                          color:
                                                              Colors.grey[200],
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "${subject['startTime']} - ${subject['endTime']}",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey[100],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                     SizedBox(height: 12),
                                                    Text(
                                                      subject['date'] ?? '',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[100],
                                                      ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    Text(
                                                      subject['note'] ?? '',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[100],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: 60,
                                                width: 0.5,
                                                color: Colors.grey[200]!
                                                    .withOpacity(0.7),
                                              ),
                                              RotatedBox(
                                                quarterTurns: 3,
                                                child: Text(
                                                  subject['complete'] == 1
                                                      ? "COMPLETED"
                                                      : "TODO",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _deleteSubject(int id) async {
    await SQLHelper.deleteSubject(id);

    
    setState(() {
      subjects.removeWhere((subject) => subject['id'] == id);
    });
  }

  
  void _refreshSubjects() {
    setState(() {
      subjects = [];
    });
  }
}
