

&НаСервере
Функция ИмяПериода(Периодичность)
	
	Если Периодичность = Перечисления.Периодичность.День Тогда
		ОписаниеДлительности = НСтр("ru = '-ый день'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		ОписаниеДлительности = НСтр("ru = '-ая неделя'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		ОписаниеДлительности = НСтр("ru = '-ая декада'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		ОписаниеДлительности = НСтр("ru = '-ый месяц'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ОписаниеДлительности = НСтр("ru = '-ый квартал'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		ОписаниеДлительности = НСтр("ru = '-ое полугодие'");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		ОписаниеДлительности = НСтр("ru = '-ый год'");
	КонецЕсли;
	
	Возврат ОписаниеДлительности;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПериодичностьБюджета = Неопределено;
	Если НЕ Параметры.Свойство("Периодичность",            ПериодичностьБюджета)
	 ИЛИ НЕ Параметры.Свойство("ДополнительнаяИнформация", ПериодичностьПериодов)
	 ИЛИ НЕ Параметры.Свойство("СпособПланирования") Тогда
		ТекстСообщения = НСтр("ru='Непосредственное открытие этой формы не предусмотрено. Открытие формы выполняется при добавлении периода в вид бюджета.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Параметры.СпособПланирования = Перечисления.СпособыСоставленияБюджетов.НаФиксированныйПериод Тогда
		КоличествоПериодов = 1;
	Иначе
		КоличествоПериодов = Параметры.КоличествоПериодовСкользящегоБюджета;
	КонецЕсли;
	
	Кэш = Новый Соответствие;
	НомерПериода = 0;
	
	Для Сч = 1 По КоличествоПериодов Цикл
	
		ТекущаяДата = Дата(1985, 1, 1);
		КонецПериода = БюджетированиеКлиентСервер.ДатаКонцаПериода(ТекущаяДата, ПериодичностьБюджета);
		
		ЛокальныйНомерПериода = 0;
		
		Пока ТекущаяДата < КонецПериода Цикл
			
			Представление = "";
			ЛокальныйНомерПериода = ЛокальныйНомерПериода + 1;
			Если ПериодичностьПериодов = Перечисления.Периодичность.Месяц
				И ПериодичностьБюджета = Перечисления.Периодичность.Год Тогда
				
				Представление = Формат(Дата(1985, ЛокальныйНомерПериода, 1), "ДФ=ММММ");
				
			ИначеЕсли ПериодичностьПериодов = Перечисления.Периодичность.День
				И ПериодичностьБюджета = Перечисления.Периодичность.Неделя Тогда
				
				Представление = Формат(Дата(1985, 1, ЛокальныйНомерПериода), "ДФ=дддд");
				
			ИначеЕсли ПериодичностьПериодов <> ПериодичностьБюджета Тогда
				
				Представление = Строка(НомерПериода + 1) + ИмяПериода(ПериодичностьПериодов);
				
			КонецЕсли;
			
			ТекущаяДата = БюджетированиеКлиентСервер.ДобавитьИнтервал(ТекущаяДата, ПериодичностьПериодов, 1, Кэш);
			
			Если КоличествоПериодов > 1 Тогда
				Представление = Строка(Сч) + ИмяПериода(ПериодичностьБюджета) + ?(ПустаяСтрока(Представление), "", ", ") + Представление;
			КонецЕсли;
			
			Если ПустаяСтрока(Представление) Тогда
				Представление = Строка(ПериодичностьПериодов);
			КонецЕсли;
			
			СписокПериодов.Добавить(НомерПериода, Представление, Истина);
			НомерПериода = НомерПериода + 1;
			
		КонецЦикла;
	КонецЦикла;
	
	Заголовок = "Период " + НРег(Строка(ПериодичностьПериодов));
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.СписокПериодов.Доступность = ВыбранныеПериоды;
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеПериодыПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПериодыПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуРезультата(Результат, Наименование, ВыбранныйПериод = Неопределено)
	
	НоваяСтрока = Новый Структура("НаименованиеДляПечати, СтатьяПоказательТипИзмерения, ЗначениеАналитики, ЭтоАналитикаПрочее");
	НоваяСтрока.НаименованиеДляПечати 			= Наименование;
	НоваяСтрока.СтатьяПоказательТипИзмерения 	= ПериодичностьПериодов;
	НоваяСтрока.ЗначениеАналитики 				= ВыбранныйПериод;
	НоваяСтрока.ЭтоАналитикаПрочее 				= Ложь;
	
	Результат.Добавить(НоваяСтрока);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатВыбора()
	
	Результат = Новый Массив;
	
	Если Не ВыбранныеПериоды Тогда
		ДобавитьСтрокуРезультата(Результат, Строка(ПериодичностьПериодов));
	Иначе
		Для Каждого Элемент Из СписокПериодов Цикл
			Если Элемент.Пометка Тогда
				ДобавитьСтрокуРезультата(Результат, Элемент.Представление, Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ПолучитьРезультатВыбора());
	
КонецПроцедуры
