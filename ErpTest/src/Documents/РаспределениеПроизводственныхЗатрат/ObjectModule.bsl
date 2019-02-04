#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.РаспределениеПроизводственныхЗатрат);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	ЗаполнитьКоличествоКРаспределениюСерийПоПравилу();
	
	ПараметрыАналитики = Новый Структура("Номенклатура,Характеристика,Серия,Склад,СтатьяКалькуляции,Назначение");
	ЗаполнитьЗначенияСвойств(ПараметрыАналитики, ЭтотОбъект, , "СтатьяКалькуляции");
	
	ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ТипНоменклатуры");
	Если Не НовоеПроизводство Или ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
		ПараметрыАналитики.Склад = ЭтотОбъект.Подразделение;
	КонецЕсли;
	
	АналитикаУчетаНоменклатуры = РегистрыСведений.АналитикаУчетаНоменклатуры.ЗначениеКлючаАналитики(ПараметрыАналитики);
	
	КоличествоПоЭтапамВручную = ПартииПроизводства.Итог("Количество");
	КоличествоНаСтатьиРасходов = ПрочиеРасходы.Итог("Количество");
	
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПрочиеРасходы);
	ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПартииПроизводства);
	
	ЗаполнитьАналитикуУчетаНоменклатурыПолучателя();
	
	Если НовоеПроизводство Тогда
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ЗаполнитьВидыЗапасов(Отказ);
		ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ДоходыИРасходыСервер.ИнициализироватьПустоеЗначениеСтатьиВТЧ(ПрочиеРасходы, "СтатьяРасходов");
	
	РаспределениеПроизводственныхЗатратЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли; 
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	РаспределениеПроизводственныхЗатратЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НовоеПроизводство Тогда
		ЗатратыСервер.ПроверитьИспользованиеПартионногоУчета22(ЭтотОбъект, Дата, Отказ);
	КонецЕсли;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "ВыпускиБезРаспоряжения";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверки);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры")
		И Не Справочники.Номенклатура.ХарактеристикиИспользуются(Номенклатура) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	КонецЕсли;
	
	РеквизитыПроверкиАналитик = Новый Массив;
	РеквизитыПроверкиАналитик.Добавить(Новый Структура("ПрочиеРасходы"));
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, РеквизитыПроверкиАналитик, МассивНепроверяемыхРеквизитов, Отказ);
		
	Если КоличествоКРаспределениюПоПравилу = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределения");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяКалькуляции");
	КонецЕсли;
	Если КоличествоКРаспределениюПоПравилу <> 0 И НЕ ЗначениеЗаполнено(ПравилоРаспределения) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяКалькуляции");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Склад");
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.РаспределениеПроизводственныхЗатрат);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РаспределениеПроизводственныхЗатратЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспределениеПроизводственныхЗатрат.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Регистрация задания к расчету себестоимости.
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(Дата, Ссылка, Организация);
	
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	
	ЗатратыСервер.ОтразитьМатериалыИРаботыВПроизводстве(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);
	
	// Запись наборов записей
	РаспределениеПроизводственныхЗатратЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);
	
	РаспределениеПроизводственныхЗатратЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	
	РаспределениеПроизводственныхЗатратЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	РаспределениеПроизводственныхЗатратЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьКоличествоКРаспределениюСерийПоПравилу()
	
	Коэффициенты = Серии.ВыгрузитьКолонку("Количество");
	
	Распределение = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(КоличествоКРаспределениюПоПравилу, Коэффициенты, 3);
	
	Если Распределение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = 0;
	Если Коэффициенты.Количество() > 0 Тогда
		
		Для Каждого Строка Из Серии Цикл
			Строка.КоличествоКРаспределениюПоПравилу = Распределение[Индекс];
			Индекс = Индекс + 1;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ЗаполнениеВидовЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанных();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТаблицыТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполненияВидовЗапасов = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполненияВидовЗапасов);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество");
		
		Если Не Отказ Тогда
			ЗаполнитьАналитикуВидовЗапасовПолучателя(МенеджерВременныхТаблиц);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныеТаблицыДанных() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата                                                     КАК Дата,
	|	&Организация                                              КАК Организация,
	|	Неопределено                                              КАК Партнер,
	|	Неопределено                                              КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)    КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)                  КАК Валюта,
	|	&НалогообложениеОрганизации                               КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ                                                      КАК ЕстьСделкиВТабличнойЧасти,
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Подразделение,
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)        КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)                  КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО
	|		СтруктураПредприятия.Ссылка = &Подразделение
	|
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаРасходы.НомерСтроки              КАК НомерСтроки,
	|	&Номенклатура                      КАК Номенклатура,
	|	&Характеристика                    КАК Характеристика,
	|	&Склад                             КАК Склад,
	|	&АналитикаУчетаНоменклатуры        КАК АналитикаУчетаНоменклатуры,
	|	&Назначение                        КАК Назначение,
	|	&Серия                             КАК Серия,
	|	&СтатусУказанияСерий               КАК СтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА НаРасходы.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|			ТОГДА &Подразделение
	|		ИНАЧЕ НаРасходы.Подразделение
	|	КОНЕЦ                              КАК Подразделение,
	|	НаРасходы.Количество               КАК Количество,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию) КАК ХозяйственнаяОперация,
	|	НаРасходы.СтатьяРасходов           КАК СтатьяРасходов,
	|	НаРасходы.АналитикаРасходов        КАК АналитикаРасходов,
	|	НаРасходы.АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
	|	НаРасходы.ИдентификаторСтроки      КАК ИдентификаторСтроки
	|	
	|ПОМЕСТИТЬ ВтНаРасходы
	|ИЗ
	|	&ПрочиеРасходы КАК НаРасходы
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПартииПроизводства.НомерСтроки						КАК НомерСтроки,
	|	&Номенклатура										КАК Номенклатура,
	|	&Характеристика										КАК Характеристика,
	|	&Склад												КАК Склад,
	|	&АналитикаУчетаНоменклатуры							КАК АналитикаУчетаНоменклатуры,
	|	ПартииПроизводства.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатурыПолучателя,
	|	&Назначение											КАК Назначение,
	|	&Серия												КАК Серия,
	|	&СтатусУказанияСерий								КАК СтатусУказанияСерий,
	|	&Подразделение										КАК Подразделение,
	|	ПартииПроизводства.Количество						КАК Количество,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеРасходовНаПартииПроизводства) КАК ХозяйственнаяОперация,
	|	ПартииПроизводства.ПартияПроизводства				КАК ПартияПроизводства,
	|	ПартииПроизводства.Этап								КАК Этап,
	|	ПартииПроизводства.СтатьяКалькуляции				КАК СтатьяКалькуляции,
	|	ПартииПроизводства.ИдентификаторСтроки				КАК ИдентификаторСтроки
	|	
	|ПОМЕСТИТЬ ВтНаПартииПроизводства
	|ИЗ
	|	&ПартииПроизводства КАК ПартииПроизводства
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1                                  КАК НомерСтроки,
	|	&Номенклатура                      КАК Номенклатура,
	|	&Характеристика                    КАК Характеристика,
	|	&Склад                             КАК Склад,
	|	&АналитикаУчетаНоменклатуры        КАК АналитикаУчетаНоменклатуры,
	|	&Назначение                        КАК Назначение,
	|	&Серия                             КАК Серия,
	|	&СтатусУказанияСерий               КАК СтатусУказанияСерий,
	|	&Подразделение                     КАК Подразделение,
	|	&КоличествоКРаспределениюПоПравилу КАК Количество,
	|	&СтатьяКалькуляции                 КАК СтатьяКалькуляции,
	|	ЗНАЧЕНИЕ(Документ.РеализацияТоваровУслуг.ПустаяСсылка) КАК ДокументРеализации,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеРасходовНаПартииПроизводства) КАК ХозяйственнаяОперация,
	|	""""                               КАК ИдентификаторСтроки
	|	
	|ПОМЕСТИТЬ ВтПоПравилу
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ПартииПроизводстваКоличествоСтрок + ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура                   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                 КАК Характеристика,
	|	ТаблицаТоваров.Серия                          КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО                                  КАК АналитикаУчетаНоменклатурыПолучателя,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.Подразделение                  КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0                                             КАК СуммаСНДС,
	|	0                                             КАК СуммаНДС,
	|	0                                             КАК СуммаВознаграждения,
	|	0                                             КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.Назначение                     КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка) КАК ГруппаПродукции,
	|	ТаблицаТоваров.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|	ТаблицаТоваров.СтатьяРасходов                 КАК СтатьяРасходов,
	|	ТаблицаТоваров.АналитикаРасходов              КАК АналитикаРасходов,
	|	ТаблицаТоваров.АналитикаАктивовПассивов       КАК АналитикаАктивовПассивов,
	|	ЗНАЧЕНИЕ(Справочник.ПартииПроизводства.ПустаяСсылка) КАК ПартияПроизводства,
	|	НЕОПРЕДЕЛЕНО                                  КАК Этап,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка) КАК СтатьяКалькуляции,
	|	ИСТИНА                                        КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.ИдентификаторСтроки            КАК ИдентификаторСтроки,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)   КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтНаРасходы КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ТаблицаТоваров.Количество > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки                    КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура                   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                 КАК Характеристика,
	|	ТаблицаТоваров.Серия                          КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыПолучателя КАК АналитикаУчетаНоменклатурыПолучателя,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.Подразделение                  КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0                                             КАК СуммаСНДС,
	|	0                                             КАК СуммаНДС,
	|	0                                             КАК СуммаВознаграждения,
	|	0                                             КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.Назначение                     КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка) КАК ГруппаПродукции,
	|	ТаблицаТоваров.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка) КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО                                  КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                  КАК АналитикаАктивовПассивов,
	|	ТаблицаТоваров.ПартияПроизводства             КАК ПартияПроизводства,
	|	ТаблицаТоваров.Этап                           КАК Этап,
	|	ТаблицаТоваров.СтатьяКалькуляции              КАК СтатьяКалькуляции,
	|	ИСТИНА                                        КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.ИдентификаторСтроки            КАК ИдентификаторСтроки,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)   КАК НомерГТД
	|ИЗ
	|	ВтНаПартииПроизводства КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ТаблицаТоваров.Количество > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ПартииПроизводстваКоличествоСтрок + &РасходыКоличествоСтрок + ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура                   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                 КАК Характеристика,
	|	ТаблицаТоваров.Серия                          КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО                                  КАК АналитикаУчетаНоменклатурыПолучателя,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.Подразделение                  КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0                                             КАК СуммаСНДС,
	|	0                                             КАК СуммаНДС,
	|	0                                             КАК СуммаВознаграждения,
	|	0                                             КАК СуммаНДСВознаграждения,
	|	ТаблицаТоваров.Назначение                     КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка) КАК ГруппаПродукции,
	|	ТаблицаТоваров.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка) КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО                                  КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                  КАК АналитикаАктивовПассивов,
	|	ЗНАЧЕНИЕ(Справочник.ПартииПроизводства.ПустаяСсылка) КАК ПартияПроизводства,
	|	НЕОПРЕДЕЛЕНО                                  КАК Этап,
	|	ТаблицаТоваров.СтатьяКалькуляции              КАК СтатьяКалькуляции,
	|	ИСТИНА                                        КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.ИдентификаторСтроки            КАК ИдентификаторСтроки,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)   КАК НомерГТД
	|ИЗ
	|	ВтПоПравилу КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ТаблицаТоваров.Количество > 0
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки                     КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.ХозяйственнаяОперация           КАК ХозяйственнаяОперация,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры      КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов                      КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД                        КАК НомерГТД,
	|	ТаблицаВидыЗапасов.КорАналитикаУчетаНоменклатуры   КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Количество                      КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.СтатьяРасходов                  КАК СтатьяРасходов,
	|	ТаблицаВидыЗапасов.Подразделение                   КАК Подразделение,
	|	ТаблицаВидыЗапасов.АналитикаРасходов               КАК АналитикаРасходов,
	|	ТаблицаВидыЗапасов.АналитикаАктивовПассивов        КАК АналитикаАктивовПассивов,
	|	ТаблицаВидыЗапасов.ПартияПроизводства              КАК ПартияПроизводства,
	|	ЛОЖЬ                                               КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|//////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки                 КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|	&Номенклатура                                  КАК Номенклатура,
	|	&Характеристика                                КАК Характеристика,
	|	&Серия                                         КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов                  КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД                    КАК НомерГТД,
	|	ТаблицаВидыЗапасов.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.Количество                  КАК Количество,
	|	&Склад                                         КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ХозяйственнаяОперация       КАК ХозяйственнаяОперация,
	|	ТаблицаВидыЗапасов.Сделка                      КАК Сделка,
	|	ТаблицаВидыЗапасов.СтатьяРасходов              КАК СтатьяРасходов,
	|	ТаблицаВидыЗапасов.Подразделение               КАК Подразделение,
	|	ТаблицаВидыЗапасов.АналитикаРасходов           КАК АналитикаРасходов,
	|	ТаблицаВидыЗапасов.АналитикаАктивовПассивов    КАК АналитикаАктивовПассивов,
	|	ТаблицаВидыЗапасов.ПартияПроизводства          КАК ПартияПроизводства,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную   КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка",                     Ссылка);
	Запрос.УстановитьПараметр("Дата",                       Дата);
	Запрос.УстановитьПараметр("Организация",                Организация);
	Запрос.УстановитьПараметр("Менеджер",                   Ответственный);
	Запрос.УстановитьПараметр("Подразделение",              Подразделение);
	Запрос.УстановитьПараметр("Номенклатура",               Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",             Характеристика);
	Запрос.УстановитьПараметр("Серия",                      Серия);
	Запрос.УстановитьПараметр("СтатусУказанияСерий",        СтатусУказанияСерий);
	Запрос.УстановитьПараметр("Назначение",                 Назначение);
	Запрос.УстановитьПараметр("СтатьяКалькуляции",          СтатьяКалькуляции);
	Запрос.УстановитьПараметр("Склад",                      Склад);
	Запрос.УстановитьПараметр("АналитикаУчетаНоменклатуры", АналитикаУчетаНоменклатуры);
	Запрос.УстановитьПараметр("Количество",                 Количество);
	Запрос.УстановитьПараметр("КоличествоКРаспределениюПоПравилу", КоличествоКРаспределениюПоПравилу);
	
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	
	Запрос.УстановитьПараметр("ПартииПроизводства",					ПартииПроизводства);
	Запрос.УстановитьПараметр("ПартииПроизводстваКоличествоСтрок",	ПартииПроизводства.Количество());
	
	Запрос.УстановитьПараметр("ПрочиеРасходы",              ПрочиеРасходы);
	Запрос.УстановитьПараметр("РасходыКоличествоСтрок",     ПрочиеРасходы.Количество());
	
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",         ВидыЗапасов);
	
	НалогообложениеОрганизации = Справочники.Организации.НалогообложениеНДС(Организация, Неопределено, Дата);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", НалогообложениеОрганизации);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ВЫБОР КОГДА ДанныеДокумента.Подразделение.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		ДанныеДокумента.Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ КАК Подразделение,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.Подразделение.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		ДанныеДокумента.Ответственный
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ КАК Менеджер,
	|
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка
	|
	|ПОМЕСТИТЬ СохраненныеДанныеДокумента
	|ИЗ
	|	Документ.РаспределениеПроизводственныхЗатрат КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Организация <> СохраненныеДанные.Организация ТОГДА
	|		ИСТИНА
	|	КОГДА ДанныеДокумента.Дата <> СохраненныеДанные.Дата ТОГДА
	|		ИСТИНА
	|	КОГДА ДанныеДокумента.Подразделение <> СохраненныеДанные.Подразделение ТОГДА
	|		ИСТИНА
	|	КОГДА ДанныеДокумента.Менеджер <> СохраненныеДанные.Менеджер ТОГДА
	|		ИСТИНА
	|	КОГДА ДанныеДокумента.Сделка <> СохраненныеДанные.Сделка ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК РеквизитыИзменены
	|ИЗ
	|	ТаблицаДанныхДокумента КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СохраненныеДанныеДокумента КАК СохраненныеДанные
	|	ПО
	|		ИСТИНА
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РеквизитыИзменены = Выборка.РеквизитыИзменены;
	Иначе
		РеквизитыИзменены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыИзменены;
	
КонецФункции

Функция ПроверитьИзменениеТаблицыТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтатьяРасходов             КАК СтатьяРасходов,
	|	ТаблицаТоваров.Подразделение              КАК Подразделение,
	|	ТаблицаТоваров.АналитикаРасходов          КАК АналитикаРасходов,
	|	ТаблицаТоваров.АналитикаАктивовПассивов   КАК АналитикаАктивовПассивов,
	|	ТаблицаТоваров.ХозяйственнаяОперация      КАК ХозяйственнаяОперация,
	|	ТаблицаТоваров.ПартияПроизводства         КАК ПартияПроизводства,
	|	СУММА(ТаблицаТоваров.Количество)          КАК Количество
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтатьяРасходов             КАК СтатьяРасходов,
	|		ТаблицаТоваров.Подразделение              КАК Подразделение,
	|		ТаблицаТоваров.АналитикаРасходов          КАК АналитикаРасходов,
	|		ТаблицаТоваров.АналитикаАктивовПассивов   КАК АналитикаАктивовПассивов,
	|		ТаблицаТоваров.ПартияПроизводства         КАК ПартияПроизводства,
	|		ТаблицаТоваров.ХозяйственнаяОперация      КАК ХозяйственнаяОперация,
	|		ТаблицаТоваров.Количество                 КАК Количество
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтатьяРасходов,
	|		ТаблицаВидыЗапасов.Подразделение,
	|		ТаблицаВидыЗапасов.АналитикаРасходов,
	|		ТаблицаВидыЗапасов.АналитикаАктивовПассивов,
	|		ТаблицаВидыЗапасов.ПартияПроизводства,
	|		ТаблицаВидыЗапасов.ХозяйственнаяОперация,
	|		-ТаблицаВидыЗапасов.Количество
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтатьяРасходов,
	|	ТаблицаТоваров.Подразделение,
	|	ТаблицаТоваров.АналитикаРасходов,
	|	ТаблицаТоваров.АналитикаАктивовПассивов,
	|	ТаблицаТоваров.ХозяйственнаяОперация,
	|	ТаблицаТоваров.ПартияПроизводства
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьАналитикуВидовЗапасовПолучателя(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыПолучателя КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура               КАК Номенклатура,
	|	ТаблицаТоваров.Номенклатура.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ТаблицаТоваров.Характеристика             КАК Характеристика,
	|	ТаблицаТоваров.Серия                      КАК Серия,
	|	ТаблицаТоваров.Подразделение              КАК Склад,
	|	СпрПартииПроизводства.Назначение          КАК Назначение,
	|	ТаблицаТоваров.Подразделение              КАК Подразделение,
	|	ТаблицаТоваров.СтатьяРасходов             КАК СтатьяРасходов,
	|	ТаблицаТоваров.АналитикаРасходов          КАК АналитикаРасходов,
	|	ТаблицаТоваров.АналитикаАктивовПассивов   КАК АналитикаАктивовПассивов,
	|	ТаблицаТоваров.ХозяйственнаяОперация      КАК ХозяйственнаяОперация,
	|	ТаблицаТоваров.ПартияПроизводства         КАК ПартияПроизводства,
	|	ТаблицаТоваров.СтатьяКалькуляции          КАК СтатьяКалькуляции,
	|	ТаблицаТоваров.ИдентификаторСтроки        КАК ИдентификаторСтроки,
	|	СУММА(ТаблицаТоваров.Количество)          КАК Количество
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ТаблицаТоваров.ПартияПроизводства
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатурыПолучателя,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Номенклатура.ГруппаФинансовогоУчета,
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Подразделение,
	|	СпрПартииПроизводства.Назначение,
	|	ТаблицаТоваров.СтатьяРасходов,
	|	ТаблицаТоваров.АналитикаРасходов,
	|	ТаблицаТоваров.АналитикаАктивовПассивов,
	|	ТаблицаТоваров.ХозяйственнаяОперация,
	|	ТаблицаТоваров.ПартияПроизводства,
	|	ТаблицаТоваров.СтатьяКалькуляции,
	|	ТаблицаТоваров.ИдентификаторСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	Количество УБЫВ";
	
	ВыборкаТовары = Запрос.Выполнить().Выбрать();
	
	ОтборТоваров = Новый Структура("АналитикаУчетаНоменклатуры");
	
	ТипыЗапасов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ВидыЗапасов.Выгрузить(, "ВидЗапасов").ВыгрузитьКолонку("ВидЗапасов"), "ТипЗапасов");
	
	Пока ВыборкаТовары.Следующий() Цикл
		
		КоличествоТоваров = ВыборкаТовары.Количество;
		
		ЗаполнитьЗначенияСвойств(ОтборТоваров, ВыборкаТовары);
		
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(ОтборТоваров) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаТовары, "КорАналитикаУчетаНоменклатуры, ХозяйственнаяОперация, СтатьяРасходов,
																|Подразделение, АналитикаРасходов, АналитикаАктивовПассивов,
																|ПартияПроизводства, ИдентификаторСтроки");
			
			Если ТипыЗапасов[СтрокаЗапасов.ВидЗапасов] = Перечисления.ТипыЗапасов.КомиссионныйТовар Тогда
				НоваяСтрока.ВидЗапасовПолучателя = Справочники.ВидыЗапасов.ВидЗапасовДокумента(Организация, , ВыборкаТовары);
			Иначе
				НоваяСтрока.ВидЗапасовПолучателя = НоваяСтрока.ВидЗапасов;
			КонецЕсли;
			
			НоваяСтрока.Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);
			
			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			
			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов()
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	
	ПараметрыЗаполнения.ОтборыВидовЗапасов.ТипЗапасов.Добавить(Перечисления.ТипыЗапасов.МатериалДавальца);
	ПараметрыЗаполнения.ОтборыВидовЗапасов.ТипЗапасов.Добавить(Перечисления.ТипыЗапасов.ПродукцияДавальца);
	
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = Истина;
	
	Возврат ПараметрыЗаполнения;
КонецФункции

#КонецОбласти

Процедура ЗаполнитьАналитикуУчетаНоменклатурыПолучателя()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПартииПроизводства.НомерСтроки                      КАК НомерСтроки,
	|	&Номенклатура                                       КАК Номенклатура,
	|	&Характеристика                                     КАК Характеристика,
	|	&Серия                                              КАК Серия,
	|	ПартииПроизводства.Подразделение                    КАК Склад,
	|	ПартииПроизводства.ПартияПроизводства               КАК ПартияПроизводства,
	|	ПартииПроизводства.Этап                             КАК Этап,
	|	ПартииПроизводства.СтатьяКалькуляции                КАК СтатьяКалькуляции
	|ПОМЕСТИТЬ ВтПартии
	|ИЗ
	|	&ПартииПроизводства КАК ПартииПроизводства
	|
	|;
	|
	|ВЫБРАТЬ
	|	ВтПартии.НомерСтроки             КАК НомерСтроки,
	|	ВтПартии.Номенклатура            КАК Номенклатура,
	|	ВтПартии.Характеристика          КАК Характеристика,
	|	ВтПартии.Серия                   КАК Серия,
	|	ВтПартии.Склад                   КАК Склад,
	|	ВтПартии.СтатьяКалькуляции       КАК СтатьяКалькуляции,
	|	СпрПартииПроизводства.Назначение КАК Назначение
	|ИЗ
	|	ВтПартии КАК ВтПартии
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ВтПартии.ПартияПроизводства
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ПартииПроизводства",   ПартииПроизводства.Выгрузить());
	Запрос.УстановитьПараметр("Номенклатура",         Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",       Характеристика);
	Запрос.УстановитьПараметр("Назначение",           Назначение);
	Запрос.УстановитьПараметр("Серия",                Серия);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СтруктураОтбора = Новый Структура("НомерСтроки");
	
	Для Каждого Строка Из ПартииПроизводства Цикл
		
		СтруктураОтбора.НомерСтроки = Строка.НомерСтроки;
		Если Выборка.НайтиСледующий(СтруктураОтбора) Тогда
			Строка.АналитикаУчетаНоменклатуры = РегистрыСведений.АналитикаУчетаНоменклатуры.ЗначениеКлючаАналитики(Выборка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
