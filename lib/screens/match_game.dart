import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vocabify/data/dictapi.dart';
import '../data/vault.dart';
import 'game.dart';


class MatchGameView extends StatefulWidget {
  const MatchGameView({Key? key, required this.vault, required this.vaultIndex}) : super(key: key);
  final Vault vault;
  final int vaultIndex;

  @override
  State<MatchGameView> createState() => _MatchGameViewState();
}

class _MatchGameViewState extends State<MatchGameView> {
  int currentScore = 0;
  int matchPlayed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Definition Match", textAlign: TextAlign.start, style: TextStyle(fontSize: 23),),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        centerTitle: true,
      ),
      body: GameContainer(),
    );
  }

  DictItem getRandomWord(List<DictItem> vaultItems){
    final random = Random();
    var i = random.nextInt(vaultItems.length);
    return vaultItems[i];
  }

  int getVaultItemCount() {
    return widget.vault.vaultitems.length +
            (widget.vault.vaultitems.length - 1 < 0
                ? 0
                : widget.vault.vaultitems.length - 1);
  }

  //generate a list of other words from the vault besides the answer to populate other options
  List<String> getFalseOptions(answer, vaultItems){
    List<String> options = [];
    String temp;
    if (getVaultItemCount() < 5) {
      while (options.length < getVaultItemCount() - 1){
        temp = getRandomWord(vaultItems).word;
        if (temp != answer && !options.contains(temp)) {
          options.add(temp);
        }
      }
    } else {
      while (options.length < 5){
        temp = getRandomWord(vaultItems).word;
        if (temp != answer && !options.contains(temp)) {
          options.add(temp);
        }
      }
    }
    return options;
  }

  Widget GameContainer() {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    DictItem mainWord = getRandomWord(widget.vault.vaultitems);
    List<String> wordOptions = getFalseOptions(mainWord.word, widget.vault.vaultitems);
    wordOptions.insert(Random().nextInt(wordOptions.length),mainWord.word);

    return Container(
      child: Column(
        children: [
          //current score; 1 game = 5 definitions?
          scoreTracker(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Select the answer that best fits the given definition",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    ),
                ),
              ),
            ],
            
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              //definition of main word is the question
              child: Text( 
                mainWord.definitions.elementAt(Random().nextInt(mainWord.definitions.length)),
                style: TextStyle(fontSize: 22,),
                textAlign: TextAlign.center,
                )
            ),
          ),
          Column(
            children: [
              Row(
                //word options
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  optionButton(style, wordOptions[1], (wordOptions[1]==mainWord.word)),
                  optionButton(style, wordOptions[2], (wordOptions[2]==mainWord.word)),
                  optionButton(style, wordOptions[3], (wordOptions[3]==mainWord.word)),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  optionButton(style, wordOptions[4], (wordOptions[4]==mainWord.word)),
                  optionButton(style, wordOptions[5], (wordOptions[5]==mainWord.word)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row scoreTracker() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,12,12,0),
              child: Row(
              children: [
                Text(
                  "Score:  "+currentScore.toString()+"/5", 
                  style: TextStyle(fontSize: 20),
                )
              ],
          ),
            )
          ]
        );
  }

  Widget optionButton(style, word, isAnswer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: style,
        onPressed: () {
          if (isAnswer) {
            setState(() {
              currentScore++;
              matchPlayed++;
            });
            print("Correct!");
          } else {
            setState(() {
              matchPlayed++;
            });
          }
        },
        child: Text(word),
      ),
    );
  }
}