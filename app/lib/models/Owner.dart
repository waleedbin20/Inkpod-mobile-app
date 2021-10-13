class Owner {
  final String name;
  final String id;

  Owner({required this.name, required this.id});

  factory Owner.fromJson(data) {
    if (data is String) return Owner(name: 'Anonymous', id: data);
    return Owner(
        name: data != null ? data['name'] : 'Anonymous',
        id: data != null ? data['_id'] : "");
  }
}
