import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  List<String> classes;
  Dropdown({required this.classes});
  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> classes=[];
  String? selectedList;
  String? _chosenModel=null;
  TextEditingController _newClassController = TextEditingController();

  @override
  void initState(){
    classes=widget.classes;
    _chosenModel=(classes.isNotEmpty)?classes[0]:null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: [
            DropdownButton<String>(
              value: _chosenModel,
              items: classes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _chosenModel = newValue!;
                });
              },
              hint: Text(
                "Choose a class",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),

            TextField(
              controller: _newClassController,
              decoration: InputDecoration(
                labelText: 'Enter a new class',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      classes.add(_newClassController.text);
                      _newClassController.text="";
                    });
                  },
                ),
              ),
            ),
          ],
        )
    );

  }

  Future<void> _showNewListDialog(BuildContext context) async {
    String newListName = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create new'),
          content: TextField(
            onChanged: (value) {
              newListName = value;
            },
            decoration: InputDecoration(hintText: 'Enter class name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                // Handle the creation of the new list
                if (newListName.isNotEmpty) {
                  // Add the new list to the existing lists
                  setState(() {
                    classes.add(newListName);
                    selectedList = newListName;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}