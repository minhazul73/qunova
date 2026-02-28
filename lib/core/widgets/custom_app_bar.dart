import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> tabLabels;
  final Function(String query) onSearchChanged;
  final VoidCallback? onSearchCleared;
  final VoidCallback? onMenuTap;
  final String searchHint;
  final bool showMenuButton;

  const CustomAppBar({
    super.key,
    required this.tabController,
    required this.tabLabels,
    required this.onSearchChanged,
    this.onSearchCleared,
    this.onMenuTap,
    this.searchHint = 'Search...',
    this.showMenuButton = true,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _activateSearch() {
    setState(() => _isSearchActive = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() => _isSearchActive = false);
    widget.onSearchCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _buildDefaultTopBar(),
          _buildSearchOverlay(),
        ],
      ),
    );
  }

  Widget _buildDefaultTopBar() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: _isSearchActive ? 0.0 : 1.0,
      child: IgnorePointer(
        ignoring: _isSearchActive,
        child: Row(
          children: [
            Expanded(
              child: TabBar(
                controller: widget.tabController,
                indicatorColor: AppColors.onPrimary,
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.label,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: widget.tabLabels
                    .map((label) => Tab(text: label, height: 30))
                    .toList(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _activateSearch,
            ),
            if (widget.showMenuButton)
              IconButton(
                icon: SvgPicture.asset(AppConstants.menuIcon),
                onPressed: widget.onMenuTap ?? () {},
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: 0,
      top: 0,
      bottom: 0,
      left: _isSearchActive ? 0 : screenWidth,
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 36.0),
              child: TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: false,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _closeSearch,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
