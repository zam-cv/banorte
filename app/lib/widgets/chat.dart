import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Añadido para hacer solicitudes HTTP
import 'dart:convert'; // Para manejar JSON
import '../config.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({Key? key}) : super(key: key);

  @override
  ChatButtonState createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  final List<Map<String, String>> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // URL de la API
  final String apiUrl = "http://172.31.98.243:3000/api/chat/learn";

  // Variable para manejar el estado de carga
  bool isLoading = false;

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
                          itemCount: messages.length +
                              (isLoading
                                  ? 1
                                  : 0), // Añadimos 1 si está cargando
                          itemBuilder: (context, index) {
                            if (index == messages.length && isLoading) {
                              // Mostrar el indicador de progreso
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
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
                                      : Colors.grey[
                                          300], // Fondo gris para los mensajes del chatbot
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
                                  // Accede al token desde Config
                                  String? token = Config.token;

                                  if (token != null && token.isNotEmpty) {
                                    _sendMessage(textController.text, token,
                                        setModalState);
                                    textController.clear();
                                  } else {
                                    // Manejo en caso de que el token no esté disponible
                                    print(
                                        "Error: No se encontró un token válido.");
                                  }
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
  void _sendMessage(String message, String token, StateSetter setModalState) {
    print("Sending message: $message");
    setModalState(() {
      messages.add({"sender": "user", "message": message});
      isLoading = true; // Iniciamos la carga
    });
    _scrollToBottom();
    _callApiAndGetResponse(
        message, token, setModalState); // Llamada a la API con el token
  }

  // Función para llamar a la API y obtener la respuesta
  Future<void> _callApiAndGetResponse(
      String userMessage, String token, StateSetter setModalState) async {
    try {
      // Hacer una solicitud POST a la API con el token en el encabezado
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Añadimos el token al header
        },
        body: jsonEncode({'prompt': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botResponse =
            data['response'] ?? 'Lo siento, no entiendo tu mensaje.';
        print("Chatbot response: $botResponse");

        setModalState(() {
          messages.add({"sender": "bot", "message": botResponse});
          isLoading = false; // Detenemos la carga cuando recibimos la respuesta
        });
      } else {
        setModalState(() {
          messages.add({
            "sender": "bot",
            "message":
                "Hubo un error al procesar tu mensaje. Inténtalo de nuevo."
          });
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error al llamar a la API: $e");
      setModalState(() {
        messages.add({
          "sender": "bot",
          "message": "Ocurrió un error de red. Inténtalo más tarde."
        });
        isLoading = false;
      });
    }
    _scrollToBottom();
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
