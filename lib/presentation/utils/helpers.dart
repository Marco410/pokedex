import 'dart:ui';

import 'package:pokedex/data/models/pokemon_model.dart';

class Helpers {
  static int urlToPokemonID(Pokemon pokemon) {
    RegExp regExp = RegExp(r'pokemon/(\d+)/');
    Match? match = regExp.firstMatch(pokemon.url);
    return int.parse(match!.group(1)!);
  }

  static Color colorPokemon(String type) {
    const Map<String, Color> colors = {
      'grass': Color(0xFF74CB48),
      'fire': Color(0xFFF47D31),
      'water': Color(0xFF6493EA),
      'electric': Color(0xFFF7D02C),
      'poison': Color(0xFFA43E9E),
      'bug': Color(0xFFA7B823),
      'flying': Color(0xFFA891EC),
      'ghost': Color(0xFF70559B),
      'normal': Color(0xFFAAA67F),
      'psychic': Color(0xFFFB5584),
      'steel': Color(0xFFB7B9D0),
      'rock': Color(0xFFB69E31),
    };

    return colors[type] ?? Color(0xFF74CB48);
  }

  static String substringStat(String stats) {
    const Map<String, String> stat = {
      'hp': "HP",
      'attack': "ATK",
      'defense': "DEF",
      'special-attack': "SATK",
      'special-defense': "SDEF",
      'speed': "SPD",
    };

    return stat[stats] ?? "-";
  }
}
