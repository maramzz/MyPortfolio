import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/portfolio_project.dart';
import '../models/portfolio_skill.dart';

class PortfolioStore extends ChangeNotifier {
  static const _storageKey = 'portfolio_data_v1';

  List<PortfolioProject> _projects = PortfolioProject.initialProjects;
  List<PortfolioSkill> _skills = PortfolioSkill.initialSkills;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _disposed = false;
  String? _loadError;

  List<PortfolioProject> get projects => List.unmodifiable(_projects);
  List<PortfolioSkill> get skills => List.unmodifiable(_skills);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isReady => !_isLoading && _loadError == null;
  String? get loadError => _loadError;

  Future<void> load() async {
    if (_isLoading && _loadError == null) return;
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      final savedData = preferences.getString(_storageKey);
      if (savedData == null) {
        await _persist(preferences, _projects, _skills);
      } else {
        final decoded = jsonDecode(savedData);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('Saved portfolio data is invalid.');
        }
        final rawProjects = decoded['projects'];
        final rawSkills = decoded['skills'];
        if (rawProjects is! List || rawSkills is! List) {
          throw const FormatException('Saved portfolio data is incomplete.');
        }
        _projects = rawProjects
            .map(
              (item) => PortfolioProject.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false);
        _skills = rawSkills
            .map(
              (item) => PortfolioSkill.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false);
      }
      _loadError = null;
    } catch (error) {
      _loadError = error.toString();
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> addProject(PortfolioProject project) async {
    await _save(projects: [..._projects, project], skills: _skills);
  }

  Future<void> updateProject(PortfolioProject project) async {
    final index = _projects.indexWhere((item) => item.id == project.id);
    if (index < 0) throw StateError('Project no longer exists.');
    final updated = [..._projects]..[index] = project;
    await _save(projects: updated, skills: _skills);
  }

  Future<void> deleteProject(String id) async {
    if (!_projects.any((item) => item.id == id)) {
      throw StateError('Project no longer exists.');
    }
    await _save(
      projects: _projects.where((item) => item.id != id).toList(),
      skills: _skills,
    );
  }

  Future<void> addSkill(PortfolioSkill skill) async {
    await _save(projects: _projects, skills: [..._skills, skill]);
  }

  Future<void> updateSkill(PortfolioSkill skill) async {
    final index = _skills.indexWhere((item) => item.id == skill.id);
    if (index < 0) throw StateError('Skill no longer exists.');
    final updated = [..._skills]..[index] = skill;
    await _save(projects: _projects, skills: updated);
  }

  Future<void> deleteSkill(String id) async {
    if (!_skills.any((item) => item.id == id)) {
      throw StateError('Skill no longer exists.');
    }
    await _save(
      projects: _projects,
      skills: _skills.where((item) => item.id != id).toList(),
    );
  }

  Future<void> _save({
    required List<PortfolioProject> projects,
    required List<PortfolioSkill> skills,
  }) async {
    if (_isLoading || _loadError != null) {
      throw StateError('Portfolio data is not ready to be changed.');
    }
    if (_isSaving) throw StateError('Another portfolio change is in progress.');

    _isSaving = true;
    notifyListeners();
    try {
      final preferences = await SharedPreferences.getInstance();
      await _persist(preferences, projects, skills);
      _projects = List.unmodifiable(projects);
      _skills = List.unmodifiable(skills);
    } finally {
      _isSaving = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _persist(
    SharedPreferences preferences,
    List<PortfolioProject> projects,
    List<PortfolioSkill> skills,
  ) async {
    final saved = await preferences.setString(
      _storageKey,
      jsonEncode({
        'projects': projects.map((project) => project.toJson()).toList(),
        'skills': skills.map((skill) => skill.toJson()).toList(),
      }),
    );
    if (!saved) throw StateError('Could not save portfolio data.');
  }
}

class PortfolioStoreScope extends InheritedNotifier<PortfolioStore> {
  const PortfolioStoreScope({
    super.key,
    required PortfolioStore store,
    required super.child,
  }) : super(notifier: store);

  static PortfolioStore of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<PortfolioStoreScope>();
    assert(scope != null, 'PortfolioStoreScope is missing above this context.');
    return scope!.notifier!;
  }
}
