import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                OnboardPage(
                  image: 'assets/on-board-1.png',
                  title: 'Join Our Community',
                  description: 'Stay connected with push notifications, follow your favorite vendors, and join a vibrant community of fashion lovers. Start your sustainable fashion journey today!',
                  currentPage: _currentPage,
                  pageController: _pageController,
                ),
                OnboardPage(
                  image: 'assets/on-board-2.png',
                  title: 'Secure Transactions & Order Tracking',
                  description: 'Shop with confidence using our secure payment gateway and track your orders from purchase to delivery with real-time updates.',
                  currentPage: _currentPage,
                  pageController: _pageController,
                ),
                OnboardPage(
                  image: 'assets/on-board-3.png',
                  title: 'Seamless Browsing and Selling',
                  description: 'Easily browse through our vast collection of thrift items or list your own with our in-app camera.',
                  currentPage: _currentPage,
                  pageController: _pageController,
                ),
                OnboardPage(
                  image: 'assets/on-board-4.png',
                  title: 'Welcome To Reverie',
                  description: 'Discover unique, pre-loved fashion. Join our community of thrift enthusiasts and find your next favorite piece!',
                  currentPage: _currentPage,
                  pageController: _pageController,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => buildDot(index, context)),
          ),
          SizedBox(height: 20),
          _currentPage == 3
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the next screen
                    },
                    child: Text("Let's Get Started!"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: _currentPage == index ? 10 : 6,
      width: _currentPage == index ? 10 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(5),
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
          Expanded(child: image.endsWith('.svg') ? SvgPicture.asset(image) : Image.asset(image)),
          SizedBox(height: 5), // Reduced space
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Color(0xFF69734E),
            ),
          ),
          SizedBox(height: 5), // Reduced space
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10), // Reduced space
          currentPage < 3
              ? IconButton(
                  icon: Image.asset('assets/arrow.png'),
                  iconSize: 30,
                  onPressed: () {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}