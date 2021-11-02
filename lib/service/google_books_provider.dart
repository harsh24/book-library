import 'package:fireauth/model/book.dart';
import 'package:fireauth/service/google_books_service.dart';
import 'package:flutter/material.dart';

class GoogleBooksProvider with ChangeNotifier {
  GoogleBooksService? googleBooksService;

  // ignore: prefer_final_fields
  List<Book> _item = [];
  List<Book> get bookItem => _item;
  int _index = 0;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  GoogleBooksProvider(String url) {
    googleBooksService = GoogleBooksService();
    getResults(url, _index, 10);
  }

  void getResults(String url, int index, int max) async {
    setLoading(true);
    List<Book> _result = await googleBooksService!
        .getBooks(url, _index.toString(), max.toString());
    _item.addAll(_result);
    indexIncrement();
    setLoading(false);
  }

  void setLoading(bool b) {
    _isLoading = b;
    notifyListeners();
  }

  void indexIncrement() {
    _index += 10;
  }
}
