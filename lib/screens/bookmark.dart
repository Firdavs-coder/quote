import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quote/providers/api.dart';

import '../widgets/quote_list.dart';

// ignore: must_be_immutable
class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark>
    with SingleTickerProviderStateMixin {
  bool isLoaded = false;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarks")),
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
                    children: provider.markedQuotes().map((item) {
                      return QuoteList(
                        quoteModel: item,
                      );
                    }).toList(),
                  );
          }),
        ),
      ),
    );
  }
}
