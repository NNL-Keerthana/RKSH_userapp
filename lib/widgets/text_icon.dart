import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final List<String> texts;
  const TextIcon(this.texts, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final sign in ['+', '-'])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: texts
                .map((e) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop("$e$sign");
                      },
                      child: CircleAvatar(
                        radius: 32,
                        child: Text("$e$sign"),
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }
}
