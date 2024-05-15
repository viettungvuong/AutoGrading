import 'package:auto_grading_mobile/views/studentView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/Class.dart';
import '../models/Student.dart';
import '../models/User.dart';
import 'View.dart';

class ClassView extends ObjectView<Class> {
  ClassView({required super.t});

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      Fluttertoast.showToast(
        msg: 'Code copied to clipboard',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!User.instance.isStudent) {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
            ),
            builder: (BuildContext context) {
              return Container(
                height: 500,
                child: t.students.toSet().isNotEmpty
                    ? ListView.builder(
                  itemCount: t.students.toSet().length,
                  itemBuilder: (context, index) {
                    print(t.students.toSet());
                    return StudentView(t: t.students.toSet().toList()[index]);
                  },
                )
                    : Container(
                  width: double.infinity, // Spread text to full width
                  child: Center(
                    child: Text("No students"),
                  ),
                ),
              );
            },
          );
        }
        else{
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
            ),
            builder: (BuildContext context) {
              return IntrinsicHeight(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text("Invitation code: "),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: SelectableText(
                                t.getCode(),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _copyToClipboard(t.getCode());
                              },
                              icon: Icon(Icons.copy),
                              label: Text("Copy"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              );
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // You can customize the border color here
            width: 1.0, // You can adjust the border width here
          ),
          borderRadius: BorderRadius.circular(8.0), // You can adjust the border radius here
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                t.getName(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10,),

              User.instance.isStudent==false?Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      t.getCode(),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _copyToClipboard(t.getCode());
                    },
                    icon: Icon(Icons.copy),
                    label: Text("Copy"),
                  ),
                ],
              ):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

}
