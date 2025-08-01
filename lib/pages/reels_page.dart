import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/reel_tile.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter properties that have video URLs
    final propertiesWithVideos = DummyData.properties
        .where((property) => property.videoUrl != null)
        .toList();

    // If no properties have videos, add sample video URLs to some properties
    if (propertiesWithVideos.isEmpty) {
      for (int i = 0; i < DummyData.properties.length && i < 3; i++) {
        DummyData.properties[i] = DummyData.properties[i].copyWith(
          videoUrl: DummyData.videoUrls[i % DummyData.videoUrls.length],
        );
      }
      propertiesWithVideos.addAll(DummyData.properties.take(3));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Property Reels',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showReelsInfo(context);
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: propertiesWithVideos.isNotEmpty
          ? PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: propertiesWithVideos.length,
              itemBuilder: (context, index) {
                return ReelTile(
                  property: propertiesWithVideos[index],
                );
              },
            )
          : _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.video_library_outlined,
              size: 80,
              color: Colors.white60,
            ),
            const SizedBox(height: 24),
            const Text(
              'No Property Reels Available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Property videos will appear here when available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate back to home page
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home),
              label: const Text('Browse Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReelsInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Reels',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              icon: Icons.swipe_vertical,
              title: 'Swipe Up/Down',
              description: 'Navigate between property videos',
            ),
            _buildInfoItem(
              icon: Icons.play_arrow,
              title: 'Tap to Play/Pause',
              description: 'Control video playback',
            ),
            _buildInfoItem(
              icon: Icons.favorite,
              title: 'Like Properties',
              description: 'Double tap to add to wishlist',
            ),
            _buildInfoItem(
              icon: Icons.info,
              title: 'Property Details',
              description: 'Tap info button for full details',
            ),
            _buildInfoItem(
              icon: Icons.share,
              title: 'Share',
              description: 'Share properties with friends',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                ),
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF4CAF50),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}