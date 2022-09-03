import 'dart:convert';

import 'package:guilt_flutter/commons/data/model/json_parser.dart';

String parseErrorMessage(String errorBody) =>
    JsonParser.stringParser(JsonParser.firstElementOfListParser(jsonDecode(errorBody), ['errors']), ['message']);
