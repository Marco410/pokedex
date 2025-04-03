import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/core/style.dart';
import 'package:pokedex/data/models/filters.dart';
import 'package:pokedex/presentation/providers/pokemon_provider.dart';

class RadioButtonWidget extends StatelessWidget {
  const RadioButtonWidget({
    super.key,
    required this.filters,
    required this.ref,
    required this.value,
    required this.option,
  });

  final Filters filters;
  final WidgetRef ref;
  final String value;
  final String option;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: filters.sortBy,
          activeColor: ColorStyle.primaryColor,
          onChanged: (val) {
            ref
                .read(filterPokemonsProvider.notifier)
                .update((state) => Filters(sortBy: val!));
          },
        ),
        Text(
          option,
          style: TxtStyle.labelText,
        ),
      ],
    );
  }
}
