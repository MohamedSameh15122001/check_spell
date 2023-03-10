import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spell_checker/shared/main_cubit/main_states.dart';
import 'package:http/http.dart' as http;

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  List errors = [];
  int howManyErrors = 0;
  checkSpell({
    text = 'plaiing',
  }) async {
    errors = [];
    howManyErrors = 0;
    emit(LoadingCheckSpellState());
    var url = Uri.parse('https://jspell-checker.p.rapidapi.com/check');

    var headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
      'X-RapidAPI-Host': 'jspell-checker.p.rapidapi.com',
    };

    var body = jsonEncode({
      "language": "enUS",
      "fieldvalues": text,
      "config": {
        "forceUpperCase": false,
        "ignoreIrregularCaps": false,
        "ignoreFirstCaps": true,
        "ignoreNumbers": true,
        "ignoreUpper": false,
        "ignoreDouble": false,
        "ignoreWordsWithNumbers": true
      }
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      errors = jsonDecode(response.body)['elements'].first['errors'];
      howManyErrors = jsonDecode(response.body)['spellingErrorCount'];
      emit(SuccessCheckSpellState());
    } else {
      emit(ErrorCheckSpellState());
      print('Failed to post data. Error code: ${response.statusCode}');
    }
  }
}
