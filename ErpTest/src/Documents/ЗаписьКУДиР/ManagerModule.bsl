

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Запись книги учета доходов и расходов (УСН)".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ЗаписьКУДиР) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ЗаписьКУДиР.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ЗаписьКУДиР);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

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

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаТаблицаКУДиР(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаКУДиР2(Запрос, ТекстыЗапроса, Регистры);
	
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.ЗаписьКУДиР КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаКУДиР(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "КнигаУчетаДоходовИРасходов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	&Период КАК Период,
	               |	&Ссылка КАК Регистратор,
	               |	&Организация КАК Организация,
	               |	ДанныеДокумента.ДоходЕНВД,
				   |	ДанныеДокумента.Графа4,
	               |	ДанныеДокумента.Графа5,
	               |	ДанныеДокумента.РасходЕНВД,
				   |	ДанныеДокумента.Графа6,
	               |	ДанныеДокумента.Графа7,
	               |	ДанныеДокумента.НДС,
	               |	ДанныеДокумента.НомерСтроки КАК НомерСтроки,
	               |	ДанныеДокумента.ДатаНомер КАК РеквизитыПервичногоДокумента,
	               |	ВЫБОР
	               |		КОГДА ДанныеДокумента.ДокументВозникновенияРасходов = НЕОПРЕДЕЛЕНО
				   |				И НЕ ДанныеДокумента.ВидРасходов = ЗНАЧЕНИЕ(Перечисление.ВидыРасходовУСН.ПустаяСсылка)
	               |			ТОГДА &Ссылка
	               |		ИНАЧЕ ДанныеДокумента.ДокументВозникновенияРасходов
	               |	КОНЕЦ КАК ДокументВозникновенияРасходов,
	               |	ДанныеДокумента.ВидРасходов КАК ВидРасходов,
				   |	ДанныеДокумента.СтатьяРасходов КАК Статья,
				   |	ДанныеДокумента.Партия КАК Партия,
	               |	ДанныеДокумента.Содержание КАК Содержание
	               |ИЗ
	               |	Документ.ЗаписьКУДиР.Строки КАК ДанныеДокумента
	               |ГДЕ
	               |	ДанныеДокумента.Ссылка = &Ссылка";			   
				   
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаКУДиР2(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "КнигаУчетаДоходовИРасходовРаздел2";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	&Период КАК Период,
	               |	&Ссылка КАК Регистратор,
	               |	&Организация КАК Организация,
	               |	ДанныеДокумента.ЭлементРасходов,
	               |	ДанныеДокумента.ДатаОплаты,
	               |	ДанныеДокумента.Графа3_ДатаВводаВЭксплуатацию,
	               |	ДанныеДокумента.Графа4_ГосударственнаяРегистрация,
	               |	ДанныеДокумента.Графа5_ПервоначальнаяСтоимость,
	               |	ДанныеДокумента.Графа6_ОстаточнаяСтоимость,
	               |	ДанныеДокумента.Графа7_СрокПолезногоИспользования,
	               |	ДанныеДокумента.Графа8_КолКварталовВОтчетномПериоде,
				   |	ДанныеДокумента.Графа9_КолКварталовВНалПериоде,
				   |	ДанныеДокумента.Графа10_ДоляРасходовЗаНалПериод,
				   |	ДанныеДокумента.Графа11_ДоляРасходовЗаКвартал,
				   |	ДанныеДокумента.Графа12_СуммаРасходовЗаОтчетнПериод,
				   |	ДанныеДокумента.Графа13_СуммаРасходовЗаКвартал,
				   |	ДанныеДокумента.Графа14_РасходыПрошлыхПериодов,
				   |	ДанныеДокумента.Графа15_ОстатокРасходов,
				   |	ДанныеДокумента.Графа16_ДатаВыбытия,
	               |	ВЫБОР
	               |		КОГДА ДанныеДокумента.ДокументВозникновенияРасходов = НЕОПРЕДЕЛЕНО
	               |			ТОГДА &Ссылка
	               |		ИНАЧЕ ДанныеДокумента.ДокументВозникновенияРасходов
	               |	КОНЕЦ КАК ДокументВозникновенияРасходов
	               |ИЗ
	               |	Документ.ЗаписьКУДиР.Строки2 КАК ДанныеДокумента
	               |ГДЕ
	               |	ДанныеДокумента.Ссылка = &Ссылка";			   
				   
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции "УправлениеПечатью.СоздатьКоллекциюКомандПечати".
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли