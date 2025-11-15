// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:studybuddy/modela/user.dart';
import 'package:studybuddy/services/service_provider.dart';
import 'package:studybuddy/ui/home/matched_users.dart';
import 'package:studybuddy/global_variables.dart';

// Define a constant for the maximum desired width of the entire swipe area on a web screen
// Increased to allow space for controls on the sides of the card.
const double _kMaxSwiperAreaWidth = 900.0;
const double _kCardWidth = 450.0; // Fixed width for the swipe card

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = CardSwiperController();

  // ... (unchanged state variables and API methods - omitted for brevity)
  double _dislikeButtonScale = 1.0;
  double _likeButtonScale = 1.0;
  double _superLikeButtonScale = 1.0;

  Color swipeIconColor = const Color(0xff41515b);

  int interestedUsersCount = 0;

  List<String> imageUrls = [
    'assets/images/animal1.png',
    'assets/images/animal2.png',
    'assets/images/animal3.png',
    'assets/images/animal4.png',
    'assets/images/animal5.png',
    'assets/images/animal6.png',
    'assets/images/animal7.png',
    'assets/images/animal8.png',
    'assets/images/animal9.png',
    'assets/images/animal10.png',
  ];

  late List<User> people = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadPeople();
    loadInterestedUsers();
  }

  Future<void> loadPeople() async {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    try {
      final response = await http.get(
        Uri.parse('$uri/api/users?count=20'),
        headers: {
          'user-id': '${serviceProvider.userId}',
          'Content-Type': 'application/json',
        },
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
            person.imageUrl =
                imageUrls[math.Random().nextInt(imageUrls.length)];
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

  Future<void> loadInterestedUsers() async {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    try {
      final response = await http.get(
        Uri.parse('$uri/api/interested-users?id=${serviceProvider.userId}'),
        headers: {
          'Content-Type': 'application/json',
          'user-id': '${serviceProvider.userId}',
        },
      );
      if (response.statusCode == 200) {
        print('Interested users fetched: ${response.body}');
        final dynamic body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        setState(() {
          interestedUsersCount = data.length;
        });
      } else {
        throw Exception(
          'Failed to load interested users: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading interested users: $e');
    }
  }

  Future<void> _handleSwipe(String direction, User user) async {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    String targetUserId = user.id.toString();
    String apiUrl = '$uri/api/interested-users';

    if (direction == 'right' || direction == 'up') {
      try {
        final response = await http.patch(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'user-id': '${serviceProvider.userId}',
          },
          body: jsonEncode({'targetUserId': targetUserId}),
        );

        if (response.statusCode == 200) {
          print('Interest recorded for user $targetUserId');
        } else {
          print(
            'Failed to record interest: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        print('Error recording interest: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> matchedUsers =
        Provider.of<ServiceProvider>(context).matchedUsers;

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
                    fontSize: 18,
                    color: Color(0xff3a4a52),
                    fontFamily: 'Teachers-R',
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _kMaxSwiperAreaWidth, // Wider max width
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 1. Info Cards Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 25.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MatchedUserList(),
                                      ),
                                    );
                                  },
                                  child: MainInfoCard(
                                    count: '${matchedUsers.length}',
                                    title: 'Matched',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: MainInfoCard(
                                  count: '$interestedUsersCount',
                                  title: 'Interested Users',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 2. Main Swiper and Side Buttons in a single Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- Left Button Group (Dislike) ---
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
                                  size: 35,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xffa6d5e6),
                                  fixedSize: const Size(60, 60),
                                ),
                                onPressed: () {
                                  _controller.swipe(CardSwiperDirection.left);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ), // Spacing between button and card
                            // --- Center Swiper Card ---
                            SizedBox(
                              width: _kCardWidth, // Fixed width for the card
                              height:
                                  MediaQuery.sizeOf(context).height * 0.85 > 800
                                      ? 800
                                      : MediaQuery.sizeOf(context).height *
                                          0.85, // Max height
                              child: CardSwiper(
                                // Swiper setup (omitted for brevity)
                                allowedSwipeDirection:
                                    const AllowedSwipeDirection.only(
                                      left: true,
                                      right: true,
                                      up: true,
                                    ),
                                controller: _controller,
                                cardsCount: people.length,
                                onSwipe: (
                                  previousIndex,
                                  currentIndex,
                                  direction,
                                ) async {
                                  if (direction == CardSwiperDirection.left) {
                                    await _handleSwipe(
                                      'left',
                                      people[previousIndex],
                                    );
                                  } else if (direction ==
                                      CardSwiperDirection.right) {
                                    await _handleSwipe(
                                      'right',
                                      people[previousIndex],
                                    );
                                    await loadInterestedUsers();
                                  } else if (direction ==
                                      CardSwiperDirection.top) {
                                    await _handleSwipe(
                                      'up',
                                      people[previousIndex],
                                    );
                                    await loadInterestedUsers();
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

                                  if (horizontalDirection ==
                                      CardSwiperDirection.left) {
                                    newDislikeScale =
                                        1.0 + (10 / 100 * bumpFactor);
                                    setState(() {
                                      swipeIconColor = Colors.red;
                                    });
                                  } else if (horizontalDirection ==
                                      CardSwiperDirection.right) {
                                    newLikeScale =
                                        1.0 + (10 / 100 * bumpFactor);
                                  } else if (verticalDirection ==
                                          CardSwiperDirection.top ||
                                      horizontalDirection ==
                                          CardSwiperDirection.top) {
                                    newSuperLikeScale =
                                        1.0 + (10 / 100 * bumpFactor);
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
                                  bool showLike =
                                      dragAmount > 0.1; // drag right
                                  bool showNope =
                                      dragAmount < -0.1; // drag left

                                  return SwipeCard(
                                    name: person.name,
                                    bio: person.description ?? '',
                                    imageUrl:
                                        person.imageUrl ??
                                        'assets/images/Suzy.jpeg',
                                    interests: person.interests ?? [],
                                    skills: person.skills ?? [],
                                    like: showLike,
                                    nope: showNope,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              width: 40,
                            ), // Spacing between card and button
                            // --- Right Button Group (Like and Super Like) ---
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Super Like (Top Button)
                                AnimatedScale(
                                  scale: _superLikeButtonScale,
                                  duration: const Duration(milliseconds: 100),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.star,
                                      color: Color(0xff41515b),
                                      size: 35,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: const Color(0xffa6d5e6),
                                      fixedSize: const Size(60, 60),
                                    ),
                                    onPressed: () {
                                      _controller.swipe(
                                        CardSwiperDirection.top,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Like (Main Button)
                                AnimatedScale(
                                  scale: _likeButtonScale,
                                  duration: const Duration(milliseconds: 100),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: const Color(0xff30a7cc),
                                      fixedSize: const Size(80, 80),
                                    ),
                                    onPressed: () {
                                      _controller.swipe(
                                        CardSwiperDirection.right,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // The bottom button row is removed for simplicity,
                        // but you can add other content here if needed.
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

// NOTE: MainInfoCard and SwipeCard definitions are assumed to be the same
// as the previous successful response, as they only handle internal layout,
// not the overall screen structure.

class MainInfoCard extends StatelessWidget {
  final String count;
  final String title;
  const MainInfoCard({super.key, required this.count, required this.title});

  @override
  Widget build(BuildContext context) {
    // 5. Removed reliance on MediaQuery for width, now relies on Expanded/Flex
    return Container(
      // Max width is already handled by the parent ConstrainedBox.
      // We set a fixed height and use all available width from the Expanded widget.
      height: 70, // Slightly increased height for web
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
              fontSize: 20, // Larger count font
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Teachers-B',
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, // Larger title font
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
          // Set a fixed radius, ensuring it looks good on a larger screen
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8, // Added elevation for a more prominent card look
          child: SingleChildScrollView(
            // Added SingleChildScrollView to prevent overflow on tall screens
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text content to the left
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ), // Clip only top corners
                  child: Image.asset(
                    imageUrl,
                    // Use a constrained height for the image that scales well
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 15),

                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Teachers-B',
                      fontSize: 36, // Larger name font
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3a4a52),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Interests Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                      interests.isEmpty
                          ? const SizedBox.shrink()
                          : Text(
                            'Interests',
                            style: TextStyle(
                              fontSize: 18, // Larger header font
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Teachers-SB',
                            ),
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8, // Increased spacing
                    runSpacing: 8,
                    children:
                        interests
                            .map(
                              (interest) => Chip(
                                label: Text(
                                  interest,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Teachers-SB',
                                    fontSize: 14, // Slightly larger chip text
                                  ),
                                ),
                                backgroundColor: const Color(0xff30a7cc),
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 15),

                // Skills Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                      skills.isEmpty
                          ? const SizedBox.shrink()
                          : Text(
                            'Skills',
                            style: TextStyle(
                              fontSize: 18, // Larger header font
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Teachers-SB',
                            ),
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    spacing: 8, // Increased spacing
                    runSpacing: 8,
                    children:
                        skills
                            .map(
                              (skill) => Chip(
                                label: Text(
                                  skill,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Teachers-SB',
                                    fontSize: 14, // Slightly larger chip text
                                  ),
                                ),
                                backgroundColor: const Color(0xff30a7cc),
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // Like/Nope Overlay (unchanged)
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
                            fontSize: 32, // Larger text
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
                            fontSize: 32, // Larger text
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
