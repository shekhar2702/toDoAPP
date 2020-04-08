import 'package:flutter/material.dart';
import 'package:to_do_app/Note.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:intl/intl.dart';
class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note,this.appBarTitle);
  @override
  State<StatefulWidget> createState() {return NoteDetailState(this.note,this.appBarTitle);}
}

class NoteDetailState extends State<NoteDetail> {
  NoteDetailState(this.note,this.appBarTitle);
  static var _priorities=['High','Low'];
  DatabaseHelper helper=DatabaseHelper();
  String appBarTitle;
  Note note;
  //Note note;
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle=Theme.of(context).textTheme.title;
    titleController.text=widget.note.title;
    descriptionController.text=widget.note.description;
    return WillPopScope(
      onWillPop: (){
         moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){moveToLastScreen();},
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                    //dropdown menu
                    child: new ListTile(
                      leading: const Icon(Icons.low_priority),
                      title: DropdownButton(
                          items: _priorities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            );
                          }).toList(),
                          value: getPriorityAsString(widget.note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                  ),
                  // Second Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        icon: Icon(Icons.title),
                      ),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                        labelText: 'Details',
                        icon: Icon(Icons.details),
                      ),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
  void _save() async{
    moveToLastScreen();
    widget.note.date=DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(widget.note.id!=null){
      result= await helper.updateNote(widget.note);
    }
    else{
      result =await helper.insertNote(widget.note);
    }
    if(result!=0){
      _showAlertDialog('Status', 'Note saved successfully');
    }
    else{
      _showAlertDialog('Status', 'Problem Saving note');
    }
  }
  void _delete() async{
    moveToLastScreen();
    if(widget.note.id==null){
      _showAlertDialog('Status', 'First add a note');
      return;
    }
    int result = await helper.deleteNote(widget.note.id);
    if(result!=0){
      _showAlertDialog('Status', 'Note deleted successfully');
    }
    else{
      _showAlertDialog('Status', 'Error');
    }
  }
  void updatePriorityAsInt(String value){
    switch(value){
      case 'High':
      widget.note.priority=1;
      break;
      case 'Low':
      widget.note.priority=2;
      break;
    }
  }
  String getPriorityAsString(int value){
    String priority;
    switch (value){
      case 1:
      priority=_priorities[0];
      break;
      case 2:
      priority=_priorities[1];
    }
    return priority;
  }
  void moveToLastScreen(){
    Navigator.pop(context,true);
  }
  void updateTitle(){
    widget.note.title=titleController.text;
  }
  void updateDescription(){
    widget.note.description=descriptionController.text;
  }
  void _showAlertDialog(String title,String message){
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,builder:(_)=>alertDialog);
  }
}