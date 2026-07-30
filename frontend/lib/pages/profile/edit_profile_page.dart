import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController address;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(text: widget.user["name"]);
    phone = TextEditingController(text: widget.user["phone"] ?? "");
    address = TextEditingController(text: widget.user["address"] ?? "");
  }

  Future<void> save() async {
    setState(() {
      loading = true;
    });

    bool success = await ApiService().updateProfile(
      name: name.text,
      phone: phone.text,
      address: address.text,
    );

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Nama"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "No HP"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: address,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Alamat"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : save,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
