import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  late SpeechToText _speechToText;

  SpeechToTextService(){
    _speechToText = SpeechToText();
  }
  Future <void> initialize() async{
    bool available = await _speechToText.initialize();
    if(available){
      print("Speech-to-text service is ready!");
    }
    else{
      print("Speech-to-text service is not available.");
    }
  }
  void startListening(){
    _speechToText.listen(onResult: (result) {
      print("Speech Recognized: ${result.recognizedWords}");
    },);
  }

  void stopListening(){
    _speechToText.stop();
  }
}