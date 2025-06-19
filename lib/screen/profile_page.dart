import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_quiz/models/user_model.dart'; // Use shared model here

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async => await _auth.signOut();

  Future<void> deleteAccount() async => await currentUser?.delete();

  Future<UserModel?> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateUserData(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(user.toMap());
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      final user = await _authService.getUserData(currentUser.uid);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _editField(String fieldName, String currentValue) async {
    final controller = TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: fieldName,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (_user != null && newValue.isNotEmpty) {
                setState(() {
                  switch (fieldName) {
                    case 'Name':
                      _user = _user!.copyWith(name: newValue);
                      break;
                    case 'Username':
                      _user = _user!.copyWith(username: newValue);
                      break;
                    case 'Bio':
                      _user = _user!.copyWith(bio: newValue);
                      break;
                    case 'Grade':
                      _user = _user!.copyWith(grade: newValue);
                      break;
                    case 'Language':
                      _user = _user!.copyWith(language: newValue);
                      break;
                  }
                });
                await _authService.updateUserData(_user!);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to delete your account?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _authService.deleteAccount();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePassword() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Password"),
        content: const TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'New Password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password updated")),
              );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_user != null) ...[
              _buildProfileItem("Name", _user!.name, () => _editField("Name", _user!.name)),
              _buildProfileItem("Username", _user!.username, () => _editField("Username", _user!.username)),
              _buildProfileItem("Bio", _user!.bio, () => _editField("Bio", _user!.bio)),
              _buildProfileItem("Grade", _user!.grade, () => _editField("Grade", _user!.grade)),
              _buildProfileItem("Language", _user!.language, () => _editField("Language", _user!.language)),
              const Divider(),
              ListTile(
                title: const Text("Update Password"),
                trailing: const Icon(Icons.lock),
                onTap: _updatePassword,
              ),
              ListTile(
                title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.delete, color: Colors.red),
                onTap: _deleteAccount,
              ),
              ListTile(
                title: const Text("Log Out"),
                trailing: const Icon(Icons.logout),
                onTap: _logout,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
