import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speech  =  SpeechToText();
  bool _isAvailable = false;
  bool get isAvailable  => _isAvailable ;


  Future <void> initialize() async{
    _isAvailable = await _speech.initialize();
  }
  void startListening({ required void Function(SpeechRecognitionResult result) onResult}){

      _speech .listen(onResult: onResult, listenMode: ListenMode.confirmation, cancelOnError: true);

    // speechToText.listen(onResult: (result) {
    //   print("Speech Recognized: ${result.recognizedWords}");
    // },);
  }

  void stopListening(){
    _speech.stop();
  }
  bool get isListening => _speech.isListening;
}