import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/core/style.dart';
import 'package:pokedex/data/models/pokemon_detail_model.dart';
import 'package:pokedex/presentation/providers/pokemon_provider.dart';
import 'package:pokedex/presentation/utils/helpers.dart';
import 'package:pokedex/presentation/widgets/pokemon_image.dart';
import 'package:sizer_pro/sizer.dart';

import '../../widgets/type_widget.dart';

class PokemonDetailScreen extends ConsumerStatefulWidget {
  final String pokemonID;

  const PokemonDetailScreen({super.key, required this.pokemonID});

  @override
  ConsumerState<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends ConsumerState<PokemonDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(pokemonProvider.notifier).fetchPokemonDetails(widget.pokemonID);
    });
    super.initState();
  }

  Color color = Color(0xFF74CB48);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final pokemonSize = screenSize.height * 0.3;

    final pokemon = ref.watch(pokemonDetailProvider);

    if (pokemon == null) {
      return Scaffold(
          backgroundColor: color,
          body: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    }

    if (pokemon.types.isNotEmpty) {
      setState(() {
        color = Helpers.colorPokemon(pokemon.types[0].type.name);
      });
    }

    return Scaffold(
      backgroundColor: color,
      body: AnimatedSwitcher(
        duration: Duration(seconds: 2),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              heroSection(context, pokemon),
              imageSection(pokemon, pokemonSize),
              contentSection(pokemon)
            ],
          ),
        ),
      ),
    );
  }

  Widget contentSection(PokemonDetailModel pokemon) {
    return Expanded(
        flex: 4,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 15,
              children: [
                typeSection(pokemon),
                Text(
                  "Acerca de",
                  style: TxtStyle.headerStyle.copyWith(color: color),
                ),
                aboutSection(pokemon),
                Text(
                  "Estadisticas",
                  style: TxtStyle.headerStyle.copyWith(color: color),
                ),
                StatsWidget(
                  pokemon: pokemon,
                  color: color,
                )
              ],
            ),
          ),
        ));
  }

  SizedBox typeSection(PokemonDetailModel pokemon) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: pokemon.types.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => FadedScaleAnimation(
            child: TypeWidget(name: pokemon.types[index].type.name)),
      ),
    );
  }

  Widget aboutSection(PokemonDetailModel pokemon) {
    return FadedScaleAnimation(
      child: SizedBox(
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 70,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage("assets/icons/weight.png")),
                      Text(
                        "${pokemon.weight / 10} kg",
                      ),
                    ],
                  ),
                ),
                Text(
                  "Peso",
                  style: TxtStyle.hintText,
                ),
              ],
            ),
            Container(
              width: 1,
              height: 80,
              color: Colors.black12,
            ),
            Column(
              children: [
                SizedBox(
                  height: 70,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage("assets/icons/height.png")),
                      Text(
                        "${pokemon.height / 10} m",
                      ),
                    ],
                  ),
                ),
                Text(
                  "Altura",
                  style: TxtStyle.hintText,
                ),
              ],
            ),
            Container(
              width: 1,
              height: 80,
              color: Colors.black12,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 70,
                  width: 100,
                  child: ListView.builder(
                    itemCount: pokemon.moves.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Text(
                      "${pokemon.moves[index].move.name.substring(0, 1).toUpperCase()}${pokemon.moves[index].move.name.substring(1)}, ",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TxtStyle.labelNormalText.copyWith(fontSize: 7.f),
                    ),
                  ),
                ),
                Text(
                  "Movimientos",
                  style: TxtStyle.hintText,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageSection(PokemonDetailModel pokemon, double pokemonSize) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -170,
              child: Center(
                child: PokemonImageWidget(
                    pokemonID: pokemon.id.toString(), pokemonSize: pokemonSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget heroSection(BuildContext context, PokemonDetailModel pokemon) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              (pokemon.id != 1)
                  ? Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(pokemonProvider.notifier)
                                .fetchPokemonDetails(
                                    (pokemon.id - 1).toString());
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(pokemonProvider.notifier)
                          .fetchPokemonDetails((pokemon.id + 1).toString());
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FadeAnimation(
              child: Row(
                spacing: 10,
                children: [
                  Bounceable(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 15.f,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${pokemon.name.substring(0, 1).toUpperCase()}${pokemon.name.substring(1)}",
                    style: TxtStyle.headerStyle.copyWith(fontSize: 15.f),
                  ),
                ],
              ),
            ),
            FadeAnimation(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  "#${pokemon.id.toString().padLeft(3, '0')}",
                  style: TxtStyle.labelText.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        FadedScaleAnimation(
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Image.asset(
                "assets/pokeball.png",
                scale: 0.5,
                height: 25.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StatsWidget extends StatefulWidget {
  const StatsWidget({
    super.key,
    required this.pokemon,
    required this.color,
  });

  final PokemonDetailModel pokemon;
  final Color color;

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      child: SizedBox(
        height: 30.h,
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ListView.builder(
                itemCount: widget.pokemon.stats.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 15,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        Helpers.substringStat(
                            widget.pokemon.stats[index].stat.name),
                        textAlign: TextAlign.end,
                        style: TxtStyle.labelText.copyWith(color: widget.color),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.black26,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.pokemon.stats[index].baseStat.toString(),
                        style: TxtStyle.labelNormalText,
                      ),
                    ),
                    Expanded(
                      flex: 11,
                      child: ScaleAnimation(
                        child: LinearProgressIndicator(
                          value: widget.pokemon.stats[index].baseStat / 100,
                          backgroundColor: widget.color.withAlpha(50),
                          color: widget.color,
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
