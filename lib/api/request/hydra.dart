class Hydra {
  String? context;
  String? id;
  String? type;
  int? totalItems;
  List<dynamic> hydraMember;

  Hydra({
    this.context,
    this.id,
    this.type,
    this.totalItems,
    required this.hydraMember,
  });

  factory Hydra.fromJson(Map<String, dynamic> json) => Hydra(
    context: json["@context"],
    id: json["@id"],
    type: json["@type"],
    totalItems: json["hydra:totalItems"],
    hydraMember: json["hydra:member"],
  );

  Map<String, dynamic> toJson() => {
    "@context": context,
    "@id": id,
    "@type": type,
    "totalItems": totalItems,
    "hydraMember": hydraMember,
  };

}
