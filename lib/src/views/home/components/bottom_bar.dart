import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/providers/bottom_bar.dart';


class BottomBarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BottomBarProvider provider = Provider.of<BottomBarProvider>(context);

    return BottomNavigationBar(
      elevation: 25.0,
      items: const <BottomNavigationBarItem> [

        BottomNavigationBarItem(
            label: "Dashboard",
            icon: Icon(Icons.pie_chart)
        ),

        BottomNavigationBarItem(
            label: "Alertas",
            icon: Icon(Icons.notifications)
        ),
        BottomNavigationBarItem(
            label: "Atención\nA Crisis",
            icon: Icon(Icons.api)
        ),
        BottomNavigationBarItem(
            label: "Tramitación\nDe Casos",
            icon: Icon(Icons.menu_book)
        ),

      ],
      showUnselectedLabels: true,
      currentIndex: provider.selectedIndex,
      selectedItemColor: !provider.firstTime ? Color(0xff0a58ca) : Colors.grey,
      unselectedItemColor: Colors.grey,
      onTap: (index){
        provider.onTap(context: context, index: index);
      },
    );
  }
}

