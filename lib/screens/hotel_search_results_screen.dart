import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hotel_search_app/models/hotel.dart';
import 'package:hotel_search_app/utils/animations.dart';

class HotelSearchResultsScreen extends StatelessWidget {
  final List<Hotel> hotels;

  const HotelSearchResultsScreen({Key? key, required this.hotels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
        leading: Semantics(
          label: 'Go back to search',
          identifier: 'back_btn',
          child: IconButton(
            key: const ValueKey('back_btn'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Semantics(
            label: 'Filter search results',
            identifier: 'filter_btn',
            child: IconButton(
              key: const ValueKey('filter_btn'),
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterBottomSheet(context),
            ),
          ),
        ],
      ),
      body: hotels.isEmpty
          ? _buildEmptyState(context)
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final hotel = hotels[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildHotelCard(hotel, context),
                        );
                      },
                      childCount: hotels.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hotel_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hotels found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel, BuildContext context) {
    return AppAnimations.slideUp(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Semantics(
          label: 'View details for ${hotel.name}',
          identifier: 'hotel_card_${hotel.id}',
          child: InkWell(
            key: ValueKey('hotel_card_${hotel.id}'),
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => _navigateToHotelDetails(hotel, context),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Hotel Image with Hero animation and shimmer loading
            Hero(
              tag: 'hotel-${hotel.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: CachedNetworkImage(
                  imageUrl: hotel.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.hotel_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            
            // Hotel Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: Text(
                                    hotel.city,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hotel.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12.0),
                  
                  // Price and amenities
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${hotel.price.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              'per night',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Quick actions
                      Row(
                        children: [
                          Semantics(
                            label: 'Add ${hotel.name} to favorites',
                            identifier: 'favorite_btn_${hotel.id}',
                            child: IconButton(
                              key: ValueKey('favorite_btn_${hotel.id}'),
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () => _toggleFavorite(hotel, context),
                              tooltip: 'Add to favorites',
                            ),
                          ),
                          Semantics(
                            label: 'Share ${hotel.name}',
                            identifier: 'share_btn_${hotel.id}',
                            child: IconButton(
                              key: ValueKey('share_btn_${hotel.id}'),
                              icon: const Icon(Icons.share_outlined),
                              onPressed: () => _shareHotel(hotel, context),
                              tooltip: 'Share',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    ));
  }

  void _navigateToHotelDetails(Hotel hotel, BuildContext context) {
    // Navigate to hotel details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${hotel.name} details'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleFavorite(Hotel hotel, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${hotel.name} to favorites'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareHotel(Hotel hotel, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${hotel.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Hotels',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Sort hotels by price',
                identifier: 'sort_by_price',
                child: ListTile(
                  key: const ValueKey('sort_by_price'),
                  leading: const Icon(Icons.sort),
                  title: const Text('Sort by Price'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Semantics(
                label: 'Sort hotels by rating',
                identifier: 'sort_by_rating',
                child: ListTile(
                  key: const ValueKey('sort_by_rating'),
                  leading: const Icon(Icons.star_outline),
                  title: const Text('Sort by Rating'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Semantics(
                label: 'Sort hotels by distance',
                identifier: 'sort_by_distance',
                child: ListTile(
                  key: const ValueKey('sort_by_distance'),
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('Sort by Distance'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
