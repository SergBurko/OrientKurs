import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StatisticButton extends StatelessWidget {
  StatisticButton({super.key, required this.name});
  String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Действия, которые должны выполняться при нажатии на кнопку
      },
      child: Container(
        width: 50,
        height: 50,
        // alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 247, 247, 247), // Установите цвет кнопки
        ),
        child:  Center(
          child: Tooltip(
            message: name,
            child: TextButton(
              // style: ButtonStyle(alignment: Alignment.center),
              onPressed: () {
              },
             child: AutoSizeText(name.substring(0,2), style: TextStyle(color: Colors.black),), 
            ),
          ),
        ),
      ),
    );
  }
}
