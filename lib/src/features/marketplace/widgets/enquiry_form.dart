import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/marketplace_providers.dart';
import '../models/product.dart';

class EnquiryFormWidget extends ConsumerStatefulWidget {
  final Product product;
  final Seller seller;
  final Function() onSubmitSuccess;

  const EnquiryFormWidget({
    super.key,
    required this.product,
    required this.seller,
    required this.onSubmitSuccess,
  });

  @override
  ConsumerState<EnquiryFormWidget> createState() => _EnquiryFormWidgetState();
}

class _EnquiryFormWidgetState extends ConsumerState<EnquiryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with values from the provider
    final enquiryForm = ref.read(enquiryFormProvider);
    _nameController.text = enquiryForm.name;
    _contactController.text = enquiryForm.contact;
    _messageController.text = enquiryForm.message;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Update the form state when a field changes
  void _updateForm() {
    final formNotifier = ref.read(enquiryFormProvider.notifier);
    formNotifier.updateName(_nameController.text);
    formNotifier.updateContact(_contactController.text);
    formNotifier.updateMessage(_messageController.text);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final formNotifier = ref.read(enquiryFormProvider.notifier);
    formNotifier.setSubmitting(true);

    try {
      final enquiry = formNotifier.createEnquiry();
      
      await ref.read(
        addEnquiryProvider.call((productId: widget.product.id, enquiry: enquiry)).future,
      );

      if (mounted) {
        formNotifier.resetForm();
        widget.onSubmitSuccess();
        
        // Reset controllers
        _nameController.clear();
        _contactController.clear();
        _messageController.clear();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enquiry sent successfully')),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send enquiry')),
        );
      }
    } finally {
      if (mounted) {
        formNotifier.setSubmitting(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enquiryForm = ref.watch(enquiryFormProvider);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send Enquiry',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Name field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (_) => _updateForm(),
          ),
          const SizedBox(height: 16),
          
          // Contact field
          TextFormField(
            controller: _contactController,
            decoration: const InputDecoration(
              labelText: 'Contact Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              return null;
            },
            onChanged: (_) => _updateForm(),
          ),
          const SizedBox(height: 16),
          
          // Message field
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'Your Message',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.message),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a message';
              }
              return null;
            },
            onChanged: (_) => _updateForm(),
          ),
          const SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: enquiryForm.isValid && !enquiryForm.isSubmitting
                  ? _submitForm
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: enquiryForm.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Send Enquiry'),
            ),
          ),
        ],
      ),
    );
  }
}
