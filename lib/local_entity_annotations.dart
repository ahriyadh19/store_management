class Id {
  const Id();
}

class Entity {
  const Entity();
}

enum ConflictStrategy { replace }

class Unique {
  const Unique({this.onConflict});

  final ConflictStrategy? onConflict;
}