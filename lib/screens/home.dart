import 'dart:async';

import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quote/providers/api.dart';
import 'package:quote/screens/bookmark.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../widgets/quote_list.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoaded = true;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    Timer(const Duration(milliseconds: 1800), () {
      setState(() {
        isLoaded = false;
      });
      context.read<APIProvider>().obtainData();
    });
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote App"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BookMark())),
            icon: const Icon(Icons.bookmark_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoaded = true;
          });
          await Provider.of<APIProvider>(context, listen: false)
              .getQuote()
              .then((value) {
            setState(() {
              isLoaded = false;
            });
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Consumer<APIProvider>(builder: (context, provider, child) {
            return isLoaded
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : AnimationList(
                    children: provider.quotes.map((item) {
                      return QuoteList(quoteModel: item);
                    }).toList(),
                  );
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: SlideAction(
          reversed: true,
          borderRadius: 8,
          sliderButtonIconSize: 20,
          sliderButtonIconPadding: 8,
          height: 55,
          text: "Slide to get new quote",
          textStyle: const TextStyle(fontSize: 18),
          innerColor: Colors.deepPurple,
          outerColor: Colors.deepPurple[200],
          onSubmit: () async {
            setState(() {
              isLoaded = true;
            });
            await Provider.of<APIProvider>(context, listen: false)
                .getQuote()
                .then((value) {
              setState(() {
                isLoaded = false;
              });
            });
          },
        ),
      ),
    );
  }
}
