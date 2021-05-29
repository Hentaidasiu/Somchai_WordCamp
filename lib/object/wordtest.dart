import 'dart:math';

class WordTest {
  //Value
  List<Map<String, dynamic>> wordList = [];
  List<String> questionList = [];
  List<List<String>> answerList = [];
  List<int> trueanswerList = [];
  int questionTotal;

  //Constructer
  WordTest(this.wordList, this.questionTotal, bool isRandom) {
    //Value
    List<Map<String, dynamic>> wordListStorage = List<Map<String, dynamic>>.from(wordList);
    List<String> answerPool = [];
    bool isCutWord = true;

    Random random = new Random();

    if(wordList.length < questionTotal) {
      isRandom = true;
    }

    for (var i = 0; i < wordListStorage.length; i++) {
      answerPool.add(wordListStorage[i]['word_meaning']);
    }
    // print(answerPool.toString());

    //Random Question
    for (var i = 0; i < questionTotal; i++) {
      // print('#: ' + i.toString());

      //Question
      int qIndex = 0;
      if (isRandom) {
        qIndex = random.nextInt(wordListStorage.length);
      }
      String qWord = wordListStorage[qIndex]['word_word'];
      if(isCutWord) {
        wordListStorage.removeAt(qIndex);
      }
      questionList.add(qWord);
      // print('Q: ' + qWord);

      //Answer
      var aIndex = findAnswerIndex(qWord);
      var except = random.nextInt(4);
      List<int> aSet =
          randomAnswerRequireOne(answerPool.length, aIndex, except);

      List<String> answerSet = [
        answerPool[aSet[0]],
        answerPool[aSet[1]],
        answerPool[aSet[2]],
        answerPool[aSet[3]]
      ];

      answerList.add(answerSet);
      // print('A: ' + answerSet.toString());

      trueanswerList.add(except);
      // print('T: ' + except.toString());
      // print('Left: ' + wordListStorage.toString());

      if(wordListStorage.length == 0) {
        isCutWord = false;
        wordListStorage = List<Map<String, dynamic>>.from(wordList);
      }
    }
  }

  //Function
  List<Map<String, dynamic>> getwordList() {
    return wordList;
  }

  List<String> getQuestion() {
    return questionList;
  }

  List<List<String>> getAnswer() {
    return answerList;
  }

  List<int> getTrueAnswer() {
    return trueanswerList;
  }

  int getQuestionTotal(int i) {
    return questionTotal;
  }

  String getObjectText() {
    return wordList.toString() + " : " + questionList.toString() + " : " + answerList.toString() + " : " + trueanswerList.toString() + " : " + questionTotal.toString();
  }

  int findAnswerIndex(String value) {
    for (int i = 0; i <= wordList.length; i++) {
      if (wordList[i]['word_word'] == value) {
        return i;
      }
    }
    return 9999;
  }

  List<int> randomAnswerRequireOne(int pull, int answer, int except) {
    Random random = new Random();
    int a1, a2, a3, a4;

    while (true) {
      a1 = (except == 0) ? answer : random.nextInt(pull);
      a2 = (except == 1) ? answer : random.nextInt(pull);
      a3 = (except == 2) ? answer : random.nextInt(pull);
      a4 = (except == 3) ? answer : random.nextInt(pull);

      if (isGoodAnswerSet(a1, a2, a3, a4)) {
        return [a1, a2, a3, a4];
      }
    }
  }

  bool isGoodAnswerSet(int a, int b, int c, int d) {
    if (a != b && c != d && a != c && b != d && a != d && b != c) {
      return true;
    } else {
      return false;
    }
  }
}
