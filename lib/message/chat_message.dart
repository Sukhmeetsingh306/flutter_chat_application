import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: false,
          )
          .snapshots(),// order of the chat display
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Message'),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something Went Wrong'),
          );
        }

        final loadedMessage = chatSnapshot.data!.docs;
        return ListView.builder(
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            return Text(
              loadedMessage[index].data()['text'],
            );
          },
        );
      },
    );
  }
}
