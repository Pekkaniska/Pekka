#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		ЗаполнитьПоНематериальномуАктиву(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
		НачислятьАмортизациюНУ = (ПорядокСписанияНИОКРНаРасходыНУ = Перечисления.ПорядокСписанияНИОКРНУ.Равномерно);
	КонецЕсли;
	
	Если Не НачислятьАмортизациюБУ Тогда
		СрокИспользованияБУ = 0;
		ОбъемНаработкиБУ = 0;
		КоэффициентБУ = 1;
	КонецЕсли;
	
	Если Не НачислятьАмортизациюНУ Тогда
		СрокИспользованияНУ = 0;
	КонецЕсли;
	
	Если Не НачислятьАмортизациюБУ И Не НачислятьАмортизациюНУ Тогда
		СтатьяРасходов = Неопределено;
		АналитикаРасходов = Неопределено;
	КонецЕсли;
	
	Если СпособНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
		ОбъемНаработкиБУ = 0;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
		Или ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		ЦелевоеФинансирование.Очистить();
	КонецЕсли;
	
	Если ВариантПримененияЦелевогоФинансирования <> Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное Тогда
		
		ТаблицаЦФ = ЦелевоеФинансирование.Выгрузить();
		ТаблицаЦФ.ЗаполнитьЗначения(Неопределено, "Сумма");
		ЦелевоеФинансирование.Загрузить(ТаблицаЦФ);
		
	КонецЕсли;
	
	СуммаЦелевыхСредств = ЦелевоеФинансирование.Итог("Сумма");
	
	ЦелевоеФинансированиеОчиститьСубконто();
	
	Если НЕ РегистрыСведений.УчетнаяПолитикаОрганизаций.РаздельныйУчетТоваровПоНалогообложениюНДС(Организация, Дата) Тогда
		
		ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента;
		НалогообложениеНДС = Справочники.Организации.ЗакупкаПодДеятельность(Организация, , Дата);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ПринятиеКУчетуНМА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	Если ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.Распределение
		Или Не ЗначениеЗаполнено(ВариантРаздельногоУчетаНДС) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	ПрименениеПБУ18 = УчетнаяПолитика.ПоддержкаПБУ18(Организация, Дата);
	
	ЭтоНМА = (ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив);
	
	Если Не ПрименениеПБУ18 Или ЭтоНМА Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокСписанияНИОКРНаРасходыНУ");
	КонецЕсли;
	
	Если Не ЭтоНМА Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СчетНачисленияАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизацииЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокУчетаНУ");
		
		Если ПорядокСписанияНИОКРНаРасходыНУ <> Перечисления.ПорядокСписанияНИОКРНУ.Равномерно Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияНУ");
		КонецЕсли;
	КонецЕсли;
	
	Если Не НачислятьАмортизациюБУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияБУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпособНачисленияАмортизацииБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ОбъемНаработкиБУ");
		МассивНепроверяемыхРеквизитов.Добавить("КоэффициентБУ");
	КонецЕсли;
	
	Если Не НачислятьАмортизациюНУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
	КонецЕсли;
	
	Если НЕ УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокСписанияНИОКРНаРасходыНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
	КонецЕсли;
	
	Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользованияБУ");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ОбъемНаработкиБУ");
	КонецЕсли;
	
	Если СпособНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КоэффициентБУ");
	КонецЕсли;
	
	Если Не ПередаватьРасходыВДругуюОрганизацию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучательРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетПередачиРасходов");
	КонецЕсли;
	
	Если НачислятьАмортизациюБУ Или НачислятьАмортизациюНУ Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходов");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВариантПримененияЦелевогоФинансирования)
		Или ВариантПримененияЦелевогоФинансирования = Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизацииЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаДоходов");
		
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование");
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Счет");
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Сумма");
	Иначе
		ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	
	Если ВариантПримененияЦелевогоФинансирования <> Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЦелевоеФинансирование.Сумма");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ОчиститьЗаписатьДвижения(Движения, "Хозрасчетный");
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	УчетНМА.ПроверитьВозможностьИзмененияСостоянияНМА(ТаблицаРеквизитов, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПринятиеКУчетуНМА.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТКА
	МеждународныйУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТКА
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	СчетУчета = ПланыСчетов.Хозрасчетный.НематериальныеАктивыОрганизации;
	СчетНачисленияАмортизации = ПланыСчетов.Хозрасчетный.АмортизацияНематериальныхАктивов;
	
	Если ЗначениеЗаполнено(НематериальныйАктив) Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НематериальныйАктив, "ВидОбъектаУчета") = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
			СчетУчета = ПланыСчетов.Хозрасчетный.РасходыНаНИОКР;
			СчетНачисленияАмортизации = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		НалогообложениеНДС = Справочники.Организации.ЗакупкаПодДеятельность(Организация, , Дата);
	КонецЕсли;
	
	НачислятьАмортизациюБУ = Истина;
	НачислятьАмортизациюНУ = Истина;
	
	ПорядокСписанияНИОКРНаРасходыНУ = ?(
		Дата < '20120101',
		Перечисления.ПорядокСписанияНИОКРНУ.Равномерно,
		Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Реквизиты.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК Состояние,
		|	Реквизиты.НематериальныйАктив КАК НематериальныйАктив,
		|	Реквизиты.Ссылка КАК Регистратор,
		|	"""" КАК ИмяСписка,
		|	Реквизиты.Дата КАК Период
		|ИЗ
		|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
		|ГДЕ
		|	Реквизиты.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ЗаполнитьПоНематериальномуАктиву(Основание)
	
	ОрганизацияНМА = УчетНМА.ОрганизацияВКоторойНМАПринятКУчету(Основание);
	
	Если ЗначениеЗаполнено(ОрганизацияНМА) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Нематериальный актив ""%1"" уже принят к учету.'"), Строка(Основание));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли; 
	
	НематериальныйАктив = Основание;
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НематериальныйАктив, "НаправлениеДеятельности,ВидОбъектаУчета");
	НаправлениеДеятельности = РеквизитыОбъекта.НаправлениеДеятельности;
	ВидОбъектаУчета = РеквизитыОбъекта.ВидОбъектаУчета;
	
КонецПроцедуры

Процедура ЦелевоеФинансированиеОчиститьСубконто()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица", ЦелевоеФинансирование.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	(ВЫРАЗИТЬ(Таблица.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
	|	ВЫРАЗИТЬ(Таблица.Счет КАК ПланСчетов.Хозрасчетный) КАК Счет,
	|	Таблица.Субконто1 КАК Субконто1,
	|	Таблица.Субконто2 КАК Субконто2,
	|	Таблица.Субконто3 КАК Субконто3
	|ПОМЕСТИТЬ втДанныеЗаполнения
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеЗаполнения.ИндексСтроки,
	|	
	|	ВЫБОР КОГДА ХозрасчетныйВидыСубконто1.Ссылка ЕСТЬ NULL
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ втДанныеЗаполнения.Субконто1
	|	КОНЕЦ КАК Субконто1,
	|	ВЫБОР КОГДА ХозрасчетныйВидыСубконто2.Ссылка ЕСТЬ NULL
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ втДанныеЗаполнения.Субконто2
	|	КОНЕЦ КАК Субконто2,
	|	ВЫБОР КОГДА ХозрасчетныйВидыСубконто3.Ссылка ЕСТЬ NULL
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ втДанныеЗаполнения.Субконто3
	|	КОНЕЦ КАК Субконто3
	|ИЗ
	|	втДанныеЗаполнения КАК втДанныеЗаполнения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто1
	|		ПО втДанныеЗаполнения.Счет = ХозрасчетныйВидыСубконто1.Ссылка И (ХозрасчетныйВидыСубконто1.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто2
	|		ПО втДанныеЗаполнения.Счет = ХозрасчетныйВидыСубконто2.Ссылка И (ХозрасчетныйВидыСубконто2.НомерСтроки = 2)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто3
	|		ПО втДанныеЗаполнения.Счет = ХозрасчетныйВидыСубконто3.Ссылка И (ХозрасчетныйВидыСубконто3.НомерСтроки = 3)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаЦФ = ЦелевоеФинансирование[Выборка.ИндексСтроки];
		ЗаполнитьЗначенияСвойств(СтрокаЦФ, Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли