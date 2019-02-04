
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидПоказателей = Параметры.ВидПоказателей;
	
	Элементы.ГруппаМеждународный.Доступность = Параметры.ЕстьПоказателиМУ;
	Элементы.ГруппаРегламентированный.Доступность = Параметры.ЕстьПоказателиБУ;
	
	#Область ПодписиРегламентированныйУчет
	ВестиУУ = ПолучитьФункциональнуюОпцию("ВестиУУНаПланеСчетовХозрасчетный");
	ВестиФО = ПолучитьФункциональнуюОпцию("ВестиУчетНаПланеСчетовХозрасчетныйВВалютеФинОтчетности");
	Если ВестиУУ И ВестиФО Тогда
		Элементы.ПояснениеРегламентированный.Заголовок =
			НСтр("ru = 'Использовать показатели только бухгалтерского плана счетов.
						|В качестве данных для показателей могут использоваться данные бухгалтерского или управленческого учета.
						|Выбор типа данных происходит при формировании отчета.'");
	ИначеЕсли ВестиУУ И НЕ ВестиФО Тогда
		Элементы.ПояснениеРегламентированный.Заголовок =
			НСтр("ru = 'Использовать показатели только бухгалтерского плана счетов.
						|В качестве данных для показателей могут использоваться данные бухгалтерского или управленческого учета или в валюте финансовой отчетности.
						|Выбор типа данных происходит при формировании отчета.'");
	ИначеЕсли НЕ ВестиУУ И ВестиФО Тогда
		Элементы.ПояснениеРегламентированный.Заголовок =
			НСтр("ru = 'Использовать показатели только бухгалтерского плана счетов.
						|В качестве данных для показателей могут использоваться данные бухгалтерского учета или в валюте финансовой отчетности.
						|Выбор типа данных происходит при формировании отчета.'");
	ИначеЕсли НЕ ВестиУУ И НЕ ВестиФО Тогда
		Элементы.ПояснениеРегламентированный.Заголовок =
			НСтр("ru = 'Использовать показатели только бухгалтерского плана счетов.'");
	КонецЕсли;
	#КонецОбласти

	#Область ПодписиМеждународныйИРегламентированныйРежим
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаМУ = МеждународнаяОтчетностьВызовСервера.УчетнаяВалюта();
	ВалютаОК = ВалютаРегл = ВалютаМУ.Функциональная ИЛИ ВалютаРегл = ВалютаМУ.Представления;
	Если ВалютаРегл = ВалютаМУ.Функциональная Тогда
		Элементы.ПояснениеСмешанный.Заголовок =
			НСтр("ru = 'Использовать показатели международного и бухгалтерского планов счетов совместно.
						|Отчет формируется в функциональной валюте для международного плана счетов
						|и валюте регламентированного учета для бухгалтерского плана счетов.'");
	ИначеЕсли ВалютаРегл = ВалютаМУ.Представления Тогда
		Элементы.ПояснениеСмешанный.Заголовок =
			НСтр("ru = 'Использовать показатели международного и бухгалтерского планов счетов совместно.
						|Отчет формируется в валюте представления для международного плана счетов
						|и валюте регламентированного учета для бухгалтерского плана счетов.'");
	Иначе//Если НЕ ВалютаОК Тогда
		Элементы.ПояснениеСмешанный.Заголовок =
			НСтр("ru = 'Использовать показатели международного и бухгалтерского планов счетов совместно.
						|Совместное использование показателей возможно при совпадении валюты регламентированного учета
						|и одной из валют международного учета (функциональной валюты или валюты представления).'");
		Шаблон = НСтр("ru='Валюта регл. учета %1; Функциональная валюта %2; Валюта представления %3.
							|Совместное использование показателей недоступно.'");
		Элементы.ПояснениеПочему.Заголовок = СтрШаблон(Шаблон, ВалютаРегл, ВалютаМУ.Функциональная,  ВалютаМУ.Представления);
		Элементы.ГруппаСмешанный.Доступность = Ложь;
	КонецЕсли;
	#КонецОбласти
	
	Текст = ?(ПустаяСтрока(Элементы.ПояснениеПочему.Заголовок),"",Элементы.ПояснениеПочему.Заголовок + Символы.ПС);
	Если Параметры.ЕстьПоказателиМУ И Параметры.ЕстьПоказателиБУ Тогда
		Элементы.ГруппаМеждународный.Доступность = Ложь;
		Элементы.ГруппаРегламентированный.Доступность = Ложь;
		Текст = Текст + НСтр("ru = 'Текущий отчет содержит показатели международного и регламентированного плана счетов.
							|Использование показателей только одного вида недоступно.'");
		
	ИначеЕсли Параметры.ЕстьПоказателиМУ И НЕ Параметры.ЕстьПоказателиБУ Тогда
		Текст = Текст + НСтр("ru = 'Текущий отчет содержит показатели только международного плана счетов.'");
		
	ИначеЕсли НЕ Параметры.ЕстьПоказателиМУ И Параметры.ЕстьПоказателиБУ Тогда
		Текст = Текст + НСтр("ru = 'Текущий отчет содержит показатели только регламентированного плана счетов.'");
		
	ИначеЕсли ВалютаОК Тогда
		Элементы.ГруппаМеждународный.Доступность = Истина;
		Элементы.ГруппаРегламентированный.Доступность = Истина;
		Элементы.ГруппаКомментарийПочему.Видимость = Ложь;
		
	КонецЕсли;
	Элементы.ПояснениеПочему.Заголовок = Текст;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВидПоказателей(Команда)
	
	Закрыть(ВидПоказателей);
	
КонецПроцедуры

#КонецОбласти
