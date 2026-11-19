import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:colportando/features/catalog/data/sources/catalog_remote_data_source.dart';
import 'package:colportando/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:colportando/features/catalog/domain/usecases/catalog_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Fuente de datos remota de catálogo.
final _catalogRemoteDataSourceProvider = Provider<ICatalogRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRemoteDataSource(apiClient: apiClient);
});

// Repositorio de catálogo.
final _catalogRepositoryProvider = Provider<ICatalogRepository>((ref) {
  final remoteDataSource = ref.watch(_catalogRemoteDataSourceProvider);
  return CatalogRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Casos de uso de catálogo expuestos para el estado y la UI.
final createMaterialUsecaseProvider = Provider<CreateMaterialUsecase>((ref) {
  return CreateMaterialUsecase(repository: ref.watch(_catalogRepositoryProvider));
});

final createCampaignCatalogUsecaseProvider =
    Provider<CreateCampaignCatalogUsecase>((ref) {
      return CreateCampaignCatalogUsecase(
        repository: ref.watch(_catalogRepositoryProvider),
      );
    });

final listCampaignCatalogsUsecaseProvider =
    Provider<ListCampaignCatalogsUsecase>((ref) {
      return ListCampaignCatalogsUsecase(
        repository: ref.watch(_catalogRepositoryProvider),
      );
    });

final addCatalogItemUsecaseProvider = Provider<AddCatalogItemUsecase>((ref) {
  return AddCatalogItemUsecase(repository: ref.watch(_catalogRepositoryProvider));
});

final updateCatalogStatusUsecaseProvider =
    Provider<UpdateCatalogStatusUsecase>((ref) {
      return UpdateCatalogStatusUsecase(
        repository: ref.watch(_catalogRepositoryProvider),
      );
    });

final createAcquisitionUsecaseProvider = Provider<CreateAcquisitionUsecase>((
  ref,
) {
  return CreateAcquisitionUsecase(
    repository: ref.watch(_catalogRepositoryProvider),
  );
});

final listCampaignAcquisitionsUsecaseProvider =
    Provider<ListCampaignAcquisitionsUsecase>((ref) {
      return ListCampaignAcquisitionsUsecase(
        repository: ref.watch(_catalogRepositoryProvider),
      );
    });

final updateAcquisitionStatusUsecaseProvider =
    Provider<UpdateAcquisitionStatusUsecase>((ref) {
      return UpdateAcquisitionStatusUsecase(
        repository: ref.watch(_catalogRepositoryProvider),
      );
    });

final listClubMaterialsUsecaseProvider = Provider<ListClubMaterialsUsecase>((
  ref,
) {
  return ListClubMaterialsUsecase(
    repository: ref.watch(_catalogRepositoryProvider),
  );
});

final listMyAcquisitionsUsecaseProvider = Provider<ListMyAcquisitionsUsecase>((
  ref,
) {
  return ListMyAcquisitionsUsecase(
    repository: ref.watch(_catalogRepositoryProvider),
  );
});
