import 'package:_bike_services_use_cases/bike_services_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mappers/service_mapper.dart';
import 'event.dart';
import 'state.dart';

class NearServicesBloc extends Bloc<NearServicesEvent, NearServicesState> {
  final GetAllServicesSortedByDistance _getAllServices;

  NearServicesBloc(this._getAllServices) : super(NearServicesState.loading()) {
    on<NearServicesStarted>((event, emit) async {
      await _loadServices(emit);
    });

    on<NearServicesReloadPressed>((event, emit) async {
      emit(NearServicesState.loading());
      await _loadServices(emit);
    });
  }

  Future<void> _loadServices(Emitter<NearServicesState> emit) async {
    final result = await _getAllServices();
    result.fold(
      (failure) => emit(NearServicesState.failure()),
      (services) {
        final serviceDtos =
            services.map((service) => service.toServiceDto()).toList();
        emit(NearServicesState.success(services: serviceDtos));
      },
    );
  }
}
