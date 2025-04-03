import 'package:pokedex/data/models/pokemon_detail_model.dart';

import '../../data/repositories/pokemon_repository.dart';

class GetPokemonDetailUseCase {
  final PokemonRepository _repository;

  GetPokemonDetailUseCase(this._repository);

  Future<PokemonDetailModel> call(String pokemonID) async {
    return await _repository.getPokemon(pokemonID);
  }
}
