#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();

	Попытка
		
		КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
		
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
		
		ЗначениеПараметраДокумент = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Документ"));
		Если ЗначениеПараметраДокумент.Значение = Неопределено Тогда
			ЗначениеПараметраДокумент.Значение = Документы.ИсполнительныйЛист.ПустаяСсылка();
			ЗначениеПараметраДокумент.Использование = Истина;
		ИначеЕсли Не ЗначениеПараметраДокумент.Использование Тогда
			ЗначениеПараметраДокумент.Использование = Истина;
		КонецЕсли;
		
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
		
		Если КлючВарианта = "ЖурналУчетаИсполнительныхДокументов" Тогда
			
			СтандартнаяОбработка = Ложь;
			
			// Параметры документа
			ДокументРезультат.ТолькоПросмотр = Истина;
			ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЖурналУчетаИсполнительныхДокументов";
			ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
			ДокументРезультат.Очистить();
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			
			МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных,
				НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , , Истина);
			
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
			ДанныеОтчета = Новый ДеревоЗначений;
			ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
			ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ЖурналУчетаИсполнительныхДокументов.ПФ_MXL_ЖурналУчетаИсполнительныхДокументов");
			
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
			
			Если ПолучитьФункциональнуюОпцию("НеИспользоватьНесколькоОрганизаций") Тогда
				ДокументРезультат.Вывести(ОбластьШапка);
				Для Каждого СтрокаСотрудника Из ДанныеОтчета.Строки Цикл
					ВывестиСтрокуПоСотруднику(ДокументРезультат, СтрокаСотрудника, ОбластьСтрока)
				КонецЦикла;
			Иначе
				Для каждого СтрокаОрганизации Из ДанныеОтчета.Строки Цикл
					ОбластьШапка.Параметры.Заполнить(СтрокаОрганизации);
					ДокументРезультат.Вывести(ОбластьШапка);
					Для Каждого СтрокаСотрудника Из СтрокаОрганизации.Строки Цикл
						ВывестиСтрокуПоСотруднику(ДокументРезультат, СтрокаСотрудника, ОбластьСтрока)
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
			
			ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
			ДопСвойства.Вставить("ОтчетПустой", ДанныеОтчета.Строки.Количество() = 0);
			
		КонецЕсли;
		
	Исключение
		
		Инфо = ИнформацияОбОшибке();
		ВызватьИсключение НСтр("ru = 'В настройку отчета внесены критичные изменения. Журнал учета исполнительных документов не будет сформирован.'") + " " + Инфо.Описание;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

Процедура ВывестиСтрокуПоСотруднику(ДокументРезультат, СтрокаСотрудника, ОбластьСтрока)
	
	ОбластьСтрока.Параметры.Заполнить(СтрокаСотрудника);
	ОбластьСтрока.Параметры.ФактическийАдресПолучателя = СтрокаСотрудника.АдресПолучателя;
	Если СтрокаСотрудника.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.ФиксированнойСуммой Тогда
		Размер = СтрокаСотрудника.Сумма;
	ИначеЕсли СтрокаСотрудника.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Процентом Тогда
		Размер = СтрокаСотрудника.Процент
	ИначеЕсли СтрокаСотрудника.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Долей Тогда
		Размер = Строка(СтрокаСотрудника.Числитель) + " / " + Строка(СтрокаСотрудника.Знаменатель)
	Иначе
		Размер = СтрокаСотрудника.Сумма
	КонецЕсли;
	ОбластьСтрока.Параметры.Размер = Размер;
	ОбластьСтрока.Параметры.Дата = Формат(СтрокаСотрудника.Дата, "ДФ=""ММММ гггг 'г.'""");
	ОбластьСтрока.Параметры.РазделительПолучателя = ?(ЗначениеЗаполнено(СтрокаСотрудника.АдресПолучателя) И ЗначениеЗаполнено(СтрокаСотрудника.Получатель), "; ", "");
	ОбластьСтрока.Параметры.РазделительСотрудника = ?(ЗначениеЗаполнено(СтрокаСотрудника.АдресМестаПроживанияСотрудника) И ЗначениеЗаполнено(СтрокаСотрудника.ФИОСотрудника), "; ", "");
	ДокументРезультат.Вывести(ОбластьСтрока);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли