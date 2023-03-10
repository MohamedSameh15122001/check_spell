import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spell_checker/shared/components/constants.dart';
import 'package:spell_checker/shared/main_cubit/main_cubit.dart';
import 'package:spell_checker/shared/main_cubit/main_states.dart';

class Home extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    internetConection(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 52, 53, 65),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return BlocConsumer<MainCubit, MainState>(
      bloc: MainCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit ref = MainCubit.get(context);
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 68, 70, 84),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 52, 53, 65),
            title: const Text(
              'Check Spell',
              style: TextStyle(
                color: Color.fromARGB(255, 209, 213, 211),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state is LoadingCheckSpellState
                      ? Column(
                          children: const [
                            SizedBox(height: 10),
                            SpinKitWave(
                              color: Color.fromARGB(255, 209, 213, 211),
                              size: 30,
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      : Container(),
                  TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 209, 213, 211),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: controller,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write the sentence',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 209, 213, 211),
                      ),
                    ),
                    cursorColor: Colors.grey.shade300,
                  ),
                  (ref.howManyErrors == 0)
                      ? Container()
                      : Text(
                          'Errors: ${ref.howManyErrors.toString()}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 209, 213, 211),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  (ref.howManyErrors == 0)
                      ? Container()
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ref.errors.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .8,
                          ),
                          itemBuilder: (context, fristIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  '◼️ ${ref.errors[fristIndex]['word']}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 209, 213, 211),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Position: ${ref.errors[fristIndex]['position'].toString()}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 209, 213, 211),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Suggestions: ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 209, 213, 211),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        '⚫ ${ref.errors[fristIndex]['suggestions'][index]}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 209, 213, 211),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                ],
              ),
            ),
          ),
          bottomSheet: GestureDetector(
            onTap: () async {
              if (controller.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'The Field Is Empty Please Fill The Filled First!',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 52, 53, 65),
                    );
                  },
                );
              } else {
                internetConection(context);
                if (isNetworkConnection) {
                  await ref.checkSpell(text: controller.text);
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 68, 70, 84),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, -1),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 50.0,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromARGB(255, 52, 53, 65),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'CHECK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 209, 213, 211),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
