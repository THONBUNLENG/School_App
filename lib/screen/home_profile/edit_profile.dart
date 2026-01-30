import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/config/app_color.dart';
import '../../extension/change_notifier.dart';

class EditProfileStudent extends StatefulWidget {
  const EditProfileStudent({super.key});

  @override
  State<EditProfileStudent> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfileStudent> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  File? _imageFile;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _facultyController;
  late TextEditingController _classController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "何 文霖");
    _emailController = TextEditingController(text: "austin.carr@example.com");
    _facultyController = TextEditingController(text: "Computer Science");
    _classController = TextEditingController(text: "CS Generation 21");
    _addressController = TextEditingController(text: "Phnom Penh, Cambodia");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _facultyController.dispose();
    _classController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _uploadProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      // Logic URL របស់អ្នកនៅទីនេះ
      await Future.delayed(const Duration(seconds: 2)); // Simulate network
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: BrandGradient.luxury)),
        title: const Text("EDIT PROFILE", style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColor.lightGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 50),
              children: [
                _buildAvatarPicker(isDark),
                const SizedBox(height: 40),

                _buildSectionTitle("PERSONAL INFORMATION", isDark),
                _buildField("Full Name", _nameController, Icons.person_rounded, isDark),
                _buildField("Email Address", _emailController, Icons.email_rounded, isDark),

                const SizedBox(height: 20),
                _buildSectionTitle("ACADEMIC DETAILS", isDark),
                _buildField("Faculty", _facultyController, Icons.school_rounded, isDark),
                _buildField("Class", _classController, Icons.hub_rounded, isDark),

                const SizedBox(height: 20),
                _buildSectionTitle("CONTACT & ADDRESS", isDark),
                _buildField("Current Address", _addressController, Icons.location_on_rounded, isDark),

                const SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
          if (_isSaving) _buildLoadingOverlay(isDark),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? AppColor.lightGold : AppColor.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: ctrl,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColor.accentGold, size: 20),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: isDark ? AppColor.surfaceColor : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColor.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColor.accentGold, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
        ),
        validator: (v) => v!.isEmpty ? "This field is required" : null,
      ),
    );
  }

  Widget _buildAvatarPicker(bool isDark) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.accentGold, width: 2),
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: isDark ? AppColor.surfaceColor : Colors.grey[200],
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!) as ImageProvider
                  : const CachedNetworkImageProvider(
                  'https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=Gw8XA4kWnoYQ7kNvwExYIwu&_nc_oc=AdnOTMQyfWOLB_BheKEu5XTcy7QxFX7ZkZdd8bMbnd1rMSQcCoZp87h02O44LaMDPNs&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=7PJE6NZ8oU9kqXNiHwVOJA&oh=00_AfquH0V8VDa1gz_R6Jf0FZqVxTQDK_aV4b2Grzuwp1TaMQ&oe=697FA6B5'),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: BrandGradient.luxury,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.camera_alt_rounded, color: AppColor.lightGold, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppColor.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _uploadProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: const Text("SAVE CHANGES", style: TextStyle(color: AppColor.lightGold, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      ),
    );
  }

  Widget _buildLoadingOverlay(bool isDark) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: isDark ? AppColor.surfaceColor : Colors.white, borderRadius: BorderRadius.circular(25)),
          child: const CircularProgressIndicator(color: AppColor.accentGold, strokeWidth: 3),
        ),
      ),
    );
  }
}