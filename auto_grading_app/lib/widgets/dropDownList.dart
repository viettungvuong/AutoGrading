import 'package:auto_grading_mobile/controllers/classRepository.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../controllers/Repository.dart';
import '../models/Student.dart';
import '../structs/pair.dart';

class DropdownListStudent extends StatefulWidget {
  final List<Student> list;
  final void Function(Student) onChanged; // callback

  DropdownListStudent({
    required this.list,
    required this.onChanged,
  });

  @override
  _DropdownRepositoryState createState() => _DropdownRepositoryState();
}

class _DropdownRepositoryState extends State<DropdownListStudent> {
  List<String> _list = [];
  String? _chosenModel;
  late List<Pair> _dropdownList;

  List<Pair> _convertForDropdown(){
    List<Pair> res=[];
    widget.list.forEach((element) {
      String name = element.getName();
      String id = element.getStudentId();
      res.add(Pair(name,id));
    });

    return res;

  }

  @override
  void initState() {
    _dropdownList = _convertForDropdown();
    _dropdownList.forEach((element) {
      _list.add(element.a + "-" + element.b); // them vao _list sau khi doi qua list danh cho dropdown
    });
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
                labelText: "Students",
              ),
            ),
            onChanged: (value) {
              setState(() {
                _chosenModel = value;

                int selectedIndex = _list.indexOf(value!); // tim index trong list theo value
                widget.onChanged(widget.list[selectedIndex]); // lay student moi chon
              });
            },
            selectedItem: _chosenModel,
          ),

        ],
      ),
    );
  }

}
