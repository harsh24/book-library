import 'package:fireauth/model/book.dart';
import 'package:fireauth/service/google_books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class SearchResultsPage extends HookWidget {
  const SearchResultsPage({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider<GoogleBooksProvider>(
        create: (BuildContext context) {
          return GoogleBooksProvider(query);
        },
        child: Align(
          alignment: Alignment.center,
          child: Consumer<GoogleBooksProvider>(
            builder: (context, gBookProvider, _) {
              return gBookProvider.bookItem.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: gBookProvider.bookItem.length + 1,
                        itemBuilder: (context, index) {
                          Book item = Book();
                          if (index != gBookProvider.bookItem.length) {
                            item = gBookProvider.bookItem[index];
                          }
                          return item.totalItems != 0
                              ? index != gBookProvider.bookItem.length
                                  ? (ListTile(
                                      key: UniqueKey(),
                                      onTap: () => Navigator.of(context)
                                          .pushNamed('/detail',
                                              arguments: {'book': item}),
                                      leading: AspectRatio(
                                        aspectRatio: 1,
                                        child: item.thumbnailUrl != null
                                            ? Image.network(item.thumbnailUrl!)
                                            : const FlutterLogo(),
                                      ),
                                      title: Text(item.title ?? ''),
                                      subtitle:
                                          Text('by ' + (item.authors ?? '')),
                                    ))
                                  : gBookProvider.isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : ListTile(
                                          title: const Center(
                                              child: Text('See more books...')),
                                          onTap: () async {
                                            gBookProvider.getResults(
                                                query, 0, 10);
                                          },
                                        )
                              : const Center(child: Text('0 results for '));
                        },
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
