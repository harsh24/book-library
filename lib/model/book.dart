abstract class MapConvertible {
  // Map<dynamic, dynamic> toMap();

  MapConvertible fromMap(Map<dynamic, dynamic> map);
}

class Book extends MapConvertible {
  Book({
    this.title,
    this.authors,
    this.isbn13,
    this.thumbnailUrl,
    this.categories,
    this.averageRating,
    this.totalItems,
    this.ratingCount,
    this.description,
    this.pageCount,
    this.publishedDate,
    this.publisher,
    this.infoLink,
    this.embeddable,
  });

  final String? title;
  final String? authors;
  final String? thumbnailUrl;
  final String? categories;
  final String? isbn13;
  final int? totalItems;
  final double? averageRating;
  final String? ratingCount;
  final String? description;
  final String? publishedDate;
  final String? publisher;
  final String? pageCount;
  final String? infoLink;
  final bool? embeddable;

  @override
  Book fromMap(Map map) {
    return Book(isbn13: map['isbn']);
  }
}
