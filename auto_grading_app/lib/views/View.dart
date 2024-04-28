import 'package:flutter/cupertino.dart';

import 'classView.dart';

abstract class ObjectView<T> extends StatelessWidget {
  final T t;

  const ObjectView({Key? key, required this.t}) : super(key: key);

  @override
  Widget build(BuildContext context);
}
