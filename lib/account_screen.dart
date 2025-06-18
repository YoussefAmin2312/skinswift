import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  final String skinType;
  final List<String> skinConcerns;

  const AccountScreen({
    super.key,
    required this.skinType,
    required this.skinConcerns,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _privacyMode = false;

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
          'Account',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),
            
            const SizedBox(height: 24),
            
            // Skincare Profile
            _buildSkincareProfile(),
            
            const SizedBox(height: 24),
            
            // Settings Section
            _buildSettingsSection(),
            
            const SizedBox(height: 24),
            
            // App Info Section
            _buildAppInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B73FF).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF6B73FF),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _editProfilePicture,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B73FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // User Info
          const Text(
            'Youssef',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'youssef@example.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _editProfile,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6B73FF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xFF6B73FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkincareProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skincare Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Skin Type
          _buildInfoRow(
            'Skin Type',
            widget.skinType,
            Icons.face,
            onTap: _editSkinType,
          ),
          
          const SizedBox(height: 12),
          
          // Skin Concerns
          _buildInfoRow(
            'Concerns',
            widget.skinConcerns.join(', '),
            Icons.healing,
            onTap: _editSkinConcerns,
          ),
          
          const SizedBox(height: 12),
          
          // Progress Stats (Mock data)
          _buildInfoRow(
            'Progress Photos',
            '12 photos taken',
            Icons.photo_camera,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon, {VoidCallback? onTap, bool showArrow = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF6B73FF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Notifications
          _buildSettingsToggle(
            'Notifications',
            'Daily reminders and tips',
            Icons.notifications,
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          
          const SizedBox(height: 16),
          
          // Dark Mode
          _buildSettingsToggle(
            'Dark Mode',
            'Switch to dark theme',
            Icons.dark_mode,
            _darkModeEnabled,
            (value) => setState(() => _darkModeEnabled = value),
          ),
          
          const SizedBox(height: 16),
          
          // Privacy Mode
          _buildSettingsToggle(
            'Privacy Mode',
            'Keep your data private',
            Icons.privacy_tip,
            _privacyMode,
            (value) => setState(() => _privacyMode = value),
          ),
          
          const SizedBox(height: 16),
          
          // Language (Clickable)
          _buildSettingsItem(
            'Language',
            'English',
            Icons.language,
            onTap: _changeLanguage,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF6B73FF),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF6B73FF),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, String value, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF6B73FF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildMenuItem('Help & FAQ', Icons.help_outline, _openHelp),
          _buildMenuItem('Contact Support', Icons.support_agent, _contactSupport),
          _buildMenuItem('Privacy Policy', Icons.privacy_tip_outlined, _openPrivacyPolicy),
          _buildMenuItem('Terms of Service', Icons.article_outlined, _openTerms),
          
          const SizedBox(height: 16),
          
          Text(
            'App Version: 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF6B73FF),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // Event handlers
  void _editProfilePicture() {
    _showComingSoonDialog('Profile Picture');
  }

  void _editProfile() {
    _showComingSoonDialog('Edit Profile');
  }

  void _editSkinType() {
    _showComingSoonDialog('Edit Skin Type');
  }

  void _editSkinConcerns() {
    _showComingSoonDialog('Edit Skin Concerns');
  }

  void _changeLanguage() {
    _showComingSoonDialog('Language Settings');
  }

  void _openHelp() {
    _showComingSoonDialog('Help & FAQ');
  }

  void _contactSupport() {
    _showComingSoonDialog('Contact Support');
  }

  void _openPrivacyPolicy() {
    _showComingSoonDialog('Privacy Policy');
  }

  void _openTerms() {
    _showComingSoonDialog('Terms of Service');
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature feature coming soon! We\'re working hard to bring you the best skincare experience.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
} 