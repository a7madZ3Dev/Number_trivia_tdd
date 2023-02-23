import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Number Trivia'),
        ),
        body: const SingleChildScrollView(
          child: BuildBody(),
        ),
      );
}

class BuildBody extends StatelessWidget {
  const BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<NumberTriviaBloc>(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                // Top half
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (_, state) {
                    if (state is Empty) {
                      return const MessageDisplay(message: 'Let\'s Do it 🦾');
                    } else if (state is Error) {
                      return MessageDisplay(message: state.message);
                    } else if (state is Loading) {
                      return const LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),

                // Bottom half
                const TriviaControls(),
              ],
            ),
          ),
        ),
      );
}
