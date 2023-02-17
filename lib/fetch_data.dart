import 'dart:async';
import 'dart:convert';

import 'api_data.dart';
import 'package:http/http.dart' as http;

Future<List<Data>> fetchData() async {
  var url = Uri.parse('https://weed-strain1.p.rapidapi.com/');
  final response = await http.get(url, headers: {
    "X-RapidAPI-Key": '2d04d2b8damshe873bd108f32543p17583bjsn28060a1e9287',
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}
