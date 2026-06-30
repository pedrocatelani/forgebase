import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forgebase/utils/translate.dart';

class SearchHelper {
  String searchTerm = '';
  Timer? _debounce;
  final VoidCallback onSearchChanged;

  SearchHelper({required this.onSearchChanged});

  void dispose() {
    _debounce?.cancel();
  }

  void clearSearch() {
    searchTerm = '';
    onSearchChanged();
  }

  void onSearchInputChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final term = query.trim();
      if (searchTerm != term) {
        searchTerm = term;
        onSearchChanged();
      }
    });
  }

  Future<void> openSearch(BuildContext context) async {
    final TextEditingController searchController =
        TextEditingController(text: searchTerm);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translate('HOME.SEARCH_DECKS_HINT')),
          content: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: translate('HOME.SEARCH_DECKS_HINT'),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: onSearchInputChanged,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(MaterialLocalizations.of(context).closeButtonLabel),
            ),
          ],
        );
      },
    );
  }
}
