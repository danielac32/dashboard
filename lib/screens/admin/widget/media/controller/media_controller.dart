import 'package:get/get.dart';

import '../../../child/user/permisos/interface/sections_response.dart';
import '../service/media_service.dart';

class MediaController extends GetxController {

  RxList<String> items = <String>[].obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    try{
      final sections = await MediaService.get("sections");
      final resSections = Sections.fromJson(sections);
      items.addAll(resSections.sections);//getDisplayName
      for(final s in items){
        print(s);
      }
    }catch(e){
      print('Error cargando secciones: $e');
    }
  }
}