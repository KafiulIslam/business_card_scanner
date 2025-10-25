// import 'package:flutter/material.dart';
//
// class SecondaryButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final Color borderColor;
//   final Color buttonColor;
//   final IconData? icon;
//   final String buttonTitle;
//   final Color titleColor;
//
//   const SecondaryButton(
//       {super.key,
//       required this.onTap,
//       required this.borderColor,
//       required this.buttonColor,
//       this.icon,
//       required this.buttonTitle,
//       required this.titleColor});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: OutlinedButton(
//         onPressed: onTap,
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: borderColor),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(32),
//           ),
//           backgroundColor: buttonColor,
//           padding: const EdgeInsets.symmetric(vertical: 8),
//         ),
//         child: icon == null
//             ? Text(
//                 buttonTitle,
//                 style: AppTypo.tTextStyle700.copyWith(
//                   color: titleColor,
//                   fontSize: 14,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, color: titleColor, size: 20),
//                   const SizedBox(width: 8),
//                   Text(
//                     buttonTitle,
//                     style: AppTypo.tTextStyle700.copyWith(
//                       color: titleColor,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
