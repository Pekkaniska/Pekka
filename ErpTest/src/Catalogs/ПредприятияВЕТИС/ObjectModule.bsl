
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеИзХранилища = ДанныеАдреса.Получить();
	Если ЗначениеИзХранилища <> Неопределено Тогда
		СтранаИдентификатор          = ЗначениеИзХранилища.СтранаGUID;
		РегионИдентификатор          = ЗначениеИзХранилища.РегионGUID;
		РайонИдентификатор           = ЗначениеИзХранилища.РайонGUID;
		НаселенныйПунктИдентификатор = ЗначениеИзХранилища.НаселенныйПунктGUID;
	Иначе
		СтранаИдентификатор          = "";
		РегионИдентификатор          = "";
		РайонИдентификатор           = "";
		НаселенныйПунктИдентификатор = "";
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Предприятие", Ссылка);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ХозяйствующиеСубъектыВЕТИС.Ссылка КАК ХозяйствующийСубъект
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК ХозяйствующиеСубъектыВЕТИСПредприятия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъектыВЕТИС
	|		ПО ХозяйствующиеСубъектыВЕТИСПредприятия.Ссылка = ХозяйствующиеСубъектыВЕТИС.Ссылка
	|ГДЕ
	|	ХозяйствующиеСубъектыВЕТИС.СоответствуетОрганизации
	|	И ХозяйствующиеСубъектыВЕТИСПредприятия.Предприятие = &Предприятие
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если НЕ ДополнительныеСвойства.ЭтоНовый Тогда
		Пока Выборка.Следующий() Цикл
			РегистрыСведений.ПредприятияЗонОтветственностиВЕТИС.УдалитьПредприятияИзЗонОтветственностиПоНаследованиюАдреса(Выборка.ХозяйствующийСубъект, Ссылка,, Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Выборка.Сбросить();
	
	Если НЕ Отказ Тогда
		Пока Выборка.Следующий() Цикл
			РегистрыСведений.ПредприятияЗонОтветственностиВЕТИС.ДобавитьПредприятияВЗоныОтветственностиПоНаследованиюАдреса(Выборка.ХозяйствующийСубъект,, Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

#КонецЕсли