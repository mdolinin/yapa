import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/categories/categories.dart';
import 'package:yapa/models/category.dart';
import 'package:yapa/repository/category_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

void main() {
  group('CategoriesBloc', () {
    CategoriesRepository categoriesRepository;
    CategoriesBloc categoriesBloc;

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      when(categoriesRepository.loadCategories())
          .thenAnswer((_) => Future.value([]));
      categoriesBloc =
          CategoriesBloc(categoriesRepository: categoriesRepository);
    });

    blocTest<CategoriesBloc, CategoriesEvent, CategoriesState>(
      'should emit CategoriesNotLoaded if repository throws',
      build: () {
        when(categoriesRepository.loadCategories())
            .thenThrow(Exception('oops'));
        return categoriesBloc;
      },
      act: (CategoriesBloc bloc) async => bloc.add(LoadCategories()),
      expect: <CategoriesState>[
        CategoriesLoading(),
        CategoriesNotLoaded(),
      ],
    );

    blocTest<CategoriesBloc, CategoriesEvent, CategoriesState>(
      'should add a category to the list in response to an AddCategory Event',
      build: () => categoriesBloc,
      act: (CategoriesBloc bloc) async => bloc
        ..add(LoadCategories())
        ..add(AddCategory(Category('Bread and Cookies', id: '0'))),
      expect: <CategoriesState>[
        CategoriesLoading(),
        CategoriesLoaded([]),
        CategoriesLoaded([Category('Bread and Cookies', id: '0')]),
      ],
    );

    blocTest<CategoriesBloc, CategoriesEvent, CategoriesState>(
      'should update a category in response to an UpdateCategory Event',
      build: () => categoriesBloc,
      act: (CategoriesBloc bloc) async {
        final category = Category('Bread and Cookies', id: '0');
        bloc
          ..add(LoadCategories())
          ..add(AddCategory(category))
          ..add(UpdateCategory(category.copyWith(name: 'Canned Food')));
      },
      expect: <CategoriesState>[
        CategoriesLoading(),
        CategoriesLoaded([]),
        CategoriesLoaded([Category('Bread and Cookies', id: '0')]),
        CategoriesLoaded([Category('Canned Food', id: '0')]),
      ],
    );

    blocTest<CategoriesBloc, CategoriesEvent, CategoriesState>(
      'should remove category from the list in response to a DeleteCategory Event',
      build: () {
        when(categoriesRepository.loadCategories())
            .thenAnswer((_) => Future.value([]));
        return categoriesBloc;
      },
      act: (CategoriesBloc bloc) async {
        final category = Category('Bread and Cookies', id: '0');
        bloc
          ..add(LoadCategories())
          ..add(AddCategory(category))
          ..add(DeleteCategory(category));
      },
      expect: <CategoriesState>[
        CategoriesLoading(),
        CategoriesLoaded([]),
        CategoriesLoaded([Category('Bread and Cookies', id: '0')]),
        CategoriesLoaded([]),
      ],
    );
  });
}
