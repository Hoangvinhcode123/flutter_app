import 'package:app_tuan89/screens/SelectLocationScreen.dart';
import 'package:flutter/material.dart';

void showSelectLocationModal({
  required BuildContext context,
  required String title,
  required List<String> items,
  required Function(String) onSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: SelectLocationModal(
          title: title,
          items: items,
          onSelected: onSelected,
        ),
      );
    },
  );
}
