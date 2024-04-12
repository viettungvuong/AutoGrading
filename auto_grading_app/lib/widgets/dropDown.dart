import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Dropdown extends StatefulWidget {
  final List<String> list;
  final void Function(String?) onChanged; //callback

  Dropdown({required this.list, required this.onChanged});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> _list = [];
  String? _chosenModel;
  TextEditingController _newClassController = TextEditingController();

  @override
  void initState() {
    _list = widget.list;
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

          TextField(
            controller: _newClassController,
            decoration: InputDecoration(
              labelText: 'Enter a new class',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _list.add(_newClassController.text);
                    _newClassController.text = "";
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
