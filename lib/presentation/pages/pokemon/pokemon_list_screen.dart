import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/core/style.dart';
import 'package:pokedex/presentation/utils/helpers.dart';
import 'package:pokedex/presentation/utils/loading_widget.dart';
import 'package:pokedex/presentation/widgets/appbar_widget.dart';
import 'package:sizer_pro/sizer.dart';
import '../../providers/pokemon_provider.dart';
import 'widgets/pokemon_card.dart';

class PokemonListScreen extends ConsumerStatefulWidget {
  const PokemonListScreen({super.key});

  @override
  PokemonListScreenState createState() => PokemonListScreenState();
}

class PokemonListScreenState extends ConsumerState<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';

  @override
  void initState() {
    Future.microtask(() => ref.read(pokemonProvider.notifier).fetchPokemons());

    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ref.read(pokemonProvider.notifier).fetchPokemons();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pokemons = ref.watch(pokemonProvider);
    final loading = ref.watch(loadingProvider);
    final filters = ref.watch(filterPokemonsProvider);

    var filteredPokemons = pokemons;

    if (filters.sortBy == "name") {
      filteredPokemons
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else {
      filteredPokemons.sort((a, b) {
        int idA = Helpers.urlToPokemonID(a);
        int idB = Helpers.urlToPokemonID(b);
        return idA.compareTo(idB);
      });
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
            title: "Pokédex",
            onCancel: () {
              ref.read(pokemonProvider.notifier).fetchPokemons(reset: true);
            },
            onChanged: (value) {
              ref.read(pokemonProvider.notifier).filterPokemons(value);
            }),
        backgroundColor: ColorStyle.primaryColor,
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 25,
              children: [
                Expanded(
                  child: (filteredPokemons.isNotEmpty)
                      ? RefreshIndicator(
                          backgroundColor: ColorStyle.primaryColor,
                          color: Colors.white,
                          onRefresh: () async {
                            await ref
                                .read(pokemonProvider.notifier)
                                .fetchPokemons(reset: true);
                          },
                          child: GridView.builder(
                            controller: _scrollController,
                            itemCount: filteredPokemons.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.89,
                            ),
                            itemBuilder: (_, index) =>
                                PokemonCard(pokemon: filteredPokemons[index]),
                          ),
                        )
                      : loading
                          ? SingleChildScrollView(
                              child: LoadingStandardWidget.skeleton(
                                  rows: 4,
                                  size: 1.5.h,
                                  columnsPerRow: 3,
                                  icon: Icons.abc),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 15,
                                children: [
                                  Lottie.network(
                                      "https://lottie.host/ed3e3299-4a6c-4fcb-bacc-76f282cb7bf6/Aa82yIbK1k.json",
                                      height: 120,
                                      fit: BoxFit.contain),
                                  Text(
                                    "No hay resultados.",
                                    style: TxtStyle.labelText,
                                  ),
                                  Bounceable(
                                    onTap: () => ref
                                        .read(pokemonProvider.notifier)
                                        .fetchPokemons(reset: true),
                                    child: Text(
                                      "Recargar",
                                      style: TxtStyle.labelText.copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              ColorStyle.primaryColor,
                                          color: ColorStyle.primaryColor),
                                    ),
                                  ),
                                ],
                              )),
                ),
                loading
                    ? SingleChildScrollView(
                        child: LoadingStandardWidget.skeleton(
                            rows: 1,
                            size: 1.5.h,
                            columnsPerRow: 3,
                            icon: Icons.abc),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
