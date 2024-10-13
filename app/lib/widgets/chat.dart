import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          _showChatPopup(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showChatPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chat',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary, // Color del ícono a tertiary
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: 20, // Ejemplo de mensajes simulados
                      itemBuilder: (context, index) {
                        bool isUserMessage =
                            index % 2 == 0; // Simula mensajes del usuario
                        return Align(
                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: isUserMessage
                                    ? const Radius.circular(20)
                                    : const Radius.circular(0),
                                bottomRight: isUserMessage
                                    ? const Radius.circular(0)
                                    : const Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              isUserMessage
                                  ? 'Yo: Mensaje $index'
                                  : 'Chatbot: Mensaje $index',
                              style: TextStyle(
                                color:
                                    isUserMessage ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Escribe un mensaje...',
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                          onPressed: () {
                            // Lógica de envío de mensajes
                          },
                          mini: true,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
