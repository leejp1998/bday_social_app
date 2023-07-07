import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(BirthdayApp());
}

class BirthdayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.deepOrangeAccent),
      ),
      home: BirthdayScreen(),
    );
  }
}

class BirthdayScreen extends StatefulWidget {
  @override
  _BirthdayScreenState createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _friendController = TextEditingController();

  bool _isNewUser = true;
  List<String> _friends = [];

  DateTime? _selectedBirthday;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _friendController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveBirthday(DateTime? birthday) async {
    try {
      if (birthday == null) return;
      final birthdayDocument = FirebaseFirestore.instance.collection('birthdays').doc('user1');

      await birthdayDocument.set({
        'birthday': birthday,
      });

      debugPrint('Birthday saved to cloud storage.');
    } catch (error) {
      debugPrint('Error saving birthday: $error');
    }
  }

  void _addFriend(String friend) {
    setState(() {
      _friends.add(friend);
    });
  }

  void _showBirthdayPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 400,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedBirthday ?? DateTime.now(),
                  onDateTimeChanged: (DateTime dateTime) {
                    setState(() {
                      _selectedBirthday = dateTime;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isBirthdayValid() {
    final now = DateTime.now();
    if (_selectedBirthday == null || _selectedBirthday!.isAfter(now)) {
      return false;
    }
    return true;
  }

  Widget _buildBirthdayScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isNewUser)
              Text(
                'Welcome! Please select your birthday:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            if (_isNewUser) SizedBox(height: 20),
            if (_isNewUser)
              GestureDetector(
                onTap: () {
                  _showBirthdayPicker(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: _selectedBirthday != null
                          ? DateFormat('MM/dd/yyyy').format(_selectedBirthday!)
                          : '', // Display the selected birthday in the text field
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Select your birthday',
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    validator: (_) {
                      if (!_isBirthdayValid()) {
                        return 'Please select a valid birthday.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            if (!_isNewUser) const SizedBox(height: 40),
            if (!_isNewUser)
              const Text(
                'Friends:',
                style: TextStyle(fontSize: 18),
              ),
            if (!_isNewUser) const SizedBox(height: 10),
            if (!_isNewUser)
              Column(
                children: _friends
                    .map(
                      (friend) => Text(
                    friend,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
                    .toList(),
              ),
            const SizedBox(height: 20),
            if (_isNewUser)
              ElevatedButton(
                onPressed: () {
                  if (_isBirthdayValid()) {
                    _saveBirthday(_selectedBirthday);
                    setState(() {
                      _isNewUser = false;
                    });
                  }
                },
                child: const Text('Save Birthday'),
              ),
            if (!_isNewUser) SizedBox(height: 20),
            if (!_isNewUser)
              ElevatedButton(
                onPressed: () {
                  _tabController.animateTo(1);
                },
                child: const Text('View Friends'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendListScreen() {
    return ListView.builder(
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return ListTile(
          title: Text(friend),
          subtitle: Text('Birthday: N/A'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBirthdayScreen(),
          _buildFriendListScreen(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2.0,
              ),
            ),
          ),
          tabs: [
            Tab(
              text: 'Home',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Friends',
              icon: Icon(Icons.people),
            ),
          ],
        ),
      ),
    );
  }
}