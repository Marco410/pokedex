class Constants {
  static const String apiBaseUrl = 'https://pokeapi.co/api/v2/';
  static String mediaImageUrl(int id) {
    return "https://assets.pokemon.com/assets/cms2/img/pokedex/full/${id.toString().padLeft(3, '0')}.png";
  }
}
