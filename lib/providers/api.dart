import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quote/constants/categories.dart';
import 'package:quote/constants/model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class APIProvider with ChangeNotifier {
  List<QuoteModel> storageData = [];
  List<QuoteModel> quotes = [];
  int index = 0;
  var uuid = const Uuid();

  List<QuoteModel> markedQuotes() {
    return quotes.where((element) => element.isBooked == true).toList();
  }

  void markTheQuote(String id) {
    quotes.asMap().forEach((index, value) {
      if (value.id == id) {
        quotes[index] = QuoteModel(
          id: value.id,
          category: value.category,
          author: value.author,
          quote: value.quote,
          isBooked: !value.isBooked,
        );
      }
    });
    saveData();
    notifyListeners();
  }

  Future<bool> getQuote() async {
    await Future.delayed(const Duration(seconds: 2));
    Uri apiUrl = Uri.https(
        "api.api-ninjas.com", "v1/quotes", {"category": categories[index]});
    Map<String, String> headers = {'origin': 'https://api-ninjas.com'};

    var response = await http.get(apiUrl, headers: headers);
    List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;

    quotes.add(
      QuoteModel(
        id: uuid.v4(),
        category: jsonResponse[0]['category'],
        author: jsonResponse[0]['author'],
        quote: jsonResponse[0]['quote'],
        isBooked: false,
      ),
    );

    if (index == 67) {
      index = 0;
    } else {
      index++;
    }

    return true;
  }

  Future<void> obtainData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> data = jsonDecode(prefs.getStringList("data")![0]);
    data.forEach((element) {
      quotes.add(QuoteModel(
        id: element['id'],
        category: element['category'],
        author: element['author'],
        quote: element['quote'],
        isBooked: element['isBooked'],
      ));
    });
    notifyListeners();
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonData = [];

    quotes.forEach((element) {
      if (element.isBooked) {
        jsonData.add({
          "id": element.id,
          "category": element.category,
          "author": element.author,
          "quote": element.quote,
          "isBooked": element.isBooked
        });
      }
    });

    prefs.setStringList("data", [jsonEncode(jsonData)]);
  }
}
