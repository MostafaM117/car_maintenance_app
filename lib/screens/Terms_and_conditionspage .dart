import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text(
                'الشروط والأحكام',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Text(
                'برجاء قراءة الشروط والأحكام التالية بعناية قبل استخدام هذا التطبيق. باستخدامك للتطبيق، فإنك توافق على الالتزام بهذه الشروط.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '1. وصف الخدمة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'يقدم التطبيق خدمة متابعة وصيانة السيارات من خلال تذكير المستخدم بمواعيد الصيانة الدورية، وتسجيل عمليات الإصلاح، وعرض معلومات استرشادية مستندة إلى جداول الصيانة الخاصة بكل سيارة بناءً على بيانات المستخدم.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '2. إخلاء مسؤولية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● التطبيق هو أداة مساعدة تهدف إلى تسهيل متابعة صيانة السيارة، وليس بديلاً عن فحص السيارة لدى متخصصين أو مراكز الصيانة المعتمدة.\n'
                '● لا يتحمل التطبيق أو القائمون عليه أي مسؤولية عن أي أعطال أو أضرار قد تنتج عن الاعتماد الكامل على المعلومات أو التوصيات المعروضة داخل التطبيق.\n'
                '● دقة المعلومات المعروضة تعتمد بشكل جزئي على إدخال المستخدم للبيانات، وبالتالي قد تختلف النتائج من حالة لأخرى.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '3. قطع الغيار والطرف الثالث',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● يعمل التطبيق كوسيط بين المستخدمين وموردي/تجار قطع الغيار، ولا يتحمل أي مسؤولية قانونية أو فنية عن جودة أو مطابقة القطع المعروضة.\n'
                '● أي عملية شراء أو تعامل تتم خارج نطاق التطبيق تكون على مسؤولية الطرفين (المستخدم والمورد)، دون تدخل أو مسؤولية من إدارة التطبيق.\n'
                '● لا يضمن التطبيق مدى صحة الأسعار أو توافر المنتجات في جميع الأوقات.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '4. استخدام البيانات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● يحتفظ التطبيق بالحق في استخدام البيانات المدخلة من قبل المستخدم لتحسين جودة الخدمة وتحليل الاستخدام، دون الكشف عن الهوية الشخصية للمستخدم.\n'
                '● يتم حفظ البيانات بسرية ولن يتم مشاركتها مع أي طرف ثالث دون موافقة المستخدم، باستثناء الحالات القانونية.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '5. التعديلات على الشروط',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'يحتفظ التطبيق بالحق في تعديل هذه الشروط في أي وقت. سيتم إخطار المستخدمين بأي تغييرات كبيرة، ويعتبر استمرار استخدام التطبيق بمثابة موافقة على الشروط الجديدة.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '6. حساب المستخدم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● يتعين على المستخدم إدخال بيانات صحيحة وحديثة عند إنشاء الحساب أو تحديثه.\n'
                '● المستخدم مسؤول بشكل كامل عن الحفاظ على سرية بيانات تسجيل الدخول الخاصة به، وأي استخدام يتم من خلال حسابه يعتبر مسؤولية المستخدم.\n'
                '● يحق للتطبيق إيقاف أو حذف الحسابات التي يتم استخدامها بشكل مخالف للشروط أو التي تتضمن إدخال بيانات مضللة.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '7. المحتوى المُدخل من قبل المستخدم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● يتحمل المستخدم المسؤولية الكاملة عن دقة وصحة البيانات المدخلة، مثل: عدد الكيلومترات، نوع السيارة، أو سجل الإصلاحات.\n'
                '● يحتفظ التطبيق بالحق في حذف أو تعديل أي محتوى يتم إدخاله ويخالف سياسة الاستخدام أو يحتوي على معلومات مضللة أو ضارة.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '8. إشعارات وتذكيرات الصيانة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● يعتمد التطبيق على تنبيهات مبنية على البيانات المدخلة من قبل المستخدم، وبالتالي فإن أي تأخير أو خطأ في الإشعارات لا يعتبر مسؤولية مباشرة على التطبيق.\n'
                '● يجب على المستخدم مراجعة حالة السيارة بشكل دوري وعدم الاعتماد الكلي على التنبيهات الآلية.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                '9. الاستخدام غير المشروع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '● يُمنع استخدام التطبيق لأي أغراض غير قانونية، أو مسيئة، أو مخالفة لحقوق الآخرين، أو قوانين حماية الملكية الفكرية.\n'
                '● يحتفظ التطبيق بحق اتخاذ الإجراءات المناسبة عند مخالفة هذه الشروط، بما في ذلك الحظر أو حذف الحساب نهائيًا.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
