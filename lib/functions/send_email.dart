import 'package:acad_calculator/functions/email_credentials.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail({required String subject, required String body}) async {
  final String username = EmailCredentials().email;
  final String password = EmailCredentials().password;

  final smtpServer = SmtpServer(
    EmailCredentials().smtp,
    port: EmailCredentials().portNumber,
    ssl: true,
    username: username,
    password: password,
  );

  final message =
      Message()
        ..from = Address(username, 'Acad Calculator')
        ..recipients.add(EmailCredentials().emailReceiver)
        ..subject = subject
        ..text = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email enviado com sucesso: $sendReport');
  } on MailerException catch (e) {
    print('Erro ao enviar e-mail: $e');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}
