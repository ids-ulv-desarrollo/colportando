import 'package:colportando/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class AppIcon {
  // Uso general
  static const Widget home = HugeIcon(icon: HugeIcons.strokeRoundedHome07);
  static const Widget person = HugeIcon(icon: HugeIcons.strokeRoundedUser);

  // static Widget edu = SvgPicture.asset(
  //   "assets/icons/Edu.svg",
  //   color: AppColor.white,
  // );
  // Autentificación
  static const Widget password = HugeIcon(
    icon: HugeIcons.strokeRoundedLockPassword,
  );
  static const Widget email = HugeIcon(icon: HugeIcons.strokeRoundedMail01);
  static const Widget visibility = HugeIcon(icon: HugeIcons.strokeRoundedEye);
  static const Widget visibilityOff = HugeIcon(
    icon: HugeIcons.strokeRoundedEyeClosed,
  );
  static const Widget notifications = HugeIcon(
    icon: HugeIcons.strokeRoundedNotification01,
  );

  // Iconos por ubicar
  static const Widget calendar = HugeIcon(
    icon: HugeIcons.strokeRoundedCalendar01,
  );
  static const Widget search = HugeIcon(icon: HugeIcons.strokeRoundedSearch01);
  static const Widget cancel = HugeIcon(icon: HugeIcons.strokeRoundedCancel01);
  static const Widget edit = HugeIcon(icon: HugeIcons.strokeRoundedEdit02);

  // Perfil
  static const Widget lockOutline = HugeIcon(
    icon: HugeIcons.strokeRoundedLockKey,
  );
  static const Widget logoutOutlined = HugeIcon(
    icon: HugeIcons.strokeRoundedLogout01,
  );
  static const Widget noAccounts = HugeIcon(
    icon: HugeIcons.strokeRoundedUserBlock01,
  );

  // Notificaciones
  static const Widget delete = HugeIcon(
    icon: HugeIcons.strokeRoundedDelete02,
    color: AppColor.error,
  );
  static Widget doneAll({Color? color}) =>
      HugeIcon(icon: HugeIcons.strokeRoundedTickDouble01, color: color);

  // Icono de menú desplegable de depósitos.
  static const Widget moreHoriz = HugeIcon(
    icon: HugeIcons.strokeRoundedMoreHorizontal,
  );

  // Fechas
  static const Widget arrowRight = HugeIcon(
    icon: HugeIcons.strokeRoundedArrowRight01,
  );
  static const Widget arrowDown = HugeIcon(
    icon: HugeIcons.strokeRoundedArrowDown01,
  );

  // Barra inferior (o lateral para pantallas grandes)
  // Barra de navegación.
  static const Widget homeInactive = HugeIcon(
    icon: HugeIcons.strokeRoundedHome07,
    color: AppColor.gray,
  );
  static const Widget homeSelected = HugeIcon(
    icon: HugeIcons.strokeRoundedHome07,
    color: AppColor.white,
  );
  static const Widget personInactive = HugeIcon(
    icon: HugeIcons.strokeRoundedUser,
    color: AppColor.gray,
  );
  static const Widget personSelected = HugeIcon(
    icon: HugeIcons.strokeRoundedUser,
    color: AppColor.white,
  );

  // Menú lateral / Drawer (Directiva, Colportor, Asociado)
  static const Widget asociados = HugeIcon(
    icon: HugeIcons.strokeRoundedUserRoadside,
  );
  static const Widget grupos = HugeIcon(icon: HugeIcons.strokeRoundedUserGroup);
  static const Widget participaciones = HugeIcon(
    icon: HugeIcons.strokeRoundedCheckList,
  );
  static const Widget campana = HugeIcon(icon: HugeIcons.strokeRoundedSignpost);
  static const Widget capacitaciones = HugeIcon(
    icon: HugeIcons.strokeRoundedComputerUser,
  );
  static const Widget campos = HugeIcon(icon: HugeIcons.strokeRoundedMapPin);
  static const Widget apelaciones = HugeIcon(
    icon: HugeIcons.strokeRoundedUserSwitch,
  );
  static const Widget depositos = HugeIcon(
    icon: HugeIcons.strokeRoundedMoneyReceive01,
  );
  static const Widget catalogo = HugeIcon(
    icon: HugeIcons.strokeRoundedCatalogue,
  );
  static const Widget ventas = HugeIcon(icon: HugeIcons.strokeRoundedInvoice);
  static const Widget pagos = HugeIcon(icon: HugeIcons.strokeRoundedPayment01);
  static const Widget credito = HugeIcon(
    icon: HugeIcons.strokeRoundedCreditCard,
  );
  static const Widget adquisiciones = HugeIcon(
    icon: HugeIcons.strokeRoundedTag01,
  );
}
