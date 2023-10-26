import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:viacep/page/viacep_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 35,
                  color: Color.fromARGB(255, 15, 15, 15),
                  // shadows: [
                  //   Shadow(
                  //     blurRadius: 7.0,
                  //     color: Color.fromARGB(255, 22, 7, 238),
                  //     offset: Offset(0, 0),
                  //   ),
                  // ],
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  repeatForever: false,
                  onFinished: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const ViaCEPPage(),
                      ),
                    );
                  },
                  animatedTexts: [
                    FlickerAnimatedText('Busca CEP'),
                    FlickerAnimatedText('Seu App'),
                    FlickerAnimatedText("de buscas"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
