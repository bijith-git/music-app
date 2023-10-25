import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/helpers/spotify_helper.dart';
import 'package:spotify_clone/presentation/home/view/home.dart';
import 'package:spotify_clone/utils/secure_storage.dart';

class LoginPage extends StatelessWidget {
  SecureStorage secureStorage = SecureStorage();
  static const String routeName = '/login';
  LoginPage({super.key});
  List<Color> colors = [
    const Color(0xFF5ed2b3),
    const Color(0xFF6fd6ad),
    const Color(0xFF78d7a8),
    const Color(0xFF7ed8a5),
    const Color(0xFF88daa0),
    const Color(0xFFa1de95),
    const Color(0xFFaae091),
    const Color(0xFFb1e08f),
  ];
  getSFile() {
    secureStorage.saveData(key: 'he', value: 'saved file');
    var data = secureStorage.getData(key: 'he');
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    getSFile();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Spotify",
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontWeight: FontWeight.bold, letterSpacing: .5),
            ).animate(adapter: ValueAdapter(0.5)).shimmer(colors: colors),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                      text: "over ",
                      style: Theme.of(context).textTheme.titleLarge,
                      children: [
                    WidgetSpan(
                      child: Text(
                        '100 million',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                          .animate(adapter: ValueAdapter(0.5))
                          .shimmer(colors: colors),
                    ),
                    const TextSpan(text: '\n Songs on Spotify')
                  ])),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                      text: "over ",
                      style: Theme.of(context).textTheme.titleLarge,
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Text(
                            ' 6 million ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                              .animate(adapter: ValueAdapter(0.5))
                              .shimmer(colors: colors),
                        ),
                        const TextSpan(text: '\n Podcast on Spotify')
                      ])),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  var auth = await SpotifyHelper.getAccessToken();
                  if (auth.isNotEmpty) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: const Text("Login")),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
