import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/property_model.dart';
import '../providers/property_provider.dart';
import '../data/dummy_data.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import '../widgets/property_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Mumbai, India',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
            icon: const Icon(Icons.map),
          ),
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            CustomSearchBar(
              onFilterTap: () => showFilterBottomSheet(context),
            ),

            // Featured Properties Carousel
            const _FeaturedSection(),

            // Categories
            const _CategoriesSection(),

            // Quick Actions
            const _QuickActionsSection(),

            // Property Listings
            const _PropertyListingsSection(),
          ],
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context) {
    final featuredProperties = DummyData.properties.where((p) => p.isFeatured).toList();

    if (featuredProperties.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Featured Properties',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider.builder(
          itemCount: featuredProperties.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: PropertyCard(property: featuredProperties[index]),
            );
          },
          options: CarouselOptions(
            height: 350,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            viewportFraction: 0.85,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Consumer<PropertyProvider>(
          builder: (context, propertyProvider, child) {
            return CategorySection(
              categories: DummyData.categories,
              selectedCategory: propertyProvider.selectedCategory,
              onCategorySelected: (category) {
                propertyProvider.setSelectedCategory(category);
              },
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.home_outlined,
                  title: 'Buy',
                  subtitle: 'Find your dream home',
                  color: const Color(0xFF2E7D32),
                  onTap: () {
                    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
                    propertyProvider.setSelectedType('Sale');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.key_outlined,
                  title: 'Rent',
                  subtitle: 'Find rental properties',
                  color: const Color(0xFF1976D2),
                  onTap: () {
                    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
                    propertyProvider.setSelectedType('Rent');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.bed_outlined,
                  title: 'PG',
                  subtitle: 'Find PG accommodations',
                  color: const Color(0xFFE91E63),
                  onTap: () {
                    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
                    propertyProvider.setSelectedType('PG');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyListingsSection extends StatelessWidget {
  const _PropertyListingsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProvider>(
      builder: (context, propertyProvider, child) {
        final properties = propertyProvider.filteredProperties;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Properties (${properties.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (propertyProvider.searchQuery.isNotEmpty ||
                      propertyProvider.selectedCategory != 'All' ||
                      propertyProvider.selectedType != 'All')
                    TextButton(
                      onPressed: () {
                        propertyProvider.clearFilters();
                      },
                      child: const Text('Clear Filters'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (properties.isEmpty)
              const _EmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  return PropertyCard(property: properties[index]);
                },
              ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
              propertyProvider.clearFilters();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}