import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spider_flutter/homepage.dart';

class SplashSpider extends StatefulWidget {
  SplashSpider({Key? key}) : super(key: key);

  @override
  State<SplashSpider> createState() => _SplashSpiderState();
}

class _SplashSpiderState extends State<SplashSpider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("asstes/spiderman_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AvatarGlow(
            child: Material(
              color: const Color.fromRGBO(167, 18, 32, 100),
              shape: const CircleBorder(),
              elevation: 8.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: MyHomePage(),
                          duration: const Duration(milliseconds: 600),
                          alignment: Alignment.center,
                          type: PageTransitionType.scale));
                },
                child: const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.expand_less_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            endRadius: 90),
      ),
    );
  }
}
