import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<String> list = [];
  bool outData = false;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  void LoadingData() async {
    setState(() {
      isLoading = true;
    });

    List<String> newData = list.length >= 60
        ? []
        : List.generate(20, (index) => 'List Item ${index + list.length}');

    await Future.delayed(Duration(milliseconds: 500));

    if (newData.isNotEmpty) {
      list.addAll(newData);
    }

    setState(() {
      isLoading = false;
      outData = newData.isEmpty;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadingData();
    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent && !isLoading){
        LoadingData();
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (list.isNotEmpty) {
            return Stack(
              children: [
                ListView.separated(
                controller: scrollController,
                  itemBuilder: (context, index) {
                   if(index < list.length){
                     return ListTile(
                      title: Text(list[index]),
                    );
                   }else{
                    return Text("All data has been downloaded");
                   }
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                    );
                  },
                  itemCount: list.length + (outData?1:0)),

                  if(isLoading)...[
                    Positioned(
                      width: constraints.maxWidth,
                      left: 0,
                      bottom: 0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ]
              ]
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
