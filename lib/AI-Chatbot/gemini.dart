import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService{
  late final GenerativeModel _model; 
  GeminiService(){
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if(apiKey == null || apiKey.isEmpty){
    throw Exception('GEMINI_API_KEY is missing in .env file');
  }
  _model = GenerativeModel(model: 'models/gemini-2.0-flash', apiKey: apiKey);
  }

  Future <String> getGeminiRespone(String userMsg) async {
    try {
      final response = await _model.generateContent([Content.text(userMsg)]);
      return response.text ?? "No Response";
    }
    catch(e){
      print("Error: $e");
      return "Something went Wrong, Please try sending your message again.";
    }
  }
}