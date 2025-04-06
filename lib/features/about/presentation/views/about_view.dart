import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/features/about/cubits/about_cubit.dart';
import 'package:islamic_calander_2/features/about/models/about_model.dart';

class AboutProvider extends StatelessWidget {
  const AboutProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutCubit(),
      child: const AboutView(),
    );
  }
}

class AboutView extends StatefulWidget {
  const AboutView({
    super.key,
  });

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  late final AboutCubit controller;
  @override
  void initState() {
    controller = context.read<AboutCubit>();
    _init();
    super.initState();
  }

  Future _init() async {
    await controller.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // backgroundColor: context.secondaryHeaderColor,
          appBar: AppBar(
            // backgroundColor: Colors.white.withOpacity(0.3),
            title: Text(
              'ABOUT'.tr(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: BlocBuilder<AboutCubit, ApiResponseModel<AboutModel>>(
                builder: (context, state) {
                  if (state.response == ResponseEnum.loading) {
                    return SingleChildScrollView(
                      child: Column(
                        children: List.generate(30, (i) {
                          return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  width: double.infinity,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.grey, borderRadius: BorderRadius.circular(5)))
                              .animate(onPlay: (c) => c.repeat())
                              .fade(
                                  delay: (100 + i * 5).ms, duration: 1000.ms, begin: 0.5, end: 0.8);
                        }),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                      child: Column(children: [
                    Html(
                      data: isEnglish() ? state.data?.en : state.data?.ar,
                      style: {
                        '#': Style(
                            // fontFamily: "Amiri",
                            textAlign: TextAlign.justify)
                      },
                    )
                  ]));
                },
              ))),
    );
  }
}
