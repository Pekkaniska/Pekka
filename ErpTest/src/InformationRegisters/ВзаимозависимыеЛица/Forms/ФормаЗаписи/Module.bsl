#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
  	Если Параметры.Свойство("АвтоТест") Тогда
   		Возврат;
  	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	ЗаполнитьЗначенияСвойств(Запись, Параметры.ЗначенияЗаполнения);
	
	Если Параметры.ЗначенияЗаполнения.Свойство("Организация") Тогда 
		Элементы.Организация.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ДоступностьКлючевыхЗаписей = Истина;
	Если Параметры.Свойство("ДоступностьКлючевыхЗаписей") Тогда
		ДоступностьКлючевыхЗаписей = Параметры.ДоступностьКлючевыхЗаписей;
	КонецЕсли;
	
	ЭтаФорма.Элементы.Организация.ТолькоПросмотр 	= НЕ ДоступностьКлючевыхЗаписей;
	ЭтаФорма.Элементы.Контрагент.ТолькоПросмотр 	= НЕ ДоступностьКлючевыхЗаписей И ЗначениеЗаполнено(Запись.Контрагент);
	ЭтаФорма.Элементы.ВзаимозависимоеЛицоЯвляетсяОрганизацией.ТолькоПросмотр = ЭтаФорма.Элементы.Контрагент.ТолькоПросмотр;
	ЭтаФорма.Элементы.ТипВзаимозависимости.АвтоОтметкаНезаполненного = НЕ ДоступностьКлючевыхЗаписей;
	
	КонтролируемыеСделки.ЗаполнитьСписокГоловныхОрганизаций(Элементы.Организация.СписокВыбора);
	
	СписокКодовВидовДеятельностиФизЛиц = КонтролируемыеСделкиПовтИсп.ПолучитьКодыВидовДеятельностиФизЛиц();
	Элементы.ЗаписьДанныхКонтрагентаКодВидаДеятельностиФизическогоЛица.СписокВыбора.Очистить();
	Для Каждого Код Из СписокКодовВидовДеятельностиФизЛиц Цикл
		НовыйКод = Элементы.ЗаписьДанныхКонтрагентаКодВидаДеятельностиФизическогоЛица.СписокВыбора.Добавить();	
		ЗаполнитьЗначенияСвойств(НовыйКод, Код);
	КонецЦикла;
	
	ВзаимозависимоеЛицоЯвляетсяОрганизацией = ?(ЗначениеЗаполнено(Запись.Контрагент),
												ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.Организации"),
												Ложь);
												
	ИзменитьПараметрыАналитики(ВзаимозависимоеЛицоЯвляетсяОрганизацией,
								Элементы.Контрагент,
								Запись.Организация);
	
	ОбновитьДанныеКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "УчастникКонтролируемойСделкиЗаписан" Тогда
		ОбновитьДанныеКонтрагента(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("Контрагент", Запись.Контрагент);
	ПараметрОповещения.Вставить("Организация", Запись.Организация);
	ПараметрОповещения.Вставить("Период", Запись.Период);
	ПараметрОповещения.Вставить("ТипВзаимозависимости", Запись.ТипВзаимозависимости);
	
	Оповестить("ВзаимозависимыеЛица_Записан", ПараметрОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура ВзаимозависимоеЛицоЯвляетсяОрганизациейПриИзменении(Элемент)
	
	ИзменитьПараметрыАналитики(ВзаимозависимоеЛицоЯвляетсяОрганизацией,
								Элементы.Контрагент,
								Запись.Организация);
								
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ОбновитьДанныеКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОРегистрацииНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Запись.Контрагент) Тогда
		ПоказатьЗначение(, Запись.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОбновитьДанныеКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИсторияИзмененийУчетнойПолитикиКонтрагентаНажатие(Элемент)
	ПараметрыОткрытия = Новый Структура("Контрагент, Период", Запись.Контрагент, Запись.Период);
	ОткрытьФорму("РегистрСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.ФормаСписка", ПараметрыОткрытия, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИзменениеУчетнойПолитикиКонтрагентаНажатие(Элемент)
	ПериодФормыЗаписи = ?(ЗначениеЗаполнено(ЗаписьДанныхКонтрагента.Период), ЗаписьДанныхКонтрагента.Период, Запись.Период);
	ПараметрыОткрытия = ПараметрыОткрытияУчетнойПолитикиКонтрагентов(Запись.Контрагент, ПериодФормыЗаписи);
	ОткрытьФорму("РегистрСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.ФормаЗаписи", ПараметрыОткрытия, Элемент,
				Ложь, ВариантОткрытияОкна.ОтдельноеОкно, , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаДействияУчетнойПолитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ЗаписьДанныхКонтрагента.Период) Тогда
		ДатаНачалаДействияУчетнойПолитики = Запись.Период;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПараметрыОткрытияУчетнойПолитикиКонтрагентов(Контрагент, Период)
	Возврат(РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.ПолучитьПараметрыОткрытияФормыЗаписиКонтрагента(Контрагент, Период));
КонецФункции

&НаСервере
Процедура ОбновитьДанныеКонтрагента(ОбновлятьДанныеПоВзаимозависимости = Истина)
	
	ДанныеПоВзаимозависимости = ОбновитьДанныеПоВзаимозависимости(Запись.Организация, Запись.Контрагент, Запись.Период);
	СведенияДействуютПо = ДанныеПоВзаимозависимости.СведенияДействуютПо;
	Если ОбновлятьДанныеПоВзаимозависимости Тогда
		ЗаполнитьЗначенияСвойств(Запись, ДанныеПоВзаимозависимости);
	КонецЕсли;
	
	ВзаимозависимоеЛицоКонтрагентИОнУказан = ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.Контрагенты") И ЗначениеЗаполнено(Запись.Контрагент);
	
	Если ВзаимозависимоеЛицоКонтрагентИОнУказан Тогда
		
		Период = Неопределено;
		Параметры.Свойство("ПериодДанныхКонтрагента", Период);
		Период = ?(ЗначениеЗаполнено(Период), Период, Запись.Период);
		Отбор = Новый Структура("Контрагент", Запись.Контрагент);
		
		ВыборкаУчетнойПолитикиКонтрагента = РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.Выбрать(, Период, Отбор, "Убыв");
		Если ВыборкаУчетнойПолитикиКонтрагента.Следующий() Тогда
			ЗначениеВРеквизитФормы(ВыборкаУчетнойПолитикиКонтрагента.ПолучитьМенеджерЗаписи(), "ЗаписьДанныхКонтрагента");
		Иначе
			ЗаписьДанныхКонтрагента.Контрагент = Запись.Контрагент;
			ЗаписьДанныхКонтрагента.Период = Запись.Период;
			ЗаписьДанныхКонтрагента.ЯвляетсяПлательщикомЕНВД = Ложь;
			ЗаписьДанныхКонтрагента.ЯвляетсяПлательщикомНалогаНаПрибыль = Ложь;
			ЗаписьДанныхКонтрагента.ЯвляетсяПлательщикомНДПИ = Ложь;
			ЗаписьДанныхКонтрагента.ЯвляетсяПлательщикомЕСХН = Ложь;
			ЗаписьДанныхКонтрагента.ЗарегистрированВОЭЗ = Ложь;
			ЗаписьДанныхКонтрагента.КодВидаДеятельностиФизическогоЛица = "";
		КонецЕсли;
		
		ВыборкаУчетнойПолитикиКонтрагента = РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.Выбрать(Период+1, , Отбор, "Возр");
		Если ВыборкаУчетнойПолитикиКонтрагента.Следующий() Тогда
			ДатаОкончанияДействия = Формат(НачалоДня(ВыборкаУчетнойПолитикиКонтрагента.Период - 1),"ДЛФ=D");
			ДатаОкончанияДействияУчетнойПолитики = НСтр("ru = 'по %ДатаОкончанияДействия%'");
			ДатаОкончанияДействияУчетнойПолитики = СтрЗаменить(ДатаОкончанияДействияУчетнойПолитики, "%ДатаОкончанияДействия%", ДатаОкончанияДействия);
		Иначе
			ДатаОкончанияДействияУчетнойПолитики = НСтр("ru = 'по настоящее время'");
		КонецЕсли;
		СведенияДействуютПоУчетнойПолитики = ДатаОкончанияДействияУчетнойПолитики;
		
		ЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Контрагент, "ЮрФизЛицо");
		ЭтоФизЛицо = ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;
		
	Иначе
		
		ЗначениеВРеквизитФормы(РегистрыСведений.ДанныеПоКонтрагентамКонтролируемыхСделок.СоздатьМенеджерЗаписи(), "ЗаписьДанныхКонтрагента");		
		ЭтоФизЛицо = Ложь;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.Контрагент) Тогда
		
		СтранаРегистрации	   = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Контрагент, "СтранаРегистрации");
		Если Не ЗначениеЗаполнено(СтранаРегистрации) И ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
			СтранаРегистрации = ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
		КонецЕсли;
		НаименованиеСтраны	   = ?(СтранаРегистрации.Пустая(), НСтр("ru = 'не указана'"), СокрЛП(СтранаРегистрации));
		СтранаЯвляетсяОффшором = КонтролируемыеСделкиПовтИсп.СтранаЯвляетсяОфшором(СтранаРегистрации);
		
		ИнформацияОРегистрации = НСтр("ru = 'Страна регистрации: %НаименованиеСтраны% %Оффшор%'");
		ИнформацияОРегистрации = СтрЗаменить(ИнформацияОРегистрации, "%НаименованиеСтраны%", НаименованиеСтраны);
		ИнформацияОРегистрации = СтрЗаменить(ИнформацияОРегистрации, "%Оффшор%", ?(СтранаЯвляетсяОффшором, "(оффшор)", ""));
		
	Иначе
		
		ИнформацияОРегистрации = "";
		
	КонецЕсли;
	
	УправлениеФормой(ВзаимозависимоеЛицоКонтрагентИОнУказан, ЭтоФизЛицо);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбновитьДанныеПоВзаимозависимости(Организация, Контрагент, Период)
	
	СтруктураВозврата = Новый Структура("СведенияДействуютПо, ТипВзаимозависимости, Период, Организация, Контрагент, ЕстьЗапись");
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("Контрагент", Контрагент);
	Запрос.Параметры.Вставить("Период", Период);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МАКСИМУМ(ВзаимозависимыеЛица.Период) КАК Период
	|ИЗ
	|	РегистрСведений.ВзаимозависимыеЛица КАК ВзаимозависимыеЛица
	|ГДЕ
	|	ВзаимозависимыеЛица.Организация = &Организация
	|	И ВзаимозависимыеЛица.Контрагент = &Контрагент
	|	И ВзаимозависимыеЛица.Период > &Период";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Не Выборка.Период = NULL Тогда
		ДатаОкончанияДействия = Формат(НачалоДня(Выборка.Период - 1), "ДЛФ=D");
		СведенияДействуютПо = НСтр("ru = 'по %ДатаОкончанияДействия%'");
		СтруктураВозврата.СведенияДействуютПо = СтрЗаменить(СведенияДействуютПо, "%ДатаОкончанияДействия%", ДатаОкончанияДействия);
	Иначе
		СтруктураВозврата.СведенияДействуютПо = НСтр("ru = 'по настоящее время'");
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВзаимозависимыеЛица.Период КАК Период,
	|	ВзаимозависимыеЛица.Организация,
	|	ВзаимозависимыеЛица.Контрагент,
	|	ВзаимозависимыеЛица.ТипВзаимозависимости
	|ИЗ
	|	РегистрСведений.ВзаимозависимыеЛица КАК ВзаимозависимыеЛица
	|ГДЕ
	|	ВзаимозависимыеЛица.Организация = &Организация
	|	И ВзаимозависимыеЛица.Контрагент = &Контрагент
	|	И ВзаимозависимыеЛица.Период <= &Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(СтруктураВозврата, Выборка);
			СтруктураВозврата.Период = Период;
			СтруктураВозврата.ЕстьЗапись = Истина;
		КонецЕсли;
	Иначе
		СтруктураВозврата.Период = Период;
		СтруктураВозврата.Организация = Организация;
		СтруктураВозврата.Контрагент = Контрагент;
		СтруктураВозврата.ЕстьЗапись = Ложь;
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура УправлениеФормой(КонтрагентУказан, ЭтоФизЛицо = Ложь)
	
	Элементы.ГруппаСведения.Доступность = КонтрагентУказан;
	
	Если КонтрагентУказан Тогда
		Элементы.ГруппаСтраницыУчетнойПолитики.ТекущаяСтраница = ?(ЭтоФизЛицо,
			Элементы.ГруппаСтраницаФизическогоЛица, Элементы.ГруппаСтраницаЮридическогоЛица);
	Иначе
		Элементы.ГруппаСтраницыУчетнойПолитики.ТекущаяСтраница = Элементы.ГруппаСтраницаОрганизации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыАналитики(ВзаимозависимоеЛицоЯвляетсяОрганизацией, Элемент, Организация)
	
	Если ВзаимозависимоеЛицоЯвляетсяОрганизацией Тогда
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
		#Если НаСервере Тогда
			Элемент.СписокВыбора.ЗагрузитьЗначения(КонтролируемыеСделки.СписокОрганизацийИсключаяУказанную(Организация));
		#Иначе
			Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораОрганизаций(Организация));
		#КонецЕсли
		Элемент.РежимВыбораИзСписка = Истина;
		Элемент.КнопкаВыбора = Ложь;
	Иначе
		Элемент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		Элемент.СписокВыбора.Очистить();
		Элемент.РежимВыбораИзСписка = Ложь;
		Элемент.КнопкаВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокВыбораОрганизаций(Организация)
	Возврат КонтролируемыеСделки.СписокОрганизацийИсключаяУказанную(Организация);
КонецФункции

#КонецОбласти
