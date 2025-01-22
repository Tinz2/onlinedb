import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlinedb_tinapat/addproduct.dart';
import 'package:onlinedb_tinapat/showproducttype.dart';
import 'showproductgrid.dart'; // เพิ่มการนำเข้าไฟล์สำหรับ showproductgrid.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA4qHt3caapDd-g9iPAWm_Psgrv_JNS5dI",
            authDomain: "onlinefirebase-e97a4.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-e97a4-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-e97a4",
            storageBucket: "onlinefirebase-e97a4.firebasestorage.app",
            messagingSenderId: "658488646483",
            appId: "1:658488646483:web:b41dd71280db80940d1fa6",
            measurementId: "G-QRMQGNJLHP"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 203, 247),
        centerTitle: true,
        title: const Text('เมนูหลัก'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopCurvedClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 126, 203, 247),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // เพิ่มรูปภาพด้านบน
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10), // ขอบโค้ง
                      child: Image.asset(
                        'assets/logo.png', // ระบุพาธของรูปภาพ
                        width: 150, // กำหนดขนาดของรูปภาพ
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10), // ระยะห่างระหว่างรูปภาพกับปุ่ม
                    // ปุ่ม 1
                    SizedBox(
                      width: 200, // ปุ่มยาวเท่ากัน
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const addproduct()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 2),
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('บันทึกสินค้า'),
                      ),
                    ),
                    const SizedBox(height: 16), // ระยะห่างระหว่างปุ่ม
                    // ปุ่ม 2
                    SizedBox(
                      width: 200, // ปุ่มยาวเท่ากัน
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowProductgrid()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 2),
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('แสดงข้อมูลสินค้า'),
                      ),
                    ),
                    const SizedBox(height: 16), // ระยะห่างระหว่างปุ่ม
                    // ปุ่ม 3
                    SizedBox(
                      width: 200, // ปุ่มยาวเท่ากัน
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowProductType()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue, width: 2),
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('ประเภทสินค้า'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
