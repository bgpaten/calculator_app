import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApplication());
}

class CalculatorApplication extends StatefulWidget {
  const CalculatorApplication({super.key});

  @override
  State<CalculatorApplication> createState() => _CalculatorApplicationState();
}

class _CalculatorApplicationState extends State<CalculatorApplication> {
  var result = '0';
  var inputUser = '';

  final Color kAmber = Color.fromARGB(255, 255, 153, 0);
  final Color kWhite = const Color(0xFFFFFFFF);
  final Color kBlack = const Color(0xFF000000);
  final Color kLightGray = const Color(0xFFC7C5B8);
  final Color kDarkGray = const Color(0xFF333333);

  void buttonPressed(String text) {
    setState(() {
      inputUser = inputUser + text;
    });
  }

  Widget getRow(String text1, String text2, String text3, String text4) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getButton(text1),
        getButton(text2),
        getButton(text3),
        getButton(text4),
      ],
    );
  }

  Widget getButton(String text) {
    return RawMaterialButton(
      onPressed: () {
        if (text == 'AC') {
          setState(() {
            inputUser = '';
            result = '0';
          });
        } else if (text == 'DEL') {
          setState(() {
            if (inputUser.isNotEmpty) {
              inputUser = inputUser.substring(0, inputUser.length - 1);
            }
          });
        } else if (text == '=') {
          try {
            Parser parser = Parser();
            Expression expression = parser.parse(inputUser.replaceAll('%', '*0.01'));
            ContextModel contextModel = ContextModel();
            double eval = expression.evaluate(EvaluationType.REAL, contextModel);

            setState(() {
              result = eval.toString();
            });
          } catch (e) {
            setState(() {
              result = 'Error';
            });
          }
        } else {
          buttonPressed(text);
        }
      },
      elevation: 2.0,
      fillColor: getBackgroundColor(text),
      child: Text(
        text,
        style: TextStyle(
          color: getTextColor(text),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      shape: const CircleBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBlack,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          inputUser,
                          style: TextStyle(
                            color: kLightGray,
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          result,
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 65,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 5,),
                      getRow('AC', 'DEL', '%', '/'),
                      getRow('1', '2', '3', '*'),
                      getRow('4', '5', '6', '-'),
                      getRow('7', '8', '9', '+'),
                      getRow('00', '0', '.', '='),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isSpecialOperator(String text) {
    var list = ['AC', 'DEL', '%'];
    return list.contains(text);
  }

  bool isOperator(String text) {
    var list = ['/', '*', '-', '+', '='];
    return list.contains(text);
  }

  Color getBackgroundColor(String text) {
    if (isSpecialOperator(text)) {
      return kLightGray;
    } else if (isOperator(text)) {
      return kAmber;
    } else {
      return kDarkGray;
    }
  }

  Color getTextColor(String text) {
    if (isSpecialOperator(text)) {
      return Colors.black;
    } else if (isOperator(text)) {
      return kWhite;
    } else {
      return kWhite;
    }
  }
}
