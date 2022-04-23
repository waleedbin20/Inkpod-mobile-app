import 'package:app/models/Article.dart';
import 'package:app/screens/home/Trending.dart';
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

  PreferredSizeWidget buildAppBar() {
    final double screenHeight = MediaQuery.of(context).size.height;
    //final double screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      actions: <Widget>[],
      centerTitle: true,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
            child: Image(
              width: screenHeight * 2 / 13,
              image: AssetImage('assets/logo.png'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          SizedBox.expand(
            child: ScrollSnapList(
              listController: listScrollController,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 1 / 150),
              itemBuilder: (BuildContext ctx, int idx) {
                return FullScreenNewsView(
                    article: widget.articles[idx], fullHeight: true);
              },
              itemCount: widget.articles.length,
              itemSize: screenHeight,
              onItemFocus: (idx) {},
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(50),
          //     color: Colors.white,
          //   ),
          //   margin: const EdgeInsets.only(top: 15.0),
          //   child: IconButton(
          //     icon: Icon(Icons.close),
          //     onPressed: () => Navigator.pop(context),
          //   ),
          // )
        ],
      ),
    );
  }
}
