import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../model/constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.title, required this.onSearch})
      : super(key: key);

  final String title;
  final Function onSearch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 71.w,
      child: AnimatedSearchBar(
        height: 50,
        searchDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: K.whiteText),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: K.whiteText),
          ),
        ),
        labelStyle: const TextStyle(
          color: K.whiteText,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        searchStyle: const TextStyle(color: K.whiteText, fontSize: 13),
        cursorColor: K.whiteText,
        label: title,
        onChanged: (value) {
          onSearch(query: value);
        },
      ),
    );
  }
}
