import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> lists = ['List 1', 'List 2', 'List 3']; // Existing lists
  String? selectedList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container( // Wrap DropdownButton with Container to constrain its size
              width: 200, // Example width, adjust as needed
              child: DropdownButton<String>(
                value: selectedList,
                hint: Text('Select a list'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedList = newValue;
                  });
                },
                items: lists.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showNewListDialog(context);
              },
              child: Text('Create New List'),
            ),
          ],
        ),
      ),
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
                    lists.add(newListName);
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