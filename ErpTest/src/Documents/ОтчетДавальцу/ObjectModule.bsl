#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в заказе клиента
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияПродаж.Валюта;
	ВалютаВзаиморасчетов = УсловияПродаж.ВалютаВзаиморасчетов;
	НаправлениеДеятельности = УсловияПродаж.НаправлениеДеятельности;
	
	ЦенаВключаетНДС       = УсловияПродаж.ЦенаВключаетНДС;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) И УсловияПродаж.Организация <> Организация Тогда
		Организация = УсловияПродаж.Организация;
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    			= Организация;
		СтруктураПараметров.НаправлениеДеятельности = НаправлениеДеятельности;
		БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент) И УсловияПродаж.Контрагент <> Контрагент Тогда
			Контрагент = УсловияПродаж.Контрагент;
		КонецЕсли;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияПродаж.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		
		Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(
			ПараметрыОбъектаССоглашением(),
			Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья,
			ВалютаВзаиморасчетов);
		
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
			НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, , Договор);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(УсловияПродаж.ИспользуютсяДоговорыКонтрагентов) 
		ИЛИ НЕ УсловияПродаж.ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокОплаты = УсловияПродаж.ПорядокОплаты;
	Иначе
		ПорядокОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокОплаты");
	КонецЕсли;
	
	ЗаполнитьУсловияРасчетов(УсловияПродаж);
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияПродаж.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ДатаНачала = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в заказе клиента
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			Новый Структура (
				"ТолькоТиповые,
				|УчитыватьГруппыСкладов,
				|ИсключитьГруппыСкладовДоступныеВЗаказах,
				|ХозяйственнаяОперация,
				|ВыбранноеСоглашение",
				Истина,
				Истина,
				Истина,
				Перечисления.ХозяйственныеОперации.РеализацияКлиенту,
				Справочники.СоглашенияСКлиентами.ПустаяСсылка()));
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение) Тогда
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		КонецЕсли;
		
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	АдресДоставки = ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(Партнер);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПараметрыОкругления = ОбщегоНазначенияУТ.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяТЧ = "Продукция";
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	СформироватьСписокЗависимыхЗаказов();
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(
		Продукция,
		ЦенаВключаетНДС);
	
	Если Валюта = ВалютаВзаиморасчетов Тогда
		СуммаВзаиморасчетов = СуммаДокумента;
	Иначе
		СтруктураКурса = РаботаСКурсамиВалютУТ.СтруктураКурсаВалюты(Курс, Кратность);
		ЗаполнитьСуммуВзаиморасчетов(СтруктураКурса);
	КонецЕсли;
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Продукция", СтруктураКурса);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ОтчетПоЗаказам = Истина; //Для глобального поиска условия при добавлении расчетов по накладным в отчеты давальцев.
		
		Если СуммаДокумента > 0 И (НЕ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов И НЕ ОтчетПоЗаказам 
			ИЛИ ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным) Тогда
			ВзаиморасчетыСервер.ЗаполнитьСуммыРасшифровкиНакладной(СуммаДокумента, СуммаВзаиморасчетов, РасшифровкаПлатежа);
		Иначе
			Если РасшифровкаПлатежа.Количество() <> 0 Тогда
				РасшифровкаПлатежа.Очистить();
			КонецЕсли;
		КонецЕсли;
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Продукция);
		
		Если ЭтапыГрафикаОплаты.Количество() = 0 Тогда
			ЗаполнитьЭтапыГрафикаОплаты();
		ИначеЕсли ЭтапыГрафикаОплаты.Итог("СуммаПлатежа")
			+ ЭтапыГрафикаОплаты.Итог("СуммаВзаиморасчетов") = 0 Тогда
			ЭтапыГрафикаОплаты.Очистить();
		ИначеЕсли ЭтапыГрафикаОплаты.Итог("СуммаПлатежа") <> СуммаДокумента
			ИЛИ ЭтапыГрафикаОплаты.Итог("СуммаВзаиморасчетов") <> СуммаВзаиморасчетов Тогда
			
			Если ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным Тогда
				ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(
					ЭтапыГрафикаОплаты,
					СуммаДокумента,
					0,
					СуммаВзаиморасчетов);
			Иначе
				ПараметрыЗаполненияЭтапов = ЭтапыОплатыСервер.ПараметрыЗаполненияЭтаповОплатыПоЗаказам();
				ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияЭтапов,ЭтотОбъект);
				ПараметрыЗаполненияЭтапов.ТабличнаяЧасть = Продукция;
				ПараметрыЗаполненияЭтапов.ИмяПоляЗаказ   = "ЗаказДавальца";
				ПараметрыЗаполненияЭтапов.ПоЗаказам      = ИСТИНА;
				ПараметрыЗаполненияЭтапов.УпрощеннаяСхема= ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах");
				
				ЭтапыОплатыСервер.РаспределитьСуммыЭтаповОплатыДокументаПоЗаказам(ПараметрыЗаполненияЭтапов);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыРегистрации = Документы.ОтчетДавальцу.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(
		ЭтотОбъект,
		РежимЗаписи);
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ПараметрыОбъектаССоглашением());
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;

	ОтчетДавальцуЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("МассивЗаказов") Тогда
			Дата = ?(ДанныеЗаполнения.Свойство("ДатаОтгрузки"), ДанныеЗаполнения.ДатаОтгрузки,
				ЗаказыСервер.ПолучитьМаксимальнуюДатуОтгрузкиЗаказа(ДанныеЗаполнения.МассивЗаказов));
			ЗаполнитьДокументНаОснованииЗаказаКлиента(ДанныеЗаполнения.МассивЗаказов, ЗначениеЗаполнено(Дата), ДанныеЗаполнения.РеквизитыШапки);
			
		Иначе
			
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
			
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказДавальца") Тогда
		
		ЗаполнитьДокументНаОснованииЗаказаКлиента(ДанныеЗаполнения, Ложь);
		
	Иначе
		
		ИнициализироватьУсловияПродаж();
		
	КонецЕсли;
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнитьЭтапыГрафикаОплаты();
	
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияКассыПриФОИспользоватьНесколькоКассЛожь", Ложь);
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	Если Не ЗначениеЗаполнено(ПорядокОплаты) Тогда
		ВалютаОплаты  = ДенежныеСредстваСервер.ПолучитьВалютуОплаты(ФормаОплаты, БанковскийСчетОрганизации, Касса);
		ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов,НалогообложениеНДС,ВалютаОплаты);
	КонецЕсли;
	
	ОтчетДавальцуЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
#Область ДокХарактеристики
	
	ПроверятьХарактеристику = Ложь;
	
	Если Не Номенклатура.Пустая() Тогда
		
		МассивВариантов = Новый Массив;
		МассивВариантов.Добавить(Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры);
		МассивВариантов.Добавить(Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры);
		МассивВариантов.Добавить(Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры);
		
		ПроверятьХарактеристику = Не (МассивВариантов.Найти(Номенклатура.ИспользованиеХарактеристик) = Неопределено);
		
	КонецЕсли;
	
	Если Не ПроверятьХарактеристику Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	КонецЕсли;

#КонецОбласти

#Область ТчХарактеристикиКоличество
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "Продукция";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "Продукция";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);

#КонецОбласти

	ПродажиСервер.ПроверитьКорректностьЭтаповГрафикаОплаты(
		ЭтотОбъект,
		Продукция.Итог("СуммаСНДС"),
		0,
		Истина,
		Отказ,
		Истина);

#Область НаправлениеДеятельности

	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
#КонецОбласти

#Область ЗаказДавальца
	
	Для ТекИндекс = 0 По Продукция.Количество() - 1 Цикл
		
		Если Не ЗначениеЗаполнено(ЗаказДавальца) И
			Не ЗначениеЗаполнено(Продукция[ТекИндекс].ЗаказДавальца) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Заказ давальца"" в строке %НомерСтроки% списка ""Продукция""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Продукция[ТекИндекс].НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Продукция", Продукция[ТекИндекс].НомерСтроки, "ЗаказДавальца"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтчетДавальцуПоНесколькимЗаказам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗаказДавальца");
	КонецЕсли;
	
#КонецОбласти

#Область ИсключимПроверенныеРеквизитыИзДальнейшейПроверки
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

#КонецОбласти

#Область ПроверкаОстальныхРеквизитов
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;

#КонецОбласти

#Область ПроверкаКорректностиЗаполненияДокумента
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект,Отказ);
	
#КонецОбласти

	ОтчетДавальцуЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетДавальцу.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗаказыСервер.ОтразитьУслугиДавальцуКОформлению(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьВыручкуИСебестоимостьПродаж(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	ЗатратыСервер.ОтразитьВыпускПродукции(ДополнительныеСвойства, Движения, Отказ);
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ОтчетДавальцуЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ОтчетДавальцу.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриПроведении(ПараметрыРегистрации);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ОтчетДавальцуЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ОтчетДавальцу.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован = Ложь;
	ЗаказДавальца = Неопределено;
	
	ЗаменаСтавкиНДС = УчетНДСУП.СкорректироватьСтавкуНДС(СтавкаНДС, Дата);
	Если ЗаменаСтавкиНДС Тогда
		ПроцентНДС = УчетНДСУПКлиентСервер.ПолучитьСтавкуНДС(СтавкаНДС);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Продукция Цикл
		
		СтрокаТЧ.ЗаказДавальца = Неопределено;
		СтрокаТЧ.КодСтроки = 0;
		Если ЗаменаСтавкиНДС Тогда
			СтрокаТЧ.СтавкаНДС = СтавкаНДС;
			СтрокаТЧ.СуммаНДС = УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(СтрокаТЧ.Сумма, ПроцентНДС, ЦенаВключаетНДС,
				НалогообложениеНДС);
		КонецЕсли;
		
	КонецЦикла;
	
	РасшифровкаПлатежа.Очистить();
	
	ЭтотОбъект.ЗаполнитьЭтапыГрафикаОплаты();
	
	ИнициализироватьДокумент();
	
	ОтчетДавальцуЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
	ОтчетДавальцуЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьСуммуВзаиморасчетов(СтруктураКурса)
	
	Если Продукция.НайтиСтроки(Новый Структура("СуммаВзаиморасчетов", 0)).Количество() = 0 Тогда
		
		СуммаВзаиморасчетов = Продукция.Итог("СуммаВзаиморасчетов");
		
	Иначе
		
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетов(ЭтотОбъект, ,СтруктураКурса);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииЗаказаКлиента(Знач ДокументОснование,Знач ЗаполнятьНаДатуОказанияУслуг = Истина, РеквизитыЗаказа = Неопределено)
	
	ТипОснования = ТипЗнч(ДокументОснование);
	ОтобратьПоЗаказу = Истина;
	
	Если ТипОснования = Тип("ДокументСсылка.ЗаказДавальца") Тогда
	
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		// *** Основные реквизиты
		|	ЗаказДавальца.Ссылка                    КАК ЗаказДавальца,
		|	ЗаказДавальца.Сделка                    КАК Сделка,
		|	ЗаказДавальца.Статус                    КАК СтатусДокумента,
		|	ЗаказДавальца.Организация               КАК Организация,
		|	ЗаказДавальца.БанковскийСчет            КАК БанковскийСчетОрганизации,
		|	ЗаказДавальца.Подразделение             КАК Подразделение,
		// *** Реквизиты оплаты
		|	ЗаказДавальца.ПорядокРасчетов           КАК ПорядокРасчетов,
		|	ЗаказДавальца.ФормаОплаты               КАК ФормаОплаты,
		|	ЗаказДавальца.ГруппаФинансовогоУчета    КАК ГруппаФинансовогоУчета,
		|	ЗаказДавальца.Касса                     КАК Касса,
		|	ЗаказДавальца.Валюта                    КАК Валюта,
		|	ЗаказДавальца.Валюта                    КАК ВалютаВзаиморасчетов,
		|	ЗаказДавальца.ГрафикОплаты              КАК ГрафикОплаты,
		|	ЗаказДавальца.НаправлениеДеятельности   КАК НаправлениеДеятельности,
		|	ЗаказДавальца.ПорядокОплаты             КАК ПорядокОплаты,
		// *** Информация о партнере
		|	ЗаказДавальца.Партнер                   КАК Партнер,
		|	ЗаказДавальца.Контрагент                КАК Контрагент,
		|	ЗаказДавальца.Договор                   КАК Договор,
		|	ЗаказДавальца.КонтактноеЛицо            КАК КонтактноеЛицо,
		|	ЗаказДавальца.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
		// *** НДС
		|	ЗаказДавальца.ЦенаВключаетНДС           КАК ЦенаВключаетНДС,
		|	ЗаказДавальца.НалогообложениеНДС        КАК НалогообложениеНДС,
		|	ЗаказДавальца.СтавкаНДС                 КАК СтавкаНДС,
		// *** Реквизиты услуги
		|	ЗаказДавальца.Номенклатура              КАК Номенклатура,
		|	ЗаказДавальца.Характеристика            КАК Характеристика,
		|	ЗаказДавальца.Содержание                КАК Содержание,
		// *** Ошибки запонления
		|	(НЕ ЗаказДавальца.Проведен)             КАК ЕстьОшибкиПроведен,
		|	ВЫБОР КОГДА ЗаказДавальца.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовДавальцев.КПроизводству)
		|			ИЛИ ЗаказДавальца.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовДавальцев.КОтгрузке)
		|			ИЛИ ЗаказДавальца.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовДавальцев.Закрыт) ТОГДА
		|		ЛОЖЬ
		|	ИНАЧЕ
		|		ИСТИНА
		|	КОНЕЦ                                   КАК ЕстьОшибкиСтатус
		|
		|ИЗ
		|	Документ.ЗаказДавальца КАК ЗаказДавальца
		|
		|ГДЕ
		|	ЗаказДавальца.Ссылка = &ЗаказДавальца");
		
		Запрос.УстановитьПараметр("ЗаказДавальца", ДокументОснование);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		РеквизитыЗаказа = РезультатЗапроса.Выбрать();
		РеквизитыЗаказа.Следующий();
		
		МассивДопустимыхСтатусов = Новый Массив;
		МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовДавальцев.КПроизводству);
		МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовДавальцев.КОтгрузке);
		МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыЗаказовДавальцев.Закрыт);
		
		ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
			РеквизитыЗаказа.ЗаказДавальца,
			РеквизитыЗаказа.СтатусДокумента,
			РеквизитыЗаказа.ЕстьОшибкиПроведен,
			РеквизитыЗаказа.ЕстьОшибкиСтатус,
			МассивДопустимыхСтатусов);
		
		// Заполнение шапки
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаказа);
		
	ИначеЕсли ТипОснования = Тип("Массив") Тогда
		
		// Заполнение шапки.
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаказа);
		
		Валюта                    = ВалютаВзаиморасчетов;
		БанковскийСчетОрганизации = РеквизитыЗаказа.БанковскийСчетОрганизации;
		
		ПродажиСервер.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
		
		Если Не ЗначениеЗаполнено(БанковскийСчетОрганизации) Тогда
			
			СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
			СтруктураПараметров.Организация    			= Организация;
			СтруктураПараметров.НаправлениеДеятельности = НаправлениеДеятельности;
			СтруктураПараметров.БанковскийСчет 			= БанковскийСчетОрганизации;
			БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			
		КонецЕсли;
		Если Не ЗначениеЗаполнено(БанковскийСчетКонтрагента) Тогда
			
			БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(
				Контрагент,
				,
				БанковскийСчетКонтрагента);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипОснования = Тип("Массив") Тогда
		МассивЗаказов = ДокументОснование;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(ЗаказДавальца);
	КонецЕсли;
	
	// Заполнение т.ч. услуги.
	Документы.ОтчетДавальцу.ЗаполнитьПоОстаткамУслугДавальцаКОформлению(
		ЭтотОбъект,
		Продукция,
		МассивЗаказов,
		ЗаполнятьНаДатуОказанияУслуг,
		Истина);
	
	ЗаказыСервер.ЗаполнитьЗаказВШапкеПоЗаказамВТабличнойЧасти(
		ЗаказДавальца,
		Продукция,
		"ЗаказДавальца");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)

	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияПродажПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер                  = Пользователи.ТекущийПользователь();
	Валюта                    = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	ВалютаВзаиморасчетов      = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(ВалютаВзаиморасчетов);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    = Организация;
	СтруктураПараметров.БанковскийСчет = БанковскийСчетОрганизации;
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация  = Организация;
	СтруктураПараметров.Касса		 = Касса;
	Касса                     = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
	
	ПараметрыЗаполнения = Документы.ОтчетДавальцу.ПараметрыЗаполненияНалогооблаженияНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	БанковскийСчетКонтрагента = Договор.БанковскийСчетКонтрагента;
	Если Не ЗначениеЗаполнено(БанковскийСчетКонтрагента) Тогда
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
	КонецЕсли;
	ПорядокРасчетов           = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ПараметрыОбъектаССоглашением());
	
	РаботаСКурсамиВалютУТ.ЗаполнитьКурсКратностьПоУмолчанию(Курс, Кратность, Валюта, ВалютаВзаиморасчетов);
	
	ЭтотОбъект.ЗаполнитьЭтапыГрафикаОплаты();
	
КонецПроцедуры

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыОбъектаССоглашением(ИменаРеквизитов = "")
	
	Если ПустаяСтрока(ИменаРеквизитов) Тогда
		ИменаРеквизитов = "Партнер, Договор, Контрагент, Организация, ПорядокРасчетов";
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
	
	ПараметрыОбъекта.Вставить("Соглашение", Справочники.СоглашенияСКлиентами.ПустаяСсылка());
	
	Возврат ПараметрыОбъекта;
	
КонецФункции

Процедура ЗаполнитьУсловияРасчетов(Знач УсловияПродаж)
	
	ФормаОплаты = УсловияПродаж.ФормаОплаты;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) И УсловияПродаж.Организация = Организация Тогда
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация  			= Организация;
		СтруктураПараметров.ФормаОплаты		 		= ФормаОплаты;
		СтруктураПараметров.НаправлениеДеятельности	= НаправлениеДеятельности;

		Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	// Контроль выполняется при проведении / отмене проведения не нового документа.
	Массив.Добавить(Движения.УслугиДавальцуКОформлению);
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.РасчетыСКлиентами);
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура СформироватьСписокЗависимыхЗаказов()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказДавальца КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В(&МассивЗаказов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказДавальца КАК ЗаказКлиента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетДавальцу.Продукция КАК ТоварыОтчета
	|		ПО ЗаказКлиента.Ссылка = ТоварыОтчета.ЗаказДавальца
	|ГДЕ
	|	ТоварыОтчета.Ссылка = &Ссылка
	|	И ЗаказКлиента.Ссылка НЕ В(&МассивЗаказов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|";
	
	Запрос.УстановитьПараметр("МассивЗаказов", ЭтотОбъект.Продукция.ВыгрузитьКолонку("ЗаказДавальца"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	МассивЗависимыхЗаказов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовКлиентов", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
КонецПроцедуры

// Заполняет табличную часть ЭтапыГрафикаОплаты
//
Процедура ЗаполнитьЭтапыГрафикаОплаты() Экспорт
	
	ЭтапыГрафикаОплаты.Очистить();
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Продукция, ЦенаВключаетНДС);
	
	Если СуммаДокумента > 0 Тогда
		Если ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным Тогда
			
			ПараметрыДляДобавления = ЭтапыОплатыКлиентСервер.ПараметрыДляДобавленияЭтапаПоУмолчанию();
			ПараметрыДляДобавления.Объект = ЭтотОбъект;
			ПараметрыДляДобавления.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки;
			ПараметрыДляДобавления.ЖелаемаяДата = Дата;
			ПараметрыДляДобавления.ДатаСеанса = ТекущаяДатаСеанса();
			ПараметрыДляДобавления.СуммаОплатыПоДокументу = СуммаДокумента;
			
			ЭтапыОплатыКлиентСервер.ДобавитьЭтапОплатыПоУмолчанию(ПараметрыДляДобавления);
			
		Иначе
			
			ПараметрыЗаполненияЭтапов = ЭтапыОплатыСервер.ПараметрыЗаполненияЭтаповОплатыПоЗаказам();
			ЗаполнитьЗначенияСвойств(ПараметрыЗаполненияЭтапов,ЭтотОбъект);
			ПараметрыЗаполненияЭтапов.ТабличнаяЧасть = Продукция.Выгрузить(,"КодСтроки, ЗаказДавальца, Номенклатура, СуммаСНДС, СуммаВзаиморасчетов");
			ПараметрыЗаполненияЭтапов.ИмяПоляЗаказ   = "ЗаказДавальца";
			ПараметрыЗаполненияЭтапов.ПоЗаказам      = ИСТИНА;
			ПараметрыЗаполненияЭтапов.УпрощеннаяСхема= ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах");
			
			ЭтапыОплатыСервер.ЗаполнитьЭтапыОплатыДокументаПоЗаказам(ПараметрыЗаполненияЭтапов);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
