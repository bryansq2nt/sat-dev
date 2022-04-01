import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/providers/api.dart';
import 'package:sat/src/utilities/screenSize.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/question_model.dart';


class ImageFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;

  const ImageFieldWidget({Key? key,required this.question,required this.properties}) : super(key: key);

  String? getImage()  {
    if(properties.answer != null){

      return ApiProvider().bucket + properties.answer;
    } else {
      return null;
    }
  }

  Future<String?> uploadFile(image) async {
    if(image != null){
      File file =  image[0] as File;
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file":
        await MultipartFile.fromFile(file.path, filename:fileName),
      });

      try {
        Response? response = await ApiProvider().makeRequest(type: MethodType.MULTIPART,endPoint: '/uploads',formData: formData,okCode: 201 );
        if(response != null && response.statusCode == 201){
          return response.data['path'];
        }
        return null;
      } catch (e){
        log(e.toString());
        return null;
      }
    } else {
      return null;
    }

  }

  @override
  Widget build(BuildContext context) {
    return  FormBuilderImagePicker(
      enabled: properties.enabled,
      initialValue: properties.answer != null && properties.answer is String ? [ApiProvider().bucket + properties.answer] : properties.answer != null && properties.answer is List<dynamic> ? properties.answer : null,
      name:question.questionId,
      onChanged: (val) => properties.answer = val,
      onSaved: (val) => properties.answer = val,
      maxImages: 1,
      validator: properties.required ? FormBuilderValidators.required(context,errorText:
      'Requerido',) : null,

      decoration: InputDecoration(
        hintText: properties.hint,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffcfe2ff)),
            borderRadius: BorderRadius.circular(15.0)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffcfe2ff)),
            borderRadius: BorderRadius.circular(15.0)
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffcfe2ff)),
            borderRadius: BorderRadius.circular(15.0)
        ),

      ),
    );
  }
}

