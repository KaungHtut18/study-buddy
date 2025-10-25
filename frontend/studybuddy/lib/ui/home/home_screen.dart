// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:studybuddy/modela/user.dart';

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

  Color swipeIconColor = const Color(0xff41515b);

  List<String> imageUrls = [
    'assets/images/bryan.webp',
    'assets/images/kylie.webp',
    'assets/images/nythan.webp',
    'assets/images/Suzy.jpeg',
  ];

  late List<User> people = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadPeople();
  }

  Future<void> loadPeople() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/users?count=5'),
        headers: {'user-id': '1'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body["data"];

        final loadedPeople =
            (data as List)
                .map((e) => User.fromJson(e as Map<String, dynamic>))
                .toList();
        for (var person in loadedPeople) {
          setState(() {
            person.imageUrl = imageUrls[math.Random().nextInt(imageUrls.length)];
          });
        }

        setState(() {
          people = loadedPeople;
        });
      } else {
        debugPrint('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xff30a7cc)),
              )
              : people.isEmpty
              ? const Center(
                child: Text(
                  'No more users to swipe right now.\nPlease check back later!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff3a4a52),
                    fontFamily: 'Teachers-R',
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        MainInfoCard(count: '24', title: 'Matches'),
                        MainInfoCard(count: '12', title: 'Likes'),
                        MainInfoCard(count: '30', title: 'Favorites'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.65,
                      child: CardSwiper(
                        allowedSwipeDirection: const AllowedSwipeDirection.only(
                          left: true,
                          right: true,
                          up: true,
                        ),
                        controller: _controller,
                        cardsCount: people.length,
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
                          } else if (horizontalDirection ==
                              CardSwiperDirection.right) {
                            newLikeScale = 1.0 + (10 / 100 * bumpFactor);
                          } else if (verticalDirection ==
                                  CardSwiperDirection.top ||
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
                            name: person.name,
                            bio: person.description ?? '',
                            imageUrl:
                                person.imageUrl ?? 'assets/images/Suzy.jpeg',
                            interests: person.interests ?? [],
                            skills: person.skills ?? [],
                            like: showLike,
                            nope: showNope,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          onEnd: () {
                            setState(() {
                              swipeIconColor = const Color(0xff41515b);
                            });
                          },
                          scale: _dislikeButtonScale,
                          duration: const Duration(milliseconds: 100),
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: swipeIconColor,
                              size: 28,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xffa6d5e6),
                            ),
                            onPressed: () {
                              _controller.swipe(CardSwiperDirection.left);
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        AnimatedScale(
                          scale: _likeButtonScale,
                          duration: const Duration(milliseconds: 100),
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 40,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xff30a7cc),
                            ),
                            onPressed: () {
                              _controller.swipe(CardSwiperDirection.right);
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        AnimatedScale(
                          scale: _superLikeButtonScale,
                          duration: const Duration(milliseconds: 100),
                          child: IconButton(
                            icon: const Icon(
                              Icons.star,
                              color: Color(0xff41515b),
                              size: 28,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xffa6d5e6),
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
        color: const Color(0xff30a7cc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Teachers-B',
            ),
          ),
          Text(
            title,
            style: const TextStyle(
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
  final List<String> skills;
  final bool like;
  final bool nope;

  const SwipeCard({
    super.key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.interests,
    required this.skills,
    required this.like,
    required this.nope,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: const Color(0xffa6d5e6),
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
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Teachers-B',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3a4a52),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontFamily: 'Teachers-R',
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                children:
                    interests
                        .map(
                          (interest) => Chip(
                            label: Text(
                              interest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Teachers-SB',
                              ),
                            ),
                            backgroundColor: const Color(0xff30a7cc),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                children:
                    skills
                        .map(
                          (skill) => Chip(
                            label: Text(
                              skill,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Teachers-SB',
                              ),
                            ),
                            backgroundColor: const Color(0xff30a7cc),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
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
