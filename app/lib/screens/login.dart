import 'package:app/routes/app_routes.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/custom_input.dart';
import 'package:app/widgets/custom_input_password.dart';
import 'package:app/widgets/degraded.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                      height: 35,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 13),
                    // Texto grande con el estilo del Theme
                    Text(
                      "Academia Financiera",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 5),
                    // Texto pequeño con el estilo del Theme
                    Text(
                      'Educación Financiera en la palma de tu mano',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Texto grande con el estilo del Theme
                        Text(
                          '¡Bienvenido!',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
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
                            // Texto pequeño con el estilo del Theme
                            child: Text(
                              'Olvidé mi contraseña',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
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
                          TextSpan(
                            text: '¿No tienes cuenta?  ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          TextSpan(
                            text: 'Regístrate',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, AppRoutes.signup);
                              },
                          ),
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
                        // Aplica el estilo en el child del botón
                        child: Text(
                          'Iniciar sesión',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
