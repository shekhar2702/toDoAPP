class Note{
  int _id;
  String _title;
  String _date;
  int _priority;
  String _description;
  Note(this._title,this._date,this._priority,[this._description]);
  Note.withID(this._id,this._title,this._date,this._priority,[this._description]);
  //getters
  int get id=>_id;
  String get title=>_title;
  int get priority=>_priority;
  String get date=>_date;
  String get description=>_description;
  //setters
  set title(String newTitle){
    if(newTitle.length<=255){
      this._title=newTitle;
    }
  }
  set description(String newDescription){
    if(newDescription.length<=255){
      this._description=newDescription;
    }
  }
  set date(String newDate){
    this._date=newDate;
  }
  set priority(int newPriority){
    if(newPriority>=1 && newPriority<=2){
      this._priority=newPriority;
    }
  }
  //used to save and retrieve from database

  //convert note to map object
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(id !=null){
      map['id']=_id;
    }
    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['date']=_date;
    return map;
  }
  Note.fromMapObject(Map<String,dynamic>map){
    this._id=map['id'];
    this._priority=map['priority'];
    this._title=map['title'];
    this.description=map['description'];
    this.date=map['date'];
  }
}