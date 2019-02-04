#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли; 
	
	Если СпособВводаЗадолженности=Перечисления.СпособВводаЗадолженностиПоЗарплате.ОстатокНевыплаченнойЗарплаты Тогда 
		ЭтоБухгалтерскаяЗадолженность = Ложь;
	ИначеЕсли СпособВводаЗадолженности=Перечисления.СпособВводаЗадолженностиПоЗарплате.БухгалтерскоеСальдоИВыплаты Тогда 
		ЭтоБухгалтерскаяЗадолженность = Истина;
	Иначе 
		ЭтоБухгалтерскаяЗадолженность = Неопределено;
	КонецЕсли;
	
	Если ЭтоБухгалтерскаяЗадолженность<>Неопределено Тогда 
		Для Каждого СтрокаТЧ Из ЗадолженностьПоЗарплате Цикл 
			Если ЭтоБухгалтерскаяЗадолженность Тогда 
				СтрокаТЧ.Сумма = 0;
			Иначе 
				СтрокаТЧ.СуммаПоБухучету = 0;
				СтрокаТЧ.ВыплатыЗаПрошлыеПериоды = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДанныеПроведения = ДанныеДляПроведения();
	
	ВзаиморасчетыССотрудниками.ЗарегистрироватьНачальныеОстатки(
		Движения, Отказ, Организация, Месяц, ДанныеПроведения.ЗадолженностьПоЗарплате);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ПериодВзаиморасчетов", Месяц);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	ЗадолженностьПоЗарплате.Сотрудник,
	|	ЗадолженностьПоЗарплате.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗадолженностьПоЗарплате.Подразделение,
	|	ЗадолженностьПоЗарплате.СтатьяФинансирования,
	|	ЗадолженностьПоЗарплате.СтатьяРасходов,";
	Если СпособВводаЗадолженности=Перечисления.СпособВводаЗадолженностиПоЗарплате.ОстатокНевыплаченнойЗарплаты
		Или СпособВводаЗадолженности=Перечисления.СпособВводаЗадолженностиПоЗарплате.ПустаяСсылка() Тогда 
		Запрос.Текст = Запрос.Текст + "
		|	ЗадолженностьПоЗарплате.Сумма,
		|	ЗадолженностьПоЗарплате.Сумма КАК СуммаПоБухучету,
		|	0 КАК ВыплатыЗаПрошлыеПериоды";
	Иначе 
		Запрос.Текст = Запрос.Текст + "
		|	ЗадолженностьПоЗарплате.СуммаПоБухучету - ЗадолженностьПоЗарплате.ВыплатыЗаПрошлыеПериоды КАК Сумма,
		|	ЗадолженностьПоЗарплате.СуммаПоБухучету,
		|	ЗадолженностьПоЗарплате.ВыплатыЗаПрошлыеПериоды";
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + "
	|ИЗ
	|	Документ.НачальнаяЗадолженностьПоЗарплате.ЗадолженностьПоЗарплате КАК ЗадолженностьПоЗарплате
	|ГДЕ
	|	ЗадолженностьПоЗарплате.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура; 	
	ДанныеДляПроведения.Вставить("ЗадолженностьПоЗарплате", РезультатыЗапроса.Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
