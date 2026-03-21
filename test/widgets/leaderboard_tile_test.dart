import 'package:flutter/material.dart';
import 'package:ammentor/components/leaderboard_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';




void main() {
  Widget createWidgetUnderTest({VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: LeaderboardTile(
          rank: 1, 
          name: "test_user",
          avatarUrl: "https://example.com/avatar.png",
          points: 100,
          isCurrentUser: false,
          onTap: onTap,
        ),
      ),
    );
  }


  testWidgets("Leaderboard tile renders", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.byType(LeaderboardTile), findsOneWidget);
    });
  });

  testWidgets("name exists", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.text("test_user"), findsOneWidget);
    });
  });

  testWidgets("points exists", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.text("100 pts"), findsOneWidget);
    });
  });


  testWidgets("avatar exists", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      expect(find.byType(CircleAvatar), findsOneWidget);
    }); 
  });

  testWidgets("Tapping works", (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onTap: () {
            tapped = true;
          },
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, true);

    });
  });



}
