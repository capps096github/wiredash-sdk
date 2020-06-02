import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';
import 'package:wiredash/src/common/translation/l10n/messages_pl.dart' as pl;

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key key}) : super(key: key);
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  /// Wiredash uses a navigation key to show and hide our overlay. This key must be passed to
  /// the `MaterialApp` and `Wiredash` widgets.
  /// Note you are not required to use `MaterialApp`, Wiredash will work perfectly fine with
  /// `CupertinoApp` and `WidgetsApp`.
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    /// Here we wrap our app at the top level using a `Wiredash` widget. This requires us to pass
    /// the `projectId` and `secret` obtained from the "configuration" section of your console.
    /// Notice we are also passing our `_navigatorKey` to both widgets.
    /// Wiredash also allows you to setup custom themes and translations using `WiredashThemeData` and
    /// `WiredashOptionsData`. Both of these are optional but should your heart desire an extra layer
    /// of customizability, you can make wiredash your own.
    /// Read more about translations support in the package's README.
    return Wiredash(
      projectId: "YOUR-PROJECT-ID",
      secret: "YOUR-SECRET",
      navigatorKey: _navigatorKey,
      options: WiredashOptionsData(
        showDebugFloatingEntryPoint: true,

        /// Uncomment below to see how custom translations work
        // customTranslations: {
        //   const Locale.fromSubtags(languageCode: 'en'):
        //       const DemoCustomTranslations(),
        //   const Locale.fromSubtags(languageCode: 'pl'):
        //       const DemoPolishTranslations(),
        // },

        /// Uncomment below to override default device locale
        // locale: const Locale('de'),
      ),
      theme: WiredashThemeData(brightness: Theme.of(context).brightness),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Adventure 🌎',
        home: const DemoHomePage(),
      ),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      drawer: Drawer(
        child: Column(
          children: const <Widget>[
            DrawerHeader(
              child: Center(child: Text('Wiredash example')),
            ),
            UserInfoButton(),
            BuildInfoButton(),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Adventure 🌎'),
        backgroundColor: const Color(0xFF02579B),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),

            /// In a single line of code, we can show the Wiredash menu. Because we wrapped our app
            /// with the `Wiredash` widget at the very top level, we can access this method from anywhere in our code.
            onPressed: () => Wiredash.of(context).show(),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: CitiesModel.cities.length,
          itemBuilder: (context, index) {
            return CountryCard(item: CitiesModel.cities[index]);
          },
        ),
      ),
    );
  }
}

class CitiesModel {
  const CitiesModel({
    @required this.title,
    @required this.description,
    @required this.image,
  });

  final String title;
  final String description;
  final String image;
  static const cities = <CitiesModel>[
    CitiesModel(
      title: 'Germany',
      description:
          "Frankfurt, a central German city on the river Main, is a major financial hub that's home to the European Central Bank. It's the birthplace of famed writer Johann Wolfgang von Goethe, whose former home is now the Goethe House Museum.",
      image:
          "https://user-images.githubusercontent.com/25674767/82772933-badd0880-9e0e-11ea-9b25-0c1f084052a1.jpg",
    ),
    CitiesModel(
      title: 'Ne York',
      description:
          "At its core is Manhattan, a densely populated borough that’s among the world’s major commercial, financial and cultural centers. Its iconic sites include skyscrapers such as the Empire State Building and sprawling Central Park.",
      image:
          "https://user-images.githubusercontent.com/25674767/82772939-bdd7f900-9e0e-11ea-9de6-1adf978c91b4.jpg",
    ),
    CitiesModel(
      title: 'Trinidad and Tobago',
      description:
          "Trinidad and Tobago is a dual-island Caribbean nation near Venezuela,  with distinctive Creole traditions and cuisines. Trinidad’s capital,  Port of Spain, hosts a boisterous carnival featuring calypso and soca music.",
      image:
          "https://user-images.githubusercontent.com/25674767/82772941-bf092600-9e0e-11ea-9fd7-7eb40161274b.jpg",
    ),
  ];
}

class CountryCard extends StatelessWidget {
  const CountryCard({Key key, @required this.item}) : super(key: key);
  final CitiesModel item;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            item.image,
            width: double.maxFinite,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 18.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              left: 12.0,
              right: 12.0,
              bottom: 8.0,
            ),
            child: Text(
              item.description,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 16.0,
                  ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

class BuildInfoButton extends StatelessWidget {
  const BuildInfoButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Wiredash.of(context).setBuildProperties(
          buildNumber: '42',
          buildVersion: '1.42',
        );
      },
      child: const Text('Set random build parameters'),
    );
  }
}

class UserInfoButton extends StatelessWidget {
  const UserInfoButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Wiredash.of(context).setUserProperties(
          userEmail: 'mail@example.com',
          userId: 'custom-id',
        );
      },
      child: const Text('Set random user parameters'),
    );
  }
}

class DemoPolishTranslations extends pl.WiredashLocalizedTranslations {
  const DemoPolishTranslations() : super();

  @override
  String get feedbackStateIntroTitle => 'Dzień dobry!';
}

class DemoCustomTranslations extends WiredashTranslations {
  const DemoCustomTranslations() : super();
  @override
  String get captureSkip => 'Skip screenshot';
  @override
  String get captureTakeScreenshot => 'Take screenshot';
  @override
  String get captureSaveScreenshot => 'Save screenshot';
  @override
  String get captureSpotlightNavigateTitle => 'navigate';
  @override
  String get captureSpotlightNavigateMsg =>
      'Navigate to the screen which you would like to attach to your capture.';
  @override
  String get captureSpotlightScreenCapturedTitle => 'draw';
  @override
  String get captureSpotlightScreenCapturedMsg =>
      'Screen captured! Feel free to draw on the screen to highlight areas affected by your capture.';
  @override
  String get feedbackStateFeedbackTitle => 'Your feedback ✍️';
  @override
  String get feedbackModeBugTitle => 'Report a Bug';
  @override
  String get feedbackModeBugMsg =>
      'Let us know so we can forward this to our bug control.';
  @override
  String get feedbackModeImprovementTitle => 'Request a Feature';
  @override
  String get feedbackModeImprovementMsg =>
      'Do you have an idea that would make our app better? We would love to know!';
  @override
  String get feedbackModePraiseTitle => 'Send Applause';
  @override
  String get feedbackModePraiseMsg =>
      'Let us know what you really like about our app, maybe we can make it even better?';
  @override
  String get feedbackBack => 'Go back';
  @override
  String get feedbackCancel => 'Cancel';
  @override
  String get feedbackSave => 'Save';
  @override
  String get feedbackSend => 'Send feedback';
  @override
  String get feedbackStateIntroTitle => 'Hi there 👋';
  @override
  String get feedbackStateIntroMsg =>
      'We can’t wait to get your thoughts on our app. What would you like to do?';
  @override
  String get feedbackStateFeedbackMsg =>
      'We are listening. Please provide as much info as needed so we can help you.';
  @override
  String get feedbackStateEmailTitle => 'Stay in the loop 👇';
  @override
  String get feedbackStateEmailMsg =>
      'If you want to get updates regarding your feedback, enter your email down below.';
  @override
  String get feedbackStateSuccessTitle => 'Thank you ✌️';
  @override
  String get feedbackStateSuccessMsg =>
      "That's it. Thank you so much for helping us building a better app!";
  @override
  String get feedbackStateSuccessCloseTitle => 'Close this Dialog';
  @override
  String get feedbackStateSuccessCloseMsg =>
      'Thanks for submitting your feedback!';
  @override
  String get inputHintFeedback => 'Your feedback';
  @override
  String get inputHintEmail => 'Your email';
  @override
  String get validationHintFeedbackEmpty => 'Please provide your feedback.';
  @override
  String get validationHintFeedbackLength => 'Your feedback is too long.';
  @override
  String get validationHintEmail =>
      'Please enter a valid email or leave this field blank.';
}
