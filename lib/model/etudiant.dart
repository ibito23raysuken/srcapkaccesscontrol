class Etudiant {
  late  int id;
  late  String nom;
  late  String ref_qrcode;

  Etudiant({
    required this.id,
    required this.nom,
    required this.ref_qrcode,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'] as int,
      nom: json['nom'] as String,
      ref_qrcode: json['ref_qrcode'] as String,
    );
  }
  void fromMap(Map<String, dynamic>  map ){
    if(map['id']!=null){
      this.id=map['id'];
    }
    this.nom=map["nom"];
    this.ref_qrcode=map["ref_qrcode"];
  }

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map["id"]=id ;
    map["nom"]=nom ;
    map["ref_qrcode"]=ref_qrcode ;
    return map;
  }
  Map toJson() => {
    'id': id,
    'nom': nom,
    'ref_qrcode': ref_qrcode,
  };
}