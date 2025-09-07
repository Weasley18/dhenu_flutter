import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/cow.dart';
import '../providers/cow_providers.dart';

class EditCowScreen extends ConsumerStatefulWidget {
  final String cowId;

  const EditCowScreen({
    super.key,
    required this.cowId,
  });

  @override
  ConsumerState<EditCowScreen> createState() => _EditCowScreenState();
}

class _EditCowScreenState extends ConsumerState<EditCowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _tagNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _milkProductionController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _tagNumberController.dispose();
    _notesController.dispose();
    _milkProductionController.dispose();
    super.dispose();
  }

  void _selectBirthDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 25); // Cows can live up to 20-25 years

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null && pickedDate != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _initializeFormFields(Cow cow) {
    if (_isInitialized) return;
    _nameController.text = cow.name;
    _breedController.text = cow.breed;
    _tagNumberController.text = cow.tagNumber ?? '';
    _notesController.text = cow.notes ?? '';
    _milkProductionController.text = cow.milkProduction?.toString() ?? '0';
    _selectedBirthDate = cow.birthDate;
    
    _isInitialized = true;
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        final cowRepository = ref.read(cowRepositoryProvider);

        // Create update map with only the changed fields
        final Map<String, dynamic> updateData = {
          'name': _nameController.text.trim(),
          'breed': _breedController.text.trim(),
          'birthDate': _selectedBirthDate!,
          'tagNumber': _tagNumberController.text.trim().isNotEmpty
              ? _tagNumberController.text.trim()
              : null,
          'notes': _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
          'milkProduction': double.tryParse(_milkProductionController.text) ?? 0,
          'updatedAt': DateTime.now(),
        };

        await cowRepository.updateCow(widget.cowId, updateData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cow updated successfully')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update cow: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cowAsyncValue = ref.watch(cowProvider(widget.cowId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cow'),
      ),
      body: cowAsyncValue.when(
        data: (cow) {
          if (cow == null) {
            return const Center(child: Text('Cow not found'));
          }
          
          _initializeFormFields(cow);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Cow Name',
                      hintText: 'Enter the cow\'s name',
                      prefixIcon: Icon(Icons.pets),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  
                  // Breed Field
                  TextFormField(
                    controller: _breedController,
                    decoration: const InputDecoration(
                      labelText: 'Breed',
                      hintText: 'Enter the cow\'s breed',
                      prefixIcon: Icon(Icons.category),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the breed';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  
                  // Birth Date Field
                  InkWell(
                    onTap: _selectBirthDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                        hintText: 'Select birth date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        errorText: _selectedBirthDate == null 
                            ? 'Please select a birth date' 
                            : null,
                      ),
                      child: Text(
                        _selectedBirthDate != null
                            ? _formatDate(_selectedBirthDate!)
                            : 'Select birth date',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tag Number Field (Optional)
                  TextFormField(
                    controller: _tagNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Tag Number (Optional)',
                      hintText: 'Enter the tag number if any',
                      prefixIcon: Icon(Icons.tag),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Milk Production Field (Optional)
                  TextFormField(
                    controller: _milkProductionController,
                    decoration: const InputDecoration(
                      labelText: 'Milk Production (liters/day, Optional)',
                      hintText: 'Enter average milk production',
                      prefixIcon: Icon(Icons.water_drop),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  
                  // Notes Field (Optional)
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Enter any additional notes',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _showDeleteConfirmation(cow),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Delete Cow',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading cow: $error'),
        ),
      ),
    );
  }
  
  void _showDeleteConfirmation(Cow cow) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cow'),
        content: Text('Are you sure you want to delete ${cow.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              try {
                setState(() {
                  _isLoading = true;
                });
                
                final cowRepository = ref.read(cowRepositoryProvider);
                await cowRepository.deleteCow(widget.cowId);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cow deleted successfully')),
                  );
                  context.pop(); // Return to previous screen
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete cow: $e')),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}