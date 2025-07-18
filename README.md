# المكتبة الطقسية - Coptic Liturgy Library

تطبيق للقراءات والصلوات القبطية باللغتين العربية والقبطية.

## نظرة عامة

هذا التطبيق يوفر مكتبة للنصوص الطقسية القبطية، بما في ذلك القداسات والتسبحة والقراءات والأجبية. يتيح التطبيق للمستخدمين قراءة النصوص باللغتين العربية والقبطية، مع إمكانية تغيير حجم الخط والتبديل بين الوضع الليلي والنهاري.

## الميزات

- عرض النصوص الطقسية باللغتين العربية والقبطية
- وضع ليلي/نهاري
- تغيير حجم الخط
- البحث في النصوص
- واجهة مستخدم سهلة الاستخدام

## البنية التقنية

تم تطوير التطبيق باستخدام Flutter مع اتباع مبادئ Clean Architecture لضمان قابلية الصيانة والاختبار والتوسع. تتكون البنية من الطبقات التالية:

### 1. طبقة العرض (Presentation Layer)

- **Pages**: واجهات المستخدم الرئيسية
- **Widgets**: مكونات واجهة المستخدم القابلة لإعادة الاستخدام
- **Blocs**: إدارة حالة التطبيق (باستخدام Provider)

### 2. طبقة المجال (Domain Layer)

- **Entities**: الكيانات الأساسية للتطبيق
- **Repositories**: واجهات للتعامل مع البيانات
- **Use Cases**: حالات الاستخدام التي تنفذ منطق الأعمال

### 3. طبقة البيانات (Data Layer)

- **Models**: نماذج البيانات التي تمثل الكيانات
- **Repositories**: تنفيذات واجهات المستودعات
- **Data Sources**: مصادر البيانات (محلية أو بعيدة)

### 4. طبقة الأساسيات (Core Layer)

- **Theme**: تعريفات السمات والألوان
- **Utils**: أدوات مساعدة وثوابت

## التثبيت

1. تأكد من تثبيت Flutter SDK
2. استنسخ المستودع
3. قم بتثبيت التبعيات:
   ```
   flutter pub get
   ```
4. قم بتشغيل التطبيق:
   ```
   flutter run
   ```

## المساهمة

نرحب بالمساهمات! إذا كنت ترغب في المساهمة، يرجى اتباع الخطوات التالية:

1. افتح issue لمناقشة التغيير الذي ترغب في إجرائه
2. قم بعمل fork للمستودع
3. قم بإنشاء فرع جديد للميزة الخاصة بك
4. قم بإرسال طلب سحب