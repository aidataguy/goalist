import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());
final GlobalKey _formKey = GlobalKey();
final _formResult = Goal();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Creates the calendar event....

  var finalDate;
  DateTime startDate = DateTime.now().subtract(Duration(days: 0));
  DateTime endDate = DateTime.now().add(Duration(days: 2));
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 2));
  List<DateTime> markedDates = [
    DateTime.now(),
  ];

  // On Select action
  onSelect(data) {
    finalDate = selectedDate;
    return finalDate;
  }

// Month Name Widget
  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  // set marker widget...
  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  // Date tile builder

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    // Animator section
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  // Create a list view function to get all lsts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: CalendarStrip(
                startDate: startDate,
                endDate: endDate,
                onDateSelected: onSelect,
                dateTileBuilder: dateTileBuilder,
                iconColor: Colors.black,
                monthNameWidget: _monthNameWidget,
                markedDates: markedDates,
                containerDecoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.lightGreen, Colors.greenAccent])),
              ),
            ),
            Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.only(top: 15.0),
                child: Column(children: <Widget>[
                  Text(
                    "You Goals For The Day...",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 22.0),
                  )
                ])),
            Container(
              width: 200.0,
              height: 200.0,
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: ListView(
                  children: <Widget>[
                    new TextField(
                      // textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "order a pizza 🍕",
                          hintStyle:
                              new TextStyle(fontWeight: FontWeight.w200)),
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      onChanged: (todoName) {
                        _formResult.todo = todoName;
                      },
                    ),
                  ],
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _submitForm,
              tooltip: 'Save',
              child: Icon(
                Icons.check,
                size: 36.0,
              ),
            ),
          ],
        )));
  }
}

void _submitForm() {
  final FormState form = _formKey.currentState;
  if (form.validate()) {
    form.save();
    print('New user saved with signup data:\n');
    print(_formResult.toJson());
  }
}

class Goal {
  String todo;
  Goal({
    this.todo,
  });
  Map<String, dynamic> toJson() => {
        'todo': todo,
      };
}
