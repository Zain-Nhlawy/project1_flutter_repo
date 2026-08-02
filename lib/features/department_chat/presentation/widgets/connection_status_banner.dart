import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../../domain/entities/socket_connection_status.dart';

class ConnectionStatusBanner extends StatelessWidget {
  final SocketConnectionStatus status;

  const ConnectionStatusBanner({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == SocketConnectionStatus.connected ||
        status == SocketConnectionStatus.initial) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context);
    String message = localizations?.chatConnecting ?? 'Connecting...';
    Color bgColor = AppColors.warning;

    if (status == SocketConnectionStatus.reconnecting) {
      message = localizations?.chatReconnecting ?? 'Reconnecting to chat...';
      bgColor = AppColors.warning;
    } else if (status == SocketConnectionStatus.error) {
      message = localizations?.chatConnectionLost ?? 'Connection lost. Retrying...';
      bgColor = AppColors.error;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
