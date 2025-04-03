import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/data/models/filters.dart';
import 'package:pokedex/data/models/pokemon_detail_model.dart';
import 'package:pokedex/presentation/utils/helpers.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../domain/usecases/get_pokemon_usecase.dart';
import '../../domain/usecases/get_pokemons_usecase.dart';
import '../../data/models/pokemon_model.dart';
import '../../core/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PokemonRepository(apiService);
});

final getPokemonsUseCaseProvider = Provider<GetPokemonsUseCase>((ref) {
  final repository = ref.read(pokemonRepositoryProvider);
  return GetPokemonsUseCase(repository);
});

final getPokemonDetailUseCaseProvider =
    Provider<GetPokemonDetailUseCase>((ref) {
  final repository = ref.read(pokemonRepositoryProvider);
  return GetPokemonDetailUseCase(repository);
});

final pokemonProvider =
    StateNotifierProvider<PokemonNotifier, List<Pokemon>>((ref) {
  final useCase = ref.read(getPokemonsUseCaseProvider);
  final useCaseDetail = ref.read(getPokemonDetailUseCaseProvider);
  return PokemonNotifier(ref, useCase, useCaseDetail);
});

final loadingProvider = StateProvider<bool>((ref) => false);
final loadingDetailProvider = StateProvider<bool>((ref) => false);

final filterPokemonsProvider =
    StateProvider<Filters>((ref) => Filters(sortBy: "number"));

final pokemonDetailProvider = StateProvider<PokemonDetailModel?>((ref) => null);

class PokemonNotifier extends StateNotifier<List<Pokemon>> {
  final GetPokemonsUseCase _getPokemonsUseCase;
  final GetPokemonDetailUseCase _getPokemonDetailUseCase;
  int _offset = 0;
  final Ref ref;
  List<Pokemon> _allPokemons = [];

  PokemonNotifier(
      this.ref, this._getPokemonsUseCase, this._getPokemonDetailUseCase)
      : super([]);

  Future<void> fetchPokemons({bool reset = false}) async {
    if (ref.read(loadingProvider)) return;

    ref.read(loadingProvider.notifier).state = true;

    if (reset) {
      _offset = 0;
      state = [];
      _allPokemons = [];
    }

    final newPokemons = await _getPokemonsUseCase(_offset);
    _allPokemons = [..._allPokemons, ...newPokemons];
    state = _allPokemons;

    _offset += 20;
    ref.read(loadingProvider.notifier).state = false;
  }

  void filterPokemons(String query) {
    final filters = ref.read(filterPokemonsProvider);

    if (query.isEmpty) {
      state = _allPokemons;
    } else {
      state = _allPokemons.where((p) {
        if (filters.sortBy == "name") {
          return p.name.toLowerCase().contains(query.toLowerCase());
        } else {
          int id = Helpers.urlToPokemonID(p);
          return id.toString().contains(query);
        }
      }).toList();
    }
  }

  Future<void> fetchPokemonDetails(String id) async {
    ref.read(pokemonDetailProvider.notifier).state =
        await _getPokemonDetailUseCase(id);
  }
}
