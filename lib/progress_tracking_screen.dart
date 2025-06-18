import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ProgressTrackingScreen extends StatefulWidget {
  final String skinType;
  final List<String> skinConcerns;

  const ProgressTrackingScreen({
    super.key,
    required this.skinType,
    required this.skinConcerns,
  });

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _progressPhotos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPhotos();
  }

  Future<void> _loadSavedPhotos() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory progressDir = Directory('${appDir.path}/progress_photos');
      
      if (await progressDir.exists()) {
        final List<FileSystemEntity> files = progressDir.listSync();
        final List<File> imageFiles = files
            .where((file) => file.path.toLowerCase().endsWith('.jpg'))
            .map((file) => File(file.path))
            .toList();
        
        // Sort by creation time (newest first)
        imageFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
        
        setState(() {
          _progressPhotos = imageFiles;
        });
      }
    } catch (e) {
      print('Error loading photos: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();
    
    if (cameraStatus.isDenied || storageStatus.isDenied) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text('Camera and storage permissions are needed to take and save progress photos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request permissions first
      await _requestPermissions();

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );

      if (photo != null) {
        await _savePhoto(File(photo.path));
      }
    } catch (e) {
      _showErrorDialog('Failed to take photo: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePhoto(File photo) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory progressDir = Directory('${appDir.path}/progress_photos');
      
      // Create directory if it doesn't exist
      if (!await progressDir.exists()) {
        await progressDir.create(recursive: true);
      }

      // Generate filename with timestamp
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'progress_$timestamp.jpg';
      final String savedPath = '${progressDir.path}/$fileName';

      // Copy photo to app directory
      await photo.copy(savedPath);

      // Reload photos to show the new one
      await _loadSavedPhotos();

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Failed to save photo: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Photo Saved!'),
        content: const Text('Your progress photo has been saved successfully.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewPhoto(File photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewScreen(photo: photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Track Progress',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.camera_alt,
                  size: 48,
                  color: Color(0xFF6B73FF),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Track Your Skin Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Take regular photos to see how your ${widget.skinType.toLowerCase()} skin improves over time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Take Photo Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _takePhoto,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.camera_alt),
              label: Text(_isLoading ? 'Taking Photo...' : 'Take Progress Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B73FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Photos Grid
          Expanded(
            child: _progressPhotos.isEmpty
                ? _buildEmptyState()
                : _buildPhotosGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No progress photos yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take your first photo to start tracking your skin journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress (${_progressPhotos.length} photos)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _progressPhotos.length,
              itemBuilder: (context, index) {
                final photo = _progressPhotos[index];
                final date = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(photo.path.split('progress_')[1].split('.jpg')[0])
                );
                
                return GestureDetector(
                  onTap: () => _viewPhoto(photo),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.file(
                              photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoViewScreen extends StatelessWidget {
  final File photo;

  const PhotoViewScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(photo),
        ),
      ),
    );
  }
} 