import 'package:flutter/material.dart';
import 'package:ridesense/screens/map_screen.dart';
import 'package:ridesense/services/api.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final TextEditingController _cont = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://img1.wsimg.com/isteam/ip/5148ced5-0fa0-43da-b590-46a4a47875f4/RideSense_Logo_Svg_vf.png/:/rs=w:141,h:200,cg:true,m/cr=w:141,h:115/qt=q:95",
              errorBuilder: (context, error, stackTrace) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.map,
                      size: 60,
                    ),
                  ),
                );
              },
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _cont,
                decoration: InputDecoration(
                  hintText: "Enter Location",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value == "") {
                    return "Enter something";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  dynamic x = await API.getCoord(placeName: _cont.text);
                  if (x["result"]) {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapScreen(
                                  lat: x["lat"],
                                  long: x["long"],
                                )));
                  } else {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            x["message"],
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Submit",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
