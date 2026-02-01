// Basic Flutter widget smoke test for HealthAI Companion

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:healthai_companion/app.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: HealthAICompanionApp()));

    // Verify the app builds without throwing
    await tester.pumpAndSettle();

    // Basic check that app structure exists
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
