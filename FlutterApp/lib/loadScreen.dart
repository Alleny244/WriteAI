import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image(
                image: AssetImage('./assets/icon.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              // decoration: BoxDecoration(
              //   gradient: RadialGradient(
              //       stops: [0.1, 0.3, 1],
              //       colors: [Colors.green, Colors.orange, Colors.pink]),
              // ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xff8a9bd4),
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                  shadowColor: MaterialStateProperty.all<Color>(
                    Colors.black,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Dancing Script',
                  ),
                ),
                onPressed: () =>
                    {Navigator.pushReplacementNamed(context, '/home')},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
