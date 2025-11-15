import 'package:flutter/foundation.dart';

class ServiceProvider with ChangeNotifier {
  int _matchedCount = 0;
  List<String> _matchedUsers = [];

  int get matchedCount => _matchedCount;
  List<String> get matchedUsers => _matchedUsers;
  
  void setMatchedCount(int count) {
    _matchedCount = count;
    notifyListeners();
  }

  void setMatchedUSers(String name){
    _matchedUsers.add(name);
    notifyListeners();
  }

  int _userId = 1;

  int get userId => _userId;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  String _userName = '';

  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  List<String> interesting = [];
  void setInteresting(List<String> interests) {
    interesting = interests;
    notifyListeners();
  }

  List<String> skills = [];
  void setSkills(List<String> skillSet) {
    skills = skillSet;
    notifyListeners();
  }

  bool _inDetail = false;
  bool get inDetail => _inDetail;
  void setInDetail(bool detail) {
    _inDetail = detail;
    notifyListeners();
  }

  List<String> messageList = [];
  void setMessageList(String name){
    messageList.add(name);
    notifyListeners();
  }

  Map<String, List<String>> messages = {};
  void setMessages(String name, List<String> useMmessages){
  messages.addAll({
    name : useMmessages,
  });
  notifyListeners();
  }
  
}
