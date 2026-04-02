abstract class ListDiffOperation<T> {
  final int index;
  final T item;

  ListDiffOperation(this.index, this.item);
}

class InsertOperation<T> extends ListDiffOperation<T> {
  InsertOperation(super.index, super.item);
}

class RemoveOperation<T> extends ListDiffOperation<T> {
  RemoveOperation(super.index, super.item);
}

class ListDiffUtil {
  /// Calculates the operations needed to transform [oldList] into [newList].
  /// [idSelector] returns a unique ID for each item to identify equality.
  static List<ListDiffOperation<T>> calculateDiff<T>(
    List<T> oldList,
    List<T> newList,
    Object Function(T item) idSelector,
  ) {
    final operations = <ListDiffOperation<T>>[];
    final workingList = List<T>.from(oldList);

    // 1. Detect Pure Removals (Items that are completely gone)
    // Iterate backwards to avoid index shifting issues
    for (int i = workingList.length - 1; i >= 0; i--) {
      final item = workingList[i];
      if (!newList.any((newItem) => idSelector(newItem) == idSelector(item))) {
        operations.add(RemoveOperation(i, item));
        workingList.removeAt(i);
      }
    }

    // 2. Sync and Reorder
    // We iterate through the NEW list and make the working list match it.
    // Strategy: "Push Down". If workingList[i] doesn't match newList[i],
    // and newList[i] is NOT a pure insert, it means workingList[i] is out of place
    // (it belongs later). So we "Remove" workingList[i] (visually slide it out/away)
    // to let the correct item slide into place.

    int newIdx = 0;
    // Safety break to prevent infinite loops
    int iterations = 0;
    while (newIdx < newList.length) {
      iterations++;
      if (iterations > (oldList.length + newList.length) * 2) break;

      final newItem = newList[newIdx];
      final newId = idSelector(newItem);

      if (newIdx >= workingList.length) {
        // We exhausted working list, just Append
        operations.add(InsertOperation(newIdx, newItem));
        workingList.insert(newIdx, newItem);
        newIdx++;
        continue;
      }

      final workingItem = workingList[newIdx];
      final workingId = idSelector(workingItem);

      if (newId == workingId) {
        // Match!
        newIdx++;
        continue;
      }

      // Mismatch
      // Is the newItem a pure insertion?
      final isNewItemInWorking = workingList.any((w) => idSelector(w) == newId);

      if (!isNewItemInWorking) {
        // It's a pure insertion (e.g. came from nowhere)
        operations.add(InsertOperation(newIdx, newItem));
        workingList.insert(newIdx, newItem);
        newIdx++;
      } else {
        // The newItem exists somewhere else in Working List.
        // AND the current workingItem is Mismatch.

        // This implies workingItem is "In the Way".
        // It belongs somewhere else (later), or we should have matched it already.
        // Strategy: "Remove" it from here. It will be re-inserted effectively when we reach its valid position
        // later in the loop (or if it was just pushed down, it's still in workingList).

        // Wait, if we "Remove" it from workingList, we verify it is removed from UI.
        // Visual effect: The item at this position disappears/slides away.
        operations.add(RemoveOperation(newIdx, workingItem));
        workingList.removeAt(newIdx);

        // Do NOT increment newIdx. We want to check the next workingItem against the SAME newItem.
      }
    }

    // 3. Cleanup trailing items (if any remain in workingList but aren't in newList)
    // (Should be handled by Step 1, but safe to verify)
    while (workingList.length > newList.length) {
      final idx = workingList.length - 1;
      operations.add(RemoveOperation(idx, workingList[idx]));
      workingList.removeAt(idx);
    }

    return operations;
  }
}
