import 'package:flutter/material.dart';

class Expenditure extends StatefulWidget{
  const Expenditure({super.key});

  State<Expenditure> createState() => ExpenditureState();
}

class ExpenditureState extends State<Expenditure>{
  final TextEditingController controller = TextEditingController();
  final List<String> Items = [];  
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Column(
         
          children: [
            Expanded(child: ListView.builder(
              itemCount: Items.length,
              itemBuilder:(context,index){
              return Container(
                 margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(Items[index]),
              );
            })),
            const Divider(height: 1),
            Padding(padding: EdgeInsets.all(16,),
            child:Row(
              children: [
                 Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.send)
                    ),
                  ),
                ),
              ],
            ) ,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Items.add(controller.text);
                  controller.clear();
                });
              },
              child: const Text('Add'),
          ) 
          ],
        ),

    );
  }
}