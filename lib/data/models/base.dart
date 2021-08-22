class BaseModel {
  String? id;
  // DateTime? addedOn;
  bool selected = false;
}

// class Selections<T extends BaseModel> {
//   var selection = Set<String>();

//   bool isSelected(String index) => selection.contains(index);

//   void setSelections(List<T> list) {
//     final updatedSet = <String>{};
//     list.forEach((element) {
//       if (element.selected) {
//         updatedSet.add(element.id!);
//       }
//     });
//     selection = updatedSet;
//   }

//   Set<String> createDefaultValue() => selection;

//   void initWithValue(Set<String> value) {
//     selection = value;
//   }

//   Object toPrimitives() => selection.toList();

//   Set<String> fromPrimitives(Object data) {
//     final selectedItemIndices = data as List<dynamic>;
//     selection = {
//       ...selectedItemIndices.map<String>((dynamic id) => id as String),
//     };
//     return selection;
//   }
// }
