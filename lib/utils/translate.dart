import 'package:easy_localization/easy_localization.dart';

String translate(
  String key, {
  List<String>? args,
  Map<String, String>? namedArgs,
}) {
  return key.toUpperCase().tr(args: args, namedArgs: namedArgs);
}
