import 'dart:convert';

class JsonUtilities {
  static Iterable<dynamic> getJsonFromObjectList(
      List<dynamic> objects /* , String filePath */) {
    return objects.map((question) => question.toJson()).toList();
  }

  static String getStringFromJson(Object json) {
    return jsonEncode(json);
  }

  static List<T> getObjectsListFromStringWithJson<T>(
      String jsonString, T Function(Map<String, dynamic>) fromJson) {
    final jsonList = jsonDecode(jsonString);
    final List<T> objectsList = [];

    try {
      if (jsonList is List) {
        for (final jsonItem in jsonList) {
          final item = fromJson(jsonItem);
          objectsList.add(item);
        }
      } else if (jsonList is Map<String, dynamic>) {
        // Если jsonList - это объект JSON, добавьте его в список как один элемент
        final item = fromJson(jsonList);
        objectsList.add(item);
      }
    } catch (e) {
      print(e);
    }

    return objectsList;
  }

  static T getObjectFromStringWithJson<T>(
      String jsonString, T Function(Map<String, dynamic>) fromJson) {
    final dynamic json = jsonDecode(jsonString);
    T object = fromJson(json);
    return object;
  }
}
