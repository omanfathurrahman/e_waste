import 'package:ewaste/screen/auth/login_screen.dart';
import 'package:ewaste/screen/auth/register_screen.dart';
import 'package:ewaste/screen/buang/detail/detail_buang_jenis_elektronik_screen.dart';
import 'package:ewaste/screen/buang/keranjang/keranjang_buang.dart';
import 'package:ewaste/screen/donasi/detail/detail_donasi_jenis_elektronik_screen.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:ewaste/screen/profile/detail_profile/detail_profile_screen.dart';
import 'package:ewaste/screen/profile/detail_profile/edit_alamat/edit_alamat.dart';
import 'package:ewaste/screen/profile/detail_profile/edit_email/edit_email.dart';
import 'package:ewaste/screen/profile/detail_profile/edit_pekerjaan/edit_pekerjaan.dart';
import 'package:ewaste/screen/profile/riwayat_buang_donasi/riwayat_buang_donasi.dart';
import 'package:ewaste/screen/service/daftar_lokasi_service/lokasi_service_terdekat_screen.dart';
import 'package:ewaste/screen/service/detail/detail_lokasi_service.dart';
import 'package:ewaste/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  // Ensure that FlutterFire is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://oexltokstwraweaozqav.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9leGx0b2tzdHdyYXdlYW96cWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ1NjM5OTEsImV4cCI6MjAyMDEzOTk5MX0.4IB_1dfaBU6Ew-CtE4Uvs2Pmfd5SPi1Lan1oe5PSwIU');

  runApp(const MainApp());
}

// Create a new instance of supabase
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            }),
        GoRoute(
            path: 'register',
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterScreen();
            }),
        GoRoute(
            path: 'main-layout',
            builder: (BuildContext context, GoRouterState state) {
              return const MainLayout();
            }),
        GoRoute(
            path: 'main-layout/:id',
            builder: (BuildContext context, GoRouterState state) {
              return MainLayout(
                  curScreenIndex: int.parse(state.pathParameters['id']!));
            }),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return Container();
          },
          routes: [
            GoRoute(
                path: 'detail',
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailProfileScreen();
                },
                routes: [
                  GoRoute(
                      path: 'edit',
                      builder: (BuildContext context, GoRouterState state) {
                        return Container();
                      },
                      routes: [
                        GoRoute(
                            path: 'email',
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return const EditEmailScreen();
                            }),
                        GoRoute(
                            path: 'alamat',
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return const EditAlamatScreen();
                            }),
                        GoRoute(
                            path: 'pekerjaan',
                            builder:
                                (BuildContext context, GoRouterState state) {
                              return const EditPekerjaanScreen();
                            }),
                      ]),
                ]),
            GoRoute(
                path: 'riwayat',
                builder: (BuildContext context, GoRouterState state) {
                  return const RiwayatBuangDonasi();
                }),
          ],
        ),
        GoRoute(
            path: 'service',
            builder: (BuildContext context, GoRouterState state) {
              return Container();
            },
            routes: [
              GoRoute(
                  path: 'list/:idKecamatan',
                  builder: (context, state) {
                    return LokasiServiceTerdekatScreen(
                        idKecamatan:
                            int.parse(state.pathParameters['idKecamatan']!));
                  }),
              GoRoute(
                  path: 'list/:idKecamatan/:idServiceCenter',
                  builder: (context, state) {
                    return DetailLokasiServiceScreen(
                        idKecamatan:
                            int.parse(state.pathParameters['idKecamatan']!),
                        idServiceCenter: int.parse(
                            state.pathParameters['idServiceCenter']!));
                  })
            ]),
        GoRoute(
            path: 'buang',
            builder: (context, state) {
              return Container();
            },
            routes: [
              GoRoute(
                  path: 'keranjang',
                  builder: (context, state) {
                    return const KeranjangBuang();
                  }),
              GoRoute(
                  path: 'detail/:jenisKategorisasi/:idJenisKategori',
                  builder: (context, state) {
                    return DetailBuangJenisElektronikScreen(
                        jenisKategorisasi:
                            state.pathParameters['jenisKategorisasi']!,
                        idJenisKategori: int.parse(
                            state.pathParameters['idJenisKategori']!));
                  }),
            ]),
        GoRoute(
            path: 'donasi',
            builder: (context, state) {
              return Container();
            },
            routes: [
              GoRoute(
                  path: 'keranjang',
                  builder: (context, state) {
                    return const KeranjangBuang();
                  }),
              GoRoute(
                  path: 'detail/:jenisKategorisasi/:idJenisKategori',
                  builder: (context, state) {
                    return DetailDonasiJenisElektronikScreen(
                        jenisKategorisasi:
                            state.pathParameters['jenisKategorisasi']!,
                        idJenisKategori: int.parse(
                            state.pathParameters['idJenisKategori']!));
                  }),
            ]),
      ],
    ),
  ],
);
