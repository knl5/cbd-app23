import 'dart:async';
import 'dart:convert';

import 'api_data.dart';
import 'package:http/http.dart' as http;

Future<List<DataStrains>> fetchData() async {
  var url = Uri.parse('https://weed-strain1.p.rapidapi.com/');
  final response = await http.get(url, headers: {
    "X-RapidAPI-Key": '24024d3c37msh77d432d3b0b04dbp1119dejsn66f40f00e220',
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => DataStrains.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}
