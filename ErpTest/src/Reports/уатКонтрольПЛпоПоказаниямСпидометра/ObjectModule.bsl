
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Компоновщик = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы;

	КомпоновщикПоУмолчанию = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы;
	
	НачалоПериода = Неопределено;
	КонецПериода  = Неопределено;
	
	Для Каждого СтрокаНастройкиПоУмолчанию Из КомпоновщикПоУмолчанию Цикл 
		Если ТипЗнч(СтрокаНастройкиПоУмолчанию) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда 
			Если СтрокаНастройкиПоУмолчанию.Параметр = (Новый ПараметрКомпоновкиДанных("НачалоПериода")) Тогда 
				ПользовательскаяНастройка = Компоновщик.Найти(СтрокаНастройкиПоУмолчанию.ИдентификаторПользовательскойНастройки);
				Если ТипЗнч(ПользовательскаяНастройка.Значение) = Тип("Дата") Тогда
					НачалоПериода = ПользовательскаяНастройка.Значение;
				Иначе
					НачалоПериода = ПользовательскаяНастройка.Значение.Дата;
				КонецЕсли;
			КонецЕсли;
			Если СтрокаНастройкиПоУмолчанию.Параметр = (Новый ПараметрКомпоновкиДанных("КонецПериода1")) Тогда 
				ПользовательскаяНастройка = Компоновщик.Найти(СтрокаНастройкиПоУмолчанию.ИдентификаторПользовательскойНастройки);
				Если ТипЗнч(ПользовательскаяНастройка.Значение) = Тип("Дата") Тогда
					КонецПериода = ПользовательскаяНастройка.Значение;
				Иначе
					КонецПериода = ПользовательскаяНастройка.Значение.Дата;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если НачалоПериода = Неопределено Или КонецПериода = Неопределено Тогда 
		ТекстСообщения = НСтр("ru = 'Неверно указаны даты начала и окончания периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
	Если Не Отказ И НачалоПериода > КонецПериода Тогда
		ТекстСообщения = НСтр("ru = 'Дата начала периода не может быть больше даты конца периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
КонецПроцедуры
