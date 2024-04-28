import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/Student.dart';
import '../structs/pair.dart';

class DropdownList extends StatefulWidget{
  final List<Student> list;
  final void Function(Student) onChanged;

  DropdownList({
    required this.list,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}

class DropdownListStudent extends DropdownList {
  DropdownListStudent({required super.list, required super.onChanged});


  @override
  _DropdownListStudentState createState() => _DropdownListStudentState();
}

class _DropdownListStudentState extends State<DropdownListStudent> {
  List<String> _dropdownOptions = [];
  String? _selectedItem;
  late List<Pair> _convertedList;

  @override
  void initState() {
    super.initState();
    _convertedList = _convertForDropdown();
    _dropdownOptions = _convertedList.map((pair) => "${pair.a}-${pair.b}").toList();
  }

  List<Pair> _convertForDropdown() {
    final Set<Student> uniqueStudents = widget.list.toSet();
    return uniqueStudents.map((student) {
      final name = student.getName();
      final id = student.getStudentId();
      return Pair(name, id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<String>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
          ),
          items: _dropdownOptions,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Students",
            ),
          ),
          onChanged: (value) {
            final selectedIndex = _dropdownOptions.indexOf(value!);
            widget.onChanged(widget.list[selectedIndex]);
            setState(() => _selectedItem = value);
          },
          selectedItem: _selectedItem,
        ),
      ],
    );
  }
}
