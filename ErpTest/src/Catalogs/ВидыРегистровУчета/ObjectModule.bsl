
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Отчет) Тогда
		МетаданныеОтчета = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Отчет);
		
		ЭтоОтчет = Ложь;
		Если МетаданныеОтчета <> Неопределено Тогда
			ЭтоОтчет = Метаданные.Отчеты.Содержит(МетаданныеОтчета);
		КонецЕсли;
		
		Если НЕ ЭтоОтчет Тогда
			ТекстСообщения = НСтр("ru = 'Вид регистра учета можно вводить только для отчетов'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Отчет", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Отчет", Отчет);
	Запрос.Параметры.Вставить("ВариантОтчета", ВариантОтчета);
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыРегистровУчета.Представление
	|ИЗ
	|	Справочник.ВидыРегистровУчета КАК ВидыРегистровУчета
	|ГДЕ
	|	ВидыРегистровУчета.Отчет = &Отчет
	|	И ВидыРегистровУчета.ВариантОтчета = &ВариантОтчета
	|	И ВидыРегистровУчета.Ссылка <> &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'Вид регистра учета для отчета %1 %2 %3 уже существует %4'");
		ОписаниеВариантОтчета = ?(ВариантОтчета = "", "", " " + НСтр("ru = 'и варианта'") + " ");
		ТекстСообщения =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, 
							Отчет, ОписаниеВариантОтчета, ВариантОтчета, Выборка.Представление);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Отчет", "Объект", Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

