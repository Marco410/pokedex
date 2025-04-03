import 'package:flutter/material.dart';
import 'package:pokedex/core/style.dart';
import 'package:pokedex/presentation/utils/helpers.dart';
import 'package:sizer_pro/sizer.dart';

class TypeWidget extends StatelessWidget {
  const TypeWidget({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Helpers.colorPokemon(name),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          "${name.substring(0, 1).toUpperCase()}${name.substring(1)}",
          style:
              TxtStyle.labelText.copyWith(color: Colors.white, fontSize: 7.f),
        ));
  }
}
