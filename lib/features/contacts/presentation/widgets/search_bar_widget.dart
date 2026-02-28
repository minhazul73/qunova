import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final bool autofocus;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    this.hintText = 'Search by name or phone',
    this.autofocus = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    if (widget.autofocus) {
      // Delay autofocus slightly for better UX
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
    _focusNode.unfocus();
    setState(() {}); // Rebuild to hide clear button
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 48.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.divider,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: textTheme.bodyLarge,
        onChanged: (value) {
          widget.onSearchChanged(value);
          setState(() {}); // Rebuild to show/hide clear button
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: AppColors.textHint,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 24.0,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                    size: 20.0,
                  ),
                  onPressed: _clearSearch,
                  splashRadius: 20.0,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
      ),
    );
  }
}
