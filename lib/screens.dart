import '0.one_file/main_00.dart' as one_file_00;
import '0.one_file/main_07.dart' as one_file_07;
import '1.one_folder/main.dart' as one_folder;
import '1.one_folder_structured/main.dart' as one_folder_structured;
import '2.one_folder_with_repositories/main.dart'
    as one_folder_with_repositories;
import '2.one_folder_with_repositories_structured/main.dart'
    as one_folder_with_repositories_structured;
import '3.one_folder_with_data_domain/main.dart' as one_folder_with_data_domain;
import '3.one_folder_with_data_domain_structured/main.dart'
    as one_folder_with_data_domain_structured;
import 'example/main_screen.dart' as example;
import 'profiling/profiling_screen.dart' as profiling;

const screens = {
  '0.one_file_00': one_file_00.MainScreen(),
  '0.one_file_07': one_file_07.MainScreen(),
  '1.one_folder': one_folder.MainScreen(),
  '1.one_folder_structured': one_folder_structured.MainScreen(),
  '2.one_folder_with_repositories': one_folder_with_repositories.MainScreen(),
  '2.one_folder_with_repositories_structured':
      one_folder_with_repositories_structured.MainScreen(),
  '3.one_folder_with_data_domain': one_folder_with_data_domain.MainScreen(),
  '3.one_folder_with_data_domain_structured':
      one_folder_with_data_domain_structured.MainScreen(),
  'example': example.MainScreen(),
  'profiling': profiling.ProfilingScreen(),
};
