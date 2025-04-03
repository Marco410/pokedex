import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/constants.dart';
import 'package:pokedex/core/style.dart';
import 'package:shimmer/shimmer.dart';

class PokemonImageWidget extends StatelessWidget {
  const PokemonImageWidget({
    super.key,
    required this.pokemonID,
    required this.pokemonSize,
  });

  final String pokemonID;
  final double pokemonSize;
  static const Size _cacheMaxSize = Size(700, 700);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: int.parse(pokemonID),
      child: CachedNetworkImage(
        imageUrl: Constants.mediaImageUrl(int.parse(pokemonID)),
        useOldImageOnUrlChange: true,
        maxWidthDiskCache: _cacheMaxSize.width.toInt(),
        maxHeightDiskCache: _cacheMaxSize.height.toInt(),
        fadeInDuration: const Duration(milliseconds: 120),
        fadeOutDuration: const Duration(milliseconds: 120),
        imageBuilder: (_, image) => Image(
          image: image,
          width: Size.square(pokemonSize).width,
          height: Size.square(pokemonSize).height,
          alignment: Alignment.bottomCenter,
          fit: BoxFit.contain,
        ),
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: ColorStyle.hintColor,
          highlightColor: ColorStyle.hintLightColor,
          child: Container(
            width: Size.square(pokemonSize).width,
            height: Size.square(pokemonSize).height,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
        ),
        errorWidget: (_, __, ___) => Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: ColorStyle.hintColor,
              highlightColor: ColorStyle.hintLightColor,
              child: Container(
                width: Size.square(pokemonSize).width,
                height: Size.square(pokemonSize).height,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
