import 'package:pokedex/data/models/pokemon_detail_model.dart';

import '../models/pokemon_model.dart';
import '../../core/api_service.dart';

class PokemonRepository {
  final ApiService _apiService;

  PokemonRepository(this._apiService);

  Future<List<Pokemon>> getPokemons(int offset) async {
    final data = await _apiService
        .get('pokemon', params: {'limit': 20, 'offset': offset});
    return (data['results'] as List)
        .map((json) => Pokemon.fromJson(json))
        .toList();
  }

  Future<PokemonDetailModel> getPokemon(String pokemonID) async {
    final data = await _apiService.get('pokemon/$pokemonID');
    return PokemonDetailModel.fromJson(data);
  }
}
