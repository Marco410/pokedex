import 'package:flutter/Material.dart';
import 'package:pokedex/core/style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer_pro/sizer.dart';

class LoadingStandardWidget {
  static Widget skeleton(
      {double? size = 25,
      int rows = 3,
      int columnsPerRow = 2,
      IconData? icon}) {
    return Column(
      spacing: 15,
      children: List.generate(rows, (rowIndex) {
        return Row(
          spacing: 10,
          children: List.generate(columnsPerRow, (columnIndex) {
            return Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: ColorStyle.hintColor,
                    highlightColor: ColorStyle.hintLightColor,
                    child: Container(
                      height: size?.h ?? 25.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey),
                    ),
                  ),
                  icon != null
                      ? ImageIcon(
                          AssetImage("assets/icons/pokeball_bar.png"),
                          color: ColorStyle.hintLightColor,
                          size: (size?.h ?? 25.h) / 4,
                        )
                      : SizedBox(),
                ],
              ),
            );
          }),
        );
      }),
    );
  }
}
