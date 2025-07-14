// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ContentScreen extends StatefulWidget {
//   final String jsonFile;
//   final String title;

//   const ContentScreen({super.key, required this.jsonFile, required this.title});

//   @override
//   State<ContentScreen> createState() => _ContentScreenState();
// }

// class _ContentScreenState extends State<ContentScreen> {
//   List<dynamic> slides = [];
//   bool isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     loadSlides();
//   }

//   Future<void> loadSlides() async {
//     final String jsonString = await rootBundle.loadString(
//       'assets/files/${widget.jsonFile}',
//     );
//     final List<dynamic> jsonData = json.decode(jsonString);
//     setState(() {
//       slides = jsonData;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final backgroundColor = isDarkMode ? Colors.black : const Color(0xFFF8F4E3);
//     final arabicColor = isDarkMode ? Colors.orange[200] : Colors.brown[900];
//     final copticColor = isDarkMode ? Colors.blue[200] : Colors.indigo[800];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
//             onPressed: () {
//               setState(() {
//                 isDarkMode = !isDarkMode;
//               });
//             },
//           ),
//         ],
//       ),
//       backgroundColor: backgroundColor,
//       body:
//           slides.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                 padding: const EdgeInsets.all(16.0),
//                 itemCount: slides.length,
//                 itemBuilder: (context, index) {
//                   final slide = slides[index];

//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                       color:
//                           isDarkMode
//                               ? Colors.grey[900]
//                               : const Color(0xFFFDF8EC),
//                       borderRadius: BorderRadius.circular(12),
//                       image:
//                           !isDarkMode
//                               ? const DecorationImage(
//                                 image: AssetImage(
//                                   'assets/images/parchment.jpg',
//                                 ),
//                                 fit: BoxFit.cover,
//                                 opacity: 0.2,
//                               )
//                               : null,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 6,
//                           offset: const Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         Text(
//                           'الشريحة رقم ${slide['slide_number']}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: arabicColor,
//                           ),
//                           textDirection: TextDirection.rtl,
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: SelectableText(
//                                 slide['coptic_transliterated_text'] ?? '',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: copticColor,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: SelectableText(
//                                 slide['arabic_text'] ?? '',
//                                 textDirection: TextDirection.rtl,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   height: 1.5,
//                                   color: arabicColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }
