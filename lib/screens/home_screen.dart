import 'package:collab_ai_docs/colors.dart';
import 'package:collab_ai_docs/common/widgets/loader.dart';
import 'package:collab_ai_docs/models/document_model.dart';
import 'package:collab_ai_docs/models/error_model.dart';
import 'package:collab_ai_docs/repository/auth_repository.dart';
import 'package:collab_ai_docs/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:routemaster/routemaster.dart';
final documentRepositoryProvider=Provider((ref)=>DocumentRepository(client: Client()));
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void signOut(WidgetRef ref){
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state)=>null);
  }
  void createDocument(BuildContext context, WidgetRef ref)async{
     String token=ref.read(userProvider)!.token;
     final navigator=Routemaster.of(context);
     final snackbar=ScaffoldMessenger.of(context);
     final errorModel=await ref.read(documentRepositoryProvider).createdDocument(token);
     if (errorModel.data!=null) {
       navigator.push('/document/${errorModel.data.id}');
     }else{
      snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
     }
  }
  void navigateDocument(BuildContext context,String documentId){
    Routemaster.of(context).push('/document/$documentId');
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=>createDocument(context,ref), icon: const Icon(Icons.add,color: kBlackColor,)),
                    IconButton(onPressed: ()=>signOut(ref), icon: const Icon(Icons.logout,color: kRedColor,)),

        ],
      ),
      body: FutureBuilder<ErrorModel?>(builder: (context,snapshot){
        if (snapshot.connectionState==ConnectionState.waiting) {
          return const Loader();
          
        }
        return Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 600,
            child: ListView.builder(itemBuilder: (context,index){
              DocumentModel document=snapshot.data!.data[index];    
              return InkWell(
                onTap: ()=>navigateDocument(context,document.id),
                child: SizedBox(
                  height: 50,
                  child: Card(
                    child: Center(child: Text(document.title,style: const TextStyle(fontSize: 17),),),
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.data.length,),
          ),
        );
      },
      future:ref.watch(documentRepositoryProvider).getDocuments(ref.watch(userProvider)!.token),
      )
    );
  }
}
