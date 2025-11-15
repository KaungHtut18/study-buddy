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

// --- Responsive Constants ---
// Maximum width for the entire swipe area on desktop
const double _kMaxSwiperAreaWidth = 900.0;
// Fixed width for the swipe card on desktop
const double _kCardWidth = 450.0;
// Screen width breakpoint to switch to mobile layout
const double _kMobileBreakpoint = 600.0;
// ----------------------------

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

  int interestedUsersCount = 0;

  // ... (imageUrls, people list, isLoading, initState, API methods - unchanged)

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

  // --- BUILD METHOD START ---
  @override
  Widget build(BuildContext context) {
    List<String> matchedUsers =
        Provider.of<ServiceProvider>(context).matchedUsers;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < _kMobileBreakpoint;

    // Define mobile-friendly button sizes
    final mobileButtonSize = isMobile ? 50.0 : 60.0;
    final mobileLikeSize = isMobile ? 70.0 : 80.0;
    final mobileIconSize = isMobile ? 30.0 : 35.0;
    final mobileLikeIconSize = isMobile ? 40.0 : 50.0;

    // Handle Loading/Empty states
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff30a7cc)),
      );
    }
    if (people.isEmpty) {
      return const Center(
        child: Text(
          'No more users to swipe right now.\nPlease check back later!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xff3a4a52),
            fontFamily: 'Teachers-R',
          ),
        ),
      );
    }

    // --- BUTTON WIDGET FACTORY ---
    Widget buildIconButton({
      required CardSwiperDirection direction,
      required IconData icon,
      required Color iconColor,
      required Color backgroundColor,
      required double iconSize,
      required double buttonSize,
      required double scale,
      required VoidCallback onEnd,
    }) {
      return AnimatedScale(
        onEnd: onEnd,
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: IconButton(
          icon: Icon(icon, color: iconColor, size: iconSize),
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            fixedSize: Size(buttonSize, buttonSize),
          ),
          onPressed: () {
            _controller.swipe(direction);
          },
        ),
      );
    }

    // --- MAIN LAYOUT WIDGET ---
    Widget mainContent;

    if (isMobile) {
      // -----------------------------------------------------
      // 📱 MOBILE LAYOUT: Info Cards and Buttons BELOW the Swiper
      // -----------------------------------------------------
      mainContent = SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Info Cards Header (Padded)
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
                        isMobile: isMobile,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: MainInfoCard(
                      count: '$interestedUsersCount',
                      title: 'Interested Users',
                      isMobile: isMobile,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Card Swiper (Fills horizontal space)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                // Max height for mobile card swiper
                height: MediaQuery.sizeOf(context).height * 0.60,
                child: CardSwiper(
                  // ... (Swiper properties remain the same)
                  allowedSwipeDirection: const AllowedSwipeDirection.only(
                    left: true,
                    right: true,
                    up: true,
                  ),
                  controller: _controller,
                  cardsCount: people.length,
                  onSwipe: (p, c, d) async {
                    if (d == CardSwiperDirection.left) {
                      await _handleSwipe('left', people[p!]);
                    } else if (d == CardSwiperDirection.right) {
                      await _handleSwipe('right', people[p!]);
                      await loadInterestedUsers();
                    } else if (d == CardSwiperDirection.top) {
                      await _handleSwipe('up', people[p!]);
                      await loadInterestedUsers();
                    }
                    return true;
                  },
                  onSwipeDirectionChange: (h, v) {
                    const bumpFactor = 2.5;
                    double newDislikeScale = 1.0;
                    double newLikeScale = 1.0;
                    double newSuperLikeScale = 1.0;

                    if (h == CardSwiperDirection.left) {
                      newDislikeScale = 1.0 + (10 / 100 * bumpFactor);
                      setState(() {
                        swipeIconColor = Colors.red;
                      });
                    } else if (h == CardSwiperDirection.right) {
                      newLikeScale = 1.0 + (10 / 100 * bumpFactor);
                    } else if (v == CardSwiperDirection.top ||
                        h == CardSwiperDirection.top) {
                      newSuperLikeScale = 1.0 + (10 / 100 * bumpFactor);
                    }
                    setState(() {
                      _dislikeButtonScale = newDislikeScale;
                      _likeButtonScale = newLikeScale;
                      _superLikeButtonScale = newSuperLikeScale;
                    });
                  },
                  cardBuilder: (context, index, pX, pY) {
                    final person = people[index];
                    num dragAmount = pX;
                    bool showLike = dragAmount > 0.1;
                    bool showNope = dragAmount < -0.1;
                    return SwipeCard(
                      name: person.name,
                      bio: person.description ?? '',
                      imageUrl: person.imageUrl ?? 'assets/images/Suzy.jpeg',
                      interests: person.interests ?? [],
                      skills: person.skills ?? [],
                      like: showLike,
                      nope: showNope,
                      isMobile: isMobile, // Pass mobile flag to card
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Button Row (Mobile: All buttons below the card)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dislike
                buildIconButton(
                  direction: CardSwiperDirection.left,
                  icon: Icons.clear,
                  iconColor: swipeIconColor,
                  backgroundColor: const Color(0xffa6d5e6),
                  iconSize: mobileIconSize,
                  buttonSize: mobileButtonSize,
                  scale: _dislikeButtonScale,
                  onEnd: () {
                    setState(() {
                      swipeIconColor = const Color(0xff41515b);
                    });
                  },
                ),
                const SizedBox(width: 25),
                // Like (Main Button)
                buildIconButton(
                  direction: CardSwiperDirection.right,
                  icon: Icons.favorite,
                  iconColor: Colors.white,
                  backgroundColor: const Color(0xff30a7cc),
                  iconSize: mobileLikeIconSize,
                  buttonSize: mobileLikeSize,
                  scale: _likeButtonScale,
                  onEnd: () {},
                ),
                const SizedBox(width: 25),
                // Super Like
                buildIconButton(
                  direction: CardSwiperDirection.top,
                  icon: Icons.star,
                  iconColor: const Color(0xff41515b),
                  backgroundColor: const Color(0xffa6d5e6),
                  iconSize: mobileIconSize,
                  buttonSize: mobileButtonSize,
                  scale: _superLikeButtonScale,
                  onEnd: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    } else {
      // -----------------------------------------------------
      // 💻 WEB LAYOUT: Info Cards above, Buttons on Sides of Swiper
      // -----------------------------------------------------
      mainContent = SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _kMaxSwiperAreaWidth, // Wider max width
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Info Cards Header
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
                            isMobile: isMobile,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: MainInfoCard(
                          count: '$interestedUsersCount',
                          title: 'Interested Users',
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Main Swiper and Side Buttons in a single Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left Button Group (Dislike)
                    buildIconButton(
                      direction: CardSwiperDirection.left,
                      icon: Icons.clear,
                      iconColor: swipeIconColor,
                      backgroundColor: const Color(0xffa6d5e6),
                      iconSize: mobileIconSize,
                      buttonSize: mobileButtonSize,
                      scale: _dislikeButtonScale,
                      onEnd: () {
                        setState(() {
                          swipeIconColor = const Color(0xff41515b);
                        });
                      },
                    ),
                    const SizedBox(width: 40),

                    // Center Swiper Card
                    SizedBox(
                      width: _kCardWidth, // Fixed width for the card
                      height:
                          MediaQuery.sizeOf(context).height * 0.85 > 800
                              ? 800
                              : MediaQuery.sizeOf(context).height * 0.85,
                      child: CardSwiper(
                        // ... (Swiper properties remain the same)
                        allowedSwipeDirection: const AllowedSwipeDirection.only(
                          left: true,
                          right: true,
                          up: true,
                        ),
                        controller: _controller,
                        cardsCount: people.length,
                        onSwipe: (p, c, d) async {
                          if (d == CardSwiperDirection.left) {
                            await _handleSwipe('left', people[p!]);
                          } else if (d == CardSwiperDirection.right) {
                            await _handleSwipe('right', people[p!]);
                            await loadInterestedUsers();
                          } else if (d == CardSwiperDirection.top) {
                            await _handleSwipe('up', people[p!]);
                            await loadInterestedUsers();
                          }
                          return true;
                        },
                        onSwipeDirectionChange: (h, v) {
                          const bumpFactor = 2.5;
                          double newDislikeScale = 1.0;
                          double newLikeScale = 1.0;
                          double newSuperLikeScale = 1.0;

                          if (h == CardSwiperDirection.left) {
                            newDislikeScale = 1.0 + (10 / 100 * bumpFactor);
                            setState(() {
                              swipeIconColor = Colors.red;
                            });
                          } else if (h == CardSwiperDirection.right) {
                            newLikeScale = 1.0 + (10 / 100 * bumpFactor);
                          } else if (v == CardSwiperDirection.top ||
                              h == CardSwiperDirection.top) {
                            newSuperLikeScale = 1.0 + (10 / 100 * bumpFactor);
                          }
                          setState(() {
                            _dislikeButtonScale = newDislikeScale;
                            _likeButtonScale = newLikeScale;
                            _superLikeButtonScale = newSuperLikeScale;
                          });
                        },
                        cardBuilder: (context, index, pX, pY) {
                          final person = people[index];
                          num dragAmount = pX;
                          bool showLike = dragAmount > 0.1;
                          bool showNope = dragAmount < -0.1;
                          return SwipeCard(
                            name: person.name,
                            bio: person.description ?? '',
                            imageUrl:
                                person.imageUrl ?? 'assets/images/Suzy.jpeg',
                            interests: person.interests ?? [],
                            skills: person.skills ?? [],
                            like: showLike,
                            nope: showNope,
                            isMobile: isMobile,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 40),

                    // Right Button Group (Like and Super Like)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Super Like (Top Button)
                        buildIconButton(
                          direction: CardSwiperDirection.top,
                          icon: Icons.star,
                          iconColor: const Color(0xff41515b),
                          backgroundColor: const Color(0xffa6d5e6),
                          iconSize: mobileIconSize,
                          buttonSize: mobileButtonSize,
                          scale: _superLikeButtonScale,
                          onEnd: () {},
                        ),
                        const SizedBox(height: 30),

                        // Like (Main Button)
                        buildIconButton(
                          direction: CardSwiperDirection.right,
                          icon: Icons.favorite,
                          iconColor: Colors.white,
                          backgroundColor: const Color(0xff30a7cc),
                          iconSize: mobileLikeIconSize,
                          buttonSize: mobileLikeSize,
                          scale: _likeButtonScale,
                          onEnd: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(backgroundColor: Colors.white, body: mainContent);
  }
}

// --- Modified Helper Widgets to accept isMobile flag ---

class MainInfoCard extends StatelessWidget {
  final String count;
  final String title;
  final bool isMobile; // Added for responsiveness
  const MainInfoCard({
    super.key,
    required this.count,
    required this.title,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 60 : 70, // Smaller height on mobile
      decoration: BoxDecoration(
        color: const Color(0xff30a7cc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20, // Smaller count font on mobile
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Teachers-B',
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14, // Smaller title font on mobile
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
  final bool isMobile; // Added for responsiveness

  const SwipeCard({
    super.key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.interests,
    required this.skills,
    required this.like,
    required this.nope,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageH = isMobile ? 250.0 : 300.0;
    final nameFS = isMobile ? 30.0 : 36.0;
    final headerFS = isMobile ? 16.0 : 18.0;

    return Stack(
      children: [
        Card(
          color: const Color(0xffa6d5e6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isMobile ? 4 : 8, // Less elevation on mobile
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    imageUrl,
                    height: imageH,
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
                    style: TextStyle(
                      fontFamily: 'Teachers-B',
                      fontSize: nameFS,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff3a4a52),
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
                              fontSize: headerFS,
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
                    spacing: 8,
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
                                    fontSize: 13,
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
                              fontSize: headerFS,
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Teachers-SB',
                            ),
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    spacing: 8,
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
                                    fontSize: 13,
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
                        child: Text(
                          'LIKE',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 24 : 32,
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
                        child: Text(
                          'NOPE',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 24 : 32,
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
