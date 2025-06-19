import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tic_quiz/models/question.dart';
import 'package:tic_quiz/services/firestore_service.dart';
import 'package:tic_quiz/services/storage_service.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;
  const EditQuestionScreen({super.key, required this.question});

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController _textController;
  late List<TextEditingController> _optionControllers;
  late int _correctIndex;
  File? _image;
  final _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question.text);
    _optionControllers =
        widget.question.options
            .map((e) => TextEditingController(text: e))
            .toList();
    _correctIndex = widget.question.correctIndex;
  }

  Future<void> _pickImage() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Future<void> _updateQuestion() async {
    if (_textController.text.isEmpty ||
        _optionControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final text = _textController.text.trim();
      final options = _optionControllers.map((c) => c.text.trim()).toList();
      String? imageUrl = widget.question.imageUrl;
      if (_image != null) {
        if (imageUrl != null) await StorageService().deleteImage(imageUrl);
        imageUrl = await StorageService().uploadImage(
          _image!,
          'questions/${DateTime.now().millisecondsSinceEpoch}.png',
        );
      }
      await FirestoreService().updateQuestion(
        'quizId',
        widget.question.id,
        Question(
          id: widget.question.id,
          text: text,
          options: options,
          correctIndex: _correctIndex,
          imageUrl: imageUrl,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    for (var controller in _optionControllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Question Text'),
            ),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _optionControllers[index],
                  decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                ),
              ),
            ),
            DropdownButton<int>(
              value: _correctIndex,
              items: List.generate(
                4,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text('Option ${index + 1}'),
                ),
              ),
              onChanged: (value) => setState(() => _correctIndex = value!),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Replace Image'),
            ),
            if (widget.question.imageUrl != null)
              Image.network(widget.question.imageUrl!, height: 100),
            if (_image != null) Image.file(_image!, height: 100),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateQuestion,
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
