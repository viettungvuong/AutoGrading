import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search...',
        ),
        onSubmitted: _performSearch,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _performSearch(_controller.text),
        ),
      ],
    );
  }
}