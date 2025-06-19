import 'dart:io';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      final userData = await _authService.getUserData(currentUser.uid);
      setState(() {
        _user =
            userData ??
            UserModel(
              uid: currentUser.uid,
              name: 'Pok Darong',
              username: 'johnwick_Robert',
              email: currentUser.email ?? '',
              bio: 'I am the smartest on the world',
              grade: '4th Year',
              language: 'English',
            );
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePassword() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Store new password
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Implement password update
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully'),
                    ),
                  );
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleImageUpload(File image) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        final imageUrl = await _authService.uploadProfileImage(uid, image);
        if (imageUrl != null) {
          setState(() {
            _user = _user?.copyWith(profileImageUrl: imageUrl);
          });
          await _authService.updateUserData(
            _user!.copyWith(profileImageUrl: imageUrl),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    await _handleImageUpload(File(pickedFile.path));
                  }
                },
                child: const Text('Gallery'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    await _handleImageUpload(File(pickedFile.path));
                  }
                },
                child: const Text('Camera'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

 Future<void> _deleteAccount() async {
  String? email;
  String? password;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please enter your credentials to confirm account deletion. This action cannot be undone.',
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              password = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (password!.isNotEmpty) {
              try {
                final user = _authService.currentUser;
                if (user == null || user.email == null) {
                  throw Exception('No user is signed in or email is unavailable');
                }
                await _authService.reauthenticateUser(user.email!, password!);
                await _authService.deleteAccount();
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted successfully')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting account: $e')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter valid email and password')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
  
  Future<void> _updateBio() async {
    String? newBio;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Bio'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    newBio = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newBio != null && newBio!.isNotEmpty) {
                    setState(() {
                      _user = _user?.copyWith(bio: newBio!);
                    });
                    await _authService.updateUserData(
                      _user!.copyWith(bio: newBio!),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bio updated successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid bio'),
                      ),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  Future<void> _updateGrade() async {
    String? newGrade;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Grade'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Grade',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    newGrade = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newGrade != null && newGrade!.isNotEmpty) {
                    setState(() {
                      _user = _user?.copyWith(grade: newGrade!);
                    });
                    await _authService.updateUserData(
                      _user!.copyWith(grade: newGrade!),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Grade updated successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid grade'),
                      ),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  Future<void> _changeName() async {
    String? newName;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'New Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    newName = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newName != null && newName!.isNotEmpty) {
                    // Update the name in the UserModel
                    setState(() {
                      _user = _user?.copyWith(name: newName!);
                    });
                    // Update the name in the backend via AuthService
                    await _authService.updateUserData(
                      _user!.copyWith(name: newName!),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Name updated successfully'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid name'),
                      ),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _authService.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
    );
  }

  Widget _buildProfileItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }

  Widget _buildAccountItem({
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black87,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _uploadProfileImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          child:
                              _user?.profileImageUrl != null
                                  ? ClipOval(
                                    child: Image.network(
                                      _user!.profileImageUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                    ),
                                  )
                                  : const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                        ),
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),
                  Text(
                    _user?.name ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Information
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildProfileItem(
                    title: 'Bio',
                    subtitle: _user?.bio ?? 'No bio available',
                    onTap: _updateBio,
                  ),
                  // _buildProfileItem(
                  //   title: 'Username',
                  //   subtitle: _user?.username ?? 'No username',
                  //   onTap: () {
                  //     // Navigate to edit username
                  //   },
                  // ),
                  _buildProfileItem(
                    title: 'Name',
                    subtitle: _user?.name ?? 'No name',
                    onTap: _changeName,
                  ),
                  _buildProfileItem(
                    title: 'Grade',
                    subtitle: _user?.grade ?? 'No grade',
                    onTap: _updateGrade,
                  ),
                  _buildProfileItem(
                    title: 'Language',
                    subtitle: _user?.language ?? 'No language',
                    onTap: () {
                      // Navigate to edit language
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Account Settings
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Account settings',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildAccountItem(
                    title: 'Update password',
                    onTap: _updatePassword,
                  ),
                  _buildAccountItem(
                    title: 'Delete account',
                    onTap: _deleteAccount,
                    textColor: Colors.red,
                  ),
                  _buildAccountItem(title: 'Log out', onTap: _logout),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: const Color(0xFF4285F4),
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(20),
      //       topRight: Radius.circular(20),
      //     ),
      //   ),
      //   child: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     selectedItemColor: Colors.white,
      //     unselectedItemColor: Colors.white70,
      //     currentIndex: 3, // Profile tab selected
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      //       BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: ''),
      //       BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //     ],
      //     onTap: (index) {
      //       switch (index) {
      //         case 0:
      //           Navigator.pushReplacementNamed(context, '/home');
      //           break;
      //         case 1:
      //           Navigator.pushReplacementNamed(context, '/quiz');
      //           break;
      //         case 2:
      //           Navigator.pushReplacementNamed(context, '/stats');
      //           break;
      //         case 3:
      //           // Already on profile
      //           break;
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
