import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models_data.dart';
import 'package:http/http.dart' as http;

Future<List<DataStrains>> fetchData() async {
  var url = Uri.parse('https://weed-strain1.p.rapidapi.com/');
  final response = await http.get(url, headers: {
    "X-RapidAPI-Key": dotenv.env['APIKEYOPT_STRAIN'].toString(),
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => DataStrains.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

// for homelist, to not have api call restriction
Future<List<DataStrains>> fetchDataFiltered(String difficulty) async {
  var url =
      Uri.parse('https://weed-strain1.p.rapidapi.com/?difficulty=$difficulty');
  final response = await http.get(url, headers: {
    "X-RapidAPI-Key": dotenv.env['APIKEY_STRAIN'].toString(),
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => DataStrains.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}
