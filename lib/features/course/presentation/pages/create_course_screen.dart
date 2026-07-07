import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/widgets/course_image_picker.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
import 'package:project1/features/course/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/course/presentation/widgets/tags_selector.dart';
import 'package:project1/features/course/presentation/widgets/visibility_dropdown.dart';
import 'package:project1/l10n/app_localizations.dart';


class CreateCourseScreen extends StatefulWidget {
  final String demoId;

  const CreateCourseScreen({
    super.key,
    required this.demoId,
  });

  @override
  State<CreateCourseScreen> createState() =>
      _CreateCourseScreenState();
}


class _CreateCourseScreenState extends State<CreateCourseScreen> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();


  String visibility = 'public';

  File? selectedImage;


  Set<String> selectedTagIds = {};


  @override
  void initState() {
    super.initState();
  }


  void toggleTag(String tagId) {

    setState(() {

      if(selectedTagIds.contains(tagId)){
        selectedTagIds.remove(tagId);
      }else{
        selectedTagIds.add(tagId);
      }

    });

  }



  bool get isValid {

    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty;

  }



  void handleCreateCourse(){

    if(!isValid){

      final localizations =
          AppLocalizations.of(context)!;


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(localizations.fillAllFieldsWarning),
          backgroundColor: Colors.red.shade400,
        ),
      );


      return;
    }



    // TODO:
    // send:
    //
    // widget.demoId
    // _titleController.text
    // _descriptionController.text
    // _priceController.text
    // visibility
    // selectedTagIds.toList()

  }



  Future<void> pickImage() async {

    // TODO

  }



  @override
  void dispose(){

    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    super.dispose();

  }




  @override
  Widget build(BuildContext context) {

    final localizations =
        AppLocalizations.of(context)!;



    return BlocProvider(
      create: (_) =>
          getIt<CourseCubit>()
            ..fetchTags(),

      child: Scaffold(

        backgroundColor: AppColors.background,


        appBar: AppBar(

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),


          title: Text(
            localizations.createCourse,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),


          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),

        ),



        body: SingleChildScrollView(

          padding: const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [


              CourseImagePicker(
                selectedImage: selectedImage,
                onTap: pickImage,
                onRemove: (){
                  setState(() {
                    selectedImage = null;
                  });
                },
                uploadLabel:
                localizations.uploadImage,
              ),



              const SizedBox(height:20),



              CustomTextField(
                controller:_titleController,
                hintText:localizations.courseTitle,
                icon:Icons.title_outlined,
                onSubmitted:(_)=>setState((){}),
              ),



              const SizedBox(height:14),



              CustomTextField(
                controller:_descriptionController,
                hintText:
                localizations.courseDescription,
                icon:Icons.description_outlined,
                maxLines:4,
                onSubmitted:(_)=>setState((){}),
              ),



              const SizedBox(height:14),



              CustomTextField(
                controller:_priceController,
                hintText:localizations.price,
                icon:Icons.attach_money_rounded,
                keyboardType:
                TextInputType.number,
                onSubmitted:(_)=>setState((){}),
              ),



              const SizedBox(height:16),



              VisibilityDropdown(
                value:visibility,
                onChanged:(v){
                  setState(() {
                    visibility=v;
                  });
                },
                publicLabel:localizations.public,
                privateLabel:localizations.private,
              ),



              const SizedBox(height:18),



              Text(
                localizations.tags,
                style:const TextStyle(
                  fontWeight:FontWeight.bold,
                  fontSize:14,
                  color:AppColors.textPrimary,
                ),
              ),



              const SizedBox(height:10),



              BlocBuilder<CourseCubit, CourseState>(

                builder:(context,state){


                  if(state is CourseTagsLoading){

                    return const Center(
                      child:CircularProgressIndicator(),
                    );

                  }



                  if(state is CourseTagsLoaded){

                    return TagsSelector(

                      availableTags:
                      state.tags,

                      selectedTagIds:
                      selectedTagIds,

                      onToggle:
                      toggleTag,

                      isLoading:false,

                    );

                  }



                  if(state is CourseTagsError){

                    return Text(
                      state.message,
                      style:
                      const TextStyle(
                        color:Colors.red,
                      ),
                    );

                  }



                  return const SizedBox();

                },

              ),



              const SizedBox(height:28),



              SizedBox(

                height:52,

                child:CustomButton(

                  text:
                  localizations.createCourse,

                  gradient:
                  AppColors.buttonGradient,

                  expand:true,

                  onPressed:
                  handleCreateCourse,

                ),

              ),



              const SizedBox(height:35),

            ],
          ),

        ),

      ),
    );

  }
}