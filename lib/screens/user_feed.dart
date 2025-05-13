import 'package:flutter/material.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  // final TextEditingController _postController = TextEditingController();
  List<Map<String, String>> posts = [
    {
      "content":
          "With electric vehicles (EVs) becoming more accessible and self-driving technology evolving, the future of driving is rapidly changing.",
    }
  ];

  // void _addPost() {
  //   if (_postController.text.trim().isNotEmpty) {
  //     setState(() {
  //       posts.insert(0, {"content": _postController.text.trim()});
  //       _postController.clear();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                "Posts",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 7.20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            // Posts list
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return _buildPostItem(
                    posts[index]["content"] ?? "",
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildPostItem(String content) {
    return Container(
      padding: EdgeInsets.all(7),
      width: 345,
      height: 221,
      decoration: ShapeDecoration(
        color: const Color(0x33D9D9D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Container()),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(child: Container()),
                Icon(Icons.share),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
