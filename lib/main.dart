import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Đảm bảo các dịch vụ của Flutter được khởi tạo trước khi gọi SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cấu hình Game',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      home: const ModernSettingScreen(),
    );
  }
}

class ModernSettingScreen extends StatefulWidget {
  const ModernSettingScreen({super.key});

  @override
  State<ModernSettingScreen> createState() => _ModernSettingScreenState();
}

class _ModernSettingScreenState extends State<ModernSettingScreen> {
  // Các giá trị mặc định
  bool isSoundOn = true;
  bool isAutoSaveOn = true;
  double volumeValue = 50.0;
  final String highScore = "3,500";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Tải dữ liệu đã lưu
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSoundOn = prefs.getBool('isSoundOn') ?? true;
      isAutoSaveOn = prefs.getBool('isAutoSaveOn') ?? true;
      volumeValue = prefs.getDouble('volumeValue') ?? 50.0;
    });
  }

  // Lưu dữ liệu
  Future<void> _saveSettings(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Màu nền sáng, sang trọng
      appBar: AppBar(
        title: const Text(
          'Cài Đặt Game',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CARD ĐIỂM CAO ---
            _buildHighscoreCard(),
            const SizedBox(height: 25),

            const Text(
              "HỆ THỐNG",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),

            // --- CỤM CÀI ĐẶT CHUNG ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.volume_up_rounded,
                    iconColor: Colors.orange,
                    title: 'Âm thanh',
                    subtitle: 'Hiệu ứng và nhạc nền',
                    trailing: Switch(
                      value: isSoundOn,
                      activeColor: Colors.blueAccent,
                      onChanged: (val) {
                        setState(() => isSoundOn = val);
                        _saveSettings('isSoundOn', val);
                      },
                    ),
                  ),
                  const Divider(height: 1, indent: 70, endIndent: 20),
                  _buildSettingItem(
                    icon: Icons.sync_rounded,
                    iconColor: Colors.blue,
                    title: 'Tự động lưu',
                    subtitle: 'Lưu tiến trình vào đám mây',
                    trailing: Switch(
                      value: isAutoSaveOn,
                      activeColor: Colors.blueAccent,
                      onChanged: (val) {
                        setState(() => isAutoSaveOn = val);
                        _saveSettings('isAutoSaveOn', val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- CARD ÂM LƯỢNG ---
            const Text(
              "ÂM LƯỢNG",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            _buildVolumeCard(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị Điểm cao nhất
  Widget _buildHighscoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'KỶ LỤC HIỆN TẠI',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 10),
          Text(
            highScore,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w900, // Đã sửa từ .black sang .w900
            ),
          ),
        ],
      ),
    );
  }

  // Widget item cho từng dòng cài đặt
  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      trailing: trailing,
    );
  }

  // Widget thanh trượt Âm lượng
  Widget _buildVolumeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.volume_down, color: Colors.grey),
              Text(
                '${volumeValue.toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const Icon(Icons.volume_up, color: Colors.grey),
            ],
          ),
          Slider(
            value: volumeValue,
            min: 0,
            max: 100,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.blueAccent.withOpacity(0.1),
            onChanged: (val) => setState(() => volumeValue = val),
            onChangeEnd: (val) => _saveSettings('volumeValue', val),
          ),
        ],
      ),
    );
  }
}