import 'package:flutter/material.dart';
import 'package:musket/musket.dart';

/// width:height
const double kDefaultBannerRatio = 1.618;

class BannerResource {
  String imageUrl;

  BannerResource({required String image}) : imageUrl = image;
}

class BannerController extends SwiperController {}

class SwipeBanner<T extends BannerResource> extends StatelessWidget {
  final List<T> banners;
  final bool autoPlay;
  final void Function(T data)? onTap;
  final EdgeInsetsGeometry? margin;
  final Color imageBackground;
  final Color dotColor;
  final Color dotActiveColor;
  final double dotSize;
  final double dotSpace;
  final BorderRadius? borderRadius;
  final double ratio;
  final BannerController? controller;
  final SwiperDataBuilder? itemBuilder;
  final bool outer;
  final bool loop;
  final bool showPagination;
  final int? index;
  final SwiperPlugin? pagination;

  const SwipeBanner({
    super.key,
    required this.banners,
    this.autoPlay = true,
    this.onTap,
    this.margin,
    this.borderRadius,
    this.itemBuilder,
    this.ratio = kDefaultBannerRatio,
    this.imageBackground = const Color(0x0A000000),
    this.dotColor = const Color(0x67FFFFFF),
    this.dotActiveColor = const Color(0xFFFFFFFF),
    this.dotSize = 4,
    this.dotSpace = 4,
    this.controller,
    this.index,
    this.pagination,
    this.outer = false,
    bool? loop,
    bool? showPagination,
  })  : assert(ratio > 0),
        this.loop = loop ?? banners.length > 1,
        this.showPagination = showPagination ?? banners.length > 1;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
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
          outer: outer,
          list: banners,
          index: index,
          loop: loop,
          controller: controller,
          autoplay: autoPlay,
          onTap: (index) => onTap?.call(banners[index]),
          builder: itemBuilder ??
              (BuildContext context, dynamic data, int index) {
                return CachedNetworkImage(
                  imageUrl: (data as T).imageUrl,
                  width: imageWidth,
                  height: height,
                  fit: BoxFit.cover,
                );
              },
          pagination: showPagination
              ? SwiperPagination(
                  builder: pagination ??
                      DotSwiperPaginationBuilder(
                        size: dotSize,
                        activeSize: dotSize,
                        space: dotSpace,
                        color: dotColor,
                        activeColor: dotActiveColor,
                      ),
                )
              : null,
        ),
      ),
    );
  }
}
