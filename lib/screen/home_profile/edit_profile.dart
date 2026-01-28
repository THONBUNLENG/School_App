import 'dart:io';
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
      var uri = Uri.parse('https://your-api.com/update-profile');
      var request = http.MultipartRequest('POST', uri);

      request.fields['full_name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['faculty'] = _facultyController.text;
      request.fields['class'] = _classController.text;
      request.fields['address'] = _addressController.text;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', _imageFile!.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated Successfully!"), backgroundColor: Colors.green));
          Navigator.pop(context);
        }
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
    final Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              children: [
                _buildAvatarPicker(),
                const SizedBox(height: 30),

                _buildSectionTitle("Personal Info", isDark),
                _buildField("Full Name", _nameController, Icons.person_outline, isDark),
                _buildField("Email Address", _emailController, Icons.email_outlined, isDark),

                const SizedBox(height: 15),
                _buildSectionTitle("Academic Info", isDark),
                _buildField("Faculty", _facultyController, Icons.school_outlined, isDark),
                _buildField("Class", _classController, Icons.class_outlined, isDark),

                const SizedBox(height: 15),
                _buildSectionTitle("Contact Info", isDark),
                _buildField("Address", _addressController, Icons.location_on_outlined, isDark),

                const SizedBox(height: 40),
                _buildSubmitButton(),
                const SizedBox(height: 50),
              ],
            ),
          ),
          if (_isSaving) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: AppColor.accentGold.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColor.accentGold, size: 20),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: AppColor.accentGold, width: 1)),
        ),
        validator: (v) => v!.isEmpty ? "Required field" : null,
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.accentGold, width: 2),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColor.accentGold,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!) as ImageProvider
                  : const NetworkImage('https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=K9NmnfrV6VEQ7kNvwFyygHf&_nc_oc=Adnxy44aKN3VODMFFOUty1W7HnHm007aK5SyNMU_BoX9bW-uiLX5C1HMtzZnq8FMzOU&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=tCXfLjKrpi-cHZ0LJjdy_A&oh=00_AfoUoIkEmAjPAs7-u9NooHyfhKqfExQOZ3l3YazHV8D-9g&oe=69790F35'),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.accentGold,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _uploadProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.accentGold,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
      ),
      child: const Text("SAVE & UPDATE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const CircularProgressIndicator(color: AppColor.accentGold),
        ),
      ),
    );
  }
}