import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BingImage extends StatefulWidget {
  final int index;

  const BingImage(this.index, {Key? key}) : super(key: key);

  @override
  State<BingImage> createState() => _BingImageState();
}

class _BingImageState extends State<BingImage> {
  late final Future<Image> image;

  @override
  void initState() {
    super.initState();
    image = _createFuture();
  }

  Future<Image> _createFuture() async {
    try {
      Uri uri = Uri.https('www.bing.com', '/HPImageArchive.aspx', {'format': 'js', 'idx': widget.index.toString(), 'n': '1'});
    print(uri);
    var response = await get(uri);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      var url = jsonDecode(response.body)['images'][0]['url'];
      return Image.network("https://www.bing.com$url");
    }
    return Image.asset("error");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image> (
      future: image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}