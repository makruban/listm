import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationTab { packingLists, allItems }

class NavigationCubit extends Cubit<NavigationTab> {
  NavigationCubit() : super(NavigationTab.packingLists);

  void setTab(NavigationTab tab) => emit(tab);
}
