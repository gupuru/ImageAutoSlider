library image_auto_slider;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageAutoSlider extends StatefulWidget {
  final List<AssetImage> assetImages;
  final double imageHeight;
  final int slideMilliseconds;
  final int durationSecond;
  final BoxFit boxFit;

  const ImageAutoSlider({
    Key key,
    @required this.assetImages,
    this.boxFit = BoxFit.cover,
    this.imageHeight = 350.0,
    this.slideMilliseconds = 550,
    this.durationSecond = 2,
  }) : super(key: key);

  @override
  ImageAutoSliderState createState() {
    return new ImageAutoSliderState();
  }
}

class ImageAutoSliderState extends State<ImageAutoSlider> {
  List<Widget> _pages = [];

  int page = 0;
  int milliseconds = 550;

  final _controller = PageController(initialPage: 0);
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _pages = widget.assetImages.map((assetImage) {
      return _buildImagePageItem(assetImage, widget.boxFit);
    }).toList();

    _timer =
        Timer.periodic(Duration(seconds: widget.durationSecond), (Timer timer) {
      milliseconds = widget.slideMilliseconds;
      if (page < widget.assetImages.length - 1) {
        page++;
      } else {
        page = 0;
        milliseconds = 1;
      }

      _controller.animateToPage(
        page,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      height: widget.imageHeight,
      child: Container(
        child: Stack(
          children: [
            _buildPagerViewSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: PageView.builder(
        physics: new NeverScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        },
        onPageChanged: (int p) {
          setState(() {
            page = p;
          });
        },
      ),
    );
  }

  Widget _buildImagePageItem(AssetImage assetImage, BoxFit fit) {
    return Container(
        decoration: BoxDecoration(
      image: DecorationImage(
        image: assetImage,
        fit: fit,
      ),
    ));
  }
}
