import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config.dart' as config;

class Api {
  String apiKey;
  String apiUrl;

  Api(String apiKey, {String apiUrl = config.apiUrl}) {
    this.apiKey = apiKey;
    this.apiUrl = apiUrl;
  }

  fetchWeight() async {
    var result = await http.get(
      Uri.https(this.apiUrl, 'sammy/weight/'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );

    if (result.statusCode == 401) {
      config.resetApp();
      return false;
    }
    return json.decode(result.body);
  }

  insertWeight(weight) async {
    var result = await http.post(
      Uri.https(this.apiUrl, 'sammy/weight/'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
      body: {"weight": weight},
    );
    if (result.statusCode == 401) {
      config.resetApp();
      return false;
    }
    return json.decode(result.body);
  }

  deleteWeight(weightId) async {
    var result = await http.delete(
      Uri.https(this.apiUrl, 'sammy/weight/' + weightId),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );
    if (result.statusCode == 401) {
      config.resetApp();
      return false;
    }
    return json.decode(result.body);
  }

  fetchImages() async {
    var result = await http.get(
      Uri.https(this.apiUrl, 'sammy/pictures/'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );
    if (result.statusCode == 401) {
      config.resetApp();
      return false;
    }
    return json.decode(result.body);
  }

  insertImage(base64) async {
    var result = await http.post(
      Uri.https(this.apiUrl, 'sammy/pictures/'),
      headers: {HttpHeaders.authorizationHeader: apiKey},
      body: base64,
    );
    if (result.statusCode == 401) {
      config.resetApp();
      return false;
    }
    return json.decode(result.body);
  }

  deleteImage(imageId) async {
    var result = await http.delete(
      Uri.https(this.apiUrl, 'sammy/pictures/' + imageId),
      headers: {HttpHeaders.authorizationHeader: apiKey},
    );
    if (result.statusCode == 401) {
      config.resetApp();
      return false;
    }
    return json.decode(result.body);
  }
}
