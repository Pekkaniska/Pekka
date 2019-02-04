
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
		
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	ФормированиеПредставленияПродукцииНаСервере(Запись.П000010000309, Запись.П000010000308);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
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
		
	Заголовок = "Сведения о производстве вина, игристого вина (шампанского)";
	
	ФлажокОтклАвтоРасчет 	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет;
	ФлажокОтклАвтоВыборКодов	= УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мАвтоВыборКодов;
	ДатаПериодаОтчета = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мДатаКонцапериодаОтчета;
	
	ПодготовкаНаСервере();

	Если НЕ ВладелецФормы.ТекущийЭлемент = Неопределено Тогда
		
		ИмяАктивногоПоля = ВладелецФормы.ТекущийЭлемент.Имя;
		
		// Если активное поле Наименование продукции - перекинем на код.
		Если ИмяАктивногоПоля = "П000010000309" Тогда
		    ИмяАктивногоПоля = "П000010000308";			
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
Процедура П000010000308НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборВидаПродукции();
	
КонецПроцедуры


&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
		
	ОбработкаПослеИзменения();
		
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

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовкаНаСервере()
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		Запись.ИДДокИндСтраницы = РегламентированнаяОтчетностьАЛКО.ПолучитьИдДокИндСтраницы(Запись.Документ, ИндексСтраницыЗаписи);
	КонецЕсли;
		
	ДоступностьПолейНаСервере();	
	СформироватьСпискиВыбораНаСервере();
	ФормированиеПредставленияПродукцииНаСервере(Запись.П000010000309, Запись.П000010000308);
	
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
	// Для раздела Декларация приложения 14 нет авторасчета.
	
	Возврат;
	
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
	
КонецПроцедуры


&НаСервере
Процедура ФормированиеПредставленияПродукцииНаСервере(ВидПродукции = Неопределено, КодВида = Неопределено)
	
	Если ВидПродукции = Неопределено Тогда
	    ВидПродукции = Запись.П000010000309;	
	КонецЕсли;
	
	Если КодВида = Неопределено Тогда
	    КодВида = Запись.П000010000308;	
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
		
КонецПроцедуры


&НаКлиенте
Процедура ВыборВидаПродукции()
	
	// Из списка.
	ИсходноеЗначениеКода = СокрЛП(Запись.П000010000308);
	ИсходноеЗначениеНазвания = СокрЛП(Запись.П000010000309);
	КолонкаПоиска = "Код";
	ИмяКолонкиКодПродукции = "П000010000308";
		
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
	ИмяКолонкиКодПродукции 			= "П000010000308";
	ИмяКолонкиНаименованияПродукции = "П000010000309";
	
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
Процедура СформироватьСпискиВыбораНаСервере()
	
	ИмяМакета = "Списки2016Кв4";
	
	КоллекцияСписковВыбора = РегламентированнаяОтчетностьАЛКО.СчитатьКоллекциюСписковВыбораАЛКО(
														ИмяМакета, ИмяФормыВладельца, ОбъектЭтогоОтчета);
	
	СвойстваПоказателей.Очистить();
	
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000010000308", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);
	РегламентированнаяОтчетность.ДобавитьСтрокуОписанияВвода(СвойстваПоказателей, "П000010000309", 3, , "Выбор вида продукции", КоллекцияСписковВыбора["ВидыПродукции"]);
	
КонецПроцедуры


#КонецОбласти
