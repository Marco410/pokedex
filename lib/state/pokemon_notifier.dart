import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pokemon_model.dart';
import '../presentation/providers/pokemon_provider.dart';

final pokemonProvider =
    StateNotifierProvider<PokemonNotifier, List<Pokemon>>((ref) {
  return PokemonNotifier(ref);
});

class PokemonNotifier extends StateNotifier<List<Pokemon>> {
  PokemonNotifier(this.ref) : super([]);

  final Ref ref;
  int offset = 0;

  Future<void> fetchPokemons() async {
    final usecase = ref.read(getPokemonsUseCaseProvider);
    final newPokemons = await usecase(offset);
    state = [...state, ...newPokemons];
    offset += 20;
  }
}
