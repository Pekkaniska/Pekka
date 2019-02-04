
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетРасходовПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("СчетРасходов");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетРасходов") Тогда
		
		Если ЗначениеЗаполнено(Объект.СчетРасходов) Тогда
			Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Истина;
			ОбновитьЗаголовкиСубконтоСчетаРасходов();
		Иначе
			Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовкиСубконтоСчетаРасходов()
	
	Элементы.СчетРасходовСубконто1.Видимость = Ложь;
	Элементы.СчетРасходовСубконто2.Видимость = Ложь;
	Элементы.СчетРасходовСубконто3.Видимость = Ложь;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 3
		|	СубконтоСчета.ВидСубконто.Наименование КАК Заголовок,
		|	СубконтоСчета.ВидСубконто.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	ПланСчетов.Международный.ВидыСубконто КАК СубконтоСчета
		|ГДЕ
		|	СубконтоСчета.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СубконтоСчета.НомерСтроки"
	);
	Запрос.УстановитьПараметр("Ссылка", Объект.СчетРасходов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = 1;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].Заголовок = "   " + Выборка.Заголовок;
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].ОграничениеТипа = Выборка.ТипЗначения;
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].Видимость = Истина;
		Индекс = Индекс + 1;
	КонецЦикла;
	
КонецПроцедуры

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти