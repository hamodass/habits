import 'package:flutter/material.dart';


class ThemeChanger extends StatefulWidget {
  const ThemeChanger({Key? key}) : super(key: key);

  @override
  _ThemeChangerState createState() => _ThemeChangerState();
}

bool isDark = false;

class _ThemeChangerState extends State<ThemeChanger> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text("Dark Mode"),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Switch(
         
            value: isDark,
            onChanged: (isDarkMode) {
              setState(() {
                isDark = !isDark;
              });
            },
          ),
        ),
      ],
    );
  }
}
