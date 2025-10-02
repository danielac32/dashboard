import 'package:flutter/material.dart';

import '../controller/Controller.dart';
import 'package:get/get.dart';

class FilesList extends StatelessWidget {
  const FilesList({
    super.key,
    required this.controller,
  });

  final XmlTxtController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = controller;
      return Column(
        children: [
          Text(
            'Archivos encontrados: ${ctrl.xmlFiles.length}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.xmlFiles.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Icon(
                          Icons.insert_drive_file,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      title: Text(
                        ctrl.xmlFiles[index].name,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Fecha: ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextSpan(
                              text: ctrl.xmlFiles[index].date,
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(text: '  •  '),
                            TextSpan(
                              text: 'Tamaño: ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            TextSpan(
                              text: ctrl.xmlFiles[index].size,
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),


                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.deleteFile(index);
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: (){

                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}