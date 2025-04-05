// import 'package:feedback_app/Screens/MenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:seam_app/screens/MenuScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandSelectionScreen extends StatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  State<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends State<BrandSelectionScreen> {
  // Modern color scheme
  final Color primaryColor = Color(0xFF2D3142);
  final Color accentColor = Color(0xFF4F6AF0);
  final Color backgroundColor = Color(0xFFF7F8FC);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF2D3142);
  final Color textLightColor = Color(0xFF9098B1);
  final Color dividerColor = Color(0xFFE5E9F2);

  final List<Map<String, dynamic>> brands = [
    {
      'name': 'KFC',
      'logo': 'assets/brands/kfc.png',
      'rating': 4.5,
      'deliveryTime': '30-40 min',
      'cuisine': 'Fast Food',
      'menuItems': [
        {
          'name': 'Chicken Burger',
          'price': 199.00,
          'image': 'assets/menu_items/kfc_burger.jpg',
          'description': 'Crispy chicken patty with fresh lettuce and special sauce',
        },
        {
          'name': 'Chicken Wings',
          'price': 299.00,
          'image': 'assets/menu_items/kfc_chicken.jpg',
          'description': '8 pieces of crispy chicken wings with your choice of sauce',
        },
        {
          'name': 'Chicken Rice Bowl',
          'price': 249.00,
          'image': 'assets/menu_items/kfc_rice.jpg',
          'description': 'Flavorful rice topped with grilled chicken and vegetables',
        },
      ],
    },
    {
      'name': 'McDonald\'s',
      'logo': 'assets/brands/mcdonald.jpg',
      'rating': 4.3,
      'deliveryTime': '25-35 min',
      'cuisine': 'Fast Food',
      'menuItems': [
        {
          'name': 'Big Mac',
          'price': 249.00,
          'image': 'assets/menu_items/mcd_burger.jpg',
          'description': 'Double beef patties with special sauce, lettuce, cheese, pickles, and onions',
        },
        {
          'name': 'McChicken',
          'price': 199.00,
          'image': 'assets/menu_items/mcd_chicken.jpg',
          'description': 'Crispy chicken with lettuce and mayo in a sesame seed bun',
        },
      ],
    },
    {
      'name': 'Burger King',
      'logo': 'assets/brands/burgerking.png',
      'rating': 4.2,
      'deliveryTime': '30-40 min',
      'cuisine': 'Fast Food',
      'menuItems': [
        {
          'name': 'Whopper',
          'price': 279.00,
          'image': 'assets/menu_items/bk_burger.jpg',
          'description': 'Flame-grilled beef patty with tomatoes, lettuce, mayo, pickles, and onions',
        },
        {
          'name': 'Chicken Royale',
          'price': 229.00,
          'image': 'assets/menu_items/bk_fries.jpg',
          'description': 'Crispy chicken with lettuce and mayo in a sesame seed bun',
        },
      ],
    },
    {
      'name': 'Pizza Hut',
      'logo': 'assets/brands/pizzahut.png',
      'rating': 4.4,
      'deliveryTime': '35-45 min',
      'cuisine': 'Pizza',
      'menuItems': [
        {
          'name': 'Margherita Pizza',
          'price': 299.00,
          'image': 'assets/menu_items/ph_pizza.jpg',
          'description': 'Classic pizza with tomato sauce, mozzarella cheese, and basil',
        },
        {
          'name': 'Pepperoni Pizza',
          'price': 349.00,
          'image': 'assets/menu_items/ph_pepperoni.jpg',
          'description': 'Loaded with pepperoni, cheese, and our signature sauce',
        },
      ],
    },
    {
      'name': 'Subway',
      'logo': 'assets/brands/subway.png',
      'rating': 4.1,
      'deliveryTime': '25-35 min',
      'cuisine': 'Sandwiches',
      'menuItems': [
        {
          'name': 'Veggie Delite',
          'price': 199.00,
          'image': 'assets/menu_items/sub_veggie.jpg',
          'description': 'Fresh vegetables with your choice of bread and sauces',
        },
        {
          'name': 'Chicken Teriyaki',
          'price': 249.00,
          'image': 'assets/menu_items/sub_chicken.jpg',
          'description': 'Grilled chicken with teriyaki sauce and fresh vegetables',
        },
      ],
    },
    {
      'name': 'Domino\'s',
      'logo': 'assets/brands/dominos.png',
      'rating': 4.3,
      'deliveryTime': '30-40 min',
      'cuisine': 'Pizza',
      'menuItems': [
        {
          'name': 'Farmhouse Pizza',
          'price': 399.00,
          'image': 'assets/menu_items/dom_pizza.jpg',
          'description': 'Loaded with mushrooms, capsicum, onions, and tomatoes',
        },
        {
          'name': 'Chicken Golden Delight',
          'price': 449.00,
          'image': 'assets/menu_items/dom_chicken.jpg',
          'description': 'Grilled chicken with black olives and red paprika',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Food & Beverages',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildCategories(),
          Expanded(
            child: _buildBrandsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: textLightColor),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for restaurants, cuisines...',
                hintStyle: GoogleFonts.poppins(color: textLightColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Fast Food', 'Italian', 'Indian', 'Chinese', 'Desserts'];
    
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                categories[index],
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {},
              backgroundColor: cardColor,
              selectedColor: accentColor,
              checkmarkColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? accentColor : dividerColor,
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        final brand = brands[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MenuScreen(
                  brandName: brand['name'],
                  menuItems: brand['menuItems'],
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    brand['logo'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            brand['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: accentColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  brand['rating'].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: textLightColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            brand['deliveryTime'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: textLightColor,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.restaurant,
                            size: 16,
                            color: textLightColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            brand['cuisine'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: textLightColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View Menu',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: accentColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: accentColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}