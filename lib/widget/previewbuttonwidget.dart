import 'package:fireauth/widget/preview_webview_widget.dart';
import 'package:flutter/material.dart';

class PreviewButtonWidget extends StatelessWidget {
  final String volumeId;
  final bool? availability;
  final String? title;

  const PreviewButtonWidget(
      {Key? key, required this.volumeId, this.availability, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 20), primary: Colors.green[600]),
            child: const Text('Preview'),
            onPressed: availability!
                ? () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PreviewWebView(
                        volumeId: volumeId,
                        title: title!,
                      );
                    }));
                  }
                : null),
      ],
    );
  }
}
