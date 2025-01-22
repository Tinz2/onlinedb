import 'package:flutter/material.dart';
import 'showfiltertype.dart';

class ShowProductType extends StatelessWidget {
  const ShowProductType({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Electronics', 'Clothing', 'Food', 'Books'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ประเภทสินค้า'),
        backgroundColor: const Color.fromARGB(255, 126, 203, 247),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // แถวละ 2 รายการ
          crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
          mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
          childAspectRatio: 1, // อัตราส่วนกว้างต่อสูงของแต่ละ Grid
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // เปลี่ยนไปยังหน้า showfiltertype พร้อมส่ง category ที่เลือกไป
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShowFilterType(category: category), // ส่ง category ไป
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Center(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
