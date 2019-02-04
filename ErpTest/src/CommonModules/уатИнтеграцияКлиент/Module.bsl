////////////////////////////////////////////////////////////////////////////////
// Переопределяемые процедуры, вызываемые из обработчиков форм.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	Если Команда.Имя = "_уатФормаДопСвойствТС" Тогда 
		ОткрытьФормуДопСвойствТС(Форма, Команда, ДополнительныеПараметры);
		
	ИначеЕсли Команда.Имя = "_уатФормаДопСвойствУзловОбъектовЭксплуатации" Тогда 
		ОткрытьФормуДопСвойствУзловОбъектовЭксплуатации(Форма, Команда, ДополнительныеПараметры);
		
	ИначеЕсли Команда.Имя = "_уатУзелОбъектовЭксплуатацииЗаполнитьНаименованиеПоДаннымУАТ" Тогда 
		ЗаполнитьНаименованиеУзлаОбъектаЭксплуатации(Форма, Команда, ДополнительныеПараметры);
		
	ИначеЕсли Команда.Имя = "_уатУзелОбъектовЭксплуатацииЗаполнитьМодельПоДаннымУАТ" Тогда 
		ЗаполнитьМодельУзлаОбъектаЭксплуатации(Форма, Команда, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуДопСвойствТС(Форма, Команда, ДополнительныеПараметры)
	
	стрДопПараметры = Новый Структура("Форма, Команда, ДополнительныеПараметры", Форма, Команда, ДополнительныеПараметры);
	
	Если Форма.Объект.Ссылка.Пустая() Или Форма.Модифицированность Тогда 
		ОповещениеВопросОЗаписиТС = Новый ОписаниеОповещения("ОткрытьФормуДопСвойствЗаписатьЭлементСправочника", уатИнтеграцияКлиент, стрДопПараметры);
		ТекстВопроса = "Данные еще не записаны.
		               |Открытие формы дополнительных реквизитов возможно только после записи данных.
		               |Записать?";
		ПоказатьВопрос(ОповещениеВопросОЗаписиТС, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ОткрытьФормуДопСвойствТСЗавершение(стрДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуДопСвойствЗаписатьЭлементСправочника(ОтветНаВопрос, ДопПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда 
		ДопПараметры.Форма.Записать();
		ОткрытьФормуДопСвойствТСЗавершение(ДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуДопСвойствТСЗавершение(ДопПараметры)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Объект",         ДопПараметры.Форма.Объект);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ДопПараметры.Форма.ТолькоПросмотр);
	
	ОткрытьФорму("Справочник.ТранспортныеСредства.Форма.уатДопСвойстваУАТ", ПараметрыФормы, ДопПараметры.Форма);
	
КонецПроцедуры

Процедура ОткрытьФормуДопСвойствУзловОбъектовЭксплуатации(Форма, Команда, ДополнительныеПараметры)
	
	стрДопПараметры = Новый Структура("Форма, Команда, ДополнительныеПараметры", Форма, Команда, ДополнительныеПараметры);
	
	Если Форма.Объект.Ссылка.Пустая() Или Форма.Модифицированность Тогда 
		ОповещениеВопросОЗаписиТС = Новый ОписаниеОповещения("ОткрытьФормуДопСвойствУзловОбъектовЭксплуатацииЗаписатьЭлементСправочника", уатИнтеграцияКлиент, стрДопПараметры);
		ТекстВопроса = "Данные еще не записаны.
		               |Открытие формы дополнительных реквизитов возможно только после записи данных.
		               |Записать?";
		ПоказатьВопрос(ОповещениеВопросОЗаписиТС, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ОткрытьФормуДопСвойствУзловОбъектовЭксплуатацииЗавершение(стрДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуДопСвойствУзловОбъектовЭксплуатацииЗаписатьЭлементСправочника(ОтветНаВопрос, ДопПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда 
		ДопПараметры.Форма.Записать();
		ОткрытьФормуДопСвойствУзловОбъектовЭксплуатацииЗавершение(ДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуДопСвойствУзловОбъектовЭксплуатацииЗавершение(ДопПараметры)
	
	РазрешеноРедактирование = Не ДопПараметры.Форма.ВладелецЛиквидирован 
		И ДопПараметры.Форма.Редактируется И Не ДопПараметры.Форма.ТолькоПросмотр;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("УзелОбъектаЭксплуатации", ДопПараметры.Форма.Параметры.Ключ);
	ПараметрыФормы.Вставить("ТолькоПросмотр",          Не РазрешеноРедактирование);
	
	ОткрытьФорму("РегистрСведений.уатАгрегатыТС.ФормаЗаписи", ПараметрыФормы, ДопПараметры.Форма);
	
КонецПроцедуры

Процедура ЗаполнитьНаименованиеУзлаОбъектаЭксплуатации(Форма, Команда, ДополнительныеПараметры)
	
	Наименование = уатОбщегоНазначения.СформироватьНаименованиеАгрегата(Форма.Параметры.Ключ);
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда 
		Возврат;
	КонецЕсли;
	
	Форма.Объект.Наименование = Наименование;
	
	Форма.Элементы.НаименованиеПолное.СписокВыбора.Очистить();
	Форма.Элементы.НаименованиеПолное.СписокВыбора.Добавить(Форма.Объект.Наименование);
	
	Если Не ЗначениеЗаполнено(Форма.Объект.НаименованиеПолное) Тогда
		Форма.Объект.НаименованиеПолное = Форма.Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьМодельУзлаОбъектаЭксплуатации(Форма, Команда, ДополнительныеПараметры)
	
	НаименованиеМодели = уатОбщегоНазначения.СформироватьНаименованиеМоделиАгрегата(Форма.Параметры.Ключ);
	
	Если Не ЗначениеЗаполнено(НаименованиеМодели) Тогда 
		Возврат;
	КонецЕсли;
	
	Форма.Объект.Модель = НаименованиеМодели;
	
КонецПроцедуры

#КонецОбласти
