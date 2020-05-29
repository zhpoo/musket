import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:musket/musket.dart';

/// width:height
const double kDefaultBannerRatio = 1.618;

class BannerResource {
  String imageUrl;
}

class BannerController extends SwiperController {}

class SwipeBanner<T extends BannerResource> extends StatelessWidget {
  final List<T> banners;
  final bool autoPlay;
  final void Function(T data) onTap;
  final EdgeInsetsGeometry margin;
  final Color imageBackground;
  final Color dotColor;
  final Color dotActiveColor;
  final double dotSize;
  final double dotSpace;
  final BorderRadius borderRadius;
  final double ratio;
  final BannerController controller;

  const SwipeBanner({
    Key key,
    @required this.banners,
    this.autoPlay: true,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.ratio = kDefaultBannerRatio,
    this.imageBackground = const Color(0x0A000000),
    this.dotColor = const Color(0x67FFFFFF),
    this.dotActiveColor = const Color(0xFFFFFFFF),
    this.dotSize = 4,
    this.dotSpace = 4,
    this.controller,
  })  : assert(autoPlay != null),
        assert(ratio != null && ratio > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (banners?.isEmpty ?? true) {
      return Container();
    }
    final imageWidth = MediaQuery.of(context).size.width - (margin?.horizontal ?? 0);
    final height = imageWidth / ratio;
    return Container(
      margin: margin,
      height: height,
      child: PhysicalModel(
        color: imageBackground,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Swiper.list(
          list: banners,
          controller: controller,
          autoplay: autoPlay,
          onTap: (index) => onTap?.call(banners[index]),
          builder: (BuildContext context, dynamic data, int index) {
            return CachedNetworkImage(
              width: imageWidth,
              height: height,
              imageUrl: (data as T)?.imageUrl ?? '',
              fit: BoxFit.cover,
            );
          },
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              size: dotSize,
              activeSize: dotSize,
              space: dotSpace,
              color: dotColor,
              activeColor: dotActiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
