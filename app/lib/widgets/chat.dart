import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({Key? key}) : super(key: key);

  @override
  ChatButtonState createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  final List<Map<String, String>> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                      // Encabezado del Chat
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ],
                        ),
                      ),

                      // Lista de mensajes
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            bool isUserMessage =
                                messages[index]['sender'] == 'user';
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
                                  messages[index]['message'] ?? '',
                                  style: TextStyle(
                                    color: isUserMessage
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Input para escribir el mensaje
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  hintText: 'Escribe un mensaje...',
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.tertiary,
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
                                if (textController.text.isNotEmpty) {
                                  _sendMessage(
                                      textController.text, setModalState);
                                  textController.clear();
                                }
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
      },
    );
  }

  // Función para enviar el mensaje y actualizar el modal
  void _sendMessage(String message, StateSetter setModalState) {
    print("Sending message: $message");
    setModalState(() {
      messages.add({"sender": "user", "message": message});
    });
    _scrollToBottom();
    _chatbotResponse(message, setModalState);
  }

  // Simulación de respuesta del chatbot y actualización en el modal
  void _chatbotResponse(String userMessage, StateSetter setModalState) {
    print("User message received: $userMessage");
    Future.delayed(const Duration(seconds: 1), () {
      String response = '';
      if (userMessage.toLowerCase() == 'hola') {
        response = 'Hola, ¿cómo te puedo ayudar hoy?';
      } else if (userMessage.toLowerCase().contains('presupuesto')) {
        response =
            'Para hacer un presupuesto mensual con un salario de 35,000 pesos, primero identifica tus gastos fijos como renta, servicios y alimentación. Luego, aparta un porcentaje para el ahorro, idealmente un 20%. El resto se puede distribuir en entretenimiento, transporte, y otros gastos variables. Es importante registrar todos los gastos y revisar el presupuesto cada mes.';
      } else {
        response = 'Lo siento, no entiendo tu mensaje. ¿Puedes repetirlo?';
      }

      setModalState(() {
        messages.add({"sender": "bot", "message": response});
        print("Chatbot response: $response");
      });
      _scrollToBottom();
    });
  }

  // Función para hacer scroll al último mensaje
  void _scrollToBottom() {
    print("Scrolling to bottom...");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        print("Scrolled to bottom");
      }
    });
  }
}
