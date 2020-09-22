extension ListExtension<E> on List<E> {
  List<T> mapIndex<T>(T f(E e, int index)) {
    return List<T>.generate(length, (index) => f(this[index], index));
  }
}
