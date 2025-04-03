import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/core/style.dart';
import 'package:pokedex/presentation/utils/helpers.dart';
import 'package:pokedex/presentation/widgets/pokemon_image.dart';
import 'package:sizer_pro/sizer.dart';
import '../../../../data/models/pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    int id = Helpers.urlToPokemonID(pokemon);
    final screenSize = MediaQuery.sizeOf(context);
    final pokemonSize = screenSize.height * 0.075;

    return FadedScaleAnimation(
      child: Bounceable(
        onTap: () =>
            context.pushNamed('pokemon', pathParameters: {"id": id.toString()}),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: const Offset(0, 0))
              ],
              borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: ColorStyle.hintLightColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "#${id.toString().padLeft(3, '0')}",
                        textAlign: TextAlign.end,
                        style:
                            TxtStyle.hintText.copyWith(color: Colors.black54),
                      ),
                    ),
                    PokemonImageWidget(
                        pokemonID: id.toString(), pokemonSize: pokemonSize),
                    Text(
                      "${pokemon.name.substring(0, 1).toUpperCase()}${pokemon.name.substring(1)}",
                      style: TxtStyle.labelText.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 7.f),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
