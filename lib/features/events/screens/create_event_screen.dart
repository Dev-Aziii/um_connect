import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:um_connect/core/services/image_upload_service.dart';
import 'package:um_connect/providers/events_provider.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _venueController = TextEditingController();

  DateTime? _selectedDate;
  XFile? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final image = await ImageUploadService().pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date and time.')),
        );
        return;
      }
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an event poster.')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        // 1. Upload image to ImageKit
        final imageUrl = await ImageUploadService().uploadImage(
          _selectedImage!,
        );
        if (imageUrl == null) {
          throw Exception('Image upload failed.');
        }

        // 2. Save event data to Firestore
        await ref
            .read(eventsRepositoryProvider)
            .createEvent(
              title: _titleController.text,
              detail: _detailController.text,
              venue: _venueController.text,
              date: _selectedDate!,
              imageUrl: imageUrl,
            );

        // 3. Invalidate providers to refetch lists
        ref.invalidate(upcomingEventsProvider);
        ref.invalidate(allUpcomingEventsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully!')),
          );
          context.pop(); // Go back to the previous screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to create event: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- Image Picker ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Upload Event Poster'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            // --- Form Fields ---
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailController,
              decoration: const InputDecoration(labelText: 'Event Details'),
              maxLines: 5,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter details' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _venueController,
              decoration: const InputDecoration(labelText: 'Venue'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a venue' : null,
            ),
            const SizedBox(height: 16),
            // --- Date Picker ---
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date & Time'),
              subtitle: Text(
                _selectedDate == null
                    ? 'Not Set'
                    : DateFormat.yMMMMd().add_jm().format(_selectedDate!),
              ),
              onTap: _pickDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 32),
            // --- Submit Button ---
            ElevatedButton(
              onPressed: _isLoading ? null : _submitEvent,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text('Publish Event'),
            ),
          ],
        ),
      ),
    );
  }
}
