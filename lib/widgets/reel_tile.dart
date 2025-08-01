import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/property_model.dart';
import '../pages/property_detail_page.dart';

class ReelTile extends StatefulWidget {
  final Property property;

  const ReelTile({
    super.key,
    required this.property,
  });

  @override
  State<ReelTile> createState() => _ReelTileState();
}

class _ReelTileState extends State<ReelTile> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.property.videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.property.videoUrl!),
      );
      _controller!.initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.setLooping(true);
        _controller!.play();
        setState(() {
          _isPlaying = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller != null && _isInitialized) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void _hideControls() {
    setState(() {
      _showControls = false;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video or Image
          if (_isInitialized && _controller != null)
            GestureDetector(
              onTap: () {
                _togglePlay();
                _hideControls();
              },
              child: VideoPlayer(_controller!),
            )
          else
            CachedNetworkImage(
              imageUrl: widget.property.images.first,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.error, color: Colors.white),
              ),
            ),

          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Play/Pause overlay
          if (_showControls && _isInitialized)
            Center(
              child: GestureDetector(
                onTap: _togglePlay,
                child: AnimatedOpacity(
                  opacity: _isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),

          // Property details
          Positioned(
            left: 16,
            right: 80,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.property.address,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatPrice(widget.property.price, widget.property.type),
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPropertyDetail(Icons.bed, '${widget.property.bedrooms}'),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(Icons.bathtub, '${widget.property.bathrooms}'),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(Icons.square_foot, '${widget.property.area.toInt()}'),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Positioned(
            right: 16,
            bottom: 80,
            child: Column(
              children: [
                _buildActionButton(
                  Icons.favorite_border,
                  '${widget.property.views ?? 0}',
                  () {
                    // Handle like
                  },
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  Icons.comment_outlined,
                  '12',
                  () {
                    // Handle comment
                  },
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  Icons.share,
                  'Share',
                  () {
                    // Handle share
                  },
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  Icons.info_outline,
                  'Info',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailPage(property: widget.property),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Video progress indicator
          if (_isInitialized && _controller != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Color(0xFF4CAF50),
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price, String type) {
    final formatter = NumberFormat('#,##,000');
    final formattedPrice = formatter.format(price);
    
    if (type.toLowerCase() == 'rent' || type.toLowerCase() == 'pg') {
      return '₹$formattedPrice/mo';
    } else {
      return '₹$formattedPrice';
    }
  }
}