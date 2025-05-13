import 'package:flutter/material.dart';

class SellerFeedScreen extends StatefulWidget {
  const SellerFeedScreen({super.key});

  @override
  State<SellerFeedScreen> createState() => _SellerFeedScreenState();
}

class _SellerFeedScreenState extends State<SellerFeedScreen> {
  final TextEditingController _postController = TextEditingController();
  List<Map<String, String>> posts = [
    {
      "content":
          "With electric vehicles (EVs) becoming more accessible and self-driving technology evolving, the future of driving is rapidly changing.",
    }
  ];

  void _addPost() {
    if (_postController.text.trim().isNotEmpty) {
      setState(() {
        posts.insert(0, {"content": _postController.text.trim()});
        _postController.clear();
      });
    }
  }

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
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    width: 260,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0x33D9D9D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _postController,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: TextStyle(
                          color: Colors.black.withValues(alpha: 128),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),

                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10), // suffixIcon: IconButton(
                        //   icon: Icon(Icons.send),
                        //   onPressed: _addPost,
                        // ),
                      ),
                      onSubmitted: (_) => _addPost(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Posts list
            Expanded(
              child: posts.isEmpty
                  ? Center(child: Text("No posts yet. Create your first post!"))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return _buildPostItem(posts[index]);
                      },
                    ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(7),
      width: 345,
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
                Text(
                  "Shop Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(child: Container()),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              post["content"] ?? "",
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
