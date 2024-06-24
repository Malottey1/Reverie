import 'package:flutter/material.dart';
import '../models/onboard_page_model.dart';

class OnboardController {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<OnboardPageModel> pages = [
    OnboardPageModel(
      image: 'assets/on-board-1.png',
      title: 'Join Our Community',
      description: 'Stay connected with push notifications, follow your favorite vendors, and join a vibrant community of fashion lovers. Start your sustainable fashion journey today!',
    ),
    OnboardPageModel(
      image: 'assets/on-board-2.png',
      title: 'Secure Transactions & Order Tracking',
      description: 'Shop with confidence using our secure payment gateway and track your orders from purchase to delivery with real-time updates.',
    ),
    OnboardPageModel(
      image: 'assets/on-board-3.png',
      title: 'Seamless Browsing and Selling',
      description: 'Easily browse through our vast collection of thrift items or list your own with our in-app camera.',
    ),
    OnboardPageModel(
      image: 'assets/on-board-4.png',
      title: 'Welcome To Reverie',
      description: 'Discover unique, pre-loved fashion. Join our community of thrift enthusiasts and find your next favorite piece!',
    ),
  ];

  void onPageChanged(int index) {
    currentPage = index;
  }
}