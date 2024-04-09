class Matiere {
  late int id;
  late String jour;
  late String anneedetude;
  late int parcours_id;
  late String nomcours;
  Matiere({
    required this.id,
    required this.jour,
    required this.anneedetude,
    required this.nomcours,
    required this.parcours_id,
  });

  factory Matiere.fromJson(Map<String, dynamic> json) {
    print(json["cours"]);
    return Matiere(
      id: json['id'] as int,
      jour: json['jour'] as String,
      anneedetude: json['anneedetude'] as String,
      nomcours: json['cours']['nomcours'] as String,
      parcours_id: json['parcours_id'] as int,
    );
  }
  void fromMap(Map<String, dynamic>  map ){
    print(map);
    if(map['id']!=null){
      this.id=map['id'];
    }
    this.jour=map["jour"];
    this.anneedetude=map["anneedetude"];
    this.nomcours=map['cours']['nomcours'];
    this.parcours_id=map["parcours_id"];
  }
}
