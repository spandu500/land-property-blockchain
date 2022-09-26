import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:land_registration/constant/constants.dart';
import 'package:universal_html/html.dart' as html;
import '../constant/utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  static final appContainer = kIsWeb
      ? html.window.document.querySelectorAll('flt-glass-pane')[0]
      : null;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // logo
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: IconButton(
            onPressed: () {
              launchUrl(
                      "https://dolr.gov.in/");
            },
            iconSize: 80,
            icon: Image.asset(
              'assets/github-logo.png',
              //color: Colors.black,
              width: 150.0,
              height: 150.0,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        const Text(
          'Ministry of Land Development of India',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: InkWell(
                child: MouseRegion(
                  onHover: (PointerHoverEvent evt) {
                    appContainer?.style.cursor = 'pointer';
                  },
                  onExit: (PointerExitEvent evt) {
                    appContainer?.style.cursor = 'default';
                  },
                  child: const Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff28313b),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.627907,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const CheckPrivateKey(
                  //               val: "UserLogin",
                  //             )));
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: "UserLogin",
                  );
                },
                child: MouseRegion(
                  onHover: (PointerHoverEvent evt) {
                    appContainer?.style.cursor = 'pointer';
                  },
                  onExit: (PointerExitEvent evt) {
                    appContainer?.style.cursor = 'default';
                  },
                  child: const Text(
                    'User Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff28313b),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.627907,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const CheckPrivateKey(
                  //               val: "LandInspector",
                  //             )));
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: "LandInspector",
                  );
                },
                child: MouseRegion(
                  onHover: (PointerHoverEvent evt) {
                    appContainer?.style.cursor = 'pointer';
                  },
                  onExit: (PointerExitEvent evt) {
                    appContainer?.style.cursor = 'default';
                  },
                  child: const Text(
                    'Govt Official Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff28313b),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.627907,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const CheckPrivateKey(
                  //               val: "owner",
                  //             )));
                  Navigator.of(context).pushNamed(
                    '/login',
                    arguments: "owner",
                  );
                },
                child: MouseRegion(
                  onHover: (PointerHoverEvent evt) {
                    appContainer?.style.cursor = 'pointer';
                  },
                  onExit: (PointerExitEvent evt) {
                    appContainer?.style.cursor = 'default';
                  },
                  child: const Text(
                    'Ministry of Rural Development',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff28313b),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.627907,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: GestureDetector(
                onTap: () async {
                  // await Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => RegisterUser()));
                },
                child: MouseRegion(
                  onHover: (PointerHoverEvent evt) {
                    appContainer?.style.cursor = 'pointer';
                  },
                  onExit: (PointerExitEvent evt) {
                    appContainer?.style.cursor = 'default';
                  },
                  child: const Text(
                    ' ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xff28313b),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.627907,
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(14.0),
            //   child: IconButton(
            //     onPressed: () {
            //       launchUrl(
            //           "https://github.com/saurabh-m-w/Blockchain-Based-Property-Registration");
            //     },
            //     iconSize: 90,
            //     icon: Image.asset(
            //       'assets/github-logo.png',
            //       //color: Colors.black,
            //       width: 160.0,
            //       height: 160.0,
            //       fit: BoxFit.fitHeight,
            //     ),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
