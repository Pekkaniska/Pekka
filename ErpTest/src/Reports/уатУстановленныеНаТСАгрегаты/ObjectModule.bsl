
Процедура УстановитьПараметры()
	
	ПараметрПоВалютеОтчета = Новый ПараметрКомпоновкиДанных("ПоВалютеОтчета");
	ПоВалютеОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрПоВалютеОтчета).Значение;
	Если ПоВалютеОтчета Тогда
		Идентификатор = КомпоновщикНастроек.ПользовательскиеНастройки.ПолучитьИдентификаторПоОбъекту(КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВалютаОтчета")));
		ВалютаОтчета  = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор).Значение;
	Иначе
		ПараметрВалютаОтчета  = Новый ПараметрКомпоновкиДанных("ВалютаОтчета");
		ВалютаОтчета          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрВалютаОтчета).Значение;
	КонецЕсли;
	
	ПараметрПериод = Новый ПараметрКомпоновкиДанных("Период");
	Период = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ПараметрПериод).Значение;
	
	Если ПоВалютеОтчета Тогда                                      
		КурсВалюты = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Период.Дата, Новый Структура("Валюта",ВалютаОтчета));
		КурсВалютыОтчета = КурсВалюты.Курс / ?(КурсВалюты.Кратность = 0,1,КурсВалюты.Кратность);
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("КурсВалютыОтчета", КурсВалютыОтчета);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) Экспорт
	
	УстановитьПараметры();
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрПоВалютеОтчета = Новый ПараметрКомпоновкиДанных("ПоВалютеОтчета");
	ПоВалютеОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрПоВалютеОтчета).Значение;
	Если ПоВалютеОтчета Тогда
		Идентификатор = КомпоновщикНастроек.ПользовательскиеНастройки.ПолучитьИдентификаторПоОбъекту(КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВалютаОтчета")));
		ВалютаОтчета  = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор).Значение;
	КонецЕсли;
	
	Если ПоВалютеОтчета И Не ЗначениеЗаполнено(ВалютаОтчета) Тогда
		ТекстОшибки = "Не указана валюта отчета!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры
