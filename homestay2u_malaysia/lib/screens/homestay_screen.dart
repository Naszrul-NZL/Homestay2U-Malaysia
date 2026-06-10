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

  final List<String> _states = [
  'All',
  'Johor', 'Kedah', 'Kelantan', 'Melaka', 'Negeri Sembilan',
  'Pahang', 'Perak', 'Perlis', 'Pulau Pinang', 'Sabah',
  'Sarawak', 'Selangor', 'Terengganu', 'WP Kuala Lumpur',
  'WP Labuan', 'WP Putrajaya'
];

  String _selectedState = 'All';

  @override
  void initState() {
    super.initState();
    _loadHomestays();
  }

  Future<void> _filterByState(String state) async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';
    _selectedState = state;
  });

  try {
    final data = state == 'All'
        ? await ApiPath.getHomestays()
        : await ApiPath.getHomestaysByState(state);
    setState(() {
      _homestays = data;
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Failed to load homestays.';
      _isLoading = false;
    });
  }
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFFFD700)),
                onPressed: _loadHomestays,
              ),
            ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth > 600
                ? constraints.maxWidth * 0.5
                : constraints.maxWidth;
            return SizedBox(
              width: width,
              child: Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: DropdownButtonFormField<String>(
              value: _selectedState,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _states.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(
                    state,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _filterByState(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) => _searchHomestays(value),
              onChanged: (value) {
                if (value.isEmpty) {
                  _loadHomestays();
                }
              },
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
          ),
        ],
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

    return RefreshIndicator(
      color: const Color(0XFF2D0B55),
      onRefresh: _loadHomestays, 
      child: ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _homestays.length,
      itemBuilder: (context, index) {
        return _buildCard(_homestays[index]);
      },
      ),
    );
  }

  Widget _buildCard(Homestay homestay) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFFFD700),
        width: 2,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          child: Image.network(
            homestay.imageUrl,
            width: 130,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 130,
              height: 160,
              color: Colors.grey[200],
              child: const Icon(Icons.home, color: Colors.grey, size: 40),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homestay.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2D0B55),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${homestay.state}, ${homestay.district}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  'Price: RM ${homestay.priceMin} / night',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  homestay.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  }
}