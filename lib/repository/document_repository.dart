import 'dart:convert';
import 'dart:math';

import 'package:collab_ai_docs/constants.dart';
import 'package:collab_ai_docs/models/document_model.dart';
import 'package:collab_ai_docs/models/error_model.dart';
import 'package:http/http.dart';

class DocumentRepository{
  final Client _client;
  DocumentRepository({required Client client}):_client=client;
 
  Future<ErrorModel> createdDocument(String token)async{
    ErrorModel error=ErrorModel(error: 'Some unexpecter error occured', data: null);

    try{
     
        var res=await _client.post(Uri.parse('$host/doc/create'),headers:{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token
        },
        body: jsonEncode( {
          'createdAt':DateTime.now().millisecondsSinceEpoch,
          
        } ));
        switch (res.statusCode) {
          case 200:
            
            error=ErrorModel(error: null, data:DocumentModel.fromJson(res.body));
            break;
          default:
            error=ErrorModel(error: res.body, data: null);
            break;
      }
    }
    catch(e){
       error=ErrorModel(error: e.toString(), data: null);
    }
    return error; 
  }
  Future<ErrorModel> getDocuments(String token)async{
    ErrorModel error=ErrorModel(error: 'Some unexpecter error occured', data: null);

    try{
     
        var res=await _client.get(Uri.parse('$host/docs/me'),headers:{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token
        }
        );
        switch (res.statusCode) {
          case 200:
            List<DocumentModel> documents=[];
            for(int i=0;i<jsonDecode(res.body).length;i++){
              documents.add(DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
            
            error=ErrorModel(error: null, data:documents);
            break;
          default:
            error=ErrorModel(error: res.body, data: null);
            break;
      }
    }
    catch(e){
       error=ErrorModel(error: e.toString(), data: null);
    }
    return error; 
  }
  void updateTitle({required String token,required String id,required String title}) async{
  
  await _client.post(
        Uri.parse('$host/doc/title'),
        headers: {
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token
        },
        body: jsonEncode({
          'id':id,
          'title':title
        })
      );
    
  }
  Future<ErrorModel> getDocumentById(String token,String id)async{
    ErrorModel error=ErrorModel(error: 'Some unexpecter error occured', data: null);
    try{
      var res=await _client.get(Uri.parse('$host/doc/$id'),headers:{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token
        }
        );
        switch (res.statusCode) {
          case 200:
            DocumentModel document=DocumentModel.fromJson(res.body);
            error=ErrorModel(error: null, data:document);
            break;
          default:
            throw 'This Document odes not exist';
            break;
      }
    }
    catch(e){
  
       error=ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}