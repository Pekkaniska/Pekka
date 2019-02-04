
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.пкЗаданияНаРемонт.СформироватьЗаписи(Отказ, РежимПроведения, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Пользователи.ТекущийПользователь());
	КонецЕсли;
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	Ответственный=Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(ВидРемонта) Тогда
		ВидРемонта = Справочники.ВидыРемонтов.НайтиПоНаименованию("Ремонт");
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ТребуемаяДата) Тогда
		ТребуемаяДата = ТекущаяДата();
	КонецЕсли;

	Если Не ЗначениеЗаполнено(МестоРемонта) Тогда
		МестоРемонта = Перечисления.пкМестоРемонта.УКлиента;
	КонецЕсли;
	
	Если ПланируемыеРаботы.Количество() = 0  Тогда	
		 Стр 					= ПланируемыеРаботы.Добавить();
		 Стр.Работа 			= Справочники.Номенклатура.НайтиПоНаименованию("Время в пути");	
		 Стр.Количество         = 0.1;
		 Стр.ЕдиницаИзмерения 	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Стр.Работа, "ЕдиницаИзмерения");
	КонецЕсли;
	 
КонецПроцедуры
