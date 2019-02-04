#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в заказе поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения.
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И Организация.Пустая() Тогда
		Организация = УсловияЗакупок.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Склад) И Склад.Пустая() Тогда
		
		Склад = УсловияЗакупок.Склад;
		
		СтруктураОтветственного = ЗакупкиСервер.ПолучитьОтветственногоПоСкладу(Склад, Менеджер);
		Если СтруктураОтветственного <> Неопределено Тогда
			Принял = СтруктураОтветственного.Ответственный;
			ПринялДолжность = СтруктураОтветственного.ОтветственныйДолжность;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		
		ХозяйственнаяОперацияДоговора = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья;
		Параметрыобъекта = ПараметрыОбъектаССоглашением();
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(Параметрыобъекта, ХозяйственнаяОперацияДоговора);
		
		ЗакупкиВызовСервера.ЗаполнитьБанковскиеСчетаПоДоговору(
			Договор,
			БанковскийСчетОрганизации,
			БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("УчитыватьГруппыСкладов", Истина);
		ПараметрыОтбора.Вставить("ИсключитьГруппыСкладовДоступныеВЗаказах", Истина);
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(Партнер, ПараметрыОтбора);
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		КонецЕсли;
		
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(
			Контрагент,
			,
			БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

#Область ВспомогательныеПеременные
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

#КонецОбласти

#Область ТчХарактеристикиИКоличество
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(
		ЭтотОбъект,
		МассивНепроверяемыхРеквизитов,
		Отказ);
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);

#КонецОбласти

#Область ВозвратнаяТара
	
	Если Не ВернутьМногооборотнуюТару Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВозвратаМногооборотнойТары");
	КонецЕсли;
	
	Если ЗначениеЗаполнено("ДатаВозвратаМногооборотнойТары") И ВернутьМногооборотнуюТару И ДатаВозвратаМногооборотнойТары < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Дата возврата многооборотной тары не должна быть меньше даты документа.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаВозвратаМногооборотнойТары",
			,
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Цена");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Сумма");
	
	Если Не ВернутьМногооборотнуюТару И ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару") Тогда
		
		ТипыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Товары.ВыгрузитьКолонку("Номенклатура"), "ТипНоменклатуры");
		
		Для Каждого Строка Из Товары Цикл
			
			Если ТипыНоменклатуры[Строка.Номенклатура].ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.МногооборотнаяТара Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.Цена) Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Цена"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Строка.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Строка.НомерСтроки, "Цена"),
					,
					Отказ);
				
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.Сумма) Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Сумма"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Строка.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Строка.НомерСтроки, "Сумма"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
#КонецОбласти

#Область Серии
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПоступлениеСырьяОтДавальца),
		Отказ,
		МассивНепроверяемыхРеквизитов);

#КонецОбласти

#Область ТчЗаказыДавальцев
	
	Если ПоступлениеПоЗаказам И Не ЗначениеЗаполнено(ЗаказДавальца) Тогда
		
		Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
			
			Если Не ЗначениеЗаполнено(Товары[ТекИндекс].ЗаказДавальца) Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Заказ давальца"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Товары[ТекИндекс].НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Товары[ТекИндекс].НомерСтроки, "ЗаказДавальца"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

#КонецОбласти

#Область Назначение

	МассивНепроверяемыхРеквизитов.Добавить("Товары.Назначение");
	ТаблицаСтрок = Новый ТаблицаЗначений();
	ТаблицаСтрок.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаСтрок.Колонки.Добавить("Индекс", Новый ОписаниеТипов("Число"));
	Для ТекИндекс = 0 По Товары.Количество() - 1 Цикл
		
		Если Не ЗначениеЗаполнено(Товары[ТекИндекс].Назначение) Тогда
			
			СтрокаТаблицы = ТаблицаСтрок.Добавить();
			СтрокаТаблицы.Номенклатура = Товары[ТекИндекс].Номенклатура;
			СтрокаТаблицы.Индекс = ТекИндекс;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаСтрок.Количество() > 0 Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура КАК Номенклатура,
			|	Таблица.Индекс КАК Индекс
			|ПОМЕСТИТЬ ВтТаблица
			|ИЗ
			|	&Таблица КАК Таблица
			|;
			|//////////////////////////
			|ВЫБРАТЬ
			|	Таблица.Индекс КАК Индекс
			|ИЗ
			|	ВтТаблица КАК Таблица
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
			|		ПО СпрНоменклатура.Ссылка = Таблица.Номенклатура
			|		 И СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
			|ГДЕ
			|	НЕ СпрНоменклатура.Ссылка ЕСТЬ NULL";
			
		Запрос.УстановитьПараметр("Таблица", ТаблицаСтрок);
		Выборка = Запрос.Выполнить().Выбрать();
		
		ТекстОшибки = НСтр("ru='Не заполнено поле ""Назначение"" в строке %НомерСтроки% списка ""Товары""'");
		Пока Выборка.Следующий() Цикл
			
			НомерСтроки = Товары[Выборка.Индекс].НомерСтроки;
			ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "Назначение");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, ПутьКТабличнойЧасти,, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
#КонецОбласти

#Область ИсключимПроверенныеРеквизитыИзДальнейшейПроверки
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

#КонецОбласти

#Область ПроверкаОстальныхРеквизитов
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗакупкиСервер.ПроверитьКорректностьЗаполненияДокументаЗакупки(ЭтотОбъект,Отказ);
	
#КонецОбласти
	
	ПоступлениеСырьяОтДавальцаЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("МассивЗаказов") Тогда
			ЗаполнитьДокументПоПараметрам(ДанныеЗаполнения);
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
		
		ИнтеграцияВЕТИСУТ.ЗаполнитьПоступлениеСырьяОтДавальцаНаОснованииВходящейТранспортнойОперацииВЕТИС(ЭтотОбъект, ДанныеЗаполнения,, СтандартнаяОбработка);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ПоступлениеСырьяОтДавальцаЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	Если ПоступлениеПоЗаказам И ЗначениеЗаполнено(ЗаказДавальца) Тогда
		
		Для Каждого ТекСтрока Из Товары Цикл
			
			Если Не ЗначениеЗаполнено(ТекСтрока.ЗаказДавальца) Тогда
				ТекСтрока.ЗаказДавальца = ЗаказДавальца;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ПорядокРасчетов");
	Если ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
		ГруппаФинансовогоУчета = Неопределено;
	КонецЕсли;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПоступлениеСырьяОтДавальца);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,ПараметрыУказанияСерий);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = Товары.Итог("Сумма");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
			Перечисления.ХозяйственныеОперации.ПоступлениеОтДавальца,
			Склад,
			Подразделение,
			Партнер);
		
		// Если Склад - группа, то для аналитики учета номенклатуры склад берем из ТЧ
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		Если Склад.ЭтоГруппа И Склад.ВыборГруппы = Перечисления.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных Тогда
			ИменаПолей.Вставить("Произвольный", "Склад");
		КонецЕсли;
		
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(
			Товары,
			МестаУчета,
			ИменаПолей);
		
		ЗаполнитьВидыЗапасовДокумента();
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		
	КонецЕсли;
	
	ПоступлениеСырьяОтДавальцаЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПоступлениеСырьяОтДавальца.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗаказыСервер.ОтразитьЗаказыПоставщикам(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьДвижениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ПартионныйУчетСервер.ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	МногооборотнаяТараСервер.ОтразитьПринятуюВозвратнуюТару(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);	
	
	ПоступлениеСырьяОтДавальцаЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполнения);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);
	
	ПоступлениеСырьяОтДавальцаЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполнения);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Согласован               = Ложь;
	ВидЗапасов               = Неопределено;
	ПоступлениеПоЗаказам     = Ложь;
	ЗаказДавальца            = Документы.ЗаказДавальца.ПустаяСсылка();
	ДатаВходящегоДокумента   = Дата(1,1,1);
	НомерВходящегоДокумента  = "";
	
	ДатаВозвратаМногооборотнойТары        = Дата(1,1,1);
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	// Коды строк и заказы переработчикам очищаем во всех строках
	Массив = Новый Массив(Товары.Количество());
	Товары.ЗагрузитьКолонку(Массив, "КодСтроки");
	Товары.ЗагрузитьКолонку(Массив, "ЗаказДавальца");
	
	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
	ПоступлениеСырьяОтДавальцаЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументПоПараметрам(СтруктураЗаполнения)
	
	МассивЗаказов = СтруктураЗаполнения.МассивЗаказов;
	
	ПараметрыЗаполнения = Документы.ПоступлениеСырьяОтДавальца.ПараметрыЗаполненияДокумента();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, СтруктураЗаполнения);
	Документы.ПоступлениеСырьяОтДавальца.ИнициализироватьПараметрыЗаполнения(ПараметрыЗаполнения,
		СтруктураЗаполнения.РеквизитыШапки, МассивЗаказов);
	
	ТаблицаНакладная = Документы.ПоступлениеСырьяОтДавальца.ДанныеТаблицыТоварыДокумента(ЭтотОбъект.Ссылка);
	
	Документы.ПоступлениеСырьяОтДавальца.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, Ссылка, ПараметрыЗаполнения);
	
	Если ПараметрыЗаполнения.ЗаполнятьПоОрдеру Тогда
		ТаблицаНакладная.Колонки.Количество.Имя        = "КоличествоДоИзменения";
		ТаблицаНакладная.Колонки.КоличествоВОрдере.Имя = "Количество";
	Иначе
		ТаблицаНакладная.Колонки.Количество.Имя        = "КоличествоДоИзменения";
		ТаблицаНакладная.Колонки.КоличествоВЗаказе.Имя = "Количество";
	КонецЕсли;
	
	НакладныеСервер.УдалитьПустыеСтроки(ТаблицаНакладная, "Количество");
	
	Товары.Загрузить(ТаблицаНакладная);
	
	Документы.ПоступлениеСырьяОтДавальца.ЗаполнитьШапкуДокументаПоЗаказу(ЭтотОбъект, ПараметрыЗаполнения, МассивЗаказов);
	
	Документы.ПоступлениеСырьяОтДавальца.ОбновитьЗависимыеРеквизитыТабличнойЧасти(Товары, ПараметрыЗаполнения);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПоступлениеСырьяОтДавальца);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияЗакупокПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер                  = Пользователи.ТекущийПользователь();
	Валюта                    = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    		= Организация;
	СтруктураПараметров.БанковскийСчет		= БанковскийСчетОрганизации;
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
	Склад                     = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки"), Истина);
	ПоступлениеПоЗаказам      = Истина; // Всегда только по заказам
	
	СтруктураОтветственного = ЗакупкиСервер.ПолучитьОтветственногоПоСкладу(Склад, Менеджер);
	Если СтруктураОтветственного <> Неопределено Тогда
		Принял = СтруктураОтветственного.Ответственный;
		ПринялДолжность = СтруктураОтветственного.ОтветственныйДолжность;
	КонецЕсли;
	
	Распоряжение = ДокументОснованиеПриЗаполнении(ДанныеЗаполнения);
	ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров(Распоряжение);
	
КонецПроцедуры

Функция ДокументОснованиеПриЗаполнении(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("МассивЗаказов") Тогда
		
		Возврат ДанныеЗаполнения.МассивЗаказов[0];
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказДавальца") Тогда
		
		Возврат ДанныеЗаполнения;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасовДокумента()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки   КАК НомерСтроки,
	|	ТаблицаТоваров.ЗаказДавальца КАК ЗаказДавальца,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.ВидЗапасов    КАК ВидЗапасов
	|
	|ПОМЕСТИТЬ ТаблицаТоваровДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки                   КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры    КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура                       КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ВЫБОР КОГДА Аналитика.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ                                        КАК ЭтоВозвратнаяТара,
	|	&Организация                                 КАК Организация,
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)     КАК ТипЗапасов,
	|	НЕОПРЕДЕЛЕНО                                 КАК Соглашение,
	|	НЕОПРЕДЕЛЕНО                                 КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	&НалогообложениеОрганизации                  КАК НалогообложениеОрганизации,
	|	&Партнер                                     КАК ВладелецТовара,
	|	&Контрагент                                  КАК Контрагент,
	|	&Договор                                     КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваровДокумента КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ВидыЗапасов КАК ВидыЗапасов
	|	ПО
	|		ТаблицаТоваров.ВидЗапасов = ВидыЗапасов.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ЗаказДавальца КАК Заказ
	|	ПО
	|		ТаблицаТоваров.ЗаказДавальца = Заказ.Ссылка
	|	
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|	ИЛИ ВидыЗапасов.ТипЗапасов <> 
	|		ВЫБОР КОГДА Аналитика.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				ТОГДА
	|			ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца)
	|		КОНЕЦ 
	|	ИЛИ ВидыЗапасов.Организация <> &Организация
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТоваров",             Товары.Выгрузить(, "НомерСтроки, ЗаказДавальца, АналитикаУчетаНоменклатуры, ВидЗапасов"));
	Запрос.УстановитьПараметр("Организация",                Организация);
	Запрос.УстановитьПараметр("Партнер",                    Партнер);
	Запрос.УстановитьПараметр("Контрагент",                 Контрагент);
	Запрос.УстановитьПараметр("Договор",                    Договор);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", Справочники.Организации.НалогообложениеНДС(Организация, , Дата));
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",      Перечисления.ХозяйственныеОперации.ПоступлениеОтДавальца);
	Запрос.УстановитьПараметр("ИспользоватьРаздельныйУчетПоНалогообложению", 
		РегистрыСведений.УчетнаяПолитикаОрганизаций.РаздельныйУчетТоваровПоНалогообложениюНДС(Организация, Дата));
	Запрос.УстановитьПараметр("Проведен",                   Проведен);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыОбъектаССоглашением(ИменаРеквизитов = "")
	
	Если ПустаяСтрока(ИменаРеквизитов) Тогда
		ИменаРеквизитов = "Партнер, Договор, Контрагент, Организация";
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, ЭтотОбъект);
	
	ПараметрыОбъекта.Вставить("Соглашение", Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	
	Возврат ПараметрыОбъекта;
	
КонецФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ПринятаяВозвратнаяТара);
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ЗаказыПоставщикам);
	КонецЕсли;
	
	Массив.Добавить(Движения.ОбеспечениеЗаказов);
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;

	ПоступлениеСырьяОтДавальцаЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
