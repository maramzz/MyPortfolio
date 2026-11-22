import 'package:flutter/material.dart';

import '../models/portfolio_skill.dart';

class SkillEditorDialog extends StatefulWidget {
  const SkillEditorDialog({super.key, this.skill});

  final PortfolioSkill? skill;

  @override
  State<SkillEditorDialog> createState() => _SkillEditorDialogState();
}

class _SkillEditorDialogState extends State<SkillEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _technologiesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill?.name);
    _technologiesController = TextEditingController(
      text: widget.skill?.technologies,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _technologiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.skill != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit skill' : 'Add skill'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(_nameController, 'Skill category'),
              _field(_technologiesController, 'Technologies'),
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
          child: Text(isEditing ? 'Save changes' : 'Add skill'),
        ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'This field is required.'
            : null,
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      PortfolioSkill(
        id:
            widget.skill?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        technologies: _technologiesController.text.trim(),
      ),
    );
  }
}
