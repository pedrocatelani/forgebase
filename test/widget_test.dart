import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgebase/utils/translate.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('loads default pt-BR translations', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('pt', 'BR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('pt', 'BR'),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: Builder(
                builder: (context) {
                  return Text(translate('AUTH.LOGIN'));
                },
              ),
            );
          },
          ),
      ),
    );

    await tester.pump();

    expect(find.text('Entrar'), findsOneWidget);
  });
}
