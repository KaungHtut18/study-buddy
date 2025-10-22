import 'package:flutter/material.dart';
import 'package:studybuddy/controllers/auth_controller.dart';
import 'package:studybuddy/ui/main_screen.dart';

class SkillRegisterScreen extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SkillRegisterScreen({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SkillRegisterScreen> createState() => _SkillRegisterScreenState();
}

class _SkillRegisterScreenState extends State<SkillRegisterScreen> {
  final List<String> allSkills = [
    'Flutter',
    'Python',
    'UI Design',
    'Public Speaking',
    'Leadership',
  ];
  final List<String> selectedSkills = [];
  final List<String> selectedInterests = [];
  final List<String> allInterests = ['do something', 'eat something', 'dance'];
  final AuthController _authController = AuthController();
  void register() async {
    await _authController.registerUser(
      context: context,
      skills: selectedSkills,
      interests:  selectedInterests,
      fullName: widget.nameController.text,
      email: widget.emailController.text,
      password: widget.passwordController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Set Up Your Skills and Interest For More Engagement',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Teachers-B',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Skills',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Teachers-B',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
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
                          color: isSelected ? Colors.white : Colors.black,
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
                    // “Add skill” chip
                    ActionChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Add Skill',
                            style: TextStyle(fontFamily: 'Teachers-M'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.grey[300],
                      onPressed: _showAddSkillDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Interests',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Teachers-B',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: [
                    ...allInterests.map((interest) {
                      final isSelected = selectedInterests.contains(interest);
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
                          color: isSelected ? Colors.white : Colors.black,
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
                    // “Add skill” chip
                    ActionChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Add Interest',
                            style: TextStyle(fontFamily: 'Teachers-M'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.grey[300],
                      onPressed: _showAddInterestDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterDecoration: BoxDecoration(color: Color(0xFFF7F7F7)),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                print('Name: ${widget.nameController.text}');
                print('Email: ${widget.emailController.text}');
                print('Password: ${widget.passwordController.text}');
                print('Selected Skills ${selectedSkills}');
                print('Selected Interest ${selectedInterests}');
                register();
              },
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontFamily: 'Teachers-B'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
