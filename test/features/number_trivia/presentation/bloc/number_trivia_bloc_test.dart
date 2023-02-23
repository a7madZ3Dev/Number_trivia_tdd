// ignore_for_file: directives_ordering

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () async {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    // test('should emit [Error] when the inputs is invalid.', () async* {
    //   //arrange
    //   when(mockInputConverter.stringToUnsignedInteger(any))
    //       .thenReturn(Left(InvalidInputFailure()));

    //   final expected = [
    //     Empty(),
    //     Error(message: invalidInputFailureMessage),
    //   ];
    //   //assert later
    //   expectLater(bloc, emitsInOrder(expected));

    //   //act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });

    blocTest('should emit [Error] when the inputs is invalid.',
        build: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          return bloc;
        },
        act: (_) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [const Error(message: invalidInputFailureMessage)]);

    // test('should get data from the concrete usecase', () async* {
    //   //arrange
    //   setUpMockInputConverterSuccess();
    //   when(mockGetConcreteNumberTrivia(any))
    //       .thenAnswer((_) async => Right(tNumberTrivia));
    //   //act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   await untilCalled(mockGetConcreteNumberTrivia(any));

    //   //assert
    //   verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    // });

    blocTest('should get data from the concrete usecase.',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          return bloc;
        },
        act: (_) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        verify: (_) {
          verify(
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
        });

    // test('should emits [Loading, Loaded] when data is gotten successfully',
    //     () async* {
    //   //arrange
    //   setUpMockInputConverterSuccess();
    //   when(mockGetConcreteNumberTrivia(any))
    //       .thenAnswer((_) async => Right(tNumberTrivia));

    //   //assert later
    //   final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
    //   expectLater(bloc, emitsInOrder(expected));
    //   //act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });

    blocTest('should emits [Loading, Loaded] when data is gotten successfully.',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          return bloc;
        },
        act: (_) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)]);

    // test('should emits [Loading, Error] when getting data fails', () async* {
    //   //arrange
    //   setUpMockInputConverterSuccess();
    //   when(mockGetConcreteNumberTrivia(any))
    //       .thenAnswer((_) async => Left(ServerFailure()));

    //   //assert later
    //   final expected = [
    //     Empty(),
    //     Loading(),
    //     Error(message: serverFailureMessage)
    //   ];
    //   expectLater(bloc, emitsInOrder(expected));
    //   //act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });

    blocTest('should emits [Loading, Error] when getting data fails.',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (_) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [Loading(), const Error(message: serverFailureMessage)]);

    // test(
    //     'should emits [Loading, Error] with a proper message for the error when getting data fails',
    //     () async* {
    //   //arrange
    //   setUpMockInputConverterSuccess();
    //   when(mockGetConcreteNumberTrivia(any))
    //       .thenAnswer((_) async => Left(CacheFailure()));

    //   //assert later
    //   final expected = [
    //     Empty(),
    //     Loading(),
    //     Error(message: cacheFailureMessage)
    //   ];
    //   expectLater(bloc, emitsInOrder(expected));
    //   //act
    //   bloc.add(GetTriviaForConcreteNumber(tNumberString));
    // });

    blocTest(
        'should emits [Loading, Error] with a proper message for the error when getting data fails.',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          return bloc;
        },
        act: (_) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [Loading(), const Error(message: cacheFailureMessage)]);
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random usecase', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emits [Loading, Loaded] when data is gotten successfully',
        () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia)
      ];
      await expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emits [Loading, Error] when getting data fails', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: serverFailureMessage)
      ];
      await expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emits [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: cacheFailureMessage)
      ];
      await expectLater(bloc, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
