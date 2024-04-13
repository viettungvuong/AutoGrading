import 'package:auto_grading_mobile/controllers/Repository.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../structs/pair.dart';

class Dropdown extends StatefulWidget {
  final BaseRepository repository;
  final void Function(String?) onChanged; //callback
  final void Function(Pair) onAdded;

  Dropdown({required this.repository, required this.onChanged, required this.onAdded});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> _list = [];
  String? _chosenModel;
  TextEditingController _newClassController = TextEditingController(); // for entering ID
  TextEditingController _newClassController2 = TextEditingController(); // for entering name
  late List<Pair> _dropdownList;

  @override
  void initState() {
    _dropdownList = widget.repository.convertForDropdown();
    _dropdownList.forEach((element) {_list.add(element.a+"-"+element.b);});
    _chosenModel = (_dropdownList.isNotEmpty) ? _dropdownList[0].b : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
            ),
            items: _list,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Class",
              ),
            ),
            onChanged: (value) {
              setState(() {
                _chosenModel = value;
                int selectedIndex = _list.indexOf(value!);
                widget.onChanged(_dropdownList[selectedIndex].b); // lay id cua cai vua moi chon
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
                            _list.add("${_newClassController.text}-${_newClassController2.text}");
                            Pair added = Pair(_newClassController.text,_newClassController2.text);
                            _dropdownList.add(added); // them pair vao dropdownlis
                            widget.onAdded(added);

                            _newClassController.text = "";
                            _newClassController2.text="";

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

