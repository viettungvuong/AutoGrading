import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../repositories/Repository.dart';
import '../structs/pair.dart';

class DropdownRepository extends StatefulWidget {
  final BaseRepository repository;
  final void Function(String?) onChanged; // callback
  final void Function(Pair)? onAdded;
  final bool showAddButton;

  DropdownRepository({
    required this.repository,
    required this.onChanged,
    this.onAdded, // khong bat buoc phai truyen onAdded
    this.showAddButton = true,
  });

  @override
  _DropdownRepositoryState createState() => _DropdownRepositoryState();
}

class _DropdownRepositoryState extends State<DropdownRepository> {
  List<String> _list = [];
  String? _chosenModel;
  TextEditingController _newClassController = TextEditingController(); // for entering ID
  TextEditingController _newClassController2 = TextEditingController(); // for entering name
  late List<Pair> _dropdownList;

  @override
  void initState() {
    _dropdownList = widget.repository.convertForDropdown().toSet().toList();
    _dropdownList.forEach((element) {
      _list.add(element.a + "-" + element.b);
    });
    print(_dropdownList);
    _chosenModel = null;
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
          if (widget.showAddButton) // Render add button if showAddButton is true
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Class'),
              onPressed: _showAddDialog,
            ),
        ],
      ),
    );
  }
  void _showAddDialog() {
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
                if (_newClassController.text.isEmpty || _newClassController2.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please fill in all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );
                }
                setState(() {
                  _list.add(
                      "${_newClassController.text}-${_newClassController2.text}");
                  Pair added = Pair(
                      _newClassController.text, _newClassController2.text);
                  _dropdownList.add(added); // them pair vao dropdownlis
                  if (widget.onAdded != null) {
                    widget.onAdded!(added); // Call onAdded if it's not null
                  }
                  _newClassController.text = "";
                  _newClassController2.text = "";

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
  }

}

