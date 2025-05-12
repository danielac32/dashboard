import 'package:flutter/material.dart';

class UserRegister extends StatelessWidget {
  const UserRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(

        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(16),
            color: colors.secondary
          ),
           child: Column(

             children: [
               Text("data"),
               Text("data")
             ],
           ),
        ),
    );
  }
}
