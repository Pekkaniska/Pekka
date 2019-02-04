////////////////////////////////////////////////////////////////////////////////
// Ведомости на выплату зарплаты.
// Расширенные серверные процедуры и функции форм документов.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыФормыРедактированияЗарплатыСтрокиВедомости

Процедура РедактированиеЗарплатыСтрокиНастроитьЭлементы(Форма) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормыБазовый.РедактированиеЗарплатыСтрокиНастроитьЭлементы(Форма);
	
	ПолеСотрудника = Форма.Элементы.ЗарплатаСотрудник;
	
	ПараметрВыбораПоказыватьДоговорниковГПХ = Новый ПараметрВыбора("Отбор.ПоказыватьДоговорниковГПХ", Истина);	
	
	ДобавитьПоказДоговорников = Истина;
	Для Каждого ПараметрВыбора Из ПолеСотрудника.ПараметрыВыбора Цикл
		Если ПараметрВыбора.Имя = ПараметрВыбораПоказыватьДоговорниковГПХ.Имя Тогда
			ПараметрВыбора.Значение = ПараметрВыбораПоказыватьДоговорниковГПХ.Значение;
			ДобавитьПоказДоговорников = Ложь;
			Прервать
		КонецЕсли;	
	КонецЦикла;	
	
	Если ДобавитьПоказДоговорников Тогда
		ПараметрыВыбора = Новый Массив(ПолеСотрудника.ПараметрыВыбора);
		ПараметрыВыбора.Добавить(ПараметрВыбораПоказыватьДоговорниковГПХ);
		ПолеСотрудника.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	КонецЕсли;	
				
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыФормВедомостейНаВыплатуЗаработнойПлаты

#Область ОбработчикиСобытийЭлементовШапкиФормы

Процедура СпособВыплатыПриИзмененииНаСервере(Форма) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.СпособВыплатыПриИзмененииНаСервере(Форма);
	
	ИнформацияОСпособеВыплаты = ВзаиморасчетыССотрудникамиВызовСервераРасширенный.ИнформацияОСпособеВыплаты(Форма.Объект.СпособВыплаты);
	
	Если Форма.ВидДокументаОснования <> ИнформацияОСпособеВыплаты.ПараметрыЗаполнения.ВидДокументаОснования Тогда
		Форма.Объект.Основания.Очистить();
		Форма.ВидДокументаОснования = ИнформацияОСпособеВыплаты.ПараметрыЗаполнения.ВидДокументаОснования;
		ВедомостьНаВыплатуЗарплатыКлиентСерверРасширенный.УстановитьПредставлениеОснований(Форма); 
	КонецЕсли;	
	
	Если Форма.ХарактерВыплаты <> ИнформацияОСпособеВыплаты.ПараметрыЗаполнения.ХарактерВыплаты Тогда
		Форма.ХарактерВыплаты = ИнформацияОСпособеВыплаты.ПараметрыЗаполнения.ХарактерВыплаты;
		ВедомостьНаВыплатуЗарплатыКлиентСерверРасширенный.УстановитьОтображениеВХО(Форма, Ложь, Истина);
	КонецЕсли;	
	
	ЗаполнитьЗначенияСвойств(Форма.Объект, ИнформацияОСпособеВыплаты.ПараметрыРасчета);
	
	УстановитьПредставлениеПараметровРасчета(Форма);
		
КонецПроцедуры

Процедура ПараметрыРасчетаПриИзменении(Форма) Экспорт
	УстановитьПредставлениеПараметровРасчета(Форма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииФорм

// Вызывается при создании формы новой ведомости.
// Выполняет заполнение первоначальных значений реквизитов ведомости в форме.
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура ЗаполнитьПервоначальныеЗначения(Форма) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.ЗаполнитьПервоначальныеЗначения(Форма);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	КонецЕсли;
	
	ИнформацияОСпособеВыплаты = ВзаиморасчетыССотрудникамиВызовСервераРасширенный.ИнформацияОСпособеВыплаты(Форма.Объект.СпособВыплаты);
	
	Если НЕ Форма.Параметры.ЗначенияЗаполнения.Свойство("Округление") ИЛИ НЕ ЗначениеЗаполнено(Форма.Параметры.ЗначенияЗаполнения.Округление) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.Округление", ИнформацияОСпособеВыплаты.ПараметрыРасчета.Округление);
	КонецЕсли;
	Если НЕ Форма.Параметры.ЗначенияЗаполнения.Свойство("ПроцентВыплаты") ИЛИ НЕ ЗначениеЗаполнено(Форма.Параметры.ЗначенияЗаполнения.ПроцентВыплаты) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.ПроцентВыплаты", ИнформацияОСпособеВыплаты.ПараметрыРасчета.ПроцентВыплаты);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при получении формой данных объекта.
// 	Приспосабливаем форму к редактируемым данным.
//
// Параметры:
// 	Форма - УправляемаяФорма.
//	ТекущийОбъект - Объект, который будет прочитан, ДокументОбъект. 
//
Процедура ПриПолученииДанныхНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.ПриПолученииДанныхНаСервере(Форма, ТекущийОбъект);	
	
	ИнформацияОСпособеВыплаты = ВзаиморасчетыССотрудникамиВызовСервераРасширенный.ИнформацияОСпособеВыплаты(Форма.Объект.СпособВыплаты);
	ЗаполнитьЗначенияСвойств(Форма, ИнформацияОСпособеВыплаты.ПараметрыЗаполнения);
	
	ВедомостьНаВыплатуЗарплатыКлиентСерверРасширенный.УстановитьПредставлениеОснований(Форма); 
	УстановитьПредставлениеПараметровРасчета(Форма);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		Форма.Элементы.ОплатыПредставление.Видимость	= Ложь;
		Форма.Элементы.ВнешниеОперацииГруппа.Видимость	= Истина;
		ВедомостьНаВыплатуЗарплатыКлиентСерверРасширенный.УстановитьОтображениеВХО(Форма);
	Иначе	
		Форма.Элементы.ОплатыПредставление.Видимость	= Истина;
		Форма.Элементы.ВнешниеОперацииГруппа.Видимость	= Ложь;
	КонецЕсли;	
	
	ПроверятьЗаполнениеФинансирования = ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях");	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СтатьяФинансирования", 	"АвтоОтметкаНезаполненного", ПроверятьЗаполнениеФинансирования);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СтатьяФинансирования", 	"ОтметкаНезаполненного",     ПроверятьЗаполнениеФинансирования И Не ЗначениеЗаполнено(ТекущийОбъект.СтатьяФинансирования));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СтатьяРасходов", 	"АвтоОтметкаНезаполненного",         ПроверятьЗаполнениеФинансирования);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СтатьяРасходов", 	"ОтметкаНезаполненного",             ПроверятьЗаполнениеФинансирования И Не ЗначениеЗаполнено(ТекущийОбъект.СтатьяРасходов));
	
КонецПроцедуры

Процедура ПриПолученииДанныхСтрокиСостава(Форма, СтрокаСостава) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.ПриПолученииДанныхСтрокиСостава(Форма, СтрокаСостава);
	ПриПолученииДанныхСтрокиСоставаФинансирование(Форма, СтрокаСостава);
КонецПроцедуры	

Процедура ПриПолученииДанныхСтрокиСоставаФинансирование(Форма, СтрокаСостава)

	ПоказыватьСтатьиРасходов		= ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиРасходовЗарплата");
	ПоказыватьСтатьиФинансирования	= ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата");
	
	Если НЕ ПоказыватьСтатьиРасходов И НЕ ПоказыватьСтатьиФинансирования Тогда
		Возврат
	КонецЕсли;
	
	Если ПоказыватьСтатьиФинансирования И ПоказыватьСтатьиРасходов Тогда
		ШаблонРасшифровки = "%1(%2)";
	Иначе
		ШаблонРасшифровки = "%1";
	КонецЕсли;
	
	ПоляСтатей = "СтатьяФинансирования, СтатьяРасходов";
	СочетанияСтатей = Форма.Объект.Зарплата.Выгрузить(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки), ПоляСтатей);
	СочетанияСтатей.Свернуть(ПоляСтатей);
	
	РасшифровкаФинансирования = "";
	Для Индекс = 0 По СочетанияСтатей.Количество()-1 Цикл
		
		Если Индекс = 3 Тогда
			РасшифровкаФинансирования = РасшифровкаФинансирования + "...";
			Прервать
		ИначеЕсли Индекс > 0 Тогда
			РасшифровкаФинансирования = РасшифровкаФинансирования + Символы.ПС;
		КонецЕсли;

		РасшифровкаФинансирования = 
			РасшифровкаФинансирования + 
			СтрШаблон(
				ШаблонРасшифровки,
				ВедомостьНаВыплатуЗарплатыФормыПовтИсп.ПредставленияСтатейФинансирования()[СочетанияСтатей[Индекс].СтатьяФинансирования],
				ВедомостьНаВыплатуЗарплатыФормыПовтИсп.ПредставленияСтатейРасходов()[СочетанияСтатей[Индекс].СтатьяРасходов]);
			
	КонецЦикла;	

	СтрокаСостава.Финансирование = РасшифровкаФинансирования;
	
КонецПроцедуры

// Обработка сообщений пользователю для форм ведомостей.
// 	Привязывает сообщения объекта к полям формы.
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура ОбработатьСообщенияПользователю(Форма) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.ОбработатьСообщенияПользователю(Форма);
	
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	
	Для Каждого Сообщение Из Сообщения Цикл
		Если СтрНайти(Сообщение.Поле, "ПроцентВыплаты") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПараметрыРасчетаИнфо";
		КонецЕсли;
		Если СтрНайти(Сообщение.Поле, "Основания") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ОснованияПредставление";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает доступность элементов формы ведомости.
// 	Документ ввода начальных остатков, или по ведомость, по которой есть выплаты,
// или зарегистрирован перенос даты получения дохода
//	доступны только для просмотра.
//
// Параметры:
// 	Форма - УправляемаяФорма.
//
Процедура УстановитьДоступностьЭлементов(Форма) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.УстановитьДоступностьЭлементов(Форма);
	
	Форма.ТолькоПросмотр = Форма.ТолькоПросмотр 
			Или ЗарплатаКадрыПриложенияВызовСервера.ЕстьПодтверждениеВыплатыДоходовПоВедомости(Форма.Объект.Ссылка);
		
КонецПроцедуры

Процедура ОчиститьНаСервере(Форма) Экспорт
	
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	
	ТекущийОбъект.ОчиститьВыплаты();
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	Форма.ПриПолученииДанныхНаСервере(ТекущийОбъект);	
	
КонецПроцедуры

Процедура УстановитьПредставлениеПараметровРасчета(Форма)
	
	ПараметрыРасчета = 
		Новый Структура(
			"ПроцентВыплаты,
			|Округление",
			Форма.Объект.ПроцентВыплаты,
			Форма.Объект.Округление);
			
	ПредставлениеПараметровРасчета = ПредставлениеПараметровРасчета(ПараметрыРасчета);		
	
	Форма.Элементы.ПараметрыРасчетаГруппа.ЗаголовокСвернутогоОтображения =  ПредставлениеПараметровРасчета;
	
КонецПроцедуры

// Возвращает представление параметров расчета ведомости.
//
// Параметры:
// 	ПараметрыРасчета - Структура - параметры расчета:
//     * ПроцентВыплаты - Число - процент выплаты.
//     * Округление     - СправочникСсылка.СпособыОкругленияПриРасчетеЗарплаты - округление.	
//
Функция ПредставлениеПараметровРасчета(ПараметрыРасчета)
	
	ПредставлениеПараметровРасчета = "";
	
	// Проконтролируем сомнительные настройки.
	Если НЕ ЗначениеЗаполнено(ПараметрыРасчета.ПроцентВыплаты) ИЛИ ПараметрыРасчета.ПроцентВыплаты < 0 Тогда
		ТекстОшибки = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'размер выплаты %1% ?'"), 
				ПараметрыРасчета.ПроцентВыплаты)
	Иначе
		ТекстОшибки = ""
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		ПредставлениеПараметровРасчета = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Внимание. Проверьте настройки расчета: %1'"),  
				ТекстОшибки);
			
	Иначе
	
		// Штатная работа
	
		ПредставлениеПараметровРасчета = 
			СтрШаблон(НСтр("ru = 'Заполнение %1, %2'"),
			ПредставлениеПроцентаВыплаты(ПараметрыРасчета.ПроцентВыплаты),
			ПредставлениеОкругления(ПараметрыРасчета.Округление));
			
	КонецЕсли;
	
	Возврат ПредставлениеПараметровРасчета;
	
КонецФункции

Функция ПредставлениеПроцентаВыплаты(ПроцентВыплаты)
	
	Если ЗначениеЗаполнено(ПроцентВыплаты) И ПроцентВыплаты <> 100 Тогда
		ПредставлениеПроцентаВыплаты = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1% от причитающихся сумм'"),  
				ПроцентВыплаты);
	Иначе
		ПредставлениеПроцентаВыплаты = НСтр("ru = 'всеми причитающимися суммами'")
	КонецЕсли;
	
	Возврат ПредставлениеПроцентаВыплаты
	
КонецФункции

Функция ПредставлениеОкругления(Округление)
	
	Если ЗначениеЗаполнено(Округление) Тогда
		ПредставлениеОкругления = НРег(Округление);
	Иначе
		ПредставлениеОкругления = НСтр("ru = 'без округления'")
	КонецЕсли;
	
	Возврат ПредставлениеОкругления
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти
