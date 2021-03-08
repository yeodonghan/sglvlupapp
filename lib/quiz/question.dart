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

  Question({
    this.qid,
    this.category,
    this.question,
    this.a,
    this.b,
    this.c,
    this.d,
    this.ans,
    this.level

  });


  String getQuestion() {
    return this.question;
  }

  factory Question.fromJson(Map<String, dynamic> parsedJson){
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

    );
  }
}