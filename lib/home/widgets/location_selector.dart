import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  final String? initialPickup;
  final String? initialDrop;

  const LocationSelector({super.key, this.initialPickup, this.initialDrop});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _pickup;
  String? _drop;

  final List<String> _matiBarangays = [
    'Badas',
    'Babangsa',
    'Bunaan',
    'Cabuaya',
    'Central',
    'Culian',
    'Dahican',
    'Danaos',
    'Don Enrique Lopez',
    'Don Salvador Lopez',
    'Don Victoriano Chiongbian',
    'Langka',
    'Libudon',
    'Luban',
    'Lumbo',
    'Mamali',
    'Matiao',
    'Mayo',
    'Sainz',
    'Sanghay',
    'Tagabakid',
    'Taguibo',
    'Tamisan',
    'Tuatua',
  ];

  @override
  void initState() {
    super.initState();
    _pickup = widget.initialPickup;
    _drop = widget.initialDrop;
  }

  void _openLocationSearch(bool isPickup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationSearchSheet(
        title: isPickup ? 'Select Pickup Point' : 'Select Destination',
        barangays: _matiBarangays,
        onSelected: (selection) {
          setState(() {
            if (isPickup) {
              _pickup = selection;
            } else {
              _drop = selection;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan your trip',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildFloatingLocationButton(
                  label: 'Pick-up Point',
                  value: _pickup,
                  icon: Icons.circle,
                  iconColor: const Color(0xFF2196F3),
                  onTap: () => _openLocationSearch(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFloatingLocationButton(
                  label: 'Drop-off Point',
                  value: _drop,
                  icon: Icons.location_on,
                  iconColor: const Color(0xFFF44336),
                  onTap: () => _openLocationSearch(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingLocationButton({
    required String label,
    required String? value,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final bool hasValue = value != null && value.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: hasValue
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.never,
          prefixIcon: Icon(icon, color: iconColor, size: 16),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: const Color(0xFF2196F3).withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2196F3)),
          ),
        ),
        child: Text(
          hasValue ? value! : label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: hasValue ? FontWeight.w700 : FontWeight.w400,
            color: hasValue ? Colors.black : Colors.grey.shade500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _LocationSearchSheet extends StatefulWidget {
  final String title;
  final List<String> barangays;
  final Function(String) onSelected;

  const _LocationSearchSheet({
    required this.title,
    required this.barangays,
    required this.onSelected,
  });

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  late List<String> filteredList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList = widget.barangays;
  }

  void _filterSearch(String query) {
    setState(() {
      filteredList = widget.barangays
          .where((b) => b.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: 'Search barangay...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(
                    filteredList[index],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    widget.onSelected(filteredList[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
