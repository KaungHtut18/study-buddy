import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/services/service_provider.dart';
import 'package:studybuddy/ui/home/normalChar.dart';

class MatchedUserList extends StatelessWidget {
  const MatchedUserList({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xffa6d5e6);
    List<String> matchedUsers =
        Provider.of<ServiceProvider>(context).matchedUsers;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Matched Users',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: matchedUsers.length,
          itemBuilder: (context, index) {
            return Card(
              color: primaryColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Text(
                    matchedUsers[index][0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  matchedUsers[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                trailing: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NormalChat(name: matchedUsers[index]),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Start texting',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
