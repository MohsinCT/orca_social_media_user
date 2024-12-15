class PostModel {
  final String id;
  final String image;
  final String video;
  final String caption;
  final String date;
 
 PostModel({
  required this.id,
  required this.image,
  required this.video,
  required this.caption,
  required this.date
 });

 Map<String ,dynamic> toMap(){
  return{
    'id':id,
    'image':image,
    'video':video,
    'caption':caption,
    'date':date

  };
 }

 factory PostModel.fromMap(Map<String, dynamic> map){
  return PostModel(
    id: map['id'], 
    image: map['image'], 
    video: map['video'], 
    caption: map['caption'], 
    date: map['date']);
 }

  
}
