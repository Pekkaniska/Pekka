#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Принятие к учету НМА (международный учет)".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ОтображатьВнеоборотныеАктивыМеждународныйУчет2_2";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	
	Возврат ИсточникиДанных; 
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ПринятиеКУчетуНМАМеждународныйУчет";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоНМА" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		ВЗапросеЕстьИсточник = Ложь;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоНМА" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	НематериальныеАктивыМеждународныйУчет(ТекстыЗапроса, Регистры);
	Международный(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Ответственный,
	|	ДанныеДокумента.Комментарий,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.НематериальныйАктив,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ПринятиеКУчетуНМАМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Граница", Новый Граница(Реквизиты.Дата, ВидГраницы.Исключая));
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПринятиеКУчетуНМАМеждународныйУчет"));
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru='Принятие к учету НМА (международный учет)'"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПринятиеКУчетуНМА);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура НематериальныеАктивыМеждународныйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НематериальныеАктивыМеждународныйУчет";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица НематериальныеАктивыМеждународныйУчет
	|"+
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Регистратор,
	|	Документ.Дата КАК Период,
	|	Документ.НематериальныйАктив КАК НематериальныйАктив,
	|	Документ.Организация КАК Организация,
	|	Документ.Подразделение КАК Подразделение,
	|	ВЫБОР
	|		КОГДА Документ.ПорядокУчета = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.Списан)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету)
	|	КОНЕЦ КАК Состояние,
	|	Документ.СчетУчета КАК СчетУчета,
	|	Документ.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
	|	Документ.ЛиквидационнаяСтоимостьПредставления КАК ЛиквидационнаяСтоимостьПредставления,
	|	Документ.ПорядокУчета КАК ПорядокУчета,
	|	Документ.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
	|	Документ.СчетАмортизации КАК СчетАмортизации,
	|	Документ.СрокИспользования КАК СрокИспользования,
	|	Документ.КоэффициентУскорения КАК КоэффициентУскорения,
	|	Документ.ОбъемНаработки КАК ОбъемНаработки,
	|	Документ.СтатьяРасходов КАК СтатьяРасходов,
	|	Документ.АналитикаРасходов КАК АналитикаРасходов,
	|	Документ.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	Документ.ПервоначальнаяСтоимостьПредставления КАК ПервоначальнаяСтоимостьПредставления
	|ИЗ
	|	Документ.ПринятиеКУчетуНМАМеждународныйУчет КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Процедура Международный(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "Международный";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица Международный
	|"+
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ПервоначальнаяСтоимость КАК Сумма,
	|	ДанныеДокумента.ПервоначальнаяСтоимостьПредставления КАК СуммаПредставления,
	|	
	|	ДанныеДокумента.СчетУчета КАК СчетДт,
	|	ВЫБОР КОГДА ДанныеДокумента.СчетУчета.УчетПоПодразделениям
	|		ТОГДА ДанныеДокумента.Подразделение
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПодразделениеДт,
	|	ВЫБОР КОГДА ДанныеДокумента.СчетУчета.УчетПоНаправлениямДеятельности
	|		ТОГДА ДанныеДокумента.НематериальныйАктив.НаправлениеДеятельности
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	ДанныеДокумента.НематериальныйАктив КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы) КАК ВидСубконтоДт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	ДанныеДокумента.СчетКапитальныхВложений КАК СчетКт,
	|	ВЫБОР КОГДА ДанныеДокумента.СчетКапитальныхВложений.УчетПоПодразделениям
	|		ТОГДА ДанныеДокумента.Подразделение
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПодразделениеКт,
	|	ВЫБОР КОГДА ДанныеДокумента.СчетКапитальныхВложений.УчетПоНаправлениямДеятельности
	|		ТОГДА ДанныеДокумента.НематериальныйАктив.НаправлениеДеятельности
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	ДанныеДокумента.НематериальныйАктив КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы) КАК ВидСубконтоКт1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка) КАК ВидСубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|ИЗ
	|	Документ.ПринятиеКУчетуНМАМеждународныйУчет КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ (ДанныеДокумента.ПервоначальнаяСтоимость=0 И ДанныеДокумента.ПервоначальнаяСтоимостьПредставления=0)
	|";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Дата                                   КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&Подразделение                          КАК Подразделение,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Дата                                   КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&Дата   КАК ДатаОтраженияВУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоНМА";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	0                          КАК НомерЗаписи,
	|	&Ссылка                    КАК Ссылка,
	|	&Дата                      КАК Дата,
	|	&Организация               КАК Организация,
	|	&Подразделение             КАК Подразделение,
	|	&Проведен                  КАК Проведен,
	|	&ХозяйственнаяОперация     КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных   КАК ТипСсылки,
	|	&НематериальныйАктив       КАК НематериальныйАктив";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ПроведениеМеждународныйУчет

Процедура ЗаполнитьТаблицуДокументаКОтражениюВМеждународномУчете(ТаблицаДокумента, Документ) Экспорт

	НоваяСтрока = ТаблицаДокумента.Добавить();
	НоваяСтрока.Регистратор = Документ.Ссылка;
	НоваяСтрока.Организация = Документ.Организация;

КонецПроцедуры

Функция ТекстОтраженияВМеждународномУчете() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	НематериальныеАктивы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.НематериальныйАктив КАК Объект,
	|	ДанныеДокумента.ПорядокУчета КАК ПорядокУчета,
	|	ДанныеДокумента.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	ДанныеДокумента.ПервоначальнаяСтоимостьПредставления КАК ПервоначальнаяСтоимостьПредставления,
	|	ДанныеДокумента.СчетКапитальныхВложений КАК СчетКапитальныхВложений,
	|	ДанныеДокумента.СчетУчета КАК СчетУчета,
	|	ДанныеДокумента.СчетРасходов КАК СчетРасходов,
	|	ДанныеДокумента.СчетРасходовСубконто1 КАК СчетРасходовСубконто1,
	|	ДанныеДокумента.СчетРасходовСубконто2 КАК СчетРасходовСубконто2,
	|	ДанныеДокумента.СчетРасходовСубконто3 КАК СчетРасходовСубконто3
	|ПОМЕСТИТЬ Операции
	|ИЗ
	|	Документ.ПринятиеКУчетуНМАМеждународныйУчет КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДокументыКОтражению КАК ДокументыКОтражению
	|		ПО ДанныеДокумента.Ссылка = ДокументыКОтражению.Регистратор
	|			И ДанныеДокумента.Ссылка.Организация = ДокументыКОтражению.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НематериальныеАктивы КАК НематериальныеАктивы
	|		ПО ДанныеДокумента.НематериальныйАктив = НематериальныеАктивы.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	ДанныеДокумента.НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Операции.Объект КАК Объект,
	|	СУММА(КапитальныеВложения.Сумма) КАК Сумма,
	|	СУММА(КапитальныеВложения.СуммаПредставления) КАК СуммаПредставления
	|ПОМЕСТИТЬ КапитальныеВложения
	|ИЗ
	|	Операции КАК Операции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.ДвиженияССубконто(
	|				,
	|				,
	|				НЕ Регистратор В
	|							(ВЫБРАТЬ
	|								Операции.Регистратор
	|							ИЗ
	|								Операции)
	|					И (Организация, Подразделение, СчетДт, Субконто1) В
	|						(ВЫБРАТЬ
	|							Операции.Организация,
	|							Операции.Подразделение,
	|							Операции.СчетКапитальныхВложений,
	|							Операции.Объект
	|						ИЗ
	|							Операции КАК Операции),
	|				,
	|				) КАК КапитальныеВложения
	|		ПО Операции.Объект = КапитальныеВложения.СубконтоДт1
	|			И (КОНЕЦПЕРИОДА(Операции.Дата, МЕСЯЦ) > КапитальныеВложения.Период)
	|			И Операции.СчетКапитальныхВложений = КапитальныеВложения.СчетДт
	|			И (КапитальныеВложения.Активность)
	|
	|СГРУППИРОВАТЬ ПО
	|	Операции.Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК ТипПроводки, // Передача стоимости со счета капитальных затрат на счет учета
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	0 КАК Сумма,
	|	0 КАК СуммаПредставления,
	|	
	|	Операции.СчетУчета КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.Объект КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетКапитальныхВложений КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|	
	|ПОМЕСТИТЬ Проводки
	|ИЗ
	|	Операции КАК Операции
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1 КАК ТипПроводки, // Передача стоимости со счета капитальных затрат на счет учета
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	Операции.ПервоначальнаяСтоимость КАК Сумма,
	|	Операции.ПервоначальнаяСтоимостьПредставления КАК СуммаПредставления,
	|	
	|	Операции.СчетУчета КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.Объект КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетКапитальныхВложений КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|	
	|ИЗ
	|	Операции КАК Операции
	|ГДЕ
	|	Операции.ПервоначальнаяСтоимость <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1 КАК ТипПроводки, // Передача стоимости со счета капитальных затрат на счет учета
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	ЕСТЬNULL(КапитальныеВложения.Сумма, 0) - Операции.ПервоначальнаяСтоимость КАК Сумма,
	|	ЕСТЬNULL(КапитальныеВложения.СуммаПредставления, 0) - Операции.ПервоначальнаяСтоимостьПредставления КАК СуммаПредставления,
	|	
	|	Операции.СчетУчета КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.Объект КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетКапитальныхВложений КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|	
	|ИЗ
	|	Операции КАК Операции
	|		ЛЕВОЕ СОЕДИНЕНИЕ КапитальныеВложения КАК КапитальныеВложения
	|		ПО Операции.Объект = КапитальныеВложения.Объект
	|ГДЕ
	|	ЕСТЬNULL(КапитальныеВложения.Сумма, 0) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК ТипПроводки, // Списание стоимости со счета учета на счет расходов
	|	Операции.Дата КАК Период,
	|	Операции.Регистратор КАК Регистратор,
	|	
	|	Операции.Организация КАК Организация,
	|	ЕСТЬNULL(КапитальныеВложения.Сумма, 0) КАК Сумма,
	|	ЕСТЬNULL(КапитальныеВложения.СуммаПредставления, 0) КАК СуммаПредставления,
	|	
	|	Операции.СчетРасходов КАК СчетДт,
	|	Операции.Подразделение КАК ПодразделениеДт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	Операции.СчетРасходовСубконто1 КАК СубконтоДт1,
	|	Операции.СчетРасходовСубконто2 КАК СубконтоДт2,
	|	Операции.СчетРасходовСубконто3 КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	
	|	Операции.СчетУчета КАК СчетКт,
	|	Операции.Подразделение КАК ПодразделениеКт,
	|	Операции.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операции.Объект КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт
	|ИЗ
	|	Операции КАК Операции
	|	ЛЕВОЕ СОЕДИНЕНИЕ КапитальныеВложения КАК КапитальныеВложения
	|		ПО Операции.Объект = КапитальныеВложения.Объект
	|ГДЕ
	|	Операции.ПорядокУчета = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ВалютаФункциональная КАК ВалютаХраненияСуммыФункциональной,
	|	&ВалютаПредставления КАК ВалютаХраненияСуммыПредставления,
	|	Проводки.ТипПроводки КАК ТипПроводки,
	|	Проводки.Период,
	|	Проводки.Регистратор,
	|	Проводки.Организация,
	|	СУММА(Проводки.Сумма) КАК Сумма,
	|	СУММА(Проводки.СуммаПредставления) КАК СуммаПредставления,
	|	Проводки.СчетДт,
	|	ВЫБОР КОГДА Проводки.СчетДт.УчетПоПодразделениям
	|		ТОГДА Проводки.ПодразделениеДт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПодразделениеДт,
	|	ВЫБОР КОГДА Проводки.СчетДт.УчетПоНаправлениямДеятельности
	|		ТОГДА Проводки.НаправлениеДеятельностиДт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НаправлениеДеятельностиДт,
	|	Проводки.ВалютаДт,
	|	Проводки.СубконтоДт1,
	|	Проводки.СубконтоДт2,
	|	Проводки.СубконтоДт3,
	|	СУММА(Проводки.ВалютнаяСуммаДт) КАК ВалютнаяСуммаДт,
	|	Проводки.СчетКт,
	|	ВЫБОР КОГДА Проводки.СчетКт.УчетПоПодразделениям
	|		ТОГДА Проводки.ПодразделениеКт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ПодразделениеКт,
	|	ВЫБОР КОГДА Проводки.СчетКт.УчетПоНаправлениямДеятельности
	|		ТОГДА Проводки.НаправлениеДеятельностиКт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НаправлениеДеятельностиКт,
	|	Проводки.ВалютаКт,
	|	Проводки.СубконтоКт1,
	|	Проводки.СубконтоКт2,
	|	Проводки.СубконтоКт3,
	|	СУММА(Проводки.ВалютнаяСуммаКт) КАК ВалютнаяСуммаКт
	|ИЗ
	|	Проводки КАК Проводки
	|
	|СГРУППИРОВАТЬ ПО
	|	Проводки.ТипПроводки,
	|	Проводки.Период,
	|	Проводки.Регистратор,
	|	Проводки.Организация,
	|	Проводки.СчетДт,
	|	ВЫБОР КОГДА Проводки.СчетДт.УчетПоПодразделениям
	|		ТОГДА Проводки.ПодразделениеДт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР КОГДА Проводки.СчетДт.УчетПоНаправлениямДеятельности
	|		ТОГДА Проводки.НаправлениеДеятельностиДт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	Проводки.ВалютаДт,
	|	Проводки.СубконтоДт1,
	|	Проводки.СубконтоДт2,
	|	Проводки.СубконтоДт3,
	|	Проводки.СчетКт,
	|	ВЫБОР КОГДА Проводки.СчетКт.УчетПоПодразделениям
	|		ТОГДА Проводки.ПодразделениеКт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР КОГДА Проводки.СчетКт.УчетПоНаправлениямДеятельности
	|		ТОГДА Проводки.НаправлениеДеятельностиКт
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	Проводки.ВалютаКт,
	|	Проводки.СубконтоКт1,
	|	Проводки.СубконтоКт2,
	|	Проводки.СубконтоКт3
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипПроводки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Операции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ Проводки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ КапитальныеВложения";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ПроверитьЗаполнениеПроводкиМеждународногоУчета(Проводка, Выборка) Экспорт
	
	Если Проводка.Сумма = 0 Тогда
		
		Если Выборка.ТипПроводки = 1 Тогда // Передача первоначальной стоимости на счет учета
			
			Проводка.Статус = МеждународныйУчетСерверПовтИсп.Статус(
				Проводка.Статус,
				Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете);
			
			ТекстОшибки = НСтр("ru='Первоначальная стоимость НМА ""%Объект%"" на счете капитальных вложений отсутствует'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%", Проводка.СубконтоДт1);
			Проводка.МассивОшибок.Добавить(ТекстОшибки);
			
		КонецЕсли;
		
		Если Выборка.ТипПроводки = 2 Тогда // Списание первоначальной стоимости со счета учета
			
			Проводка.Статус = МеждународныйУчетСерверПовтИсп.Статус(
				Проводка.Статус,
				Перечисления.СтатусыОтраженияВМеждународномУчете.ОтраженоВУчете);
			
			ТекстОшибки = НСтр("ru='Стоимость НМА ""%Объект%"" на счете учета отсутствует'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%", Проводка.СубконтоКт1);
			Проводка.МассивОшибок.Добавить(ТекстОшибки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли