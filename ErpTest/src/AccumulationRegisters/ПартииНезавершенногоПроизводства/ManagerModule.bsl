#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления КА 2.4.1
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.ПартииНезавершенногоПроизводства";
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ПартииНезавершенногоПроизводства КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
	|	ИЛИ ДанныеРегистра.КорВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
	|");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"), ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления КА 2.4.1.
// Очищаются виды запасов с типом запасов Услуга.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.ПартииНезавершенногоПроизводства";
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ВыпускПродукции;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Движения.Регистратор            КАК Регистратор,
	|	Движения.Период                 КАК Период,
	|	Движения.ВидДвижения            КАК ВидДвижения,
	|	Движения.Организация                   КАК Организация,
	|	Движения.АналитикаУчетаНоменклатуры    КАК АналитикаУчетаНоменклатуры,
	|	ВЫБОР КОГДА Движения.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ Движения.ВидЗапасов
	|	КОНЕЦ                                  КАК ВидЗапасов,
	|	Движения.ЗаказНаПроизводство           КАК ЗаказНаПроизводство,
	|	Движения.КодСтрокиПродукция            КАК КодСтрокиПродукция,
	|	Движения.ДокументПоступления           КАК ДокументПоступления,
	|	Движения.Этап                          КАК Этап,
	|	Движения.СтатьяКалькуляции             КАК СтатьяКалькуляции,
	|	Движения.АналитикаУчетаПартий          КАК АналитикаУчетаПартий,
	|	Движения.Количество              КАК Количество,
	|	Движения.Стоимость               КАК Стоимость,
	|	Движения.СтоимостьБезНДС         КАК СтоимостьБезНДС,
	|	Движения.СтоимостьРегл           КАК СтоимостьРегл,
	|	Движения.НДСРегл                 КАК НДСРегл,
	|	Движения.ПостояннаяРазница       КАК ПостояннаяРазница,
	|	Движения.ВременнаяРазница        КАК ВременнаяРазница,
	|	Движения.Продукция                     КАК Продукция,
	|	Движения.ХарактеристикаПродукции       КАК ХарактеристикаПродукции,
	|	Движения.КоличествоПродукции           КАК КоличествоПродукции,
	|	Движения.АналитикаУчетаПродукции       КАК АналитикаУчетаПродукции,
	|	Движения.ДатаРегистратора              КАК ДатаРегистратора,
	|	Движения.КорРазделУчета                КАК КорРазделУчета,
	|	ВЫБОР КОГДА Движения.КорВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Услуга)
	|		ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|		ИНАЧЕ Движения.КорВидЗапасов
	|	КОНЕЦ                                  КАК КорВидЗапасов,
	|	Движения.ДокументИсточник              КАК ДокументИсточник,
	|	Движения.ДокументВыпуска               КАК ДокументВыпуска
	|ИЗ
	|	РегистрНакопления.ПартииНезавершенногоПроизводства КАК Движения
	|ГДЕ
	|	Движения.Регистратор = &Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Регистратор", Регистратор);
			
			Набор = РегистрыНакопления.ПартииНезавершенногоПроизводства.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Регистратор);
			
			Результат = Запрос.Выполнить().Выгрузить();
			Если Результат.Количество() = 0 Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Регистратор, ДополнительныеПараметры);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Набор.Загрузить(Результат);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли