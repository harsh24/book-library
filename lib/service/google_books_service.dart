import 'dart:convert';

import 'package:fireauth/model/book.dart';
import 'package:fireauth/model/google_books.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class GoogleBooksService {
  Future<List<Book>> getBooks(String url, String index, String max) async {
    final uri = Uri.https('books.googleapis.com', '/books/v1/volumes', {
      'q': 'intitle:' + url + '|inauthor:' + url,
      'startIndex': index,
      'maxResults': max,
      'fields=': 'totalItems,items(volumeInfo(title,publisher,authors,categories,'
          'description,publishedDate,infoLink,averageRating,imageLinks/smallThumbnail,'
          'industryIdentifiers(identifier,type),ratingsCount,pageCount),accessInfo/embeddable)'
    });
    //print(uri.toString());
    final res = await get(uri);

    if (res.statusCode == 200) {
      return _parseBookJson(res.body);
    } else {
      throw Exception('Error: ${res.statusCode}');
    }
  }

  List<Book> _parseBookJson(String jsonStr) {
    final jsonMap = json.decode(jsonStr);

    if (jsonMap['totalItems'] != 0) {
      final volume = GoogleBooks.fromJson(jsonMap);
      var formatter = NumberFormat('#,##,##0');

      final x = volume.items
          .map(
            (result) => Book(
              title: result.volumeinfo.title,
              authors: result.volumeinfo.authors,
              thumbnailUrl: result.volumeinfo.image?.thumb,
              averageRating: result.volumeinfo.averageRating?.toDouble(),
              categories: result.volumeinfo.categories,
              isbn13: result.volumeinfo.isbn?[0].iSBN13,
              description: result.volumeinfo.description,
              ratingCount:
                  formatter.format(result.volumeinfo.ratingsCount ?? 0),
              pageCount: result.volumeinfo.pageCount.toString(),
              publishedDate: result.volumeinfo.publishedDate,
              publisher: result.volumeinfo.publisher,
              infoLink: result.volumeinfo.infoLink,
              embeddable: result.accessInfo.embeddable,
            ),
          )
          .toList();

      return x;
    }
    return [Book(totalItems: 0)];
  }
}
