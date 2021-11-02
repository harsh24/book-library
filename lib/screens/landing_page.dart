import 'package:fireauth/utils/spacer.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, this.skip}) : super(key: key);
  final bool? skip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Books\n',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Discover your favorites.',
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
                ],
              )),
          const VerticalSpace(h: 32),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/auth',
                  arguments: {'type': false}),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(220, 10), primary: Colors.indigo[200]),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.indigo[900],
                  decoration: TextDecoration.underline,
                ),
              )),
          const VerticalSpace(h: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/auth',
                arguments: {'type': true}),
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(220, 10), primary: Colors.indigo),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          skip != false
              ? Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 16, right: 24),
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
