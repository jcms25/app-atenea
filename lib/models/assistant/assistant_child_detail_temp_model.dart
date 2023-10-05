//purpose of this model to transfer child's data from one screen to another

import 'package:colegia_atenea/models/assistant/parent_model_assistant_model.dart';

class TempChildModel{
  String imagePath;
  String name;
  String address;
  List<TempParentModel> parentsName;
  String className;

  TempChildModel(this.imagePath, this.name, this.address, this.parentsName,
      this.className);
}