import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String keyword);

class SearchBar extends StatelessWidget {
  final SearchCallback onSearch;

  const SearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          labelText: '搜索',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => onSearch,
          ),
        ),
      ),
    );
  }
}
