import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String date;
  final String? imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OfferCard({
    Key? key,
    required this.title,
    required this.date,
    this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Center(child: Text('Image')),
                  ),
          ),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
