import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/seller_screens/add_item.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<String> items = [];
  final TextEditingController _searchController = TextEditingController();

  void _editItem(int index) async {
    // هنا هتنتقلي لصفحة التعديل لو تحبي
    // دلوقتي هنخليه بسيط:
    TextEditingController editController =
        TextEditingController(text: items[index]);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                items[index] = editController.text.trim();
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Market',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Sort',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFilterButton('Price'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Location'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Filter'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Filter'),
                ],
              ),
              const SizedBox(height: 20),
              // Input for new item
              GestureDetector(
                onTap: () async {
                  final newItemName = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddItem(),
                    ),
                  );

                  if (newItemName != null) {
                    setState(() {
                      items.add(newItemName);
                    });
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Add New Item',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(Icons.add, size: 30, color: Colors.black),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Items List
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryText,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            items[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => _editItem(index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                          ),
                          onPressed: () async {
                            // Show confirmation dialog
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.borderSide,
                                  title: Text(
                                    'Are you sure you want to delete this Item?',
                                    style: textStyleWhite,
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    'This action is permanent and cannot be undone. All Item’s data will be permanently removed.',
                                    style: textStyleGray,
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    popUpBotton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        'Cancel',
                                        AppColors.primaryText,
                                        AppColors.buttonText),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    popUpBotton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      'Delete',
                                      AppColors.buttonColor,
                                      AppColors.buttonText,
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              setState(() {
                                items.removeAt(index);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(title),
    );
  }
}
