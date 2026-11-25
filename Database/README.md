# توثيق قاعدة بيانات تطبيق رفيق رمضان (RamadanCompanionDb)

يستعرض هذا الملف بنية قاعدة البيانات المكوّنة من اثني عشر جدولاً في SQL Server والمرتبطة بالتطبيق عبر ADO.NET، مع توضيح المفاتيح الأساسية والأجنبية والعلاقات والقرارات التصميمية المعتمدة لمطابقة شاشات المستخدم والمشرف.

## 1. الجداول والمفاتيح (PK و FK)

* **Users (المستخدمون):** يحفظ بيانات الحسابات، البريد الإلكتروني، كلمة المرور المشفرة، الصلاحية (Role)، اللغة المفضلة، حالة الحساب، وتواريخ الإنشاء وآخر دخول.
  * PK: `UserId`
  * FK: لا يوجد

* **UserSettings (إعدادات المستخدم):** يحفظ إعدادات الموقع الجغرافي (البلد والمدينة)، طريقة حساب المواقيت، وتعديل التاريخ الهجري لكل مستخدم.
  * PK: `UserId`
  * FK: `UserId` -> `Users(UserId)` (يجمع العمود بين المفتاح الأساسي والأجنبي لتحقيق علاقة واحد لواحد وضمان وجود سجل إعدادات واحد لكل مستخدم)

* **ReminderTypes (أنواع التذكيرات):** جدول مرجعي يحدد أنواع التذكيرات المتاحة وقيمها الافتراضية (التفعيل، الإزاحة الزمنية أو الوقت الثابت، وتشغيل الصوت).
  * PK: `ReminderTypeId`
  * FK: لا يوجد

* **NotificationSettings (إعدادات التذكيرات):** يحفظ التخصيص الفعلي للتذكيرات لكل مستخدم ونوع تذكير، مع منع التكرار عبر قيد UNIQUE على `(UserId, ReminderTypeId)`.
  * PK: `NotificationSettingId`
  * FK: `UserId` -> `Users(UserId)`، و `ReminderTypeId` -> `ReminderTypes(ReminderTypeId)`

* **RamadanSeasons (مواسم رمضان):** يحفظ بيانات كل موسم رمضاني من حيث السنة الهجرية (فريدة UNIQUE)، تاريخ البداية، وعدد أيام الموسم.
  * PK: `SeasonId`
  * FK: لا يوجد

* **FastMissReasons (أسباب عدم الصيام):** جدول مرجعي يضم أسباب عدم الصيام لربطها بالسجل اليومي عند الحاجة.
  * PK: `FastMissReasonId`
  * FK: لا يوجد

* **DailyDuas (الأدعية اليومية):** يحفظ الأدعية المخصصة لكل يوم من أيام موسم رمضاني محدد (مع قيد UNIQUE على `(SeasonId, RamadanDay)`).
  * PK: `DuaId`
  * FK: `SeasonId` -> `RamadanSeasons(SeasonId)`

* **QuranPlans (خطط الختمة):** يحفظ خطط ختم القرآن لكل مستخدم في موسم معين، بما في ذلك عدد الختمات المستهدفة والمنجزة، آخر صفحة، ويوم البدء (مع قيد UNIQUE على `(UserId, SeasonId)`).
  * PK: `PlanId`
  * FK: `UserId` -> `Users(UserId)`، و `SeasonId` -> `RamadanSeasons(SeasonId)`

* **QuranReadingLogs (سجل القراءة):** يحفظ جلسات القراءة اليومية ضمن خطة ختمة محددة (من صفحة إلى صفحة)، مع عمود محسوب تلقائياً لعدد الصفحات `PagesCount`.
  * PK: `ReadingLogId`
  * FK: `PlanId` -> `QuranPlans(PlanId)`

* **DailyWorshipLogs (سجل العبادات اليومية):** يحفظ سجل العبادات اليومية لكل مستخدم في كل يوم من الموسم (الصيام، صلوات الجماعة، التراويح، القيام، النوافل، الأذكار، والصدقة)، مع قيد UNIQUE على `(UserId, SeasonId, RamadanDay)`.
  * PK: `WorshipLogId`
  * FK: `UserId` -> `Users(UserId)`، و `SeasonId` -> `RamadanSeasons(SeasonId)`، و `FastMissReasonId` -> `FastMissReasons(FastMissReasonId)`

* **Goals (الأهداف):** يحفظ الأهداف الشخصية للمستخدم في موسم محدد (يومية أو تراكمية)، ووحدة القياس، والقيمة المستهدفة، وحالة الأرشفة.
  * PK: `GoalId`
  * FK: `UserId` -> `Users(UserId)`، و `SeasonId` -> `RamadanSeasons(SeasonId)`

* **GoalProgress (تقدم الأهداف):** يحفظ القيمة المحققة لكل هدف في كل يوم من أيام رمضان، مع قيد UNIQUE على `(GoalId, RamadanDay)`.
  * PK: `ProgressId`
  * FK: `GoalId` -> `Goals(GoalId)`

## 2. ارتباط الجداول بـ Users و RamadanSeasons

* **الجداول المرتبطة بـ Users:** `UserSettings`، `NotificationSettings`، `QuranPlans`، `DailyWorshipLogs`، و `Goals`.
* **الجداول المرتبطة بـ RamadanSeasons:** `DailyDuas`، `QuranPlans`، `DailyWorshipLogs`، و `Goals`.

## 3. قرار عمود Role في جدول Users

* **التعريف المعتمد:** `Role NVARCHAR(10) NOT NULL DEFAULT 'User'` مع قيد تحقق `CHECK (Role IN ('User', 'Admin'))`.
* **المبرر التصميمي:** يُستخدم للتمييز بين المستخدم العادي (`'User'`) والمشرف (`'Admin'`)؛ بحيث يُمنح أي حساب جديد صلاحية `'User'` افتراضياً، بينما يتيح حساب المشرف الوصول إلى لوحة إدارة المشرف في التطبيق.

## 4. أسباب ربط السجلات اليومية بـ SeasonId و RamadanDay بدلاً من التاريخ الميلادي

* يرتبط شهر رمضان بالتقويم الهجري، ويتغير تاريخ بدايته في التقويم الميلادي من عام لآخر، كما قد يختلف دخول الشهر بين المواسم أو المناطق.
* ربط السجلات اليومية بـ `SeasonId` مع `RamadanDay` (من `1` إلى `30`) يجعل رقم اليوم الرمضاني ثابتاً وواضحاً داخل كل موسم، ويبسّط تتبع الأيام، وحساب الإحصائيات والسلاسل، ومقارنة تقدم المستخدم عبر مواسم رمضان المختلفة.

