extension MapIndexing<K, V> on Map<K, V> {
  /// Get the key-value pair at the specified index.
  MapEntry<K, V>? entryAt(int index) {
    if (index < 0 || index >= this.length) {
      return null; // Return null if the index is out of range
    }
    return this.entries.elementAt(index);
  }

  /// Get the key at the specified index.
  K? keyAt(int index) {
    final entry = entryAt(index);
    return entry?.key;
  }

  /// Get the value at the specified index.
  V? valueAt(int index) {
    final entry = entryAt(index);
    return entry?.value;
  }
}

extension StringExtension on String {
  String truncate(int length) {
    return (this.length > length) ? this.substring(0, length) : this;
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension ListExtensions<T> on List<T> {
  List<T> removeDuplicates() {
    return [
      ...{...this}.toList()
    ];
  }
}