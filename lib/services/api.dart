import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

class API{
  static Future getCoord({required String placeName})async{
    try{
      http.Response resp = await http.get(Uri.parse("https://nominatim.openstreetmap.org/search?q=$placeName&format=json&limit=1")).timeout(const Duration(seconds: 15),onTimeout: (){
        throw TimeoutException("Couldn't connect with location server");
      });

      if (resp.statusCode == 200) {
        dynamic x = jsonDecode(resp.body);

        return {
          "result":true,
          "lat": double.parse(x[0]["lat"]),
          "long": double.parse(x[0]["lon"]),
        };
      }
      else {
        return {
          "result": false,
          "message": "Unable to find location",
        };
      }
    }catch(e){
      return {
        "result": false,
        "message": "Troubling Connecting to the Internet",
      };
    }

  }
}