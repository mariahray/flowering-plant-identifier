import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'favorite.dart';
import 'flower_info.dart';
import 'database_helper.dart';

class Catalog extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final TextEditingController _searchController = TextEditingController();

  List<String> items = [
    'assets/images/Abbey.png',
    'assets/images/Abbey Dark Purple.png',
    'assets/images/Abbey Yellow.png',
    'assets/images/Alamos Purple.png',
    'assets/images/Alamos Yellow.png',
    'assets/images/Anastasia Sunny.png',
    'assets/images/Anastasia White.png',
    'assets/images/Dante Dark.png',
    'assets/images/Dante Pink.png',
    'assets/images/Dante Purple.png',
    'assets/images/Dante Red.png',
    'assets/images/Dante Yellow.png',
    'assets/images/Deligreen.png',
    'assets/images/Fireball.png',
    'assets/images/Florange.png',
    'assets/images/Magnum Yellow.png',
    'assets/images/Midnightsun.png',
    'assets/images/Mulberry.png',
    'assets/images/Olive.png',
    'assets/images/Paladov Dark.png',
    'assets/images/Pip Salmon.png',
    'assets/images/Radost.png',
    'assets/images/Radost Yellow.png',
    'assets/images/Rossano Charlotte.png',
    'assets/images/Rossano Elizabeth.png',
    'assets/images/Rossano White.png',
    'assets/images/Zembla.png',
    'assets/images/Zembla Brasil.png',
    'assets/images/Zembla Lime.png',
    'assets/images/Zembla Yellow.png',
  ];

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void _showFlowerDetails(String flowerImage) async {
    final dbHelper = DatabaseHelper();

    int flowerId = await dbHelper.getFlowerIdByImage(flowerImage);

    final flower = await dbHelper.getFlowerById(flowerId);

    if (flower != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return FlowerDetail(
            flower: flower,
            isFavorite: FavoriteManager().isFavorite(flower['image']),
            onFavoriteChanged: (isFavorite) {
              setState(() {

              });
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flower not found')),
      );
    }
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
              'assets/images/tt1.png',
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
              image: DecorationImage(image: AssetImage('assets/images/catbook.png')),
            ),
            child: Column(
              children: [
                SizedBox(height: 85),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
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
                        setState(() {
                          filteredItems = items.where((item) => item.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                      },
                    ),
                  ),
                ),
    Expanded(
    child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 20.0,
    mainAxisSpacing: 10.0,
    childAspectRatio: 0.8,
    ),
    itemCount: filteredItems.length,
    padding: EdgeInsets.all(15.0),
    itemBuilder: (context, index) {
    String flowerImage = filteredItems[index];
    return FlowerCard(
    flowerImage: flowerImage,
    onTap: () {
    _showFlowerDetails(flowerImage);
    },
    );
    },
    ),
    ),

    Positioned(
            top: 30,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/back-icon.png',
                width: 25,
                height: 40,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.info_outline, color: Colors.green,
              size:30),
              onPressed: _showTutorial,
            ),
          ),
        ],
      )),
    ],
    ));
  }
}

class FlowerCard extends StatelessWidget {
  final String flowerImage;
  final VoidCallback onTap;

  FlowerCard({
    required this.flowerImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFFDF2E9);
    Color shadowDarkColor = const Color(0xFFB6A89B);
    Color shadowLightColor = const Color(0xFFFFFFFF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: shadowDarkColor.withOpacity(0.5),
              offset: Offset(6, 6),
              blurRadius: 12,
              inset: true,
            ),
            BoxShadow(
              color: shadowLightColor.withOpacity(0.8),
              offset: Offset(-6, -6),
              blurRadius: 12,
              inset: true,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flower image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  flowerImage,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        'Image not found',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Flower name below the image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                flowerImage
                    .split('/')
                    .last
                    .split('.')
                    .first
                    .replaceAll('_', ' '),
                style: TextStyle(
                  fontFamily: 'Mazzard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}