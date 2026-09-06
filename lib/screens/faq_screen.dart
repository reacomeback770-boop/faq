import 'package:flutter/material.dart';

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<FaqItem> faqItems = [
    FaqItem(
      question: "Как сбросить пароль?",
      answer: "Чтобы сбросить пароль, перейдите на экран входа и нажмите «Забыли пароль». Следуйте инструкциям, отправленным на ваш зарегистрированный адрес электронной почты.",
    ),
    FaqItem(
      question: "Какие способы оплаты вы принимаете?",
      answer: "Мы принимаем все основные кредитные карты (Visa, MasterCard), а также электронные кошельки и банковские переводы.",
    ),
    FaqItem(
      question: "Могу ли я отменить подписку в любое время?",
      answer: "Да, вы можете отменить подписку в любое время в настройках вашего аккаунта. Доступ сохранится до конца текущего расчетного периода.",
    ),
    FaqItem(
      question: "Как связаться со службой поддержки?",
      answer: "Вы можете связаться с нашей службой поддержки 24/7 через встроенный чат в приложении или написав на support@example.com.",
    ),
    FaqItem(
      question: "Безопасны ли мои данные?",
      answer: "Абсолютно. Мы используем современное шифрование для защиты вашей личной и финансовой информации. Мы никогда не передаем ваши данные третьим лицам.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Вопрос-ответ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 24),
          ...faqItems.map((item) => _buildFaqItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Вопрос-ответ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Реализуйте интерактивный список FAQ, где при нажатии на вопрос разворачивается ответ (эффект аккордеона).',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(FaqItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            title: Text(
              item.question,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            iconColor: const Color(0xFF4338CA),
            collapsedIconColor: Colors.grey.shade500,
            children: [
              Text(
                item.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
