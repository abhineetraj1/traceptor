import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

var stateLoader = "active";
var responseBody = "";
var url = "YOUR_FLASK_SERVER_URL";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Traceptor",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 12, 42),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 12, 42),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Traceptor", style: TextStyle(color: Colors.white)),
            IconButton(onPressed: () {
              launchUrl(Uri.parse("https://github.com/abhineetraj1/traceptor"));
            }, icon: Icon(Icons.code, color: Colors.white,))
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Unlock endless opportunities with just a click—discover job openings and hackathon challenges tailored to your skills.",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () async {
                    stateLoader = "active";
                    await pickAndSendFile(context);
                  },
                  child: Text("Upload your resume"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickAndSendFile(BuildContext context) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf';
    uploadInput.click();
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) {
        showDialogBox(context, "Error", "No file selected");
        return;
      }
      final file = files[0];
      Loading(context);
      await sendFile(context, file);
    });
  }
}

class Result extends StatelessWidget {
  Result({super.key});

  var result = jsonDecode(responseBody.toString().replaceAll("```json", "```").split("```")[1]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 12, 42),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {return HomeScreen();}));
            }, icon: Icon(Icons.arrow_back)),
            Text("Result"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: result["applicable"] == "yes" ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: Text("Hackathons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
              Container(
                height: 215,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i in result["hackathons"]) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            color: const Color.fromARGB(255, 105, 105, 105)
                          )]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(i["name"], style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(i["description"], style: TextStyle(fontSize: 14,),),
                              ),
                              Row(
                                children: [
                                  Text("Location : "),
                                  for (var x in i["locations"]) Text(x,style: TextStyle(fontSize: 14),)
                                ],
                              ),
                              Align(alignment: Alignment.centerLeft,child: Text(i["date"],style: TextStyle(fontSize: 14))),
                              ElevatedButton(onPressed: () {
                                launchUrl(Uri.parse(i["registration_link"]));
                              }, child: Text("Apply"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Align(alignment: Alignment.centerLeft, child: Text("Jobs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i in result["jobs"]) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            color: const Color.fromARGB(255, 105, 105, 105)
                          )]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(i["title"], style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(i["location"], style: TextStyle(fontSize: 14,),),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(i["experience"], style: TextStyle(fontSize: 14,),),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(i["company"], style: TextStyle(fontSize: 14,),),
                              ),
                              ElevatedButton(onPressed: () {
                                launchUrl(Uri.parse(i["apply_link"]));
                              }, child: Text("Apply"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ) : Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("No relevant information found. Improve your skills and experience.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
          )),
        ),
      ),
    );
  }
}

void showDialogBox(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

void Loading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text("Uploading file...", textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              stateLoader = "inactive";
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<void> sendFile(BuildContext context, html.File file) async {
  try {
    final formData = html.FormData();
    formData.appendBlob('file', file, file.name);
    final request = html.HttpRequest();
    request.open('POST', url+"upload", async: true);
    request.onLoadEnd.listen((e) {
      if (request.status == 200) {
        responseBody = request.responseText ?? '';
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Result()),
          );
        }
      } else {
        if (context.mounted) {
          showDialogBox(context, "Error", "Failed to upload file");
        }
      }
    });
    request.send(formData);
  } catch (e) {
    if (context.mounted) {
      showDialogBox(context, "Error", "An error occurred: $e");
    }
  }
}