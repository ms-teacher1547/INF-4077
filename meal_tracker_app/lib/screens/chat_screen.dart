import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = []; // Stockage des messages
  final TextEditingController _messageController = TextEditingController();

  // Fonction pour envoyer un fichier
  Future<void> _sendFile() async {
    try {
      // Ouvrir le sélecteur de fichiers
      final result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Ajouter un message avec le nom du fichier sélectionné
        final fileName = result.files.single.name;
        setState(() {
          _messages.add({'text': 'File sent: $fileName', 'isUser': true});
          _messages.add({'text': 'Bot: Fichier "$fileName" reçu avec succès.', 'isUser': false});
        });
      }
    } catch (e) {
      // Gérer les erreurs
      setState(() {
        _messages.add({'text': 'Bot: Une erreur s\'est produite lors de l\'envoi du fichier.', 'isUser': false});
      });
    }
  }

// Fonction pour simuler une réponse
// Fonction pour simuler une réponse améliorée
  String _simulateBotResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('bonjour')) {
      return 'Bot: Bonjour ! Comment puis-je vous aider aujourd\'hui ?';
    } else if (lowerMessage.contains('aide')) {
      return 'Bot: Bien sûr, je suis là pour vous aider. Posez votre question ou dites-moi ce que vous cherchez.';
    } else if (lowerMessage.contains('fichier')) {
      return 'Bot: Vous pouvez m\'envoyer des fichiers. Appuyez sur l\'icône de pièce jointe pour commencer.';
    } else if (lowerMessage.contains('merci')) {
      return 'Bot: Avec plaisir ! N\'hésitez pas si vous avez d\'autres questions.';
    } else if (lowerMessage.contains('comment ça va')) {
      return 'Bot: Je suis un programme informatique, mais merci de demander ! Et vous, comment allez-vous ?';
    } else if (lowerMessage.contains('repas')) {
      return 'Bot: Vous pouvez consulter des recommandations de repas ou ajouter un repas dans l\'application.';
    } else if (lowerMessage.contains('réservation')) {
      return 'Bot: Vous pouvez réserver une table dans un restaurant ou un rendez-vous avec un diététicien via les fonctionnalités dédiées.';
    } else if (lowerMessage.contains('bmi')) {
      return 'Bot: Votre BMI (Indice de Masse Corporelle) est un excellent indicateur de votre santé. Vous pouvez le calculer dans la section Profil.';
    } else if (lowerMessage.contains('calories')) {
      return 'Bot: Pour surveiller vos calories, ajoutez vos repas et vérifiez les statistiques dans l\'application.';
    } else if (lowerMessage.contains('openai')) {
      return 'Bot: OpenAI est une API avancée que cette application pourrait utiliser pour des réponses plus précises.';
    } else if (lowerMessage.contains('adieu') || lowerMessage.contains('au revoir')) {
      return 'Bot: Au revoir ! Passez une excellente journée.';
    } else if (lowerMessage.contains('erreur')) {
      return 'Bot: Si vous rencontrez une erreur, essayez de redémarrer l\'application ou de vérifier votre connexion.';
    } else if (lowerMessage.contains('fonctionnalité')) {
      return 'Bot: L\'application offre de nombreuses fonctionnalités, comme le suivi des repas, le calcul de l\'IMC, et les réservations.';
    } else if (lowerMessage.contains('hello')) {
      return 'Bot: Hello! How can I assist you today?';
    } else {
      return 'Bot: Désolé, je ne comprends pas encore cette requête. Essayez d\'utiliser des mots-clés ou reformulez votre question.';
    }
  }


// Utiliser cette fonction dans `_sendMessage`
  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'text': message, 'isUser': true});
      _messages.add({'text': _simulateBotResponse(message), 'isUser': false});
    });

    _messageController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat-Bot avec Fichiers')),
      body: Column(
        children: [
          // Liste des messages
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'];
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                      child: ListTile(
                        leading: isUser
                            ? null
                            : const CircleAvatar(
                          child: Icon(Icons.bolt),
                          backgroundColor: Colors.grey,
                        ),
                        trailing: isUser
                            ? const CircleAvatar(
                          child: Icon(Icons.person),
                          backgroundColor: Colors.blue,
                        )
                            : null,
                        title: Text(
                          message['text'],
                          style: TextStyle(color: isUser ? Colors.white : Colors.black),
                        ),
                      ),

                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Zone de saisie et boutons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.blue),
                  onPressed: _sendFile, // Bouton pour envoyer un fichier
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
