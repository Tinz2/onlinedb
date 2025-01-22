import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class ShowProductgrid extends StatefulWidget {
  const ShowProductgrid({super.key});

  @override
  State<ShowProductgrid> createState() => _ShowProductgridState();
}

class _ShowProductgridState extends State<ShowProductgrid> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      // ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];

        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        for (var child in snapshot.children) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        }

        // เรียงราคาสินค้าจากน้อยไปมาก
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));

        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });

        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console

      // แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate); // แสดงแค่วันที่ (ไม่รวมเวลา)
  }

  // ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts(); // อัปเดตข้อมูลหลังจากลบ
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  // ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
            // ปุ่มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
            // ปุ่มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบ
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
void showEditProductDialog(Map<String, dynamic> product) {
    // สร้าง controller สำหรับแต่ละฟิลด์
    TextEditingController nameController = TextEditingController(text: product['name']);
    TextEditingController descriptionController = TextEditingController(text: product['description']);
    TextEditingController priceController = TextEditingController(text: product['price'].toString());
    TextEditingController selectedCategory = TextEditingController(text: product['category']);
    TextEditingController quantityController = TextEditingController(text: product['quantity'].toString());
    TextEditingController selectedOption = TextEditingController(text: product['discount'].toString());
    TextEditingController dateController = TextEditingController(
        text: product['productionDate'] != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(product['productionDate']))
            : '');
 
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: selectedCategory,
                  decoration: InputDecoration(labelText: 'ประเภท'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: selectedOption,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ส่วนลด'),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'วันที่ผลิต (dd/MM/yyyy)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // ตรวจสอบว่าเป็นตัวเลขก่อน
                String priceText = priceController.text;
                String discountText = selectedOption.text;
 
                // ตรวจสอบราคา
                if (priceText.isEmpty || int.tryParse(priceText) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กรุณากรอกราคาเป็นตัวเลข')));
                  return;
                }
 
                // ตรวจสอบส่วนลด
                int discount = 0;
                if (discountText.isNotEmpty && int.tryParse(discountText) != null) {
                  discount = int.parse(discountText);
                }
 
                // เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'category': selectedCategory.text,
                  'quantity': int.parse(quantityController.text),
                  'discount': discount, // ใช้ตัวเลขที่แปลงแล้ว
                  'productionDate': dateController.text.isNotEmpty
                      ? DateFormat('dd/MM/yyyy').parse(dateController.text).toIso8601String()
                      : null, // การแปลงวันที่ให้เป็น ISO 8601 format
                };
 
                // อัปเดตข้อมูลใน Firebase
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')));
                  fetchProducts(); // รีเฟรชข้อมูลหลังการแก้ไข
                  Navigator.of(dialogContext).pop(); // ปิด Dialog
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
                });
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }


  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แสดงผลข้อมูลสินค้า'),
        backgroundColor: const Color.fromARGB(255, 126, 203, 247),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // แถวละ 2 รายการ
                crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
                childAspectRatio: 2 / 3, // อัตราส่วนกว้างต่อสูงของแต่ละ Grid
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                            color: Colors.blue.shade100,
                          ),
                          child: Center(
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'รายละเอียด: ${product['description']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'วันที่ผลิต: ${formatDate(product['productionDate'])}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ราคา: ${product['price']} บาท',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end, // จัดให้อยู่ด้านขวา
                          children: [
                            IconButton(
                              onPressed: () {
                                showDeleteConfirmationDialog(
                                    product['key'], context);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 30,
                              tooltip: 'ลบสินค้า',
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                showEditProductDialog(
                                    product); // เปด Dialog แกไขสินคา
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              iconSize: 30,
                              tooltip: 'แก้ไขสินค้า',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
