

#Область ОписаниеПеременных

&НаСервере
Перем ОбъектЭтогоОтчета; // Объект метаданных отчета, из которого открыта форма записи.

&НаКлиенте
Перем УправляемаяФормаВладелец; // Форма отчета, из которого открыта форма записи.

&НаКлиенте
Перем УникальностьФормы; // Уникальный идентификатор формы отчета.

&НаКлиенте
Перем ПоказыватьПредупреждениеПослеПереходаПоСсылке; // Флаг необходимости показа предупреждения.

// Форма выбора из списка, ввода пары значений, форма длительной операции, 
// записи регистра, ввода данных по ОП и т.д.
// Любая открытая из данной формы форма в режиме блокировки владельца.
&НаКлиенте
Перем ОткрытаяФормаПотомокСБлокировкойВладельца Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеВидимостью(Ложь);
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	ФормированиеПредставленияПродукцииНаСервере(Запись.П000010000301, Запись.П000010000302);
		
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	// Определим тексты запросов динамических списков.
			
	ВставитьКодПродукции = Ложь;
	
	ТекстЗапроса = РегламентированнаяОтчетностьАЛКО.ТекстЗапросаВыбораПроизводителяИмпортераАЛКО(
																	ВставитьКодПродукции, "Пиво");	    
	ДинСписокПроизводителяИмпортера.ТекстЗапроса = ТекстЗапроса;
	ДинСписокПроизводителяИмпортера.ОсновнаяТаблица = "Справочник.Контрагенты";
	ДинСписокПроизводителяИмпортера.ДинамическоеСчитываниеДанных = Истина;
	
	Если ВставитьКодПродукции Тогда
		ДинСписокПроизводителяИмпортера.Параметры.УстановитьЗначениеПараметра("КодПродукции", Запись.П000010000302);
	КонецЕсли;
	
	Элементы.ТаблицаПроизводителей.Обновить();
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекстПредупреждения = НСтр("ru='Данная форма предназначена для редактирования данных из форм регламентированных отчетов.
										|
										|Открытие данной формы не из формы регламентированного отчета не предусмотрено!'");
	
	// Ищем управляемую форму, откуда открыли.
	Если ВладелецФормы = Неопределено Тогда
		
	    Отказ = Истина;		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
				
	ТекущийРодитель = ВладелецФормы;
	 
	Пока ТипЗнч(ТекущийРодитель) <> Тип("УправляемаяФорма") Цикл
	    ТекущийРодитель = ТекущийРодитель.Родитель;		
	КонецЦикла;
	
	УправляемаяФормаВладелец = ТекущийРодитель;
		
	ИмяФормыВладельца 	= УправляемаяФормаВладелец.ИмяФормы;
		
	Если СтрНайти(ИмяФормыВладельца, "РегламентированныйОтчетАлко") = 0 Тогда
	
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	
	КонецЕсли;
	
	УникальностьФормы   = УправляемаяФормаВладелец.УникальностьФормы;
	Оповестить("ОткрытаФормаЗаписиРегистра", ЭтаФорма, УникальностьФормы);
		
	ТекущееСостояниеВладельца = УправляемаяФормаВладелец.ТекущееСостояние;
	
    ДокументЗаписи = 		УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИндексСтраницыЗаписи = 	УправляемаяФормаВладелец.ИндексАктивнойСтраницыВРегистре;
	ИндексСтраницы = 		УправляемаяФормаВладелец.НомерАктивнойСтраницыМногострочногоРаздела;
	НомерПоследнейЗаписи = 	УправляемаяФормаВладелец.КоличествоСтрок;
	МаксИндексСтраницы = 	УправляемаяФормаВладелец.МаксИндексСтраницы;
	
	ПоказыватьПредупреждениеПослеПереходаПоссылке = УправляемаяФормаВладелец.ПоказыватьПредупреждениеПослеПереходаПоссылке;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
				
		// Заполним измерения, их нет на форме.
	    Запись.Активно = Истина;
		
		Запись.Документ = ДокументЗаписи;
				
		НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
	    Запись.ИндексСтроки = НомерПоследнейЗаписи;
		
		Модифицированность = Истина;
		
	КонецЕсли;
		
	Заголовок = "Движение слабоалкогольной продукции";
	
	ФлажокОтклАвтоРасчет 	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет;
	ФлажокОтклАвтоВыборКодов	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мАвтоВыборКодов;
	ДатаПериодаОтчета = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мДатаКонцапериодаОтчета;
	
	ПодготовкаНаСервере();

	Если НЕ ВладелецФормы.ТекущийЭлемент = Неопределено Тогда
		
		ИмяАктивногоПоля = ВладелецФормы.ТекущийЭлемент.Имя;
		
		// Если активное поле Наименование продукции - перекинем на код.
		Если ИмяАктивногоПоля = "П000010000301" Тогда
		    ИмяАктивногоПоля = "П000010000302";			
		КонецЕсли; 
		
	    АктивноеПоле = Элементы.Найти(ИмяАктивногоПоля);
		Если НЕ АктивноеПоле = Неопределено Тогда
		    ТекущийЭлемент = АктивноеПоле;		
		КонецЕсли;
	
	КонецЕсли;
			
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытаФормаЗаписиРегистра", , УникальностьФормы);
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
				
	ВнесеныИзменения = Модифицированность;
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоПервоеРедактирование = Ложь;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "ДобавлениеСтроки");
									
	ИначеЕсли ВнесеныИзменения Тогда
		
		// Нужно записать первоначальные данные Записи регистра в журнал.
		// Но сделать это надо только для случая первого изменения Записи после последнего сохранения отчета,
		// чтобы была информация о данных до изменения в случае отката внесенных изменений, если
		// отказался пользователь от сохранения отчета.
		
		ЭтоПервоеРедактирование = РегламентированнаяОтчетностьАЛКО.ЭтоПервоеРедактированиеЗаписиРегистра(ТекущийОбъект.Документ, ИмяРегистра, 
															ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки);
				
	КонецЕсли;
	
	Если ЭтоПервоеРедактирование Тогда
		
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("НачальноеЗначение", НачальноеЗначение);
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		// Нужно сохранить первоначальные данные.
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "Редактирование", Ресурсы);
	Иначе
									
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);		
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, 0, "Сервис", Ресурсы);							
	КонецЕсли;
	
	Если ВнесеныИзменения Тогда
		РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
											Запись, ИмяРегистра, КонечноеЗначениеСтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		
	// Оповещаем о необходимости пересчета итогов форму-владелец для активных записей.
	Если ВнесеныИзменения и Запись.Активно Тогда
	 
		// Оповещаем форму-владелец о изменениях.
		ИнформацияДляПересчетаИтогов = Новый Структура;
		ИнформацияДляПересчетаИтогов.Вставить("ИмяРегистра", 		ИмяРегистра);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтраницы", 	ИндексСтраницы);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтроки", 		Запись.ИндексСтроки);
		ИнформацияДляПересчетаИтогов.Вставить("НачальноеЗначение", 	НачальноеЗначениеСтруктураДанных);
		ИнформацияДляПересчетаИтогов.Вставить("КонечноеЗначение", 	КонечноеЗначениеСтруктураДанных);
		
		Оповестить("ПересчетИтогов", ИнформацияДляПересчетаИтогов, УникальностьФормы);
	
	КонецЕсли;
	
	ВнесеныИзменения = Ложь;
		
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если (НЕ ЗавершениеРаботы = Неопределено) и ЗавершениеРаботы Тогда
		// Идет завершение работы системы.
	Иначе
		// Обычное закрытие.
	    Если Элементы.ГруппаВыборПроизводителя.Видимость Тогда
		    // Щелкнули на крестик при выборе производителя.
			Отказ = Истина;
		    УправлениеВидимостью(Ложь);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормыЗаписи") Тогда			
		    Модифицированность = Ложь;
			Закрыть();			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура П000010000301Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура П000010000302Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура П000010000304ПриИзменении(Элемент)
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры


&НаКлиенте
Процедура П000010000305ПриИзменении(Элемент)
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры


&НаКлиенте
Процедура П000010000303ПриИзменении(Элемент)
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры


&НаКлиенте
Процедура ПроизводительИмпортерПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	НажатиеГиперссылки(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПроизводителей

&НаКлиенте
Процедура ТаблицаПроизводителейВыбор(Элемент, ВыбраннаяСтрока = Неопределено, Поле = Неопределено, СтандартнаяОбработка = Истина)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	Производитель 		= Элемент.ТекущиеДанные.НаименованиеПолное;
	
	ПроизводительИНН	= Элемент.ТекущиеДанные.ИНН;
	ПроизводительКПП	= Элемент.ТекущиеДанные.КПП;	
	
	ТаблицаПроизводителейВыборНаСервере(Производитель, ПроизводительИНН, ПроизводительКПП);
			
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПроизводителейПриАктивизацииСтроки(Элемент)
	
	Если НЕ ПроверялиНеобходимостьПоказаПредупреждения Тогда	
		
		Элементы.ГруппаИнфоВыбораПроизводителя.Видимость = (Элемент.ТекущиеДанные = Неопределено);			
		
		ПроверялиНеобходимостьПоказаПредупреждения = Истина;
		
	КонецЕсли;	 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьИЗакрыть(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ Модифицированность Тогда
	    Закрыть();
	Иначе	
	    Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПроизводителяИмпортера(Команда)
	
	УправлениеВидимостью(Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура ВыборПроизводителя(Команда)
	
	ТаблицаПроизводителейВыбор(Элементы.ТаблицаПроизводителей);
	
КонецПроцедуры


&НаКлиенте
Процедура ВернутьсяНазад(Команда)
	
	УправлениеВидимостью(Ложь);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовкаНаСервере()
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		Запись.ИДДокИндСтраницы = РегламентированнаяОтчетностьАЛКО.ПолучитьИдДокИндСтраницы(Запись.Документ, ИндексСтраницыЗаписи);
	КонецЕсли;
	
	УправлениеВидимостью(Ложь);
	
	ДоступностьПолейНаСервере();	
	СформироватьСпискиВыбораНаСервере();
	ФормированиеПредставленияПродукцииНаСервере(Запись.П000010000301, Запись.П000010000302);
		
	// Заполним начальное значение всех полей записи во внутреннем формате.
	ИмяРегистра = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяОбъектаМетаданныхПоИмениФормы(ИмяФормы);
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		// Начальные данные в этих случаях всегда пустые.
		НачальноеЗначениеСтруктураДанных = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(ИмяРегистра);
		НачальноеЗначение = ЗначениеВСтрокуВнутр(НачальноеЗначениеСтруктураДанных);
		
	Иначе
		НачальноеЗначение = РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
															Запись, ИмяРегистра, НачальноеЗначениеСтруктураДанных);
	КонецЕсли;	
	
	
КонецПроцедуры


&НаСервере
Процедура ДоступностьПолейНаСервере()
	
	// Доступность полей формы в зависимости от флажка Авторасчет в отчете-владельце.
	Элементы.П000010000310.ТолькоПросмотр = НЕ ФлажокОтклАвтоРасчет;
	Элементы.П000010000313.ТолькоПросмотр = НЕ ФлажокОтклАвтоРасчет;
	Элементы.П000010000317.ТолькоПросмотр = НЕ ФлажокОтклАвтоРасчет;
	Элементы.П000010000318.ТолькоПросмотр = НЕ ФлажокОтклАвтоРасчет;
	
	Элементы.П000010000310.ПропускатьПриВводе = НЕ ФлажокОтклАвтоРасчет;
	Элементы.П000010000313.ПропускатьПриВводе = НЕ ФлажокОтклАвтоРасчет;
	Элементы.П000010000317.ПропускатьПриВводе = НЕ ФлажокОтклАвтоРасчет;
	Элементы.П000010000318.ПропускатьПриВводе = НЕ ФлажокОтклАвтоРасчет;
	
КонецПроцедуры


&НаСервере
Функция ОбъектОтчета(ИмяФормыОбъекта)
	
	Возврат РегламентированнаяОтчетностьАЛКО.ОбъектОтчетаАЛКО(ИмяФормыОбъекта, ОбъектЭтогоОтчета);
	
КонецФункции


&НаСервере
Процедура ОбработкаМодифицированности(НачальноеЗначениеПолей, СтруктураМодифицированности)
	
	МодифицированностьКлючевыхПолей = Ложь;
	Для Каждого ЭлСтруктуры Из СтруктураМодифицированности Цикл
	
		ИмяПоля = ЭлСтруктуры.Ключ;
		Если Лев(ИмяПоля, 2) <> "П0" Тогда
		    // Это не ресурс.
			Продолжить;			
		КонецЕсли;
					
		Если ЭлСтруктуры.Значение Тогда
		    МодифицированностьКлючевыхПолей = Истина;
			Прервать;			
		КонецЕсли; 
	
	КонецЦикла;
	
	Если НЕ МодифицированностьКлючевыхПолей Тогда
		
		// Принудительно записываем начальные данные, включая всю
		// вспомогательную информацию.
		ЗаполнитьЗначенияСвойств(Запись, НачальноеЗначениеПолей);
		
	Иначе
		
		// Анализ изменений Производителя.
		ИНН = СокрЛП(Запись.П000010000304);
		КПП = СокрЛП(Запись.П000010000305);
		НаименованиеПолное = СокрЛП(Запись.П000010000303);
		КодПродукции = Запись.П000010000302;
																		
		ПроизводительИмпортер = ОбъектОтчета(ИмяФормыВладельца).ОпределитьПроизводителяИмпортера(
																ИНН, КПП, НаименованиеПолное, КодПродукции);
		
		НужноОбработатьЗапись = Ложь;														
		Если НЕ Запись.ПроизводительИмпортер = ПроизводительИмпортер Тогда																	
		    Запись.ПроизводительИмпортер = ПроизводительИмпортер;
			НужноОбработатьЗапись = Истина;
		КонецЕсли;
						
		Если НЕ Запись.П000010000303 = НаименованиеПолное  Тогда		
			Запись.П000010000303 = НаименованиеПолное;
			НужноОбработатьЗапись = Истина;		
		КонецЕсли;
		
		Если НЕ Запись.П000010000305 = КПП  Тогда			
			Запись.П000010000305 = КПП;
			НужноОбработатьЗапись = Истина;			
		КонецЕсли;
		
		Если НужноОбработатьЗапись Тогда		
			// Возможно изменение Хеша - поэтому обработаем.
			ОбъектОтчета(ИмяФормыВладельца).ОбработкаЗаписи(ИмяРегистра, Запись);		
		КонецЕсли;
		
	КонецЕсли;
		
	Модифицированность = МодифицированностьКлючевыхПолей;
	
КонецПроцедуры


&НаСервере
Процедура ОбработкаПослеИзменения()
	
	ОбъектОтчета(ИмяФормыВладельца).ОбработкаЗаписи(ИмяРегистра, Запись);
	
	СтруктураМодифицированности = "";
	РегламентированнаяОтчетностьАЛКО.ЗаписьИзменилась(Запись, НачальноеЗначениеСтруктураДанных, 
														Ложь, СтруктураМодифицированности);
	ОбработкаМодифицированности(НачальноеЗначениеСтруктураДанных, СтруктураМодифицированности);
	
	ФормированиеЗаголовковСвернутогоОтображения();
	
КонецПроцедуры


&НаСервере
Процедура ФормированиеЗаголовковСвернутогоОтображения()
		
	// Группа ПроизводительИмпортер.
	Элементы.ПроизводительИмпортерПредставление.Видимость = ЗначениеЗаполнено(Запись.ПроизводительИмпортер);
	
	Если ЗначениеЗаполнено(Запись.П000010000303) 
		или ЗначениеЗаполнено(Запись.П000010000304)
		или ЗначениеЗаполнено(Запись.П000010000305)
		Тогда
	    Элементы.ГруппаПроизводительИмпортер.ЗаголовокСвернутогоОтображения = "Производитель или импортер: " + 
			?(ЗначениеЗаполнено(Запись.П000010000303),Запись.П000010000303, "наименование не заполнено") 
			+ ?(ЗначениеЗаполнено(Запись.П000010000304),", ИНН " + Запись.П000010000304, ", ИНН не заполнено")
			+ ?(ЗначениеЗаполнено(Запись.П000010000305),", КПП " + Запись.П000010000305, 
											?(СтрДлина(Запись.П000010000304) = 10,", КПП не заполнено", "") );
	Иначе	
	    Элементы.ГруппаПроизводительИмпортер.ЗаголовокСвернутогоОтображения = 
							Элементы.ГруппаПроизводительИмпортер.Заголовок + " не заполнены!";							
	КонецЕсли;
						
	// Доступ к КПП только если введен 10 значный ИНН.
	Если СтрДлина(Запись.П000010000304) = 10 Тогда
	    Элементы.П000010000305.ТолькоПросмотр = Ложь;
		Элементы.П000010000305.ПропускатьПриВводе = Ложь;
	Иначе
		
	    Элементы.П000010000305.ТолькоПросмотр = Истина;
		Элементы.П000010000305.ПропускатьПриВводе = Истина;
		Если НЕ Запись.П000010000305 = "" Тогда
		    Запись.П000010000305 = "";
			Модифицированность = Истина;		
		КонецЕсли; 
		
	КонецЕсли; 
		
	// Остатки.
	Элементы.Остатки.ЗаголовокСвернутогоОтображения = "Остатки: на начало периода " 
					+ Формат(Запись.П000010000306, "ЧЦ = 15; ЧДЦ = 5; ЧН=; ЧВН;") + " | " 
					+ "на конец периода " + Формат(Запись.П000010000318, "ЧЦ = 15; ЧДЦ = 5; ЧН=; ЧВН;");
	
	// Поступление.
	Элементы.Поступление.ЗаголовокСвернутогоОтображения = "Поступление: всего " 
					+ Формат(Запись.П000010000313, "ЧЦ = 15; ЧДЦ = 5; ЧН=; ЧВН;") + " включая  закупки " 
					+ Формат(Запись.П000010000310, "ЧЦ = 15; ЧДЦ = 5; ЧН=; ЧВН;");
	
	// Расход.
	Элементы.Расход.ЗаголовокСвернутогоОтображения = "Расход: всего " 
					+ Формат(Запись.П000010000317, "ЧЦ = 15; ЧДЦ = 5; ЧН=; ЧВН;") + " включая  розничную продажу " 
					+ Формат(Запись.П000010000314, "ЧЦ = 15; ЧДЦ = 5; ЧН=; ЧВН;");
	
КонецПроцедуры


&НаСервере
Процедура ФормированиеПредставленияПродукцииНаСервере(ВидПродукции = Неопределено, КодВида = Неопределено)
	
	Если ВидПродукции = Неопределено Тогда
	    ВидПродукции = Запись.П000010000301;	
	КонецЕсли; 
	Если КодВида = Неопределено Тогда
	    КодВида = Запись.П000010000302;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодВида) Тогда
	    ПредставлениеПродукции = "Код " + КодВида + ", " + ВидПродукции;
	Иначе	
	    ПредставлениеПродукции = "Заполнить";
	КонецЕсли; 
	
	Если ПредставлениеПродукции = "Заполнить" Тогда		
		Элементы.Представление.ЦветТекста = ЦветСтиляНезаполненныйРеквизит;
	Иначе
		Элементы.Представление.ЦветТекста = ЦветСтиляЦветГиперссылкиБРО;
	КонецЕсли;
		
	ФормированиеЗаголовковСвернутогоОтображения();
		
КонецПроцедуры


&НаКлиенте
Процедура ВыборВидаПродукции()
	
	// Из списка.
	ИсходноеЗначениеКода = СокрЛП(Запись.П000010000302);
	ИсходноеЗначениеНазвания = СокрЛП(Запись.П000010000301);
	КолонкаПоиска = "Код";
	ИмяКолонкиКодПродукции = "П000010000302";
		
	// Не из списка.
	ЗаголовокФормы = "Ввод вида продукции";
	НадписьПоляЗначения = "Вид продукции";
	НадписьПоляКод = "Код";
	МногострочныйРежимЗначения = Истина;
	ДлинаПоляКода  = 4;
	ДлинаПоляЗначения = 40;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборЗавершение", ЭтотОбъект);
		
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ПараметрыПриВключенномВыбореИзСписка", Новый Структура);
	ПараметрыВыборИзСписка = СтруктураПараметров.ПараметрыПриВключенномВыбореИзСписка;
	// Из списка.
	ПараметрыВыборИзСписка.Вставить("СвойстваПоказателей", 	СвойстваПоказателей);
	ПараметрыВыборИзСписка.Вставить("ИмяКолонкиКод", 		ИмяКолонкиКодПродукции);	
	ПараметрыВыборИзСписка.Вставить("КолонкаПоиска", 		КолонкаПоиска);
	ПараметрыВыборИзСписка.Вставить("ИсходноеЗначение", 	ИсходноеЗначениеКода);
	
	СтруктураПараметров.Вставить("ПараметрыПриОтключенномВыбореИзСписка", Новый Структура);
	ПараметрыВыборНеИзСписка = СтруктураПараметров.ПараметрыПриОтключенномВыбореИзСписка;
	// Не из списка.
	ПараметрыВыборНеИзСписка.Вставить("ЗаголовокФормы", 			ЗаголовокФормы);
	ПараметрыВыборНеИзСписка.Вставить("ИсходноеЗначениеКода", 		ИсходноеЗначениеКода);	
	ПараметрыВыборНеИзСписка.Вставить("ИсходноеЗначениеПоКоду",		ИсходноеЗначениеНазвания);
	ПараметрыВыборНеИзСписка.Вставить("НадписьПоляЗначения", 		НадписьПоляЗначения);
	ПараметрыВыборНеИзСписка.Вставить("НадписьПоляКод", 			НадписьПоляКод);
	ПараметрыВыборНеИзСписка.Вставить("МногострочныйРежимЗначения", МногострочныйРежимЗначения);
	ПараметрыВыборНеИзСписка.Вставить("ДлинаПоляКода", 				ДлинаПоляКода);
	ПараметрыВыборНеИзСписка.Вставить("ДлинаПоляЗначения", 			ДлинаПоляЗначения);
	ПараметрыВыборНеИзСписка.Вставить("УникальностьФормы", 			УникальностьФормы);

	
	РегламентированнаяОтчетностьАЛКОКлиент.ВызватьФормуВыбораЗначенийАЛКО(
			ЭтаФорма, ФлажокОтклАвтоВыборКодов, СтруктураПараметров, ОписаниеОповещения);
		
КонецПроцедуры


&НаКлиенте
Процедура ВыборЗавершение(РезультатВыбора, Параметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если РезультатВыбора = Неопределено Тогда
	    Возврат;	
	КонецЕсли; 
	
	// Поскольку всегда "выбираем" код.
	ИмяКолонкиКодПродукции 			= "П000010000302";
	ИмяКолонкиНаименованияПродукции = "П000010000301";
	
	ИсходноеЗначение 				= СокрЛП(Запись[ИмяКолонкиКодПродукции]);
	Запись[ИмяКолонкиКодПродукции] 	= СокрЛП(РезультатВыбора.Код);
	
	КодИзменился = (ИсходноеЗначение <> СокрЛП(Запись[ИмяКолонкиКодПродукции]));
		
	ИсходноеЗначениеНаименования 			= СокрЛП(Строка(Запись[ИмяКолонкиНаименованияПродукции]));
	Запись[ИмяКолонкиНаименованияПродукции] = ?(СокрЛП(РезультатВыбора.Код) = "",
													"", СокрЛП(РезультатВыбора.Название));
	
	НаименованиеИзменилось = (ИсходноеЗначениеНаименования <> СокрЛП(Запись[ИмяКолонкиНаименованияПродукции]));	
	
	Модифицированность = Модифицированность или КодИзменился или НаименованиеИзменилось;
	
	ФормированиеПредставленияПродукцииНаСервере();	
	ОбработкаПослеИзменения(); 
	
КонецПроцедуры


&НаСервере
Процедура Расчет()

	Если ФлажокОтклАвтоРасчет Тогда
	    Возврат;	
	КонецЕсли; 
	
	ИдГруппы = "П0000100003";
		
	ОбъектОтчета(ИмяФормыВладельца).Расчет(ИдГруппы, Запись);
	ФормированиеЗаголовковСвернутогоОтображения();
	
КонецПроцедуры


&НаСервере
Процедура СформироватьСпискиВыбораНаСервере()
		
	Если ДатаПериодаОтчета < '20131101' Тогда
		ИмяМакета = "Списки2012Кв3";
	ИначеЕсли ДатаПериодаОтчета < '20140901' Тогда
		ИмяМакета = "Списки2012Кв3_20131101";
	Иначе
		// С 3-го квартала 2015 года действует новый список.
		// Отчет квартальный, поэтому можно указать 01.09 как границу
		ИмяМакета = ?(ДатаПериодаОтчета < '20150901', "Списки2014Кв4", "Списки2015Кв3");		
	КонецЕсли;
	
	КоллекцияСписковВыбора = РегламентированнаяОтчетностьАЛКО.СчитатьКоллекциюСписковВыбораАЛКО(
														ИмяМакета, ИмяФормыВладельца, ОбъектЭтогоОтчета);
	
	СвойстваПоказателей.Очистить();
		
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000010000301", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000010000302", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);

КонецПроцедуры


&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
	
	Расчет();
	ОбработкаПослеИзменения();
	
КонецПроцедуры


&НаСервере
Процедура УправлениеВидимостью(ПоказатьВыбор = Ложь)
	
	Если ПоказатьВыбор Тогда
		
		ПроверялиНеобходимостьПоказаПредупреждения = Ложь;
		
		Если ВставитьКодПродукции Тогда
			ДинСписокПроизводителяИмпортера.Параметры.УстановитьЗначениеПараметра("КодПродукции", Запись.П000010000302);
		КонецЕсли;
		
		Элементы.ОК.Видимость = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.ГруппаЗапись.Видимость = Ложь;
		Элементы.ГруппаВыборПроизводителя.Видимость = Истина;
		
		Если ЗначениеЗаполнено(Запись.ПроизводительИмпортер) Тогда
		
			Элементы.ТаблицаПроизводителей.ТекущаяСтрока = Запись.ПроизводительИмпортер;
		
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаИнфоВыбораПроизводителя.Видимость = Ложь;
		
		Элементы.ГруппаВыборПроизводителя.Видимость = Ложь;
		Элементы.ГруппаЗапись.Видимость = Истина;	
		Элементы.Отмена.Видимость = Истина;
		Элементы.ОК.Видимость = Истина;	
		
	КонецЕсли; 
	
КонецПроцедуры


&НаСервере
Функция ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка = Неопределено)
	
	ЗначениеСсылка = РегламентированнаяОтчетностьАЛКО.ПолучитьЗначениеЭлементаФормы(ЭтаФорма, ИмяЭлементаСсылки);	
	ИмяФормыОбъекта = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяФормыОбъекта(ЗначениеСсылка);
	
	Возврат ИмяФормыОбъекта;
	
КонецФункции


&НаКлиенте
Процедура НажатиеГиперссылки(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ИмяЭлементаСсылки = Элемент.Имя;
	
	ЗначениеСсылка = Неопределено;
	ИмяФормыОбъекта = ПолучитьИмяФормыОбъектаЭлементаСсылки(ИмяЭлементаСсылки, ЗначениеСсылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НажатиеГиперссылкиЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ЗначениеСсылка);
	ОткрытаяФормаПотомокСБлокировкойВладельца = ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы, 
			ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


&НаКлиенте
Процедура НажатиеГиперссылкиЗавершение(Результат, ДопПараметры) Экспорт
	
	ОткрытаяФормаПотомокСБлокировкойВладельца = Неопределено;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке = Неопределено Тогда
	    ПоказыватьПредупреждениеПослеПереходаПоссылке = Истина;	
	КонецЕсли;
	
	Если ПоказыватьПредупреждениеПослеПереходаПоссылке Тогда
	    // Открываем форму предупреждения.
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Внимание!'"));
		ПараметрыФормы.Вставить("ТекстПредупреждения", НСтр("ru='"
				+ "Если Вы внесли изменения в элемент справочника или документ,"
				+ " для внесения изменений в строки отчета, заполняемых на основании"
				+ " измененной информации, необходимо перезаполнить Отчет.
				|
				|Для этого в основной форме отчета нужно нажать кнопку ""Заполнить"".
				|
				|Не обязательно это делать прямо сейчас, это можно сделать после внесения"
				+ " всех необходимых правок по разным документам и справочникам.'"));
		ПараметрыФормы.Вставить("ТекстЗаголовкаФлажка", НСтр("ru='Больше не показывать в этом сеансе редактирования'"));
		ПараметрыФормы.Вставить("УникальностьФормы",       		УникальностьФормы);
		
		ИмяФормыПредупреждения = "ОбщаяФорма.АЛКОФормаПредупрежденияСФлажком";
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьСостояниеФлажкаФормыПредупреждения", ЭтотОбъект);
		ОткрытьФорму(ИмяФормыПредупреждения, ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьСостояниеФлажкаФормыПредупреждения(Результат, ДопПараметры) Экспорт
	
	Если (НЕ Результат = Неопределено) и Результат Тогда
		// Оповещаем форму отчета владельца о том, что больше показывать
		// предупреждение не надо.
		ПоказыватьПредупреждениеПослеПереходаПоссылке = Ложь;
		Оповестить("ПоказыватьПредупреждениеПослеПереходаПоСсылке", , УникальностьФормы);		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ТаблицаПроизводителейВыборНаСервере(Производитель, ПроизводительИНН, ПроизводительКПП)
		
	Запись.П000010000304 = СокрЛП(ПроизводительИНН);
	Запись.П000010000305 = СокрЛП(ПроизводительКПП);
	Запись.П000010000303 = СокрЛП(Производитель);
	
	УправлениеВидимостью(Ложь);
	
	ОбработкаПослеИзменения();
	
КонецПроцедуры

#КонецОбласти
