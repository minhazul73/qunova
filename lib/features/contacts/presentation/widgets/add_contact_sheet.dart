import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AddContactSheet extends StatefulWidget {
  final Function({
    required String name,
    required String phone,
    String? designation,
    String? company,
    String? relation,
  }) onSave;

  const AddContactSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _companyController = TextEditingController();

  String? _selectedRelation;
  bool _isSaving = false;

  final List<String> _relations = [
    'Family',
    'Friend',
    'Work',
    'Client',
    'VIP',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    // Call the save callback
    widget.onSave(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      designation: _designationController.text.trim().isEmpty
          ? null
          : _designationController.text.trim(),
      company: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      relation: _selectedRelation,
    );

    // Wait a moment for the BLoC to process
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: mediaQuery.viewInsets.bottom + 24.0,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  // Drag Handle Bar
                  Center(
                    child: Container(
                      width: 80.0,
                      height: 4.0,
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  // Title
                  Text(
                    'Add New Contact',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  // const SizedBox(height: 16.0),

                  // Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hint: 'Enter contact name',
                    isRequired: true,
                    icon: Icons.person_outline,
                  ),

                  // Phone Field
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    hint: '+880 1XXX XXXXXX',
                    isRequired: true,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                      if (digitsOnly.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),

                  // Designation Field
                  _buildTextField(
                    controller: _designationController,
                    label: 'Designation',
                    hint: 'e.g., Manager, Engineer',
                    icon: Icons.work_outline,
                  ),

                  // Company Field
                  _buildTextField(
                    controller: _companyController,
                    label: 'Company',
                    hint: 'e.g., PlnZe, Google',
                    icon: Icons.business_outlined,
                  ),

                  // Relation Dropdown
                  _buildDropdownField(),

                  const SizedBox(height: 4.0),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        textStyle: textTheme.labelLarge,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.onPrimary,
                                ),
                              ),
                            )
                          : const Text('Save Contact'),
                    ),
                  ),
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : _handleCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(
                          color: AppColors.divider,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        textStyle: textTheme.labelLarge,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: label,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        // Text Field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: textTheme.bodyLarge,
          validator: validator ??
              (value) {
                if (isRequired && (value == null || value.trim().isEmpty)) {
                  return '$label is required';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.textSecondary,
              size: 20.0,
            ),
            filled: true,
            fillColor: AppColors.chipUnselectedBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.divider,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.divider,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Relation',
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        // Dropdown
        DropdownButtonFormField<String>(
          initialValue: _selectedRelation,
          decoration: InputDecoration(
            hintText: 'Select relation',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.label_outline,
              color: AppColors.textSecondary,
              size: 20.0,
            ),
            filled: true,
            fillColor: AppColors.chipUnselectedBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.divider,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.divider,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
          ),
          items: _relations.map((relation) {
            return DropdownMenuItem<String>(
              value: relation,
              child: Text(relation),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedRelation = value;
            });
          },
        ),
      ],
    );
  }
}
