import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String apiKey = "api_key";

  static Future<List> searchSongs(String query) async {
    final url =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    return data['items'];
  }
}
