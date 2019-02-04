#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт

	//++ Локализация
	СписокОбъектов.Добавить(Документы.ВнесениеДенежныхСредствВКассуККМ);
	СписокОбъектов.Добавить(Документы.ВозвратПодарочныхСертификатов);
	СписокОбъектов.Добавить(Документы.ВыемкаДенежныхСредствИзКассыККМ);
	СписокОбъектов.Добавить(Документы.ЗаписьКнигиПокупок);
	СписокОбъектов.Добавить(Документы.ЗаписьКнигиПродаж);
	СписокОбъектов.Добавить(Документы.ЗаявлениеОВвозеТоваров);	
	СписокОбъектов.Добавить(Документы.ОперацияПоЯндексКассе);
	СписокОбъектов.Добавить(Документы.ЧекККМ);
	СписокОбъектов.Добавить(Документы.ЧекККМВозврат);
	
	СписокОбъектов.Добавить(Справочники.ПодарочныеСертификаты);
	
	//++ НЕ УТ
	ЗарплатаКадры.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	РегламентированнаяОтчетность.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	
	СписокОбъектов.Добавить(Документы.АвансовыйПлатежИностранцаПоНДФЛ);
	СписокОбъектов.Добавить(Документы.АктПроверкиСтраховыхВзносов);
	СписокОбъектов.Добавить(Документы.АмортизацияНМА);
	СписокОбъектов.Добавить(Документы.АмортизацияНМА2_4);
	СписокОбъектов.Добавить(Документы.АмортизацияОС);
	СписокОбъектов.Добавить(Документы.АмортизацияОС2_4);
	СписокОбъектов.Добавить(Документы.БольничныйЛист);
	СписокОбъектов.Добавить(Документы.БронированиеГражданПребывающихВЗапасе);
	СписокОбъектов.Добавить(Документы.ВводНачальныхОстатковОтпусков);
	СписокОбъектов.Добавить(Документы.ВводОстатковВнеоборотныхАктивов);
	СписокОбъектов.Добавить(Документы.ВводОстатковВнеоборотныхАктивов2_4);
	СписокОбъектов.Добавить(Документы.ВедомостьНаВыплатуЗарплатыВБанк);
	СписокОбъектов.Добавить(Документы.ВедомостьНаВыплатуЗарплатыВКассу);
	СписокОбъектов.Добавить(Документы.ВедомостьНаВыплатуЗарплатыПеречислением);
	СписокОбъектов.Добавить(Документы.ВедомостьНаВыплатуЗарплатыРаздатчиком);
	СписокОбъектов.Добавить(Документы.ВедомостьУплатыАДВ_11);
	СписокОбъектов.Добавить(Документы.ВозвратИзОтпускаПоУходуЗаРебенком);
	СписокОбъектов.Добавить(Документы.ВозвратМатериаловИзПроизводства);
	СписокОбъектов.Добавить(Документы.ВозвратНДФЛ);
	СписокОбъектов.Добавить(Документы.ВозвратОСОтАрендатора);
	СписокОбъектов.Добавить(Документы.ВозвратОСОтАрендатора2_4);
	СписокОбъектов.Добавить(Документы.ВозвратСырьяОтПереработчика);
	СписокОбъектов.Добавить(Документы.ВходящаяСправкаОЗаработкеДляРасчетаПособий);
	СписокОбъектов.Добавить(Документы.ВыбытиеАрендованныхОС);
	СписокОбъектов.Добавить(Документы.ВыбытиеДенежныхДокументов);
	СписокОбъектов.Добавить(Документы.ВыплатаБывшимСотрудникам);
	СписокОбъектов.Добавить(Документы.ВыпускПродукции);
	СписокОбъектов.Добавить(Документы.ВыработкаНМА);
	СписокОбъектов.Добавить(Документы.ГрафикОтпусков);
	СписокОбъектов.Добавить(Документы.ДанныеДляРасчетаЗарплаты);
	СписокОбъектов.Добавить(Документы.ДепонированиеЗарплаты);
	СписокОбъектов.Добавить(Документы.ДоговорАвторскогоЗаказа);
	СписокОбъектов.Добавить(Документы.ДоговорЗаймаСотруднику);
	СписокОбъектов.Добавить(Документы.ДоговорРаботыУслуги);
	СписокОбъектов.Добавить(Документы.ПервичныйДокумент);
	СписокОбъектов.Добавить(Документы.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.ДоходВНатуральнойФорме);
	СписокОбъектов.Добавить(Документы.ЕдиновременноеПособиеЗаСчетФСС);
	СписокОбъектов.Добавить(Документы.ЗаписьКУДиР);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников);
	СписокОбъектов.Добавить(Документы.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов);
	СписокОбъектов.Добавить(Документы.ЗаявлениеВФССОВозмещенииРасходовНаПогребение);
	СписокОбъектов.Добавить(Документы.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ);
	СписокОбъектов.Добавить(Документы.ЗаявлениеСотрудникаНаВыплатуПособия);
	СписокОбъектов.Добавить(Документы.ИзменениеАванса);
	СписокОбъектов.Добавить(Документы.ИзменениеГрафикаРаботыСписком);
	СписокОбъектов.Добавить(Документы.ИзменениеКвалификационногоРазряда);
	СписокОбъектов.Добавить(Документы.ИзменениеОплатыТруда);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНМА2_4);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровОС);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровОС2_4);
	СписокОбъектов.Добавить(Документы.ИзменениеПлановыхНачислений);
	СписокОбъектов.Добавить(Документы.ИзменениеСостоянияОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособаОтраженияИмущественныхНалогов);
	СписокОбъектов.Добавить(Документы.ИзменениеУсловийДоговораЗаймаСотруднику);
	СписокОбъектов.Добавить(Документы.ИзменениеУсловийИсполнительногоЛиста);
	СписокОбъектов.Добавить(Документы.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком);
	СписокОбъектов.Добавить(Документы.ИзменениеШтатногоРасписания);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНМА);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияРасчетов);
	СписокОбъектов.Добавить(Документы.ИндексацияЗаработка);
	СписокОбъектов.Добавить(Документы.ИндексацияШтатногоРасписания);
	СписокОбъектов.Добавить(Документы.ИндивидуальныйГрафик);
	СписокОбъектов.Добавить(Документы.ИсполнительныйЛист);
	СписокОбъектов.Добавить(Документы.ИсходящаяСправкаОЗаработкеДляРасчетаПособий);
	СписокОбъектов.Добавить(Документы.КадровыйПеревод);
	СписокОбъектов.Добавить(Документы.КадровыйПереводСписком);
	СписокОбъектов.Добавить(Документы.КнигаПокупокДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.КнигаПродажДляПередачиВЭлектронномВиде);
	СписокОбъектов.Добавить(Документы.Командировка);
	СписокОбъектов.Добавить(Документы.КомандировкиСотрудников);
	СписокОбъектов.Добавить(Документы.КонтролируемаяСделка);
	СписокОбъектов.Добавить(Документы.ЛистокСообщенияДляВоенкомата);
	СписокОбъектов.Добавить(Документы.МатериальнаяПомощь);
	СписокОбъектов.Добавить(Документы.МодернизацияОС);
	СписокОбъектов.Добавить(Документы.МодернизацияОС2_4);
	СписокОбъектов.Добавить(Документы.НачальнаяЗадолженностьПоЗарплате);
	СписокОбъектов.Добавить(Документы.НачальнаяШтатнаяРасстановка);
	СписокОбъектов.Добавить(Документы.НачислениеДивидендов);
	СписокОбъектов.Добавить(Документы.НачислениеЗаПервуюПоловинуМесяца);
	СписокОбъектов.Добавить(Документы.НачислениеЗарплаты);
	СписокОбъектов.Добавить(Документы.НачислениеОценочныхОбязательствПоОтпускам);
	СписокОбъектов.Добавить(Документы.ОперацияБух);
	СписокОбъектов.Добавить(Документы.ОперацияНалоговогоУчетаПоНДФЛ);
	СписокОбъектов.Добавить(Документы.ОперацияУчетаПоСтраховымВзносам);
	СписокОбъектов.Добавить(Документы.ОписьЗаявленийСотрудниковНаВыплатуПособий);
	СписокОбъектов.Добавить(Документы.ОписьПачекСЗВ_6);
	СписокОбъектов.Добавить(Документы.ОплатаДнейУходаЗаДетьмиИнвалидами);
	СписокОбъектов.Добавить(Документы.ОплатаПоСреднемуЗаработку);
	СписокОбъектов.Добавить(Документы.Отгул);
	СписокОбъектов.Добавить(Документы.ОтменаБронированияГражданПребывающихВЗапасе);
	СписокОбъектов.Добавить(Документы.ОтменаДоплатыДоСреднегоЗаработка);
	СписокОбъектов.Добавить(Документы.ОтменаРегистрацииЗемельныхУчастков);
	СписокОбъектов.Добавить(Документы.ОтменаРегистрацииТранспортныхСредств);
	СписокОбъектов.Добавить(Документы.ОтменаСовмещения);
	СписокОбъектов.Добавить(Документы.Отпуск);
	СписокОбъектов.Добавить(Документы.ОтпускаСотрудников);
	СписокОбъектов.Добавить(Документы.ОтпускБезСохраненияОплаты);
	СписокОбъектов.Добавить(Документы.ОтпускПоУходуЗаРебенком);
	СписокОбъектов.Добавить(Документы.ОтражениеЗарплатыВФинансовомУчете);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовАДВ_1);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовАДВ_2);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовАДВ_3);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовДСВ_1);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовСЗВ_6_1);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовСЗВ_6_3);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовСЗВ_6_4);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовСЗВ_К);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовСПВ_1);
	СписокОбъектов.Добавить(Документы.ПачкаДокументовСПВ_2);
	СписокОбъектов.Добавить(Документы.ПачкаРазделов6РасчетаРСВ_1);
	СписокОбъектов.Добавить(Документы.ПереводКДругомуРаботодателю);
	СписокОбъектов.Добавить(Документы.ПередачаОСАрендатору);
	СписокОбъектов.Добавить(Документы.ПередачаОСАрендатору2_4);
	СписокОбъектов.Добавить(Документы.ПеремещениеВДругоеПодразделение);
	СписокОбъектов.Добавить(Документы.ПеремещениеВЭксплуатации);
	СписокОбъектов.Добавить(Документы.ПеремещениеМатериаловВПроизводстве);
	СписокОбъектов.Добавить(Документы.ПеремещениеМеждуТерриториями);
	СписокОбъектов.Добавить(Документы.ПеремещениеНМА2_4);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС2_4);
	СписокОбъектов.Добавить(Документы.ПереносДанных);
	СписокОбъектов.Добавить(Документы.ПереносОтпуска);
	СписокОбъектов.Добавить(Документы.ПереоценкаНМА);
	СписокОбъектов.Добавить(Документы.ПереоценкаНМА2_4);
	СписокОбъектов.Добавить(Документы.ПереоценкаОС);
	СписокОбъектов.Добавить(Документы.ПереоценкаОС2_4);
	СписокОбъектов.Добавить(Документы.ПерерасчетНДФЛ);
	СписокОбъектов.Добавить(Документы.ПерерасчетСтраховыхВзносов);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеНМА);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеНМА2_4);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеОС);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеОС2_4);
	СписокОбъектов.Добавить(Документы.ПодтверждениеЗачисленияЗарплаты);
	СписокОбъектов.Добавить(Документы.ПодтверждениеОткрытияЛицевыхСчетовСотрудников);
	СписокОбъектов.Добавить(Документы.ПостоянноеУдержаниеВПользуТретьихЛиц);
	СписокОбъектов.Добавить(Документы.ПоступлениеАрендованныхОС);
	СписокОбъектов.Добавить(Документы.ПоступлениеДенежныхДокументов);
	СписокОбъектов.Добавить(Документы.ПоступлениеОтПереработчика);
	СписокОбъектов.Добавить(Документы.ПоступлениеПредметовЛизинга);
	СписокОбъектов.Добавить(Документы.ПрекращениеСтандартныхВычетовНДФЛ);
	СписокОбъектов.Добавить(Документы.Премия);
	СписокОбъектов.Добавить(Документы.ПриемНаРаботу);
	СписокОбъектов.Добавить(Документы.ПриемНаРаботуСписком);
	СписокОбъектов.Добавить(Документы.ПризПодарок);
	СписокОбъектов.Добавить(Документы.ПриказНаДоплатуДоСреднегоЗаработка);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуНМА);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуНМА2_4);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуОС);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуОС2_4);
	СписокОбъектов.Добавить(Документы.ПриобретениеУслугПоЛизингу);
	СписокОбъектов.Добавить(Документы.ПрогулНеявка);
	СписокОбъектов.Добавить(Документы.ПродлениеКонтрактаДоговора);
	СписокОбъектов.Добавить(Документы.ПроизводствоБезЗаказа);
	СписокОбъектов.Добавить(Документы.ПростойСотрудников);
	СписокОбъектов.Добавить(Документы.РаботаВВыходныеИПраздничныеДни);
	СписокОбъектов.Добавить(Документы.РаботаСверхурочно);
	СписокОбъектов.Добавить(Документы.РазовоеНачисление);
	СписокОбъектов.Добавить(Документы.РаспределениеОсновногоЗаработка);
	СписокОбъектов.Добавить(Документы.РеестрДСВ_3);
	СписокОбъектов.Добавить(Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий);
	СписокОбъектов.Добавить(Документы.РеестрСЗВ_6_2);
	СписокОбъектов.Добавить(Документы.РегистрацияЗемельныхУчастков);
	СписокОбъектов.Добавить(Документы.РегистрацияПереработок);
	СписокОбъектов.Добавить(Документы.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество);
	СписокОбъектов.Добавить(Документы.РегистрацияПрочихДоходов);
	СписокОбъектов.Добавить(Документы.РегистрацияПрочихКонтролируемыхСделок);
	СписокОбъектов.Добавить(Документы.РегистрацияТранспортныхСредств);
	СписокОбъектов.Добавить(Документы.Совмещение);
	СписокОбъектов.Добавить(Документы.СписаниеИзЭксплуатации);
	СписокОбъектов.Добавить(Документы.СписаниеНМА);
	СписокОбъектов.Добавить(Документы.СписаниеНМА2_4);
	СписокОбъектов.Добавить(Документы.СписаниеОС);
	СписокОбъектов.Добавить(Документы.СписаниеОС2_4);
	СписокОбъектов.Добавить(Документы.СправкаНДФЛ);
	СписокОбъектов.Добавить(Документы.СправкаОПодтверждающихДокументах);
	СписокОбъектов.Добавить(Документы.СправкиНДФЛДляПередачиВНалоговыйОрган);
	СписокОбъектов.Добавить(Документы.СправкиПоНДФЛДляРасчетаПоНалогуНаПрибыль);
	СписокОбъектов.Добавить(Документы.СторнированиеНачислений);
	СписокОбъектов.Добавить(Документы.ТабельУчетаРабочегоВремени);
	СписокОбъектов.Добавить(Документы.УведомлениеОПравеНаИмущественныйВычетДляНДФЛ);
	СписокОбъектов.Добавить(Документы.Увольнение);
	СписокОбъектов.Добавить(Документы.УвольнениеСписком);
	СписокОбъектов.Добавить(Документы.УдержаниеВСчетРасчетовПоПрочимОперациям);
	СписокОбъектов.Добавить(Документы.УдержаниеДобровольныхВзносовВНПФ);
	СписокОбъектов.Добавить(Документы.УдержаниеДобровольныхСтраховыхВзносов);
	СписокОбъектов.Добавить(Документы.УдержаниеПрофсоюзныхВзносов);
	СписокОбъектов.Добавить(Документы.УтверждениеТарифнойСетки);
	СписокОбъектов.Добавить(Документы.УтверждениеШтатногоРасписания);
	СписокОбъектов.Добавить(Документы.ХодатайствоОБронированииГражданПребывающихВЗапасе);
	
	СписокОбъектов.Добавить(ПланыСчетов.Хозрасчетный);
	
	СписокОбъектов.Добавить(Справочники.ДоверенностиНалогоплательщика);
	СписокОбъектов.Добавить(Справочники.ДоговорыЛизинга);
	СписокОбъектов.Добавить(Справочники.Сотрудники);
	СписокОбъектов.Добавить(Справочники.Субконто);
	СписокОбъектов.Добавить(Справочники.ШтатноеРасписание);
	//++ НЕ УТКА
	СписокОбъектов.Добавить(Документы.АмортизацияНМАМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.АмортизацияОСМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ВводОстатковНМАМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ВводОстатковОСМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНМАМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровОСМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.МаршрутныйЛистПроизводства);
	СписокОбъектов.Добавить(Документы.ОперацияМеждународный);
	СписокОбъектов.Добавить(Документы.ПереводОсновныхСредствИнвестиционногоИмуществаМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ПеремещениеНМАМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ПеремещениеОСМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуНМАМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуОСМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.СписаниеНМАМеждународныйУчет);
	СписокОбъектов.Добавить(Документы.СписаниеОСМеждународныйУчет);	
	//-- НЕ УТКА
	//-- НЕ УТ	

	// Интеграция ЕГАИС
	СписокОбъектов.Добавить(Документы.АктПостановкиНаБалансЕГАИС);
	СписокОбъектов.Добавить(Документы.АктСписанияЕГАИС);
	СписокОбъектов.Добавить(Документы.ВозвратИзРегистра2ЕГАИС);
	СписокОбъектов.Добавить(Документы.ЗапросАкцизныхМарокЕГАИС);
	СписокОбъектов.Добавить(Документы.ОстаткиЕГАИС);
	СписокОбъектов.Добавить(Документы.ОтчетЕГАИС);
	СписокОбъектов.Добавить(Документы.ПередачаВРегистр2ЕГАИС);
	СписокОбъектов.Добавить(Документы.ЧекЕГАИС);
	СписокОбъектов.Добавить(Документы.ЧекЕГАИСВозврат);
	СписокОбъектов.Добавить(Документы.ТТНИсходящаяЕГАИС);
	СписокОбъектов.Добавить(Документы.ТТНВходящаяЕГАИС);
	СписокОбъектов.Добавить(Обработки.ПечатьРазделаБСправкиТТН);
	
	//++ВЕТИС
	СписокОбъектов.Добавить(Справочники.ВетеринарноСопроводительныйДокументВЕТИС);
	СписокОбъектов.Добавить(Документы.ВходящаяТранспортнаяОперацияВЕТИС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияПродукцииВЕТИС);
	СписокОбъектов.Добавить(Документы.ИсходящаяТранспортнаяОперацияВЕТИС);
	СписокОбъектов.Добавить(Документы.ЗапросСкладскогоЖурналаВЕТИС);
	СписокОбъектов.Добавить(Документы.ПроизводственнаяОперацияВЕТИС);
	//--ВЕТИС
	
	//++ГИСМ
	СписокОбъектов.Добавить(Документы.ПеремаркировкаТоваровГИСМ);
	СписокОбъектов.Добавить(Документы.МаркировкаТоваровГИСМ);
	//--ГИСМ
	
	УчетНДСУП.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	//-- Локализация
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	Если ИмяФормы = "Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента"
		ИЛИ ИмяФормы = "Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаСписка"
		ИЛИ ИмяФормы = "Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаСпискаДокументов" Тогда
		
		Если ПраваПользователяПовтИсп.ПечатьЭтикетокИЦенников() Тогда
			СтандартнаяОбработка = Ложь;
			
			КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
			
			КомандаПечати = КоллекцияКомандПечати.Добавить();
			КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьАкцизныхМарок";
			КомандаПечати.Идентификатор = "АкцизныеМарки";
			КомандаПечати.Представление = НСтр("ru = 'Печать акцизных марок'");
			КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
			
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		КонецЕсли;
		
	КонецЕсли;
	
	УчетНДСУП.ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка);	
	//-- Локализация
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// см. УправлениеПечатьюПереопределяемый.ПриПолученииНастроекСпискаКомандПечати()
//
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	ЗарплатаКадры.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти