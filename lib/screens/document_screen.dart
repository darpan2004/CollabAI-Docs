import 'package:collab_ai_docs/colors.dart';
import 'package:collab_ai_docs/models/document_model.dart';
import 'package:collab_ai_docs/models/error_model.dart';
import 'package:collab_ai_docs/repository/auth_repository.dart';
import 'package:collab_ai_docs/repository/socket_repository.dart';
import 'package:collab_ai_docs/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
        token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(ref.read(userProvider)!.token, widget.id);
    
    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
   
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlueColor,
                ),
              ),
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/docs-logo.png',
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    onSubmitted: (value) => updateTitle(ref, value),
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kBlueColor)),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: kGreyColor, width: 0.1))),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              quill.QuillSimpleToolbar(
                controller: _controller,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: kWhiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                          controller: _controller,
                          config: const quill.QuillEditorConfig()),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
