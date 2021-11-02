import 'package:fireauth/screens/book_detail_page.dart';
import 'package:fireauth/screens/book_finder_page.dart';
import 'package:fireauth/service/google_books_provider.dart';
import 'package:fireauth/screens/search_results_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AuthExampleApp());
}

class AuthExampleApp extends StatelessWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleBooksProvider>(
              create: (_) => GoogleBooksProvider('harry')),
        ],
        child: MaterialApp(
          title: 'Firebase Example App',
          debugShowCheckedModeBanner: false,
          home: const BookFinderPage(),
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                return _buildRoute(
                    context: context,
                    routeName: settings.name,
                    arguments: settings.arguments);
              },
              maintainState: true,
              fullscreenDialog: false,
            );
          },
        ));
  }
}

Widget _buildRoute({
  required BuildContext context,
  required String? routeName,
  Object? arguments,
}) {
  switch (routeName) {
    case '/home':
      return const BookFinderPage();

    case '/detail':
      final map = arguments as Map<String, dynamic>;
      final _book = map['book'];
      final _fav = map['fav'];

      return BookDetailsPage(book: _book, fav: _fav);

    case '/results':
      final map = arguments as Map<String, dynamic>;
      final query = map['query'];

      return SearchResultsPage(query: query);

    default:
      return Container();
  }
}
