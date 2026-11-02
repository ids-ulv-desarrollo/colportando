import 'package:colportando/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppIcon {
  // Uso general
  static const Widget home = HugeIcon(icon: HugeIcons.strokeRoundedHome07);
  static const Widget person = HugeIcon(icon: HugeIcons.strokeRoundedUser);

  // Autentificación
  static const Widget ios = HugeIcon(
    icon: HugeIcons.strokeRoundedApple,
    size: 40,
  );
  static const Widget google = HugeIcon(
    icon: HugeIcons.strokeRoundedGoogle,
    size: 40,
  );
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

  // Operaciones y multimedia
  static const Widget add = HugeIcon(icon: HugeIcons.strokeRoundedPlusSign);
  static const Widget remove = HugeIcon(icon: HugeIcons.strokeRoundedMinusSign);
  static const Widget upload = HugeIcon(icon: HugeIcons.strokeRoundedUpload01);
  static const Widget file = HugeIcon(icon: HugeIcons.strokeRoundedFile01);
  static const Widget camera = HugeIcon(icon: HugeIcons.strokeRoundedCamera01);

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
  static const Widget doneAll = HugeIcon(
    icon: HugeIcons.strokeRoundedTickDouble01,
  );

  // Icono de menú desplegable de depósitos.
  static const Widget menu = HugeIcon(icon: HugeIcons.strokeRoundedMenu04);
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
  static const Widget arrowUp = HugeIcon(
    icon: HugeIcons.strokeRoundedArrowUp01,
  );

  // Menú lateral / Drawer (Directiva, Colportor, Asociado)
  static const Widget asociados = HugeIcon(icon: HugeIcons.strokeRoundedMuslim);
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
