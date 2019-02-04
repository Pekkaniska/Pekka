#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("СпособУстановкиКурса");
	Результат.Добавить("Наценка");
	Результат.Добавить("ОсновнаяВалюта");
	Результат.Добавить("ФормулаРасчетаКурса");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

// Процедура заполняет справочник валюты значениями по умолчанию.
//
Процедура ЗаполнитьВалютыПоУмолчанию() Экспорт
	
	Коды = Новый Массив;
	Коды.Добавить("643");
	РаботаСКурсамиВалют.ДобавитьВалютыПоКоду(Коды);
	
КонецПроцедуры // ЗаполнитьВалютыПоУмолчанию()

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВалютаОснованияСчетаФактуры") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ВалютаРегламентированногоУчета);
		
		Если ЗначениеЗаполнено(Параметры.ВалютаОснованияСчетаФактуры)
		 И Параметры.ВалютаОснованияСчетаФактуры <> ВалютаРегламентированногоУчета Тогда
			ДанныеВыбора.Добавить(Параметры.ВалютаОснованияСчетаФактуры);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		
		Параметры.Вставить("Ключ", ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета());
		ВыбраннаяФорма = "ФормаЭлемента";
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ
#Область ОбновлениеИнформационнойБазы

#КонецОбласти
//-- НЕ УТ
#КонецЕсли