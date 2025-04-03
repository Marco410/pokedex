import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/core/style.dart';
import 'package:pokedex/presentation/providers/pokemon_provider.dart';
import 'package:pokedex/presentation/widgets/radio_button.dart';
import 'package:sizer_pro/sizer.dart';

// ignore: must_be_immutable
class AppBarWidget extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  AppBarWidget(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.onCancel});

  String title;
  ValueChanged<String>? onChanged;
  Function() onCancel;
  final double _prefferedHeight = 12.h;
  @override
  ConsumerState<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _AppBarWidgetState extends ConsumerState<AppBarWidget> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  bool isFocused = false;

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchFocus.addListener(() {
      setState(() {
        isFocused = searchFocus.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filterPokemonsProvider);
    return AppBar(
      backgroundColor: ColorStyle.primaryColor,
      leadingWidth: 60.w,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              "assets/icons/pokeball_bar.png",
              scale: 0.8,
              fit: BoxFit.fill,
            ),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TxtStyle.headerStyle.copyWith(fontSize: 14.f),
            )
          ],
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: TextFormField(
                      controller: searchController,
                      focusNode: searchFocus,
                      keyboardType: filters.sortBy == 'name'
                          ? TextInputType.text
                          : TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Buscar...',
                          border: InputBorder.none,
                          labelStyle: TxtStyle.labelText.copyWith(
                              fontSize: 5.sp,
                              color: ColorStyle.hintDarkColor,
                              fontWeight: FontWeight.normal),
                          constraints: BoxConstraints(maxHeight: 5.h),
                          suffixIcon: (isFocused)
                              ? IconButton(
                                  icon: Icon(Icons.close_rounded,
                                      color: ColorStyle.primaryColor),
                                  onPressed: () {
                                    widget.onCancel();
                                    searchController.clear();
                                    searchFocus.unfocus();
                                  },
                                )
                              : SizedBox(),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: ColorStyle.primaryColor,
                          )),
                      onChanged: widget.onChanged,
                    ),
                  ),
                ),
                Bounceable(
                  onTap: () {
                    dialogFilters(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      filters.sortBy == 'name'
                          ? Icons.abc_rounded
                          : Icons.tag_rounded,
                      size: 12.f,
                      color: ColorStyle.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future<dynamic> dialogFilters(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Consumer(builder: (context, ref, child) {
                final filters = ref.watch(filterPokemonsProvider);
                return Column(
                  spacing: 15,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Buscar y ordenar por:",
                      style: TxtStyle.headerStyle.copyWith(fontSize: 8.f),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          RadioButtonWidget(
                            filters: filters,
                            ref: ref,
                            value: "number",
                            option: "Número",
                          ),
                          RadioButtonWidget(
                            filters: filters,
                            ref: ref,
                            value: "name",
                            option: "Nombre",
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              backgroundColor: ColorStyle.primaryColor);
        },
        barrierDismissible: true);
  }
}
