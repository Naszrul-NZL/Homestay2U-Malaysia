import 'package:flutter/material.dart';
import 'package:homestay2u_malaysia/models/homestay.dart';
import 'package:homestay2u_malaysia/services/api_path.dart';

class HomestayListScreen extends StatefulWidget {
  const HomestayListScreen({super.key});

  @override
  State<HomestayListScreen> createState() => _HomestayListScreenState();
}

class _HomestayListScreenState extends State<HomestayListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Homestay> _homestays = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadHomestays();
  }

  Future<void> _loadHomestays() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await ApiPath.getHomestays();
      setState(() {
        _homestays = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load homestays. Please check your internet connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchHomestays(String keyword) async {
    if (keyword.isEmpty) {
      _loadHomestays();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await ApiPath.fetchSearchHomestays(keyword);
      setState(() {
        _homestays = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No homestay found.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0B55),
        title: const Text(
          'Homestay2U Malaysia',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) => _searchHomestays(value),
        decoration: InputDecoration(
          hintText: 'Search homestay...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2D0B55)),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2D0B55),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHomestays,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D0B55),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Color(0xFFFFD700)),
              ),
            ),
          ],
        ),
      );
    }

    if (_homestays.isEmpty) {
      return const Center(
        child: Text(
          'No homestay found.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _homestays.length,
      itemBuilder: (context, index) {
        return _buildCard(_homestays[index]);
      },
    );
  }

  Widget _buildCard(Homestay homestay) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homestay.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF2D0B55),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${homestay.state}, ${homestay.district}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '💰 RM ${homestay.priceMin} / night',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      homestay.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}