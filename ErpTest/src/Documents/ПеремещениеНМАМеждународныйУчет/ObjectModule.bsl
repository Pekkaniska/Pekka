#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		НематериальныйАктив = ДанныеЗаполнения;
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ПеремещениеНМАМеждународныйУчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоНМА");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ОчиститьЗаписатьДвижения(Движения, "Международный, НематериальныеАктивыМеждународныйУчет");
	
	ПроверитьВозможностьПроведения(Отказ);
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПеремещениеНМАМеждународныйУчет.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоНМА.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

Процедура ПроверитьВозможностьПроведения(Отказ=Ложь)
	
	ТребуемоеСостояние = Новый Структура(
		"Организация, Состояние, Подразделение",
		Организация, Перечисления.ВидыСостоянийНМА.ПринятКУчету, Подразделение);
	ПараметрыПроверки = Новый Структура("ДатаСведений, ИсключаемыйРегистратор", Дата, Ссылка);
	Ошибки = МеждународныйУчетВнеоборотныеАктивы.ПроверитьСостояниеВнеоборотныхАктивов(
		НематериальныйАктив, ТребуемоеСостояние, ПараметрыПроверки);
	Если Ошибки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Ошибки Цикл
		Объект = КлючИЗначение.Ключ;
		Данные = КлючИЗначение.Значение;
		
		ТекстОшибки = НСтр("ru='Учетные данные нематериального актива ""%1"" не могут быть изменены.'") + Символы.ПС;
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", Объект);
		Если Данные.Состояние <> Перечисления.ВидыСостоянийНМА.ПринятКУчету Тогда
			ТекстОшибки = ТекстОшибки
				+ НСтр("ru='Объект не принят к учету'");
		Иначе
			Шаблон = НСтр("ru='Объект принят к учету в организации ""%1"" в подразделение ""%2""'");
			ТекстОшибки = ТекстОшибки
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Данные.Организация, Данные.Подразделение);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НематериальныйАктив",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли