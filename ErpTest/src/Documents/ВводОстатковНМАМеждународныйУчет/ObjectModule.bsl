#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДанныеЗаполненияТип = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполненияТип = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если ПорядокУчета<>Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию Тогда
		
		НепроверяемыеРеквизиты.Добавить("МетодНачисленияАмортизации");
		НепроверяемыеРеквизиты.Добавить("СрокИспользования");
		НепроверяемыеРеквизиты.Добавить("ПоказательНаработки");
		НепроверяемыеРеквизиты.Добавить("ОбъемНаработки");
		НепроверяемыеРеквизиты.Добавить("КоэффициентУскорения");
		
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходов");
		
		Если НакопленнаяАмортизация = 0 И НакопленнаяАмортизацияПредставления = 0 Тогда
			НепроверяемыеРеквизиты.Добавить("СчетАмортизации");
		КонецЕсли;
		
	КонецЕсли;
	
	Если МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
		НепроверяемыеРеквизиты.Добавить("КоэффициентУскорения");
	КонецЕсли;
	
	Если МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
		НепроверяемыеРеквизиты.Добавить("СрокИспользования");
	Иначе
		НепроверяемыеРеквизиты.Добавить("ОбъемНаработки");
	КонецЕсли;
	
	Если НепроверяемыеРеквизиты.Найти("СтатьяРасходов") = Неопределено Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект,, НепроверяемыеРеквизиты, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
		КоэффициентУскорения = 1;
	КонецЕсли;
	
	Если МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
		ОбъемНаработки = 0;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ВводОстатковНМАМеждународныйУчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ВводОстатковНМАМеждународныйУчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли