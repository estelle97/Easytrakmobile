import 'dart:convert';
import 'dart:io';

import 'package:easytrack/commons/globals.dart';
import 'package:http/http.dart' as http;

Future createEmployee(params) async {
  print(params.toString());
  try {
    final response = await http.post('$endPoint/employees',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception(
        'Creation of new Employeee exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Creation of new Employee exited with error $ex');
  }
}

Future updateEmployee(params, int id) async {
  try {
    final response = await http.post('$endPoint/employees/$id',
        body: params,
        headers: {HttpHeaders.authorizationHeader: "Bearer $userToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }

    throw Exception('Update Site $id exited with code ${response.statusCode}');
  } catch (ex) {
    throw Exception('Update Site $id exited with error $ex');
  }
}