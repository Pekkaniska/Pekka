
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	АдресПравилаЗаполнения = ПоместитьВоВременноеХранилище(
		ТекущийОбъект.ПравилоЗаполнения.Выгрузить(),
		УникальныйИдентификатор);
	
	ПриЧтенииСозданииНаСервере();
	
	СтруктураНастроекОбъекта = ТекущийОбъект.СтруктураНастроек.Получить();
	Если ТипЗнч(СтруктураНастроекОбъекта) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, СтруктураНастроекОбъекта);
	КонецЕсли; 
	
	Если ТипЗнч(СтруктураНастроекОбъекта) = Тип("Структура") И СтруктураНастроекОбъекта.Свойство("ПользовательскиеНастройки") Тогда
		АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(СтруктураНастроекОбъекта.ПользовательскиеНастройки, УникальныйИдентификатор);
	Иначе
		АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ЗаполнятьПартнера = ЗаполнятьПартнера И (ТекущийОбъект.ЗаполнятьПоФормуле ИЛИ НЕ ТекущийОбъект.ЗаполнятьПартнераВТЧ);
	ТекущийОбъект.ЗаполнятьПартнераВТЧ = ЗаполнятьПартнера И ТекущийОбъект.ЗаполнятьПартнераВТЧ И НЕ ТекущийОбъект.ЗаполнятьПоФормуле;
	ТекущийОбъект.ЗаполнятьСоглашение = ЗаполнятьПартнера И ЗаполнятьСоглашение 
		И (ТекущийОбъект.ЗаполнятьПоФормуле ИЛИ НЕ ТекущийОбъект.ЗаполнятьСоглашениеВТЧ);
	ТекущийОбъект.ЗаполнятьСоглашениеВТЧ = ЗаполнятьПартнера И ЗаполнятьСоглашение 
		И (ТекущийОбъект.ЗаполнятьСоглашениеВТЧ ИЛИ ТекущийОбъект.ЗаполнятьПартнераВТЧ) И НЕ ТекущийОбъект.ЗаполнятьПоФормуле;
		
	//++ НЕ УТ
	ТекущийОбъект.ЗаполнятьСпецификациюПоПериодам = ЗаполнятьСпецификациюПоПериодам = "ПоПериодам";
	ТекущийОбъект.ПланироватьПолуфабрикатыАвтоматически = Число(ПланироватьПолуфабрикатыАвтоматически);
	//-- НЕ УТ
	
	Если ЭтоАдресВременногоХранилища(АдресПравилаЗаполнения) Тогда
		ТекущийОбъект.ПравилоЗаполнения.Загрузить(ПолучитьИзВременногоХранилища(АдресПравилаЗаполнения));
	КонецЕсли;
	Если ЭтоАдресВременногоХранилища(АдресПользовательскихНастроек) Тогда
		СтруктураНастроек.Вставить("ПользовательскиеНастройки",ПолучитьИзВременногоХранилища(АдресПользовательскихНастроек));
		ТекущийОбъект.СтруктураНастроек = Новый ХранилищеЗначения(СтруктураНастроек);
		СтруктураНастроек.Вставить("ПользовательскиеНастройки",Неопределено);
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнятьПартнера 	= Объект.ЗаполнятьПартнера ИЛИ Объект.ЗаполнятьПартнераВТЧ;
	ЗаполнятьСоглашение = Объект.ЗаполнятьСоглашение ИЛИ Объект.ЗаполнятьСоглашениеВТЧ;
	ЗаполнятьСклад 		= Объект.ЗаполнятьСклад ИЛИ Объект.ЗаполнятьСкладВТЧ;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьДоступностьЭлементов();
	
	Оповестить("Справочник.ВидыПланов.Изменение", Объект.Владелец, ЭтотОбъект);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Реквизиты = ПолучитьРеквизитыВладельцаСервер(Объект.Владелец);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Реквизиты);
	
	//++ НЕ УТ
	Объект.ОтражаетсяВБюджетировании = ОтражаетсяВБюджетировании;
	Объект.ОтражаетсяВБюджетированииОплаты = ОтражаетсяВБюджетировании И Объект.ЗаполнятьПланОплат;
	Если Не Объект.ОтражаетсяВБюджетированииОплаты Тогда
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
	КонецЕсли; 
	//-- НЕ УТ
	
	УстановитьВидимость(ЭтаФорма);
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПланаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипПлана) Тогда
		Элементы.ПравилоЗаполнения.Доступность = Ложь;
	КонецЕсли;
		
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
		Если НЕ ИспользоватьСоглашенияСКлиентами Тогда
			
			ЗаполнятьСоглашение = Ложь;
			Объект.ЗаполнятьСоглашение = Ложь;
			Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
			
		КонецЕсли;
		Если НЕ ПланПродажПланироватьПоСумме Тогда
			Объект.ЗаполнятьПланОплат = Ложь;
		КонецЕсли;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
		
		Если НЕ ПланЗакупокПланироватьПоСумме Тогда
			Объект.ЗаполнятьПланОплат = Ложь;
		КонецЕсли;
		Объект.ЗаполнятьМенеджера = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланОстатков") Тогда
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланСборкиРазборки") Тогда
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьПодразделение = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродажПоКатегориям") Тогда
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		
		//++ НЕ УТ
		
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства") Тогда
		
		Если КомплекснаяАвтоматизация Тогда
			Объект.ЗаполнятьПодразделение = Ложь;
		КонецЕсли;
		
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьПланОплат = Ложь;
		Объект.ЗаполнятьМенеджера = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		
		//-- НЕ УТ
	КонецЕсли;
	
	//++ НЕ УТ
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства") Тогда
		
		Если Объект.ТипПроизводственногоПроцесса.Пустая() Тогда
			Объект.ТипПроизводственногоПроцесса = ПредопределенноеЗначение("Перечисление.ТипыПроизводственныхПроцессов.Сборка");
		КонецЕсли;
		
	ИначеЕсли НЕ Объект.ТипПроизводственногоПроцесса.Пустая() Тогда
		
		Объект.ТипПроизводственногоПроцесса = Неопределено;
		
	КонецЕсли;
	
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланОстатков") Тогда
		Объект.СтатьяБюджетов = ПредопределенноеЗначение("Справочник.ПоказателиБюджетов.ПустаяСсылка");
	Иначе
		Объект.СтатьяБюджетов = ПредопределенноеЗначение("Справочник.СтатьиБюджетов.ПустаяСсылка");
	КонецЕсли;
	//-- НЕ УТ
	
	УстановитьВидимость(ЭтаФорма);
	
	ОбновитьДоступностьЭлементов();
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Истина, Новый Структура("Форма", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПартнераПриИзменении(Элемент)
	
	Если ЗаполнятьПартнера И Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Ложь;
		Если ЗаполнятьСоглашение Тогда
			Объект.ЗаполнятьСоглашение = Ложь;
			Объект.ЗаполнятьСоглашениеВТЧ = Истина;
		КонецЕсли; 
	ИначеЕсли ЗаполнятьПартнера И НЕ Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Истина;
	Иначе
		Объект.ЗаполнятьПартнера = Ложь;
		Объект.ЗаполнятьПартнераВТЧ = Ложь;
		
		ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПартнераВТЧПриИзменении(Элемент)
	
	Если ЗаполнятьПартнера И Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Ложь;
		Если ЗаполнятьСоглашение Тогда
			Объект.ЗаполнятьСоглашениеВТЧ = Истина;
		КонецЕсли; 
		Объект.ЗаполнятьСоглашение = Ложь; 
		Объект.ЗаполнятьПланОплат = Ложь;
		//++ НЕ УТ
		Объект.ОтражаетсяВБюджетированииОплаты       = Ложь;
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
		//-- НЕ УТ
	ИначеЕсли ЗаполнятьПартнера И НЕ Объект.ЗаполнятьПартнераВТЧ Тогда
		Объект.ЗаполнятьПартнера = Истина;
	Иначе
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСоглашениеПриИзменении(Элемент)
	
	Если ЗаполнятьСоглашение И (Объект.ЗаполнятьПартнераВТЧ ИЛИ Объект.ЗаполнятьСоглашениеВТЧ) Тогда
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Истина;
	ИначеЕсли ЗаполнятьСоглашение И НЕ Объект.ЗаполнятьСоглашениеВТЧ Тогда
		Объект.ЗаполнятьСоглашение = Истина;
	Иначе
		Объект.ЗаполнятьСоглашение = Ложь;
		Объект.ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСоглашениеВТЧПриИзменении(Элемент)
	
	Если Объект.ЗаполнятьСоглашениеВТЧ Тогда
		Объект.ЗаполнятьСоглашение = Ложь;
		Если НЕ Объект.ЗаполнятьПартнера Тогда
			Объект.ЗаполнятьПартнераВТЧ = Истина;
		КонецЕсли;
		Объект.ЗаполнятьПланОплат = Ложь;
		//++ НЕ УТ
		Объект.ОтражаетсяВБюджетированииОплаты = Ложь;
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
		//-- НЕ УТ
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСкладПриИзменении(Элемент)
	
	Если ЗаполнятьСклад Тогда
		Объект.ЗаполнятьСклад = Истина;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		Объект.ЗаполнятьФорматМагазина = Ложь;
		ВариантЗаполненияСкладФорматМагазина = 1;
	Иначе
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		ВариантЗаполненияСкладФорматМагазина = 0;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСкладВТЧПриИзменении(Элемент)
	
	Если Объект.ЗаполнятьСкладВТЧ Тогда
		Объект.ЗаполнятьСклад = Ложь;
		ВариантЗаполненияСкладФорматМагазина = 1;
	ИначеЕсли ЗаполнятьСклад Тогда
		Объект.ЗаполнятьСклад = Истина;
		ВариантЗаполненияСкладФорматМагазина = 1;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПоФормулеПриИзменении(Элемент)
	
	Объект.ЗаполнятьПоФормуле = ЗаполнятьПоФормуле;
	
	УстановитьВидимость(ЭтотОбъект);
	
	ОбновитьДоступностьЭлементов();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗамещающийПриИзменении(Элемент)
	
	Объект.Замещающий = Замещающий;
	
	Модифицированность = Истина;
	
	ИзменитьОтметкуНезаполненного(ЭтаФорма, Объект.КоличествоПериодов, Объект.Замещающий);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовПриИзменении(Элемент)
	ИзменитьОтметкуНезаполненного(ЭтаФорма, Объект.КоличествоПериодов, Объект.Замещающий);
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьПланОплатПриИзменении(Элемент)
	
	//++ НЕ УТ
	Если НЕ Объект.ЗаполнятьПланОплат Тогда
		Объект.ОтражаетсяВБюджетированииОплаты = Ложь;
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов();
	//-- НЕ УТ
	
	Возврат; // В УТ 11.1 код данного обработчика пустой
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииОплатыПриИзменении(Элемент)
	
	//++ НЕ УТ
	Если НЕ Объект.ОтражаетсяВБюджетированииОплаты Тогда
		Объект.ОтражаетсяВБюджетированииОплатыКредит = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииОплатыКредитПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияСкладФорматМагазинаПриИзменении(Элемент)
	
	Если ВариантЗаполненияСкладФорматМагазина = 1 Тогда
		Объект.ЗаполнятьФорматМагазина = Ложь;
		ЗаполнятьСклад = Истина;
		Объект.ЗаполнятьСклад = Истина;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
	ИначеЕсли ВариантЗаполненияСкладФорматМагазина = 2 Тогда
		Объект.ЗаполнятьФорматМагазина = Истина;
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
	Иначе
		Объект.ЗаполнятьФорматМагазина = Ложь;
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
	КонецЕсли;
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьФорматМагазинаПриИзменении(Элемент)
	
	Если Объект.ЗаполнятьФорматМагазина Тогда
		ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСклад = Ложь;
		Объект.ЗаполнятьСкладВТЧ = Ложь;
		ВариантЗаполненияСкладФорматМагазина = 2;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланироватьПолуфабрикатыАвтоматическиПриИзменении(Элемент)
	
	УстановитьПодсказкуПланироватьПолуфабрикатыАвтоматически(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПроизводственногоПроцессаПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура ПравилоЗаполнения(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли; 
	
	Если Модифицированность ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Оповещение = Новый ОписаниеОповещения("ПравилоЗаполненияВопросЗаписиЗавершение", ЭтотОбъект);
		
		ТекстВопроса = НСтр("ru = 'Настройки вида плана были изменены. Записать?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		Возврат;
		
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("РежимРедактирования");
	ПараметрыФормы.Вставить("ОбновитьДополнить",      			СтруктураНастроек.ОбновитьДополнить);
	ПараметрыФормы.Вставить("АдресПравилаЗаполнения", 			АдресПравилаЗаполнения);
	ПараметрыФормы.Вставить("ИзменитьРезультатНа",    			СтруктураНастроек.ИзменитьРезультатНа);
	ПараметрыФормы.Вставить("ТочностьОкругления",     			СтруктураНастроек.ТочностьОкругления);
	ПараметрыФормы.Вставить("Периодичность",            		Периодичность);
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
		ПараметрыФормы.Вставить("ПланироватьПоСумме", 			ПланЗакупокПланироватьПоСумме);
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") Тогда
		ПараметрыФормы.Вставить("ПланироватьПоСумме",			ПланПродажПланироватьПоСумме);
	Иначе
		ПараметрыФормы.Вставить("ПланироватьПоСумме",          	Ложь);
	КонецЕсли;
	ПараметрыФормы.Вставить("ВидПлана",                         Объект.Ссылка);
	ПараметрыФормы.Вставить("АдресПользовательскихНастроек",    АдресПользовательскихНастроек);
	ПараметрыФормы.Вставить("ТолькоПросмотр",                   ЭтаФорма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("КоличествоПериодов",               Объект.КоличествоПериодов);
	
	Оповещение = Новый ОписаниеОповещения("ПравилоЗаполненияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ИсточникиДанныхПланирования.Форма.ФормаЗаполнения", 
		ПараметрыФормы, 
		ЭтаФорма, 
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Если Элементы.ТипПлана.СписокВыбора.Количество() = 0 Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок") Тогда
			Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланЗакупок, НСтр("ru='Плана закупок'"));
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеОстатков") Тогда
			Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланОстатков, НСтр("ru='Плана остатков'"));
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродажПоКатегориям") Тогда
			Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланПродажПоКатегориям, НСтр("ru='Плана продаж по категориям'"));
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") Тогда
			Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланПродаж, НСтр("ru='Плана продаж'"));
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки") Тогда
			Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланСборкиРазборки, НСтр("ru='Плана сборки (разборки)'"));
		КонецЕсли; 
		//++ НЕ УТ
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства") Тогда
			Элементы.ТипПлана.СписокВыбора.Добавить(Перечисления.ТипыПланов.ПланПроизводства, НСтр("ru='Плана производства'"));
		КонецЕсли;
		//-- НЕ УТ
	КонецЕсли;
	
	КомплекснаяАвтоматизация = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	Если ЗначениеЗаполнено(Объект.ТипПлана) И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ТипПлана.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ИспользоватьФорматыМагазинов = ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов");
	ИспользоватьНесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	ИспользоватьСоглашенияСКлиентами    = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	ИспользоватьСоглашенияСПоставщиками = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСПоставщиками");
	ИспользоватьОбособленноеОбеспечениеЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов");
	
	УправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	
	//++ НЕ УТКА
	ДоступноОписаниеТипаПроизводственногоПроцесса = УправлениеДаннымиОбИзделиях.ДоступноОписаниеТипаПроизводственногоПроцесса();
	Если ДоступноОписаниеТипаПроизводственногоПроцесса Тогда
		ИсключаемыеТипы = Новый Массив;
		ИсключаемыеТипы.Добавить(Перечисления.ТипыПроизводственныхПроцессов.БезСпецификаций);
		ПроизводствоСервер.ЗаполнитьСписокТиповПроизводственногоПроцесса(Элементы.ТипПроизводственногоПроцесса, ИсключаемыеТипы);
	КонецЕсли;
	//-- НЕ УТКА
	
	Реквизиты = ПолучитьРеквизитыВладельцаСервер(Объект.Владелец);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Реквизиты);
	
	СтруктураНастроек = Новый Структура("ОбновитьДополнить, ИзменитьРезультатНа, ТочностьОкругления", 0, 0, 0);
	
	//++ НЕ УТ
	Если Не ЗначениеЗаполнено(Объект.СтатьяБюджетов)
		И Объект.ОтражаетсяВБюджетировании Тогда
		Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланОстатков") Тогда
			Объект.СтатьяБюджетов = ПредопределенноеЗначение("Справочник.ПоказателиБюджетов.ПустаяСсылка");
		Иначе
			Объект.СтатьяБюджетов = ПредопределенноеЗначение("Справочник.СтатьиБюджетов.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		//++ НЕ УТ
		Если ЭтаФорма.ОтражаетсяВБюджетировании Тогда
			Объект.ОтражаетсяВБюджетировании = Истина;
		КонецЕсли;
		
		Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства")
			И Объект.ТипПроизводственногоПроцесса.Пустая() Тогда
			Объект.ТипПроизводственногоПроцесса = ПредопределенноеЗначение("Перечисление.ТипыПроизводственныхПроцессов.Сборка");
		КонецЕсли;
		
		//-- НЕ УТ
	
	КонецЕсли;
	Если НЕ ЭтоАдресВременногоХранилища(АдресПравилаЗаполнения) Тогда		
		// Копированием
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			АдресПравилаЗаполнения = ПоместитьВоВременноеХранилище(
				Параметры.ЗначениеКопирования.ПравилоЗаполнения.Выгрузить(),
				УникальныйИдентификатор);
		Иначе
			СценарийОбъект = РеквизитФормыВЗначение("Объект");
			
			АдресПравилаЗаполнения = ПоместитьВоВременноеХранилище(
				СценарийОбъект.ПравилоЗаполнения.Выгрузить(),
				УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресПользовательскихНастроек) Тогда
		// Копированием
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			
			СтруктураНастроекКопирования = Параметры.ЗначениеКопирования.СтруктураНастроек.Получить();
			Если ТипЗнч(СтруктураНастроекКопирования) = Тип("Структура") Тогда
				ЗаполнитьЗначенияСвойств(СтруктураНастроек, СтруктураНастроекКопирования);
			КонецЕсли;
			Если ТипЗнч(СтруктураНастроекКопирования) = Тип("Структура") И СтруктураНастроекКопирования.Свойство("ПользовательскиеНастройки") Тогда
				АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(СтруктураНастроекКопирования.ПользовательскиеНастройки, УникальныйИдентификатор);
			Иначе
				АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
			КонецЕсли; 
		Иначе
			АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнятьПартнера   = Объект.ЗаполнятьПартнера ИЛИ Объект.ЗаполнятьПартнераВТЧ;
	ЗаполнятьСоглашение = Объект.ЗаполнятьСоглашение ИЛИ Объект.ЗаполнятьСоглашениеВТЧ;
	ЗаполнятьСклад      = Объект.ЗаполнятьСклад ИЛИ Объект.ЗаполнятьСкладВТЧ;
	ЗаполнятьПоФормуле  = Объект.ЗаполнятьПоФормуле;
	Замещающий          = Объект.Замещающий;
	
	//++ НЕ УТ
	Если Объект.ЗаполнятьСпецификациюПоПериодам Тогда
		ЗаполнятьСпецификациюПоПериодам = "ПоПериодам";
	Иначе
		ЗаполнятьСпецификациюПоПериодам = "НачалоПериода";
	КонецЕсли;
	
	ПланироватьПолуфабрикатыАвтоматически = Число(Объект.ПланироватьПолуфабрикатыАвтоматически);
	УстановитьПодсказкуПланироватьПолуфабрикатыАвтоматически(ЭтотОбъект);
	//-- НЕ УТ
	
	Если ЗаполнятьСклад Тогда
		ВариантЗаполненияСкладФорматМагазина = 1;
	ИначеЕсли Объект.ЗаполнятьФорматМагазина Тогда
		ВариантЗаполненияСкладФорматМагазина = 2;
	Иначе
		ВариантЗаполненияСкладФорматМагазина = 0;
	КонецЕсли; 
	
	//++ НЕ УТ
	ПравоПросмотраСтатейБюджетов = ПравоДоступа("Просмотр", Метаданные.Справочники.СтатьиБюджетов);
	//-- НЕ УТ
	
	ИзменитьОтметкуНезаполненного(ЭтаФорма, Объект.КоличествоПериодов, Объект.Замещающий);
	
	УстановитьВидимость(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	
	Элементы.ЗаполнятьПартнераВТЧПродажи.Доступность = ЗаполнятьПартнера;
	Элементы.ЗаполнятьПартнераВТЧЗакупки.Доступность = ЗаполнятьПартнера;
	Элементы.ЗаполнятьСоглашение.Доступность = ЗаполнятьПартнера;
	Элементы.ЗаполнятьСоглашениеВТЧПродажи.Доступность = ЗаполнятьПартнера И ЗаполнятьСоглашение;
	Элементы.ЗаполнятьСоглашениеВТЧЗакупки.Доступность = ЗаполнятьПартнера И ЗаполнятьСоглашение;
	Элементы.ЗаполнятьСкладВТЧ.Доступность = ЗаполнятьСклад;
	Элементы.ЗаполнятьНазначениеВТЧ.Доступность = ПланированиеПоНазначениям;
	
	Элементы.ЗаполнятьПланОплатПродажи.Доступность = ПланПродажПланироватьПоСумме;
	Элементы.ЗаполнятьПланОплатЗакупки.Доступность = ПланЗакупокПланироватьПоСумме;
	
	//++ НЕ УТ
	Элементы.ОтражаетсяВБюджетировании.Доступность = ОтражаетсяВБюджетировании;
	Элементы.СтатьяБюджетов.Доступность = Объект.ОтражаетсяВБюджетировании;
	Элементы.ОтражаетсяВБюджетированииОплаты.Доступность = ОтражаетсяВБюджетировании И Объект.ЗаполнятьПланОплат;
	Элементы.СтатьяБюджетовОплат.Доступность = Объект.ОтражаетсяВБюджетированииОплаты;
	Элементы.ОтражаетсяВБюджетированииОплатыКредит.Доступность = Объект.ОтражаетсяВБюджетированииОплаты;
	Элементы.СтатьяБюджетовОплатКредит.Доступность = Объект.ОтражаетсяВБюджетированииОплатыКредит;
	
	Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж") И ОтражаетсяВБюджетировании Тогда
		ЗаголовокФлагаОплат = ?(Объект.ОтражаетсяВБюджетированииОплатыКредит,
				НСтр("ru = 'Оплаты (до отгрузки):'"),
				НСтр("ru = 'Оплаты:'"));
		Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = ЗаголовокФлагаОплат;
	ИначеЕсли Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") И ОтражаетсяВБюджетировании Тогда
		ЗаголовокФлагаОплат = ?(Объект.ОтражаетсяВБюджетированииОплатыКредит,
				НСтр("ru = 'Оплаты (до поступления):'"),
				НСтр("ru = 'Оплаты:'"));
		Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = ЗаголовокФлагаОплат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.СтатьяБюджетов)
		И Объект.ОтражаетсяВБюджетировании Тогда
		Если Объект.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланОстатков") Тогда
			Объект.СтатьяБюджетов = ПредопределенноеЗначение("Справочник.ПоказателиБюджетов.ПустаяСсылка");
		Иначе
			Объект.СтатьяБюджетов = ПредопределенноеЗначение("Справочник.СтатьиБюджетов.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыВладельцаСервер(Знач Сценарий)
	
	Реквизиты = "Периодичность, ПланЗакупокПланироватьПоСумме, ПланПродажПланироватьПоСумме, ПланированиеПоНазначениям";
	//++ НЕ УТ
	Реквизиты = Реквизиты + ", ОтражаетсяВБюджетировании, ИспользоватьДляПланированияМатериалов";
	//-- НЕ УТ
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, Реквизиты);
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	ТипПлана = Форма.Объект.ТипПлана;
	ЭтоПланЗакупок = ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок");
	ЭтоПланОстатков = ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланОстатков");
	ЭтоПланПродаж = ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродаж");
	ЭтоПланПродажПоКатегориям = ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПродажПоКатегориям");
	ЭтоПланПроизводства = Ложь;
	//++ НЕ УТ
	ЭтоПланПроизводства = ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланПроизводства");
	//-- НЕ УТ
	ЭтоПланСборкиРазборки = ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланСборкиРазборки");
	
	ВыборСклада = Форма.ИспользоватьНесколькоСкладов И НЕ Форма.ИспользоватьФорматыМагазинов;
	ВыборФормата = Форма.ИспользоватьФорматыМагазинов И НЕ Форма.ИспользоватьНесколькоСкладов;
	ВыборСкладаИлиФорматам = Форма.ИспользоватьНесколькоСкладов И Форма.ИспользоватьФорматыМагазинов;
	
	Форма.Элементы.ЗаполнятьПодразделение.Видимость = ЭтоПланЗакупок ИЛИ ЭтоПланПродаж ИЛИ ЭтоПланПродажПоКатегориям;
	Форма.Элементы.ЗаполнятьПодразделениеПроизводство.Видимость = ЭтоПланПроизводства И Не Форма.КомплекснаяАвтоматизация;
	Форма.Элементы.ЗаполнятьСпецификациюПоПериодам.Видимость = ЭтоПланПроизводства И Форма.ИспользоватьДляПланированияМатериалов;
	Форма.Элементы.ПланироватьПолуфабрикатыАвтоматически.Видимость = Ложь;
	Форма.Элементы.ТипПроизводственногоПроцесса.Видимость = Ложь;
	//++ НЕ УТКА
	Форма.Элементы.ПланироватьПолуфабрикатыАвтоматически.Видимость = 
		ЭтоПланПроизводства
		И Форма.ИспользоватьДляПланированияМатериалов
		И (Форма.Объект.ТипПроизводственногоПроцесса = ПредопределенноеЗначение("Перечисление.ТипыПроизводственныхПроцессов.Сборка")
			ИЛИ Форма.Объект.ТипПроизводственногоПроцесса = ПредопределенноеЗначение("Перечисление.ТипыПроизводственныхПроцессов.Ремонт"));
	Форма.Элементы.ТипПроизводственногоПроцесса.Видимость = ЭтоПланПроизводства
		И Форма.ДоступноОписаниеТипаПроизводственногоПроцесса;
	//-- НЕ УТКА
	Форма.Элементы.ЗаполнятьПартнераПродажи.Видимость = ЭтоПланПродаж;
	Форма.Элементы.ЗаполнятьПартнераЗакупки.Видимость = ЭтоПланЗакупок;
	Форма.Элементы.ГруппаЗаполнятьПартнераВТЧ.Видимость = НЕ Форма.Объект.ЗаполнятьПоФормуле И (ЭтоПланЗакупок ИЛИ ЭтоПланПродаж);
	Форма.Элементы.ЗаполнятьПартнераВТЧПродажи.Видимость = ЭтоПланПродаж;
	Форма.Элементы.ЗаполнятьПартнераВТЧЗакупки.Видимость = ЭтоПланЗакупок;
	Форма.Элементы.ЗаполнятьСоглашение.Видимость = ЭтоПланЗакупок И Форма.ИспользоватьСоглашенияСПоставщиками ИЛИ ЭтоПланПродаж И Форма.ИспользоватьСоглашенияСКлиентами;
	Форма.Элементы.ГруппаЗаполнятьСоглашениеВТЧ.Видимость = НЕ Форма.Объект.ЗаполнятьПоФормуле И (ЭтоПланЗакупок И Форма.ИспользоватьСоглашенияСПоставщиками ИЛИ ЭтоПланПродаж И Форма.ИспользоватьСоглашенияСКлиентами);
	Форма.Элементы.ЗаполнятьСоглашениеВТЧПродажи.Видимость = ЭтоПланПродаж И Форма.ИспользоватьСоглашенияСКлиентами;
	Форма.Элементы.ЗаполнятьСоглашениеВТЧЗакупки.Видимость = ЭтоПланЗакупок И Форма.ИспользоватьСоглашенияСПоставщиками;
	Форма.Элементы.ЗаполнятьМенеджера.Видимость = ЭтоПланПродаж;
	Форма.Элементы.ЗаполнятьФорматМагазина.Видимость = ВыборФормата И (ЭтоПланПродаж ИЛИ ЭтоПланПродажПоКатегориям);
	Форма.Элементы.ЗаполнятьСклад.Видимость = ЭтоПланЗакупок ИЛИ ЭтоПланОстатков ИЛИ ЭтоПланСборкиРазборки ИЛИ ВыборСклада И (ЭтоПланПродаж ИЛИ ЭтоПланПродажПоКатегориям);
	Форма.Элементы.ГруппаЗаполнятьСкладВТЧ.Видимость = НЕ Форма.Объект.ЗаполнятьПоФормуле И (ЭтоПланЗакупок ИЛИ ЭтоПланОстатков ИЛИ ЭтоПланСборкиРазборки ИЛИ (ВыборСклада ИЛИ ВыборСкладаИлиФорматам) И (ЭтоПланПродаж  ИЛИ ЭтоПланПродажПоКатегориям));
	Форма.Элементы.ВариантЗаполненияСкладФорматМагазина.Видимость = ВыборСкладаИлиФорматам И (ЭтоПланПродаж ИЛИ ЭтоПланПродажПоКатегориям);
	Форма.Элементы.ЗаполнятьПланОплатПродажи.Видимость = ЭтоПланПродаж;
	Форма.Элементы.ЗаполнятьПланОплатЗакупки.Видимость = ЭтоПланЗакупок;
	Форма.Элементы.ЗаполнятьНазначения.Видимость = Форма.ИспользоватьОбособленноеОбеспечениеЗаказов;
	Форма.Элементы.ЗаполнятьНазначениеВТЧ.Видимость = Форма.ПланированиеПоНазначениям И Форма.ИспользоватьОбособленноеОбеспечениеЗаказов;
	Форма.Элементы.ГруппаЗаполнятьНазначениеВТЧ.Видимость = Форма.ПланированиеПоНазначениям И Форма.ИспользоватьОбособленноеОбеспечениеЗаказов;
	
	Форма.Элементы.ДекорацияДетализацияПояснениеЗакупки.Видимость = ЭтоПланЗакупок;
	Форма.Элементы.ДекорацияДетализацияПояснениеОстатки.Видимость = ЭтоПланОстатков;
	Форма.Элементы.ДекорацияДетализацияПояснениеПродажи.Видимость = ЭтоПланПродаж;
	Форма.Элементы.ДекорацияДетализацияПояснениеПродажиПоКатегориям.Видимость = ЭтоПланПродажПоКатегориям;
	Форма.Элементы.ДекорацияДетализацияПояснениеПроизводство.Видимость = ЭтоПланПроизводства;
	Форма.Элементы.ДекорацияДетализацияПояснениеСборка.Видимость = ЭтоПланСборкиРазборки;
	
	Форма.Элементы.ГруппаПоПравилуИсточника.Видимость = НЕ Форма.Объект.ЗаполнятьПоФормуле;
	
	Форма.Элементы.ГруппаОтражениеВБюджетировании.Видимость = НЕ Форма.УправлениеТорговлей И
		Форма.ОтражаетсяВБюджетировании И Форма.ПравоПросмотраСтатейБюджетов;
		
	//++ НЕ УТ
	Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Видимость = (ЭтоПланЗакупок ИЛИ ЭтоПланПродаж) И Форма.ПравоПросмотраСтатейБюджетов;
	Форма.Элементы.СтатьяБюджетовОплат.Видимость = (ЭтоПланЗакупок ИЛИ ЭтоПланПродаж) И Форма.ПравоПросмотраСтатейБюджетов;
	Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Видимость = (ЭтоПланЗакупок ИЛИ ЭтоПланПродаж) И Форма.ПравоПросмотраСтатейБюджетов;
	Форма.Элементы.СтатьяБюджетовОплатКредит.Видимость = (ЭтоПланЗакупок ИЛИ ЭтоПланПродаж) И Форма.ПравоПросмотраСтатейБюджетов;
	
	Если Форма.ОтражаетсяВБюджетировании И Форма.ПравоПросмотраСтатейБюджетов Тогда 
		Если ЭтоПланЗакупок Тогда
			
			Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru = 'Закупки:'");
			ЗаголовокФлагаОплат = ?(Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит,
				НСтр("ru = 'Оплаты (до поступления):'"),
				НСтр("ru = 'Оплаты:'"));
			Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = ЗаголовокФлагаОплат;
			Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru = 'Выделять оплаты (после поступления):'");
			
			
		ИначеЕсли ЭтоПланПродаж Тогда
			
			Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru = 'Продажи:'");
			ЗаголовокФлагаОплат = ?(Форма.Объект.ОтражаетсяВБюджетированииОплатыКредит,
				НСтр("ru = 'Оплаты (до отгрузки):'"),
				НСтр("ru = 'Оплаты:'"));
			Форма.Элементы.ОтражаетсяВБюджетированииОплаты.Заголовок = ЗаголовокФлагаОплат;
			Форма.Элементы.ОтражаетсяВБюджетированииОплатыКредит.Заголовок = НСтр("ru = 'Выделять оплаты (после отгрузки):'");
			
		ИначеЕсли ЭтоПланПродажПоКатегориям Тогда
			
			Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru = 'Продажи:'");
			
		ИначеЕсли ЭтоПланОстатков Тогда
			
			Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru = 'Остатки:'");
			
		ИначеЕсли ЭтоПланПроизводства Тогда
			
			Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru = 'План производства:'");
			
		ИначеЕсли ЭтоПланСборкиРазборки Тогда
			
			Форма.Элементы.ОтражаетсяВБюджетировании.Заголовок = НСтр("ru = 'План сборки (разборки):'");
			
		КонецЕсли;
		
		Если ЭтоПланОстатков Тогда
			Форма.Элементы.ГруппаОтражениеВБюджетировании.Заголовок = НСтр("ru = 'Отражать по показателям бюджета:'");
		Иначе
			Форма.Элементы.ГруппаОтражениеВБюджетировании.Заголовок = НСтр("ru = 'Отражать по статьям бюджетирования:'");
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ УТ
	
	Форма.Элементы.КоличествоПериодов.Видимость = Не ЭтоПланОстатков;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоЗаполненияЗавершение(Настройки, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		
		Модифицированность = Истина;
		
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, Настройки, "ОбновитьДополнить,ИзменитьРезультатНа,ТочностьОкругления");
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сохранение настроек в виде плана завершено'"),
			,
			,
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоЗаполненияВопросЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Записать() Тогда
			ПравилоЗаполнения(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПодсказкуПланироватьПолуфабрикатыАвтоматически(Форма)
	
	Если Форма.ПланироватьПолуфабрикатыАвтоматически Тогда
		
		Подсказка = НСтр("ru = 'Полуфабрикаты планируются автоматически в соответствии со структурой изделий.'");
		
	Иначе
		
		Подсказка = НСтр("ru = 'Полуфабрикаты могут быть добавлены в план отдельными строчками с возможностью внесения изменений.'");
		
	КонецЕсли;
	
	Форма.Элементы.ПланироватьПолуфабрикатыАвтоматически.Подсказка = Подсказка;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОтметкуНезаполненного(Форма, КоличествоПериодов, Замещающий)
	Форма.Элементы.КоличествоПериодов.ОтметкаНезаполненного = Не ЗначениеЗаполнено(КоличествоПериодов) И Замещающий;
КонецПроцедуры

#КонецОбласти
