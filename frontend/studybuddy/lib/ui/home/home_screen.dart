// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = CardSwiperController();

  double _dislikeButtonScale = 1.0;
  double _likeButtonScale = 1.0;
  double _superLikeButtonScale = 1.0;

  Color swipeIconColor = Color(0xff41515b);
  late List<dynamic> people = [
    {
      'name': 'Suzy',
      'bio': 'Blah Blah Black Sheep',
      'imageUrl': 'assets/images/Suzy.jpeg',
      'interests': ['Physics', 'Cs', 'Python'],
      'time': 'Friday Evening',
      'location': 'MFU',
    },
    {
      'name': 'Kylie',
      'bio': 'Blah Blah Black Sheep',
      'imageUrl': 'assets/images/kylie.webp',
      'interests': ['Physics', 'Cs', 'Python'],
      'time': 'Friday Evening',
      'location': 'MFU',
    },
    {
      'name': 'Bryan',
      'bio': 'Blah Blah Black Sheep',
      'imageUrl': 'assets/images/bryan.webp',
      'interests': ['Physics', 'Cs', 'Python'],
      'time': 'Friday Evening',
      'location': 'MFU',
    },
    {
      'name': 'Nathan',
      'bio': 'Blah Blah Black Sheep',
      'imageUrl': 'assets/images/nythan.webp',
      'interests': ['Physics', 'Cs', 'Python'],
      'time': 'Friday Evening',
      'location': 'MFU',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainInfoCard(count: '24', title: 'Matches'),
                MainInfoCard(count: '12', title: 'Likes'),
                MainInfoCard(count: '30', title: 'Favorites'),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: CardSwiper(
                allowedSwipeDirection: AllowedSwipeDirection.only(
                  left: true,
                  right: true,
                  up: true,
                ),
                controller: _controller,
                cardsCount: people.length,
                onSwipe: (previousIndex, currentIndex, direction) {
                  if (direction == CardSwiperDirection.right) {
                    setState(() {
                      people[previousIndex]['like'] = true;
                    });
                  }
                  return true;
                },
                onSwipeDirectionChange: (
                  horizontalDirection,
                  verticalDirection,
                ) {
                  const bumpFactor = 2.5;
                  double newDislikeScale = 1.0;
                  double newLikeScale = 1.0;
                  double newSuperLikeScale = 1.0;
                  if (horizontalDirection == CardSwiperDirection.left) {
                    newDislikeScale = 1.0 + (10 / 100 * bumpFactor);
                    setState(() {
                      swipeIconColor = Colors.red;
                    });
                  } else if (horizontalDirection == CardSwiperDirection.right) {
                    newLikeScale = 1.0 + (10 / 100 * bumpFactor);
                  } else if (verticalDirection == CardSwiperDirection.top ||
                      horizontalDirection == CardSwiperDirection.top) {
                    newSuperLikeScale = 1.0 + (10 / 100 * bumpFactor);
                  }

                  setState(() {
                    _dislikeButtonScale = newDislikeScale;
                    _likeButtonScale = newLikeScale;
                    _superLikeButtonScale = newSuperLikeScale;
                  });
                },
                cardBuilder: (
                  context,
                  index,
                  percentThresholdX,
                  percentThresholdY,
                ) {
                  final person = people[index];

                  num dragAmount = percentThresholdX;
                  bool showLike = dragAmount > 0.1; // drag right
                  bool showNope = dragAmount < -0.1; // drag left

                  return SwipeCard(
                    name: person['name'],
                    bio: person['bio'],
                    imageUrl: person['imageUrl'],
                    interests: person['interests'],
                    time: person['time'],
                    location: person['location'],
                    like: showLike,
                    nope: showNope,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedScale(
                  onEnd: () {
                    setState(() {
                      swipeIconColor = Color(0xff41515b);
                    });
                  },
                  scale: _dislikeButtonScale,
                  duration: const Duration(milliseconds: 100),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: swipeIconColor, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xffa6d5e6),
                    ),
                    onPressed: () {
                      _controller.swipe(CardSwiperDirection.left);
                    },
                  ),
                ),
                SizedBox(width: 20),
                AnimatedScale(
                  onEnd: () {},
                  scale: _likeButtonScale,
                  duration: const Duration(milliseconds: 100),
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.white, size: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xff30a7cc),
                    ),
                    onPressed: () {
                      _controller.swipe(CardSwiperDirection.right);
                    },
                  ),
                ),
                SizedBox(width: 20),
                AnimatedScale(
                  scale: _superLikeButtonScale,
                  duration: const Duration(milliseconds: 100),
                  child: IconButton(
                    icon: Icon(Icons.star, color: Color(0xff41515b), size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xffa6d5e6),
                    ),
                    onPressed: () {
                      _controller.swipe(CardSwiperDirection.top);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainInfoCard extends StatelessWidget {
  final String count;
  final String title;
  const MainInfoCard({super.key, required this.count, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xff30a7cc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Teachers-B',
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'Teachers-R',
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeCard extends StatelessWidget {
  final String name;
  final String bio;
  final String imageUrl;
  final List<String> interests;
  final String time;
  final String location;
  final bool like;
  final bool nope;
  const SwipeCard({
    super.key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.interests,
    required this.time,
    required this.location,
    required this.like,
    required this.nope,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: Color(0xffa6d5e6),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Teachers-B',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3a4a52),
                ),
              ),
              SizedBox(height: 5),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontFamily: 'Teachers-R',
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 5,
                children:
                    interests
                        .map(
                          (interest) => Chip(
                            label: Text(
                              interest,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Teachers-SB',
                              ),
                            ),
                            backgroundColor: Color(0xff30a7cc),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff3c4a4e),
                          fontFamily: 'Teachers-R',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 5),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff3c4a4e),
                          fontFamily: 'Teachers-R',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        // Overlay for LIKE or NOPE text
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                if (like)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Transform.rotate(
                      angle: -0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'LIKE',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            fontFamily: 'Teachers-B',
                          ),
                        ),
                      ),
                    ),
                  ),
                if (nope)
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent, width: 4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NOPE',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            fontFamily: 'Teachers-B',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
