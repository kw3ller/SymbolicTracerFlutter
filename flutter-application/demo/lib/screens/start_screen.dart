import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symtrace/data/codeFile.dart';
import 'package:symtrace/data/codeLine.dart';
import 'package:symtrace/data/symbolicValue.dart';
import 'package:symtrace/main.dart';

import 'package:file_picker/file_picker.dart';
import 'package:symtrace/providers/codeFilesStats_provider.dart';
import 'package:symtrace/providers/loadFilesButton_provider.dart';

import '../data/symProgram.dart';
import '../providers/codeFilesSearch_provider.dart';

class StartScreen extends StatelessWidget {
  StartScreen({super.key});

  List<String> errorFiles = [];

  // reads directory and loads all files specified by json file
  Future<bool> readCodeFileDir(BuildContext context) async {
    File codeFile;

    for (CodeFile cf in symProgram.codeFilesList) {
      final String filePath = cf.filePath;
      try {
        codeFile = File(filePath);
        Stream<String> lines = codeFile
            .openRead()
            .transform(utf8.decoder) // Decode bytes to UTF-8.
            .transform(
                const LineSplitter()); // Convert stream to individual lines.
        await for (var line in lines) {
          cf.codeLinesContent.add(line);
        }
      } catch (e) {
        // something went wrong reading this specific filePath
        errorFiles.add(filePath);
      }
    }
    return true;
  }

  // to read the JSON file into a symProgram
  Future<bool> readJson() async {
    File jsonFile;
    String jsonString = "";
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (result != null) {
        final String filePath = result.files.single.path!;
        jsonFile = File(filePath);
        jsonString = await jsonFile.readAsString();
      } else {
        return false;
      }

      List<dynamic> data = await jsonDecode(jsonString);
      symProgram = data.map((data) => SymProgram.fromJson(data)).toList().first;

      // for coverage percentage of the whole Program
      int hitLinesProg = 0;
      int allLines = 0;

      for (CodeFile cf in symProgram.codeFilesList) {
        // for coveragePercentage
        int hitLines = 0;

        cf.fileName = cf.filePath.split('/').last;
        // sort the codeLines
        cf.codeLines.sort(((a, b) => a.line.compareTo(b.line)));

        allLines += cf.codeLines.length;

        // count the number of symbolic values and hardbounds and hardbound violations
        for (CodeLine cl in cf.codeLines) {
          cf.numberOfSymbolicValues += cl.symbolicValues.length;
          symProgram.numerOfSymValues += cl.symbolicValues.length;
          if(cl.symbolicValues.isNotEmpty) {
            cf.numberOfHardBounds += 1;
            symProgram.numberOfHardbounds += 1;
          }
          
          

          if (cl.exeCount != 0 || cl.branchExeCount != 0) {
            hitLines += 1;
            hitLinesProg += 1;
          }

          // calculate the hexValues and sum number of hardbound violations
          for (SymbolicValue sv in cl.symbolicValues) {
            sv.aktValueHex = sv.aktValue.toRadixString(16).toUpperCase();
            sv.minValueHex = sv.minValue.toRadixString(16).toUpperCase();
            sv.maxValueHex = sv.maxValue.toRadixString(16).toUpperCase();

            if(sv.aktValue < sv.minValue || sv.aktValue > sv.maxValue) {
              cf.numberOfHardBoundViolations += 1;
              symProgram.numberOfHardBoundViolations += 1;
            }

          }


        }

        if (cf.codeLines.isNotEmpty) {
          double covPerc = hitLines / cf.codeLines.length;
          String covPercStr = "${covPerc.toString()}000000";
          covPercStr.startsWith("1")
              ? cf.coveragePercentage = "100"
              : cf.coveragePercentage =
                  "${covPercStr.substring(2, 4)},${covPercStr.toString().substring(4, 6)}";
        }
      }

      if (allLines != 0) {
          double covPerc = hitLinesProg / allLines;
          String covPercStr = "${covPerc.toString()}000000";
          covPercStr.startsWith("1")
              ? symProgram.coveragePercentage = "100"
              : symProgram.coveragePercentage =
                  "${covPercStr.substring(2, 4)},${covPercStr.toString().substring(4, 6)}";
        }


    } catch (e) {
      // something went wrong reading/converting the json file
      symProgram.codeFilesList = [];
    }

    return true;
  }

  // to show code files that could not be opened in an alertDialog
  Future<void> showErrorFiles(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 420,
          width: 400,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                7,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Some files could not be opened:",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        5,
                      ),
                    ),
                    color: Color.fromARGB(255, 59, 59, 59),
                  ),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    itemCount: errorFiles.length,
                    itemBuilder: (context, index) {
                      return Text(errorFiles[index]);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    errorFiles = [];
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => DemoPage(
                              key: key,
                            )),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: const Text(
                    'Ok',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shoWJsonErrorDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 400,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "The JSON file could not be read:",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "It appears that the JSON file could not be read. \nA reason might be that it has an unexpected format that is not supported. \nEither that or it has an error inside which leads to this dialog.",
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: const Text(
                    'Ok',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 800,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Welcome to our visualisation of the symbolic trace",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "IOT4U",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    "This program enables you to visualize the symbolic trace that the SymEx-VP has produced."),
                const SizedBox(height: 20),
                const Text(
                  "Getting started",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              "Load the JSON-File that has been generated:"),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              bool jsonWasSelected = await readJson();
                              // do only if the thing before went right -> when CodeFilesList isn't empty
                              // otherwise show error popUp
                              if (symProgram.codeFilesList.isNotEmpty &&
                                  jsonWasSelected) {
                                // now load codeFiles
                                if (!await readCodeFileDir(context)) {
                                  return;
                                }

                                if (!context.mounted) return;

                                // initialize the codeLists for searching
                                context.read<CodeFilesSearch>().init();
                                context.read<CodeFilesStats>().init();

                                if (errorFiles.isEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => DemoPage(
                                            key: key,
                                          )),
                                    ),
                                  );
                                } else {
                                  showErrorFiles(context);
                                }
                              } else if (!jsonWasSelected) {
                                return;
                              } else {
                                shoWJsonErrorDialog(context);
                              }
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Theme.of(context).secondaryHeaderColor),
                            child: const Text("Load JSON-File"),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
