#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт 
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.СостоянияИРеквизитыДоставки");
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаписьРегистра.Распоряжение          КАК Распоряжение,
	|	ЗаписьРегистра.Склад                 КАК Склад,
	|	ЗаписьРегистра.ПолучательОтправитель КАК ПолучательОтправитель,
	|	ЗаписьРегистра.Перевозчик            КАК Перевозчик,
	|	ЗаписьРегистра.СпособДоставки        КАК СпособДоставки,
	|	ЗаписьРегистра.Зона                  КАК Зона
	|ИЗ
	|	РегистрСведений.СостоянияИРеквизитыДоставки КАК ЗаписьРегистра
	|ГДЕ
	|	ЗаписьРегистра.Адрес <> """"
	|		И ВЫРАЗИТЬ(ЗаписьРегистра.АдресЗначенияПолей КАК СТРОКА (500)) <> """"
	|		И НЕ ЗаписьРегистра.АдресЗначенияПолей ПОДОБНО ""%</КонтактнаяИнформация>""";
	
	ЗаписиКРегистрации = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ЗаписиКРегистрации, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	ДополнительныеПараметры.ВыбиратьПорциями = Ложь;
	
	ДанныеКОбработке = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		ПолноеИмяРегистра(),
		ДополнительныеПараметры);
	
	Пока ДанныеКОбработке.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра());
			ЭлементБлокировки.УстановитьЗначение("Распоряжение",          ДанныеКОбработке.Распоряжение);
			ЭлементБлокировки.УстановитьЗначение("Склад",                 ДанныеКОбработке.Склад);
			ЭлементБлокировки.УстановитьЗначение("ПолучательОтправитель", ДанныеКОбработке.ПолучательОтправитель);
			ЭлементБлокировки.УстановитьЗначение("Перевозчик",            ДанныеКОбработке.Перевозчик);
			ЭлементБлокировки.УстановитьЗначение("СпособДоставки",        ДанныеКОбработке.СпособДоставки);
			ЭлементБлокировки.УстановитьЗначение("Зона",                  ДанныеКОбработке.Зона);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.СостоянияИРеквизитыДоставки.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Распоряжение.Установить(ДанныеКОбработке.Распоряжение);
			НаборЗаписей.Отбор.Склад.Установить(ДанныеКОбработке.Склад);
			НаборЗаписей.Отбор.ПолучательОтправитель.Установить(ДанныеКОбработке.ПолучательОтправитель);
			НаборЗаписей.Отбор.Перевозчик.Установить(ДанныеКОбработке.Перевозчик);
			НаборЗаписей.Отбор.СпособДоставки.Установить(ДанныеКОбработке.СпособДоставки);
			НаборЗаписей.Отбор.Зона.Установить(ДанныеКОбработке.Зона);
			
			НаборЗаписей.Прочитать();
			
			ОбъектИзменен = Ложь;
			
			Для Каждого ЗаписьРегистра Из НаборЗаписей Цикл
				Если Не ПустаяСтрока(ЗаписьРегистра.АдресЗначенияПолей) Тогда
					НовыеЗначенияПолей = "";
					ОбщегоНазначенияУТ.ЗаполнитьЗначенияПолейКИПоПредставлению(ЗаписьРегистра.Адрес, НовыеЗначенияПолей);
					ЗаписьРегистра.АдресЗначенияПолей = НовыеЗначенияПолей;
					ОбъектИзменен = Истина;
				КонецЕсли;
			КонецЦикла;
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ДанныеКОбработке.Распоряжение);
			Продолжить;
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра());
	
КонецПроцедуры

#КонецОбласти

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрСведений.СостоянияИРеквизитыДоставки";
	
КонецФункции

#КонецОбласти

#КонецЕсли