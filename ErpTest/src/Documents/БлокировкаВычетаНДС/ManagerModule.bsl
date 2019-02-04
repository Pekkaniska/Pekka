#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("Состояние");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Данные.Состояние = Перечисления.СостоянияБлокировкиВычетаНДС.Установлена Тогда
		ПредставлениеОперации = НСтр("ru='Установка блокировки вычета НДС %1 от %2'");
	Иначе
		ПредставлениеОперации = НСтр("ru='Снятие блокировки вычета НДС %1 от %2'");
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОперации, Данные.Номер, Данные.Дата);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Процедура формирования движений по регистру "Состояния блокировки вычета НДС по счетам-фактурам".
//
// Параметры:
//	ДополнительныеСвойства - Структура, перечень таблиц значений для записи в регистры
//	Движения - Коллекция движений документа
//	Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьСостоянияБлокировкиВычетаНДСПоСчетамФактурам(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаСостоянияБлокировкиВычетаНДСПоСчетамФактурам = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСостоянияБлокировкиВычетаНДСПоСчетамФактурам;
	
	Если Отказ ИЛИ ТаблицаСостоянияБлокировкиВычетаНДСПоСчетамФактурам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияТоварыКОформлениюЗаявленийОВвозе = Движения.СостоянияБлокировкиВычетаНДСПоСчетамФактурам;
	ДвиженияТоварыКОформлениюЗаявленийОВвозе.Записывать = Истина;
	ДвиженияТоварыКОформлениюЗаявленийОВвозе.Загрузить(ТаблицаСостоянияБлокировкиВычетаНДСПоСчетамФактурам);
	
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

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаСостоянияБлокировкиВычетаНДСПоСчетамФактурам(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БлокировкаВычетаНДС.Ссылка,
	|	БлокировкаВычетаНДС.ПометкаУдаления,
	|	БлокировкаВычетаНДС.Номер,
	|	БлокировкаВычетаНДС.Дата,
	|	БлокировкаВычетаНДС.Проведен,
	|	БлокировкаВычетаНДС.Организация,
	|	БлокировкаВычетаНДС.Состояние,
	|	БлокировкаВычетаНДС.Комментарий,
	|	БлокировкаВычетаНДС.Ответственный
	|ИЗ
	|	Документ.БлокировкаВычетаНДС КАК БлокировкаВычетаНДС
	|ГДЕ
	|	БлокировкаВычетаНДС.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",      Реквизиты.Дата);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("Состояние",   Реквизиты.Состояние);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаСостоянияБлокировкиВычетаНДСПоСчетамФактурам(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СостоянияБлокировкиВычетаНДСПоСчетамФактурам";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = "
	|
	|ВЫБРАТЬ
	|	&Ссылка              КАК Регистратор,
	|	Операция.Дата        КАК Период,
	|	Операция.Организация КАК Организация,
	|	Операция.Состояние   КАК Состояние,
	|	Строки.СчетФактура   КАК СчетФактура
	|ИЗ
	|	Документ.БлокировкаВычетаНДС КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.БлокировкаВычетаНДС.СчетаФактуры КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли