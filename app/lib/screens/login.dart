import 'package:app/routes/app_routes.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_input.dart';
import 'package:app/widgets/custom_input_password.dart';
import 'package:app/widgets/degraded.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/custom_title.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Degraded(),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Column(
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/logo.svg',
                      width: 60,
                      height: 60,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 13),
                    CustomTitle(
                      value: "BANORTE AI",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Text(
                      'Educación Financiera en la palma de tu mano',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTitle(value: '¡Bienvenido!'),
                        const SizedBox(height: 10),
                        const CustomInput(
                          label: "Correo electronico",
                          hintText: "a51726553@gmail.com",
                        ),
                        const SizedBox(height: 15),
                        const CustomInputPassword(
                          label: "Contraseña",
                          hintText: "**********",
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.forgotPassword);
                            },
                            child: Text(
                              'Olvidé mi contraseña',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '¿No tienes cuenta?  ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: 'Regístrate',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, AppRoutes.signup);
                              },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CustomButton(
                        text: 'Iniciar sesión',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.home);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
