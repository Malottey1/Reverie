import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/onboard_controller.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardController _controller = OnboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _controller.pageController,
              onPageChanged: (int page) {
                setState(() {
                  _controller.onPageChanged(page);
                });
              },
              itemCount: _controller.pages.length,
              itemBuilder: (context, index) {
                final page = _controller.pages[index];
                return OnboardPage(
                  image: page.image,
                  title: page.title,
                  description: page.description,
                  currentPage: _controller.currentPage,
                  pageController: _controller.pageController,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_controller.pages.length, (index) => buildDot(index, context)),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: _controller.currentPage == index ? 10 : 6,
      width: _controller.currentPage == index ? 10 : 6,
      decoration: BoxDecoration(
        color: _controller.currentPage == index ? Color(0xFF69734E) : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final int currentPage;
  final PageController pageController;

  OnboardPage({
    required this.image,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image.endsWith('.svg')
              ? SvgPicture.asset(image)
              : Image.asset(image),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF69734E),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w100,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ),
          currentPage < 3
              ? Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: IconButton(
                    icon: Image.asset('assets/arrow.png'),
                    iconSize: 30,
                    onPressed: () {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF69734E), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding inside the button
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Let's Get Started!",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}