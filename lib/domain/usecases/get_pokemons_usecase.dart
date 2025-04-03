import '../../data/repositories/pokemon_repository.dart';
import '../../data/models/pokemon_model.dart';

class GetPokemonsUseCase {
  final PokemonRepository _repository;

  GetPokemonsUseCase(this._repository);

  Future<List<Pokemon>> call(int offset) async {
    return await _repository.getPokemons(offset);
  }
}
