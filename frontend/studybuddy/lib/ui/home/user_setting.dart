import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybuddy/services/service_provider.dart';
import 'package:studybuddy/ui/auth/login_screen.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({super.key});

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final List<String> allInterests = [];
  final List<String> selectedInterests = [];
  final List<String> allSkills = [];
  final List<String> selectedSkills = [];

  void _showAddInterestDialog() {
    TextEditingController interestController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Add New Interest',
              style: TextStyle(fontFamily: 'Teachers-M'),
            ),
            content: TextField(
              controller: interestController,
              decoration: InputDecoration(hintText: 'Enter your interest'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontFamily: 'Teachers-M'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newInterest = interestController.text.trim();
                  if (newInterest.isNotEmpty &&
                      !allInterests.contains(newInterest)) {
                    setState(() {
                      allInterests.add(newInterest);
                      selectedInterests.add(newInterest);
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text('Add', style: TextStyle(fontFamily: 'Teachers-M')),
              ),
            ],
          ),
    );
  }

  void _showAddSkillDialog() {
    TextEditingController skillController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Add New Skill',
              style: TextStyle(fontFamily: 'Teachers-M'),
            ),
            content: TextField(
              controller: skillController,
              decoration: InputDecoration(hintText: 'Enter skill name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontFamily: 'Teachers-M'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newSkill = skillController.text.trim();
                  if (newSkill.isNotEmpty && !allSkills.contains(newSkill)) {
                    setState(() {
                      allSkills.add(newSkill);
                      selectedSkills.add(newSkill);
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text('Add', style: TextStyle(fontFamily: 'Teachers-M')),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    setState(() {
      allInterests.addAll(serviceProvider.interesting);
      allSkills.addAll(serviceProvider.skills);
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 142,
                    height: 142,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/animal1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt, size: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Basic Info',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-B',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Edit',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF4F45E4),
                              fontFamily: 'Teachers-SB',
                              fontSize: 13,
                              color: Color(0xFF4F45E4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              color: const Color.fromARGB(120, 0, 0, 0),
                              fontFamily: 'Teachers-M',
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Major',
                            style: TextStyle(
                              fontFamily: 'Teachers-M',
                              fontSize: 13,
                              color: const Color.fromARGB(120, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            serviceProvider.userName,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-SB',
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Software Engineering',
                            style: TextStyle(
                              fontFamily: 'Teachers-SB',
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Year',
                            style: TextStyle(
                              color: const Color.fromARGB(120, 0, 0, 0),
                              fontFamily: 'Teachers-M',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '3rd Year',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-SB',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'University',
                            style: TextStyle(
                              color: const Color.fromARGB(120, 0, 0, 0),
                              fontFamily: 'Teachers-M',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mae Fah Luang University',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-SB',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Interests',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-B',
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: _showAddInterestDialog,
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: Color(0xFF44C887),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 5,
                          children: [
                            ...allInterests.map((interest) {
                              final isSelected = selectedInterests.contains(
                                interest,
                              );
                              return ChoiceChip(
                                showCheckmark: false,
                                label: Text(
                                  interest,
                                  style: TextStyle(fontFamily: 'Teachers-M'),
                                ),
                                selected: isSelected,
                                selectedColor: Colors.lightBlueAccent,
                                backgroundColor: Colors.grey[200],
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    if (value) {
                                      selectedInterests.add(interest);
                                    } else {
                                      selectedInterests.remove(interest);
                                    }
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Skills',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-B',
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: _showAddSkillDialog,
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: Color(0xFFE95D00),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 5,
                          children: [
                            ...allSkills.map((skill) {
                              final isSelected = selectedSkills.contains(skill);
                              return ChoiceChip(
                                showCheckmark: false,
                                label: Text(
                                  skill,
                                  style: TextStyle(fontFamily: 'Teachers-M'),
                                ),
                                selected: isSelected,
                                selectedColor: Colors.lightBlueAccent,
                                backgroundColor: Colors.grey[200],
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    if (value) {
                                      selectedSkills.add(skill);
                                    } else {
                                      selectedSkills.remove(skill);
                                    }
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bio & Motivation',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Teachers-B',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Edit',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF4F45E4),
                              fontFamily: 'Teachers-SB',
                              fontSize: 13,
                              color: Color(0xFF4F45E4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Looking for a study partner to prep for upcoming finals! I'm great at coding and ML concepts, but could really use help with math fundamentals. Let's motivate each other! 📚✨",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Teachers-SB',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff30a7cc),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
