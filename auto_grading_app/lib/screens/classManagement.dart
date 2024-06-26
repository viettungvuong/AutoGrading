import 'package:auto_grading_mobile/repositories/classRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Class.dart';
import '../models/User.dart';
import '../views/classView.dart';
import '../views/viewFactory.dart';
import '../widgets/searchBar.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final classesProvider = FutureProvider<List<Class>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  if (searchQuery.isEmpty) {
    return ClassRepository.instance.getAll();
  } else {
    return ClassRepository.instance.filter(searchQuery);
  }
});


class ClassManagementScreen extends ConsumerStatefulWidget {
  @override
  _ClassManagementScreenState createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends ConsumerState<ClassManagementScreen> {
  final TextEditingController _newClassController = TextEditingController();
  final TextEditingController _newClassController2 = TextEditingController();
  late AsyncValue<List<Class>> classesAsyncValue; // luu class

  @override
  void dispose() {
    _newClassController.dispose();
    _newClassController2.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    ref.read(classesProvider);
  }

  @override
  Widget build(BuildContext context) {
    classesAsyncValue = ref.watch(classesProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Search(
              onSearch: (query) {
                setState(() {
                  ref.read(searchQueryProvider.state).state = query;
                });

              },
            ),
            User.instance.isStudent == false
                ? IconButton(
              onPressed: () {
                _showAddDialog(context, ref);
              },
              icon: Icon(Icons.add),
            )
                : SizedBox(),
            Expanded(
              child: classesAsyncValue.when(
                data: (classes) {
                  if (classes.isEmpty) {
                    return Center(
                      child: Text('No classes available'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        return ObjectViewFactory.getView(classes[index]);
                      },
                    );
                  }
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
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
              onPressed: () async {
                if (_newClassController.text.isEmpty || _newClassController2.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please fill in all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );
                  return;
                }
                String name = _newClassController.text;
                String id = _newClassController2.text;
                await ClassRepository.instance.add(Class(name, id));
                ref.refresh(classesProvider); // refresh danh sach class
                _newClassController.text = "";
                _newClassController2.text = "";

                Navigator.of(context).pop();
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
