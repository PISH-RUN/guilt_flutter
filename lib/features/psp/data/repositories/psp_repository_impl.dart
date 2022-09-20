import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/gender_type.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp_step.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

import '../../../../application/constants.dart';
import '../../domain/repositories/psp_repository.dart';

class PspRepositoryImpl implements PspRepository {
  final RemoteDataSource remoteDataSource;

  PspRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginateList<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page, String searchText) async {
    //todo
    // final output = remoteDataSource.getFromServer<PaginateList<GuildPsp>>(
    //   url: '${BASE_URL_API}users/me',
    //   params: {'searchText':searchText},
    //   mapSuccess: (Map<String, dynamic> json) => PaginateList(
    //     list: JsonParser.listParser(json, ['data']).map((element) => GuildPspModel.fromJson(element)).toList(),
    //     currentPage: page,
    //     perPage: 30,
    //     totalPage: 3,
    //   ),
    // );
    // return output;
    return Right(
      PaginateList(
        list: List.generate(
          20,
          (index) {
            return GuildPsp(
              guild: Guild(
                id: index + (20 * (page - 1)),
                nationalCode: "5434234",
                phoneNumber: "32424",
                poses: [],
                firstName: "dd",
                gender: Gender.boy,
                lastName: "cdsc",
                organName: "f${index + (20 * (page - 1))}",
                isic: Isic(name: "name", code: "1312"),
                avatar: "",
                isCouponRequested: false,
                title: "title${index + (20 * (page - 1))}",
                province: "province",
                city: "city",
                homeTelephone: "homeTelephone",
                address: "address",
                postalCode: "postalCode",
                location: lat_lng.LatLng(23.0, 23.0),
              ),
              guildPspStep: GuildPspStep.normal,
            );
          },
        ),
        currentPage: page,
        totalPage: 6,
        perPage: 20,
      ),
    );
  }

  @override
  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guild) async {
    final output = await remoteDataSource.postToServer<bool>(
      url: '${BASE_URL_API}users/me',
      params: {},
      mapSuccess: (Map<String, dynamic> json) => true,
    );
    return RequestResult.fromEither(output);
  }
}
