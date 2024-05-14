import 'package:finalproject/thememode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'SQLHelper.dart';
import 'inputs.dart';

class Add extends StatefulWidget {
  final Map<String, dynamic>? subject;

  Add({Key? key, this.subject}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  String startTime = "Start Time";
  String endTime = "End Time";
  DateTime selectedDate = DateTime.now();
  int coloeselected = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.subject != null) {
      _subjectController.text = widget.subject!['name'] ?? '';
      _noteController.text = widget.subject!['note'] ?? '';
      startTime = widget.subject!['startTime'] ?? '';
      endTime = widget.subject!['endTime'] ?? '';
      String dateString = widget.subject!['date'] ?? '';
      DateFormat format = DateFormat('MM/dd/yyyy');
      selectedDate =
          dateString.isNotEmpty ? format.parse(dateString) : DateTime.now();
      coloeselected = getColorIndex(widget.subject!['colorCode'] ?? '');
    }
  }

  int getColorIndex(String colorCode) {
    switch (colorCode) {
      case "#F68B86":
        return 0;
      case "#D5C475":
        return 1;
      case "#603751":
        return 2;
      default:
        return 0;
    }
  }

  Future<void> _selectTime(String timeType) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String formattedTime = "${pickedTime.hour}:${pickedTime.minute}";
      setState(() {
        if (timeType == "start") {
          startTime = formattedTime;
        } else if (timeType == "end") {
          endTime = formattedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Provider.of<ThemeModel>(context).isDarkMode
          ? Color(0xFFF5DFD3)
          : Color(0xFFF5DFD3),
      // Set resizeToAvoidBottomInset to false
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          // Wrap the container in a SizedBox with fixed height and width
          height: screenHeight - 120,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: Provider.of<ThemeModel>(context).isDarkMode
                ? Colors.black
                : Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Column(
                        children: [
                          // Use BoxFit.fill to stretch the image
                          SizedBox(
                            width: 600,
                            child: Image.asset(
                              "lib/assets/c.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon:
                                Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text('Add ',
                                style: TextStyle(
                                    color: Provider.of<ThemeModel>(context)
                                            .isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 4.0),
                            child: Text('Subject',
                                style: TextStyle(
                                    color: Provider.of<ThemeModel>(context)
                                            .isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Inputs(
                  title: 'Subject',
                  Subtitle: 'Enter subject',
                  controller: _subjectController,
                ),
                SizedBox(
                  height: 10,
                ),
                Inputs(
                  title: 'Note',
                  Subtitle: 'Enter Your Note',
                  controller: _noteController,
                ),
                SizedBox(
                  height: 10,
                ),
                Inputs(
                  title: 'Date',
                  Subtitle: DateFormat.yMd().format(selectedDate),
                  controller: null,
                  widget: IconButton(
                    color: Colors.grey,
                    onPressed: () async {
                      DateTime? picker = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2525),
                      );
                      if (picker != null) {
                        setState(() {
                          selectedDate = picker;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Inputs(
                        title: 'Start Time',
                        Subtitle: startTime,
                        widget: IconButton(
                          onPressed: () => _selectTime("start"),
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Inputs(
                        title: 'End Time',
                        Subtitle: endTime,
                        widget: IconButton(
                          onPressed: () => _selectTime("end"),
                          icon: Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Color',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Wrap(
                            children: List<Widget>.generate(
                              3,
                              (int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      coloeselected = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CircleAvatar(
                                      child: coloeselected == index
                                          ? Icon(Icons.done,
                                              color: Colors.white, size: 16)
                                          : Container(),
                                      radius: 15,
                                      backgroundColor: index == 0
                                          ? Color(0xFFF68B86)
                                          : index == 1
                                              ? Color(0xFFD5C475)
                                              : index == 2
                                                  ? Color(0xFF603751)
                                                  : Colors.transparent,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (validateInputs()) {
                            if (widget.subject != null) {
                              updateInDatabase();
                            } else {
                              storeInDatabase();
                            }
                            Navigator.pop(context);
                          } else {
                            showValidationNotification();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF603751)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Add Subject',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateInputs() {
    if (_subjectController.text.isEmpty ||
        _noteController.text.isEmpty ||
        startTime == "Start Time" ||
        endTime == "End Time") {
      return false;
    }
    return true;
  }

  void showValidationNotification() {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('All fields must be filled.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void storeInDatabase() async {
    String subject = _subjectController.text;
    String note = _noteController.text;
    int complete = 0;
    String date = DateFormat.yMd().format(selectedDate);
    String colorCode = coloeselected == 0
        ? "#F68B86"
        : coloeselected == 1
            ? "#D5C475"
            : "#603751";
    await SQLHelper.insertSubject(
        name: subject,
        note: note,
        date: date,
        startTime: startTime,
        endTime: endTime,
        colorCode: colorCode,
        complete: complete);
  }

  void updateInDatabase() async {
    int id = widget.subject!['id'];
    String subject = _subjectController.text;
    String note = _noteController.text;
    String date = DateFormat.yMd().format(selectedDate);
    String colorCode = coloeselected == 0
        ? "#F68B86"
        : coloeselected == 1
            ? "#D5C475"
            : "#603751";
    await SQLHelper.updateSubject(
        id: id,
        name: subject,
        note: note,
        date: date,
        startTime: startTime,
        endTime: endTime,
        colorCode: colorCode,
        complete: 0);
  }
}
