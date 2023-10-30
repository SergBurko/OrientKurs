import 'package:flutter/material.dart';
import 'package:second_quiz/classes/common/saying.dart';

class Singleton {
  static String quizDirectoryName = "quiz";
  static String quizSettingsFileName = "settings.txt";
  static String quizUsersFileName = "users.txt";
  static String quizQuizesFileName = "quizes.txt";

  static String questionFileName = 'assets/jsons/questions.json';
  static String questionPathWithoutName = 'assets/jsons/';

  static String dbPath = 'https://orientkurs-default-rtdb.europe-west1.firebasedatabase.app';

// music
  static String assetsMusicFolder = 'music/';
  static int amountOfTracks = 4;

  static bool OnGroupScreenBlockSeconds = false;

  // static String internetCheckHost = "8.8.8.8";

  static List<String> lands = [
    "Baden-Württemberg",
    "Bayern",
    "Berlin",
    "Brandenburg",
    "Bremen",
    "Hamburg",
    "Hessen",
    "Mecklenburg-Vorpommern",
    "Niedersachsen",
    "Nordrhein-Westfalen",
    "Rheinland-Pfalz",
    "Saarland",
    "Sachsen",
    "Sachsen-Anhalt",
    "Schleswig-Holstein",
    "Thüringen"
  ];

  static ThemeData themes = ThemeData(
    // colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 253, 250, 219),),
    // primaryColor: const Color.fromARGB(255, 253, 250, 219),
    primaryColor: const Color.fromARGB(255, 255, 255, 255),

    textTheme: const TextTheme(
      labelSmall:
          TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'ComicSans'),
      labelMedium:
          TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'ComicSans'),
      labelLarge: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold, // Жирный шрифт (по желанию)
          fontFamily: 'ComicSans'),
      bodyLarge: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold, // Жирный шрифт (по желанию)
          fontFamily: 'ComicSans'),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(4)),
    ),

    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
      // backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 153, 88, 108)),
      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
      elevation: MaterialStateProperty.all(4),
      alignment: Alignment.center,
    )),
    iconTheme: const IconThemeData(
      size: 30,
    ),
    useMaterial3: true,
  );

  // static List<String> musicLinks = [
  //   "https://drive.google.com/uc?export=download&id=1_hy5xMCXK4gmtuVXdO11mFhIznc46AXo",
  //   "https://drive.google.com/u/0/uc?id=1ZKftPgKUuF9jF912ZabSp8mWCLzbbSQv&export=download"
  // ];
  static List<Saying> sayings = [
    Saying("Deutschland, das Land der Dichter und Denker.",
        "Johann Wolfgang von Goethe"),
    Saying("Arbeit macht das Leben süß.", " Friedrich Nietzsche"),
    Saying("Die Deutschen sind bekannt für ihre Pünktlichkeit.", ""),
    Saying("Made in Germany", ""),
    Saying("Die Berliner Mauer trennte Ost und West.", ""),
    Saying("Die deutsche Küche ist vielfältig und lecker.", ""),
    Saying("Deutschland hat eine reiche Kulturgeschichte.",
        "Friedrich von Schiller"),
    Saying("Goethe war ein bedeutender deutscher Dichter.",
        "Johann Wolfgang von Goethe"),
    Saying("Bier und Bratwurst sind typisch deutsch.", ""),
    Saying("Die Autobahnen haben keine Geschwindigkeitsbegrenzung.", ""),
    Saying("Deutsche Ingenieure sind weltweit geschätzt.", ""),
    Saying("Die deutsche Effizienz ist beeindruckend.", ""),
    Saying("Die deutsche Sprache hat viele Dialekte.", ""),
    Saying("Deutschland ist bekannt für seine grünen Landschaften.", ""),
    Saying("Die deutsche Geschichte ist komplex und reichhaltig.", ""),
    Saying("Deutschland ist Europas Wirtschaftsmotor.", ""),
    Saying("Die deutsche Musik hat weltweit Einfluss.", ""),
    Saying("Nürnberg ist berühmt für seine Lebkuchen.", ""),
    Saying("Die deutsche Literatur hat viele Nobelpreisträger.", ""),
    Saying("Deutschland ist ein Land der Traditionen und Moderne.", ""),
    Saying("Die deutsche Sprache ist die Sprache der Dichter und Denker.",
        "Wilhelm von Humboldt"),
    Saying("Deutschland ist ein Land der Vielfalt und Kultur.", ""),
    Saying("Die deutsche Technologie ist weltweit führend.", ""),
    Saying("Deutschland ist berühmt für seine Autobahnen.", ""),
    Saying("Die deutsche Philosophie hat die Welt beeinflusst.", ""),
    Saying("Deutsche Literatur ist reich an Meisterwerken.", ""),
    Saying("Deutsche Musik begeistert die Herzen.", ""),
    Saying("Die deutsche Architektur ist beeindruckend.", ""),
    Saying("Deutschland ist stolz auf seine Traditionen.", ""),
    Saying("Die deutsche Bildung ist von hoher Qualität.", ""),
    Saying("Deutschland ist bekannt für seine Bierkultur.", ""),
    Saying("Die deutsche Mode ist weltweit gefragt.", ""),
    Saying("Deutschland ist ein Land der Innovation.", ""),
    Saying("Die deutsche Wissenschaft ist renommiert.", ""),
    Saying("Deutschland hat eine reiche Geschichte.", ""),
    Saying("Die deutsche Wirtschaft ist stark.", ""),
    Saying("Deutschland ist ein Land der Dichtung und Musik.", ""),
    Saying("Die deutsche Gastfreundschaft ist herzlich.", ""),
    Saying("Deutschland ist ein Land der Festivals und Feiern.", ""),
    Saying("Die deutsche Natur ist atemberaubend schön.", "")
  ];
}
