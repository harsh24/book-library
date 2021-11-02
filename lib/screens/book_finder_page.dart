import 'dart:async';

import 'package:fireauth/utils/spacer.dart';
import 'package:fireauth/service/google_books_service.dart';
import 'package:fireauth/service/google_books_provider.dart';
import 'package:fireauth/widget/booklistwidget.dart';
import 'package:fireauth/model/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BookFinderPage extends StatefulWidget {
  const BookFinderPage({Key? key}) : super(key: key);

  @override
  State<BookFinderPage> createState() => _BookFinderPageState();
}

class _BookFinderPageState extends State<BookFinderPage> {
  List<Book> _results = [];
  bool isLoading = true;
  final textcontroller = TextEditingController();
  final ScrollController _sc = ScrollController();

  Timer? searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 500);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(String value) async {
    List<Book> result = [];
    if (value.isNotEmpty) {
      GoogleBooksService googleBooksService = GoogleBooksService();
      result = await googleBooksService.getBooks(value, '0', '4');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _results = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _sc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 64, bottom: 16),
              child: Text(
                'Explore thousands of\nbooks on the go',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Mollen',
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                      controller: textcontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search for books...'),
                      onChanged: _onChangeHandler),
                ),
              ),
            ),
            const VerticalSpace(h: 10),
            SizedBox(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _results.isNotEmpty
                    ? _results[0].totalItems != 0
                        ? _SearchListView(
                            results: _results,
                            text: textcontroller.text,
                          )
                        : Center(
                            child:
                                Text('0 results for "${textcontroller.text}"'))
                    : Consumer<GoogleBooksProvider>(
                        builder: (context, gBookProvider, _) {
                          return gBookProvider.bookItem.isEmpty
                              ? (ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey,
                                      highlightColor: Colors.grey[400]!,
                                      child: ListTile(
                                        title: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: Colors.red,
                                          ),
                                          height: 130.0,
                                          width: 50.0,
                                        ),
                                      ),
                                    );
                                  }))
                              : _CreateListView(
                                  gBookProvider: gBookProvider,
                                  sc: _sc,
                                );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateListView extends HookWidget {
  const _CreateListView({
    Key? key,
    required this.gBookProvider,
    required this.sc,
  }) : super(key: key);
  final GoogleBooksProvider gBookProvider;
  final ScrollController sc;
  @override
  Widget build(BuildContext context) {
    sc.addListener(() {
      if (sc.position.maxScrollExtent == sc.position.pixels) {
        if (gBookProvider.isLoading == false) {
          gBookProvider.getResults('harry', 0, 10);
        }
      }
    });

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 20.0, top: 20),
        child: Text(
          'Famous Books',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Mollen',
          ),
        ),
      ),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: gBookProvider.bookItem.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == gBookProvider.bookItem.length) {
            return const ListTile(
              title: Center(child: CircularProgressIndicator()),
            );
          } else {
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/detail',
                  arguments: {'book': gBookProvider.bookItem[index]}),
              child: BookListWidget(
                book: gBookProvider.bookItem[index],
              ),
            );
          }
        },
      )
    ]);
  }
}

class _SearchListView extends StatelessWidget {
  const _SearchListView({
    Key? key,
    required this.results,
    required this.text,
  }) : super(key: key);

  final List<Book> results;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          key: UniqueKey(),
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              key: UniqueKey(),
              onTap: () => Navigator.of(context)
                  .pushNamed('/detail', arguments: {'book': item}),
              leading: AspectRatio(
                aspectRatio: 1,
                child: item.thumbnailUrl != null
                    ? Image.network(item.thumbnailUrl!)
                    : const FlutterLogo(),
              ),
              title: Text(item.title ?? ''),
              subtitle: Text('by ' + (item.authors ?? '')),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, '/results',
                  arguments: {'query': text});
            },
            child: Text('See all results for "$text"'),
          ),
        )
      ],
    );
  }
}
