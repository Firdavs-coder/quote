import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quote/providers/api.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/model.dart';

class QuoteList extends StatelessWidget {
  QuoteList({super.key, required this.quoteModel});
  final QuoteModel quoteModel;
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg${random.nextInt(10) + 1}.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(.7), BlendMode.color),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "${quoteModel.category} | Author: ${quoteModel.author}",
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic),
                  overflow: TextOverflow.fade,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await Share.share(
                          "${quoteModel.quote}\n\n${quoteModel.category} | Author: ${quoteModel.author}");
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Provider.of<APIProvider>(context, listen: false)
                            .markTheQuote(quoteModel.id),
                    icon: Icon(
                      quoteModel.isBooked
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                quoteModel.quote,
                style: const TextStyle(
                  fontFamily: "Lobster",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
