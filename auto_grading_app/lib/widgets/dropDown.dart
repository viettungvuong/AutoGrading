import 'package:auto_grading_mobile/controllers/Repository.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Dropdown extends StatefulWidget {
  final BaseRepository repository;
  final void Function(String?) onChanged; //callback

  Dropdown({required this.repository, required this.onChanged});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> _list = [];
  String? _chosenModel;
  TextEditingController _newClassController = TextEditingController(); // de nhap id
  TextEditingController _newClassController2 = TextEditingController(); // de nhap ten

  @override
  void initState() {
    _list = widget.repository.convertForDropdown(); // doi danh sach cua repository qua dang dropdown
    _chosenModel = (_list.isNotEmpty) ? _list[0] : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
            ),
            items: _list,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Menu mode",
                hintText: "country in menu mode",
              ),
            ),
            onChanged: (value) {
              setState(() {
                _chosenModel = value;
                widget.onChanged(value);
              });
            },
            selectedItem: _chosenModel,
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Class'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add New Class'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _newClassController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _newClassController2,
                          decoration: InputDecoration(
                            labelText: 'Id',
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _list.add(_newClassController.text);
                            _newClassController.text = "";
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text('Add'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

    );
  }
}
