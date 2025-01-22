import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'productdetail.dart'; // Import หน้า productdetail.dart

class ShowFilterType extends StatefulWidget {
  final String category; // หมวดหมู่สินค้า

  const ShowFilterType({super.key, required this.category});

  @override
  State<ShowFilterType> createState() => _ShowFilterTypeState();
}

class _ShowFilterTypeState extends State<ShowFilterType> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];
  final double minPrice = 500.0;
  final double maxPrice = 1000.0;

  // ฟังก์ชันสำหรับดึงข้อมูลจาก Firebase พร้อมกรองตามหมวดหมู่และราคา
  Future<void> fetchProducts() async {
    try {

  
  //เติมบรรทัดที่ใช้ query ข้อมูล กรองสินค้าที่ราคา >= 500
    final query = dbRef.orderByChild('category').equalTo(widget.category);

// ดึงข้อมูลจาก Realtime Database
      final snapshot = await query.get();
   if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
// วนลูปเพื่อแปลงข้อมูลเป็ น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
        
        setState(() {
          products = loadedProducts;
        });
      } else {
        print("ไม่พบสินค้าในหมวดหมู่ ${widget.category}");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สินค้าในหมวด: ${widget.category}'),
        backgroundColor: const Color.fromARGB(255, 126, 203, 247),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายละเอียด: ${product['description']}'),
                        Text('ราคา: ${product['price']} บาท'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetail(product: product), // ส่งข้อมูลสินค้าไปยังหน้าถัดไป
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
