import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PageHeading extends StatelessWidget {
  final String heading;
  PageHeading(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 41, horizontal: 16),
      child: Text(
        heading,
        style: TextStyle(
            fontSize: 32,
            color: Colors.grey[600],
            fontWeight: FontWeight.w900,
            letterSpacing: 1),
      ),
    );
  }
}

class SliverHeading implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final String heading;

  SliverHeading({
    this.minExtent = 120,
    this.maxExtent = 120,
    required this.heading,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: PageHeading(heading),
        ));
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => null;
}
