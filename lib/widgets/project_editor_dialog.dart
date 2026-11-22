import 'package:flutter/material.dart';

import '../models/portfolio_project.dart';

class ProjectEditorDialog extends StatefulWidget {
  const ProjectEditorDialog({super.key, this.project});

  final PortfolioProject? project;

  @override
  State<ProjectEditorDialog> createState() => _ProjectEditorDialogState();
}

class _ProjectEditorDialogState extends State<ProjectEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _technologiesController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _statusController;
  late final TextEditingController _repositoryController;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _nameController = TextEditingController(text: project?.name);
    _technologiesController = TextEditingController(
      text: project?.technologies,
    );
    _descriptionController = TextEditingController(text: project?.description);
    _categoryController = TextEditingController(text: project?.category);
    _statusController = TextEditingController(text: project?.status);
    _repositoryController = TextEditingController(text: project?.repository);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _technologiesController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _statusController.dispose();
    _repositoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.project != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit project' : 'Add project'),
      scrollable: true,
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(_nameController, 'Project name'),
              _field(_technologiesController, 'Technologies'),
              _field(_descriptionController, 'Description', maxLines: 3),
              _field(_categoryController, 'Category'),
              _field(_statusController, 'Status (optional)', required: false),
              _field(
                _repositoryController,
                'GitHub repository URL (optional)',
                required: false,
                validator: _validateRepository,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isEditing ? 'Save changes' : 'Add project'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = true,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ??
            (value) => required && (value == null || value.trim().isEmpty)
                ? 'This field is required.'
                : null,
      ),
    );
  }

  String? _validateRepository(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        !uri.host.contains('.')) {
      return 'Enter a valid HTTPS URL.';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.project;
    Navigator.pop(
      context,
      PortfolioProject(
        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        technologies: _technologiesController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        status: _optionalValue(_statusController.text),
        repository: _optionalValue(_repositoryController.text),
      ),
    );
  }

  String? _optionalValue(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
