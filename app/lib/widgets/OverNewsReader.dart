import 'package:app/models/Article.dart';
import 'package:app/widgets/FullScreenNewsView.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class OverlayNewsReader extends StatefulWidget {
  final List<Article> articles;
  final double toPosition;

  const OverlayNewsReader(
      {Key? key, required this.articles, this.toPosition = 0})
      : super(key: key);

  @override
  _OverlayNewsReaderState createState() => _OverlayNewsReaderState();
}

class _OverlayNewsReaderState extends State<OverlayNewsReader> {
  ScrollController listScrollController = new ScrollController();

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => listScrollController.jumpTo(widget.toPosition));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: ScrollSnapList(
              listController: listScrollController,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(0),
              itemBuilder: (BuildContext ctx, int idx) {
                return FullScreenNewsView(
                    article: widget.articles[idx], fullHeight: true);
              },
              itemCount: widget.articles.length,
              itemSize: screenHeight,
              onItemFocus: (idx) {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 15.0),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
