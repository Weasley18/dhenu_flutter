import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/marketplace_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/providers/data_provider.dart';

/// Provider for the Marketplace repository
final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return MarketplaceRepository(mockDataService);
});

/// Provider for fetching all products
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return await repository.fetchProducts();
});

/// Provider for a single product by ID
final productProvider = FutureProvider.family<Product?, String>((ref, productId) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return await repository.fetchProductById(productId);
});

/// Provider for the currently selected product
final selectedProductProvider = StateProvider<Product?>((ref) => null);

/// Provider for fetching the seller of a product
final sellerProvider = FutureProvider.family<Seller?, String>((ref, userId) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return await repository.fetchSeller(userId);
});

/// Provider for the enquiry form state
final enquiryFormProvider = StateNotifierProvider<EnquiryFormNotifier, EnquiryForm>((ref) {
  return EnquiryFormNotifier();
});

/// Provider for adding an enquiry to a product
final addEnquiryProvider = FutureProvider.family<void, ({String productId, Enquiry enquiry})>((ref, params) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  await repository.addEnquiryToProduct(params.productId, params.enquiry);
  // Invalidate the product provider to refresh data
  ref.invalidate(productProvider(params.productId));
});

/// Class to hold the enquiry form state
class EnquiryForm {
  final String name;
  final String contact;
  final String message;
  final bool isSubmitting;

  EnquiryForm({
    this.name = '',
    this.contact = '',
    this.message = '',
    this.isSubmitting = false,
  });

  /// Check if the form is valid
  bool get isValid => name.isNotEmpty && contact.isNotEmpty && message.isNotEmpty;

  /// Create a copy of this EnquiryForm with the given field values updated
  EnquiryForm copyWith({
    String? name,
    String? contact,
    String? message,
    bool? isSubmitting,
  }) {
    return EnquiryForm(
      name: name ?? this.name,
      contact: contact ?? this.contact,
      message: message ?? this.message,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// Reset the form to its initial state
  EnquiryForm reset() {
    return EnquiryForm();
  }
}

/// Notifier for the enquiry form state
class EnquiryFormNotifier extends StateNotifier<EnquiryForm> {
  EnquiryFormNotifier() : super(EnquiryForm());

  /// Update the name field
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  /// Update the contact field
  void updateContact(String contact) {
    state = state.copyWith(contact: contact);
  }

  /// Update the message field
  void updateMessage(String message) {
    state = state.copyWith(message: message);
  }

  /// Set the submitting state
  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  /// Reset the form
  void resetForm() {
    state = state.reset();
  }

  /// Create an Enquiry from the form state
  Enquiry createEnquiry() {
    return Enquiry(
      name: state.name,
      contact: state.contact,
      message: state.message,
      createdAt: DateTime.now(),
    );
  }
}