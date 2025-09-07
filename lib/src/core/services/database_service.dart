import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timestamp.dart';

/// A simple class to mimic Firestore field value operations
class FieldValue {
  static const _serverTimestampMarker = '__serverTimestamp__';
  static const _incrementMarker = '__increment__';
  static const _arrayUnionMarker = '__arrayUnion__';
  static const _arrayRemoveMarker = '__arrayRemove__';
  
  final String _operation;
  final dynamic _value;
  
  const FieldValue._(this._operation, [this._value]);
  
  /// Creates a sentinel for use with serverTimestamp()
  static FieldValue serverTimestamp() => const FieldValue._(_serverTimestampMarker);
  
  /// Creates a sentinel for use with increment()
  static FieldValue increment(num value) => FieldValue._(_incrementMarker, value);
  
  /// Creates a sentinel for use with arrayUnion()
  static FieldValue arrayUnion(List<dynamic> elements) => 
      FieldValue._(_arrayUnionMarker, elements);
  
  /// Creates a sentinel for use with arrayRemove()
  static FieldValue arrayRemove(List<dynamic> elements) => 
      FieldValue._(_arrayRemoveMarker, elements);
      
  String get operation => _operation;
  dynamic get value => _value;
}

/// A class that mimics Firestore DocumentSnapshot
class DocumentSnapshot<T> {
  final String id;
  final bool exists;
  final Map<String, dynamic> _data;
  
  DocumentSnapshot({
    required this.id,
    required this.exists,
    required Map<String, dynamic> data,
  }) : _data = data;
  
  /// Returns the document data as a Map
  Map<String, dynamic> data() => _data;
  
  /// Returns a specific field from the document
  dynamic get(String field) => _data[field];
}

/// A class that mimics Firestore QuerySnapshot
class QuerySnapshot<T> {
  final List<DocumentSnapshot<T>> docs;
  
  QuerySnapshot({required this.docs});
  
  /// Returns a list of documents
  List<DocumentSnapshot<T>> get documents => docs;
  
  /// Returns true if the query result is empty
  bool get empty => docs.isEmpty;
  
  /// Returns the number of documents in the query result
  int get size => docs.length;
}

/// A class that mimics Firestore DocumentReference
class DocumentReference<T> {
  final String id;
  final String path;
  final DatabaseService _service;
  
  DocumentReference({
    required this.id,
    required this.path,
    required DatabaseService service,
  }) : _service = service;
  
  /// Gets a document snapshot from the database
  Future<DocumentSnapshot<T>> get() async {
    return _service.getDocument<T>(path);
  }
  
  /// Sets document data
  Future<void> set(Map<String, dynamic> data, {bool merge = false}) async {
    await _service.setDocument(path, data, merge: merge);
  }
  
  /// Updates document data
  Future<void> update(Map<String, dynamic> data) async {
    await _service.updateDocument(path, data);
  }
  
  /// Deletes the document
  Future<void> delete() async {
    await _service.deleteDocument(path);
  }
}

/// A class that mimics Firestore CollectionReference
class CollectionReference<T> {
  final String path;
  final DatabaseService _service;
  
  CollectionReference({
    required this.path,
    required DatabaseService service,
  }) : _service = service;
  
  /// Gets a document reference by ID
  DocumentReference<T> doc([String? documentPath]) {
    final docPath = documentPath ?? _generateId();
    return DocumentReference<T>(
      id: docPath,
      path: '$path/$docPath',
      service: _service,
    );
  }
  
  /// Adds a new document with auto-generated ID
  Future<DocumentReference<T>> add(Map<String, dynamic> data) async {
    final docRef = doc();
    await docRef.set(data);
    return docRef;
  }
  
  /// Gets all documents in the collection
  Future<QuerySnapshot<T>> get() async {
    return _service.getCollection<T>(path);
  }
  
  /// Generates a random document ID
  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final result = StringBuffer();
    
    for (var i = 0; i < 20; i++) {
      result.write(chars[random % chars.length]);
    }
    
    return result.toString();
  }
}

/// A mock database service that uses SharedPreferences to store data
/// This replaces the functionality of Firebase Firestore
class DatabaseService {
  static DatabaseService? _instance;
  static const String _keyPrefix = 'db_';
  static const String _collectionsKey = '${_keyPrefix}collections';
  
  late SharedPreferences _prefs;
  final Map<String, StreamController<DocumentSnapshot>> _documentStreamControllers = {};
  final Map<String, StreamController<QuerySnapshot>> _queryStreamControllers = {};
  
  /// Gets the singleton instance of DatabaseService
  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      final service = DatabaseService._();
      await service._init();
      _instance = service;
    }
    return _instance!;
  }
  
  DatabaseService._();
  
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize collections list if not exists
    if (!_prefs.containsKey(_collectionsKey)) {
      await _prefs.setStringList(_collectionsKey, []);
    }
  }
  
  /// Creates a reference to a Firestore collection
  CollectionReference<T> collection<T>(String collectionPath) {
    _registerCollection(collectionPath);
    return CollectionReference<T>(
      path: collectionPath,
      service: this,
    );
  }
  
  /// Registers a collection path in the collections list
  Future<void> _registerCollection(String collectionPath) async {
    final collections = _prefs.getStringList(_collectionsKey) ?? [];
    if (!collections.contains(collectionPath)) {
      collections.add(collectionPath);
      await _prefs.setStringList(_collectionsKey, collections);
    }
  }
  
  /// Gets all document IDs in a collection
  Future<List<String>> _getCollectionDocumentIds(String collectionPath) async {
    final collectionKey = '${_keyPrefix}$collectionPath/';
    final allKeys = _prefs.getKeys().where((key) => key.startsWith(collectionKey));
    
    final docIds = <String>[];
    for (final key in allKeys) {
      final parts = key.split('/');
      if (parts.length >= 2) {
        final docId = parts.last;
        if (!docIds.contains(docId)) {
          docIds.add(docId);
        }
      }
    }
    
    return docIds;
  }
  
  /// Gets a document from the database
  Future<DocumentSnapshot<T>> getDocument<T>(String documentPath) async {
    final key = '$_keyPrefix$documentPath';
    final json = _prefs.getString(key);
    
    if (json == null) {
      return DocumentSnapshot<T>(
        id: documentPath.split('/').last,
        exists: false,
        data: {},
      );
    }
    
    try {
      final data = Map<String, dynamic>.from(jsonDecode(json));
      
      // Process any Timestamp objects stored as maps
      _processTimestamps(data);
      
      return DocumentSnapshot<T>(
        id: documentPath.split('/').last,
        exists: true,
        data: data,
      );
    } catch (e) {
      debugPrint('Error parsing document data: $e');
      return DocumentSnapshot<T>(
        id: documentPath.split('/').last,
        exists: false,
        data: {},
      );
    }
  }
  
  /// Sets a document in the database
  Future<void> setDocument(String documentPath, Map<String, dynamic> data, {bool merge = false}) async {
    final key = '$_keyPrefix$documentPath';
    
    Map<String, dynamic> finalData = Map.from(data);
    
    // Handle merge if requested
    if (merge) {
      final existingJson = _prefs.getString(key);
      if (existingJson != null) {
        final existingData = Map<String, dynamic>.from(jsonDecode(existingJson));
        finalData = _mergeMaps(existingData, finalData);
      }
    }
    
    // Process any FieldValue objects
    finalData = _processFieldValues(finalData);
    
    // Store Timestamp objects as serializable maps
    _prepareDataForStorage(finalData);
    
    final json = jsonEncode(finalData);
    await _prefs.setString(key, json);
    
    // Notify any listeners
    _notifyDocumentChange(documentPath, finalData);
  }
  
  /// Updates a document in the database
  Future<void> updateDocument(String documentPath, Map<String, dynamic> data) async {
    final key = '$_keyPrefix$documentPath';
    final existingJson = _prefs.getString(key);
    
    if (existingJson == null) {
      throw Exception('Cannot update a document that does not exist');
    }
    
    final existingData = Map<String, dynamic>.from(jsonDecode(existingJson));
    final updatedData = _mergeMaps(existingData, _processFieldValues(data));
    
    // Store Timestamp objects as serializable maps
    _prepareDataForStorage(updatedData);
    
    final json = jsonEncode(updatedData);
    await _prefs.setString(key, json);
    
    // Notify any listeners
    _notifyDocumentChange(documentPath, updatedData);
  }
  
  /// Deletes a document from the database
  Future<void> deleteDocument(String documentPath) async {
    final key = '$_keyPrefix$documentPath';
    await _prefs.remove(key);
    
    // Notify any listeners
    _notifyDocumentChange(documentPath, null);
  }
  
  /// Gets all documents in a collection
  Future<QuerySnapshot<T>> getCollection<T>(String collectionPath) async {
    final docIds = await _getCollectionDocumentIds(collectionPath);
    
    final docs = <DocumentSnapshot<T>>[];
    for (final docId in docIds) {
      final docPath = '$collectionPath/$docId';
      final doc = await getDocument<T>(docPath);
      docs.add(doc);
    }
    
    return QuerySnapshot<T>(docs: docs);
  }
  
  /// Merges two maps recursively
  Map<String, dynamic> _mergeMaps(Map<String, dynamic> target, Map<String, dynamic> source) {
    final result = Map<String, dynamic>.from(target);
    
    for (final entry in source.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value == null) {
        result.remove(key);
      } else if (value is Map<String, dynamic> && result[key] is Map<String, dynamic>) {
        result[key] = _mergeMaps(result[key] as Map<String, dynamic>, value);
      } else {
        result[key] = value;
      }
    }
    
    return result;
  }
  
  /// Processes any FieldValue objects in the data
  Map<String, dynamic> _processFieldValues(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is FieldValue) {
        switch (value.operation) {
          case FieldValue._serverTimestampMarker:
            result[key] = Timestamp.now();
            break;
          case FieldValue._incrementMarker:
            if (data[key] is num) {
              result[key] = (data[key] as num) + value.value;
            } else {
              result[key] = value.value;
            }
            break;
          case FieldValue._arrayUnionMarker:
            if (data[key] is List) {
              final currentList = List.from(data[key] as List);
              for (final element in value.value as List) {
                if (!currentList.contains(element)) {
                  currentList.add(element);
                }
              }
              result[key] = currentList;
            } else {
              result[key] = value.value;
            }
            break;
          case FieldValue._arrayRemoveMarker:
            if (data[key] is List) {
              final currentList = List.from(data[key] as List);
              currentList.removeWhere((element) => (value.value as List).contains(element));
              result[key] = currentList;
            } else {
              result[key] = [];
            }
            break;
        }
      } else if (value is Map<String, dynamic>) {
        result[key] = _processFieldValues(value);
      } else {
        result[key] = value;
      }
    }
    
    return result;
  }
  
  /// Prepares data for storage by converting Timestamp objects to maps
  void _prepareDataForStorage(Map<String, dynamic> data) {
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is Timestamp) {
        data[key] = {
          '_type': 'timestamp',
          'seconds': value.seconds,
          'nanoseconds': value.nanoseconds,
        };
      } else if (value is Map<String, dynamic>) {
        _prepareDataForStorage(value);
      } else if (value is List) {
        _prepareListForStorage(value);
      }
    }
  }
  
  /// Prepares a list for storage by converting Timestamp objects to maps
  void _prepareListForStorage(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      final value = list[i];
      
      if (value is Timestamp) {
        list[i] = {
          '_type': 'timestamp',
          'seconds': value.seconds,
          'nanoseconds': value.nanoseconds,
        };
      } else if (value is Map<String, dynamic>) {
        _prepareDataForStorage(value);
      } else if (value is List) {
        _prepareListForStorage(value);
      }
    }
  }
  
  /// Processes any stored Timestamp maps and converts them back to Timestamp objects
  void _processTimestamps(Map<String, dynamic> data) {
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is Map<String, dynamic> &&
          value['_type'] == 'timestamp' &&
          value.containsKey('seconds') &&
          value.containsKey('nanoseconds')) {
        data[key] = Timestamp(
          value['seconds'] as int,
          value['nanoseconds'] as int,
        );
      } else if (value is Map<String, dynamic>) {
        _processTimestamps(value);
      } else if (value is List) {
        _processTimestampList(value);
      }
    }
  }
  
  /// Processes any stored Timestamp maps in lists and converts them back to Timestamp objects
  void _processTimestampList(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      final value = list[i];
      
      if (value is Map<String, dynamic> &&
          value['_type'] == 'timestamp' &&
          value.containsKey('seconds') &&
          value.containsKey('nanoseconds')) {
        list[i] = Timestamp(
          value['seconds'] as int,
          value['nanoseconds'] as int,
        );
      } else if (value is Map<String, dynamic>) {
        _processTimestamps(value);
      } else if (value is List) {
        _processTimestampList(value);
      }
    }
  }
  
  /// Notifies listeners about document changes
  void _notifyDocumentChange(String documentPath, Map<String, dynamic>? data) {
    final controller = _documentStreamControllers[documentPath];
    if (controller != null) {
      final docSnapshot = DocumentSnapshot<Map<String, dynamic>>(
        id: documentPath.split('/').last,
        exists: data != null,
        data: data ?? {},
      );
      controller.add(docSnapshot);
    }
    
    // Also notify collection listeners
    final collectionPath = documentPath.substring(0, documentPath.lastIndexOf('/'));
    _notifyCollectionChange(collectionPath);
  }
  
  /// Notifies listeners about collection changes
  void _notifyCollectionChange(String collectionPath) async {
    final controller = _queryStreamControllers[collectionPath];
    if (controller != null) {
      final querySnapshot = await getCollection<Map<String, dynamic>>(collectionPath);
      controller.add(querySnapshot);
    }
  }
}

/// Creates and returns a singleton instance of DatabaseService
/// This is used like: FirebaseFirestore.instance
class FirebaseFirestore {
  static final FirebaseFirestore _instance = FirebaseFirestore._();
  late DatabaseService _service;
  bool _initialized = false;
  
  FirebaseFirestore._();
  
  static FirebaseFirestore get instance => _instance;
  
  /// Initialize the database service
  Future<void> initialize() async {
    if (!_initialized) {
      _service = await DatabaseService.getInstance();
      _initialized = true;
    }
  }
  
  /// Creates a reference to a Firestore collection
  CollectionReference<T> collection<T>(String collectionPath) {
    assert(_initialized, 'DatabaseService must be initialized before use');
    return _service.collection<T>(collectionPath);
  }
}
