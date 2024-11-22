import 'package:flutter/material.dart';
import 'favorite.dart';

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  TextEditingController _searchController = TextEditingController();
  List<String> filteredFavoriteItems = [];

  @override
  void initState() {
    super.initState();
    filteredFavoriteItems = FavoriteManager().favoriteItems;
  }

  void _filterFavorites(String query) {
    setState(() {
      filteredFavoriteItems = FavoriteManager()
          .favoriteItems
          .where((item) =>
          item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Image.asset(
              'assets/images/tt2.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/catbook.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/back-icon.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search bookmarked flowers',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                  ),
                  onChanged: (value) {
                    _filterFavorites(value);
                  },
                ),
              ),
              Expanded(
                child: filteredFavoriteItems.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/bookmark.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'No bookmarked items found',
                        style: TextStyle(color: Colors.green, fontFamily: "Mazzard", fontSize: 19),
                      ),
                    ),
                  ],
                )
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredFavoriteItems.length,
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final imageName = filteredFavoriteItems[index];
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(imageName),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                imageName.split('/').last.split('.').first,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 8),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.lightGreen,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  FavoriteManager().removeFavorite(imageName);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.green, size: 30),
              onPressed: _showTutorial,
            ),
          ),
        ],
      ),
    );
  }
}
