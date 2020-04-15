class Todo {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Todo(
    this._title,
    this._priority,
    this._date,
    [this._description]
  );

  Todo.withId(
    this._id,
    this._title,
    this._priority,
    this._date,
    [this._description]
  );

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title (String newTitle) {
    if (newTitle.length <= 150) {
      _title = newTitle;
    }
  }

  set description (String newDescription) {
    if (newDescription.length <= 300) {
      _description = newDescription;
    }
  }

  set date (String newDate) {
    _date = newDate;
  }

  set priority (int newPriority) {
    if (newPriority > 0 && newPriority <= 3) {
      _priority = newPriority;
    }
  }

  Map <String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  Todo.fromObject(dynamic object) {
    this._id = object['id'];
    this._title = object['title'];
    this._description = object['description'];
    this._date = object['date'];
    this._priority = object['priority'];
  }
}
