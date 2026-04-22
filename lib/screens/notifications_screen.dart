import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/notifications'),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      );
      if (response.statusCode == 200) {
        setState(() {
          _notifications = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(int id) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      await http.put(
        Uri.parse('http://localhost:3000/api/notifications/$id/read'),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      );
      _fetchNotifications();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);

    return Scaffold(
      appBar: const KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    'THÔNG BÁO',
                    style: GoogleFonts.barlowCondensed(fontSize: 48, fontWeight: FontWeight.bold, color: katinatBlue),
                  ),
                  const SizedBox(height: 10),
                  Text('Cập nhật những tin tức mới nhất từ ĐƯƠNG Coffee', style: GoogleFonts.montserrat(color: Colors.grey[600])),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(50.0), child: CircularProgressIndicator()))
            else if (_notifications.isEmpty)
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Column(
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    const Text('Bạn không có thông báo nào.'),
                  ],
                ),
              )
            else
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      final isRead = n['is_read'] == true;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isRead ? Colors.grey[200] : const Color(0xFFD3A374).withOpacity(0.2),
                          child: Icon(Icons.notifications, color: isRead ? Colors.grey : const Color(0xFFD3A374)),
                        ),
                        title: Text(n['title'], style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                        subtitle: Text(n['body'] ?? ''),
                        trailing: Text(n['created_at'].toString().split('T')[0], style: const TextStyle(fontSize: 10)),
                        onTap: () => _markAsRead(n['id']),
                      );
                    },
                  ),
                ),
              ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }
}
