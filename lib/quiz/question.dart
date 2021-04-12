class Question{
  int qid;
  String category;
  String question;
  String a;
  String b;
  String c;
  String d;
  String ans;
  int level;
  double fontsize;
  int stats_a;
  int stats_b;
  int stats_c;
  int stats_d;

  Question({
    this.qid,
    this.category,
    this.question,
    this.a,
    this.b,
    this.c,
    this.d,
    this.ans,
    this.level,
    this.fontsize,
    this.stats_a,
    this.stats_b,
    this.stats_c,
    this.stats_d,
  }) ;


  String getQuestion() {
    return this.question;
  }

  factory Question.fromJson(Map<String, dynamic> parsedJson){
    var alength = parsedJson['option_a'].toString().length;
    var blength = parsedJson['option_b'].toString().length;
    var clength = parsedJson['option_c'].toString().length;
    var dlength = parsedJson['option_d'].toString().length;
    var maxlength= alength;
    var size = 20.0;
    if(blength > maxlength) {
      maxlength = blength;
    }
    if(clength > maxlength) {
      maxlength = clength;
    }
    if(dlength > maxlength) {
      maxlength = dlength;
    }

    if (maxlength > 34) {
      size = 14.0;
    }

    return Question(
        qid: parsedJson['q_id'],
        category : parsedJson['category'],
        question : parsedJson['question'],
        a : parsedJson['option_a'],
        b : parsedJson['option_b'],
        c : parsedJson['option_c'],
        d : parsedJson['option_d'],
        ans : parsedJson['answer'],
        level : parsedJson['difficulty'],
        fontsize : size,
        stats_a : parsedJson['stats_a'],
      stats_b : parsedJson['stats_b'],
      stats_c : parsedJson['stats_c'],
      stats_d : parsedJson['stats_d'],
    );
  }
}