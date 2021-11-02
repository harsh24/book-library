class GoogleBooks {
  final int totalItems;

  final List<Item> items;

  GoogleBooks({required this.items, required this.totalItems});

  factory GoogleBooks.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;

    List<Item> itemList = list.map((i) {
      return Item.fromJson(i);
    }).toList();

    return GoogleBooks(items: itemList, totalItems: parsedJson['totalItems']);
  }
}

class Item {
  final VolumeInfo volumeinfo;

  final AccessInfo accessInfo;

  Item({
    required this.volumeinfo,
    required this.accessInfo,
  });

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(
      volumeinfo: VolumeInfo.fromJson(parsedJson['volumeInfo']),
      accessInfo: AccessInfo.fromJson(parsedJson['accessInfo']),
    );
  }
}

class VolumeInfo {
  VolumeInfo({
    required this.title,
    required this.isbn,
    required this.publisher,
    required this.authors,
    required this.categories,
    required this.averageRating,
    required this.image,
    required this.ratingsCount,
    required this.description,
    required this.pageCount,
    required this.publishedDate,
    required this.infoLink,
  });

  final String? title;
  final String? publisher;
  final String? authors;
  final String? categories;
  final String? description;
  final String? publishedDate;
  final String? infoLink;

  final dynamic averageRating;
  final ImageLinks? image;
  final List<ISBN>? isbn;
  final int? ratingsCount;
  final int? pageCount;

  factory VolumeInfo.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['industryIdentifiers'] as List?;
    List<ISBN>? isbn = list?.map((i) => ISBN.fromJson(i)).toList();

    return VolumeInfo(
      title: parsedJson['title'] as String?,
      publisher: parsedJson['publisher'] as String?,
      publishedDate: parsedJson['publishedDate'] as String?,
      authors: (parsedJson['authors'])?.join(', '),
      categories: (parsedJson['categories'])?.join(', '),
      averageRating: parsedJson['averageRating'],
      pageCount: parsedJson['pageCount'],
      ratingsCount: parsedJson['ratingsCount'],
      description: parsedJson['description'],
      isbn: isbn,
      infoLink: parsedJson['infoLink'],
      image: ImageLinks?.fromJson(
          parsedJson['imageLinks'] as Map<String, dynamic>?),
    );
  }
}

class ImageLinks {
  final String? thumb;

  ImageLinks({this.thumb});

  factory ImageLinks.fromJson(Map<String, dynamic>? parsedJson) {
    return ImageLinks(thumb: parsedJson?['smallThumbnail'] as String?);
  }
}

class ISBN {
  final String iSBN13;
  final String type;

  ISBN({required this.iSBN13, required this.type});

  factory ISBN.fromJson(Map<String, dynamic>? parsedJson) {
    return ISBN(
      iSBN13: parsedJson?['identifier'],
      type: parsedJson?['type'],
    );
  }
}

class AccessInfo {
  final bool embeddable;

  AccessInfo({required this.embeddable});

  factory AccessInfo.fromJson(Map<String, dynamic>? parsedJson) {
    return AccessInfo(
      embeddable: parsedJson?['embeddable'],
    );
  }
}
