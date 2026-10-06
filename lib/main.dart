import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CodeConverterApp());
}

class CodeConverterApp extends StatelessWidget {
  const CodeConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Code Converter',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E1117),
        fontFamily: 'monospace',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5865F2),
          brightness: Brightness.dark,
        ),
      ),
      home: const ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController outputController = TextEditingController();

  String fromLanguage = 'JavaScript';
  String toLanguage = 'Python';

  final List<String> languages = [
    'Python',
    'JavaScript',
    'TypeScript',
    'Dart',
    'Java',
    'C',
    'C++',
    'C#',
    'Go',
    'Rust',
    'PHP',
    'HTML',
    'CSS',
    'SQL',
    'JSON',
    'YAML',
  ];

  void convertCode() {
    final code = inputController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาใส่โค้ดก่อน'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    outputController.text =
        '// Converted from $fromLanguage to $toLanguage\n\n$code';
  }

  void copyResult() {
    if (outputController.text.isEmpty) return;

    Clipboard.setData(
      ClipboardData(text: outputController.text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('คัดลอกโค้ดแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLanguageSection(),
                    const SizedBox(height: 18),
                    _buildEditor(
                      title: 'SOURCE CODE',
                      controller: inputController,
                      placeholder: 'วางโค้ดของคุณที่นี่...',
                      icon: Icons.code_rounded,
                    ),
                    const SizedBox(height: 18),
                    _buildConvertButton(),
                    const SizedBox(height: 18),
                    _buildEditor(
                      title: 'CONVERTED CODE',
                      controller: outputController,
                      placeholder: 'ผลลัพธ์จะแสดงที่นี่...',
                      icon: Icons.output_rounded,
                      readOnly: true,
                      showCopy: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF202630),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF5865F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CODE CONVERTER',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Convert your code simply.',
                  style: TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF30363D),
              ),
            ),
            child: const Text(
              'v1.0',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF151A21),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF272E38),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _languageDropdown(
              title: 'FROM',
              value: fromLanguage,
              onChanged: (value) {
                setState(() {
                  fromLanguage = value!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF202733),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Color(0xFF8B949E),
              ),
            ),
          ),
          Expanded(
            child: _languageDropdown(
              title: 'TO',
              value: toLanguage,
              onChanged: (value) {
                setState(() {
                  toLanguage = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageDropdown({
    required String title,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF7D8590),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1117),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: const Color(0xFF30363D),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF161B22),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Color(0xFF8B949E),
              ),
              style: const TextStyle(
                color: Color(0xFFE6EDF3),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              items: languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditor({
    required String title,
    required TextEditingController controller,
    required String placeholder,
    required IconData icon,
    bool readOnly = false,
    bool showCopy = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF161B22),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF252C35),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Color(0xFF8B949E),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                if (showCopy)
                  GestureDetector(
                    onTap: copyResult,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: Color(0xFF8B949E),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'COPY',
                          style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: 9,
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              color: Color(0xFFD8DEE9),
              fontSize: 13,
              height: 1.55,
            ),
            cursorColor: Color(0xFF5865F2),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFF484F58),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConvertButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: convertCode,
        icon: const Icon(
          Icons.auto_awesome_rounded,
          size: 18,
        ),
        label: const Text(
          'CONVERT CODE',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5865F2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}
