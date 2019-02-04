#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

#Область ОбновлениеИнформационнойБазы

Процедура ЗаполнитьДатуРегистрации(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияТранспортныхСредств.Организация КАК Организация,
	|	РегистрацияТранспортныхСредств.ОсновноеСредство КАК ОсновноеСредство,
	|	РегистрацияТранспортныхСредств.Период КАК Период,
	|	РегистрацияТранспортныхСредств.ВидЗаписи КАК ВидЗаписи
	|ПОМЕСТИТЬ ВТ_Записи
	|ИЗ
	|	РегистрСведений.РегистрацияТранспортныхСредств КАК РегистрацияТранспортныхСредств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Записи.Организация КАК Организация,
	|	ВТ_Записи.ОсновноеСредство КАК ОсновноеСредство,
	|	ВТ_Записи.Период КАК Период
	|ПОМЕСТИТЬ ВТ_Регистрация
	|ИЗ
	|	ВТ_Записи КАК ВТ_Записи
	|ГДЕ
	|	ВТ_Записи.ВидЗаписи = ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.Регистрация)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Записи.Организация КАК Организация,
	|	ВТ_Записи.ОсновноеСредство КАК ОсновноеСредство,
	|	ВТ_Записи.Период КАК Период
	|ПОМЕСТИТЬ ВТ_Снятые
	|ИЗ
	|	ВТ_Записи КАК ВТ_Записи
	|ГДЕ
	|	ВТ_Записи.ВидЗаписи = ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Регистрация.Организация КАК Организация,
	|	ВТ_Регистрация.ОсновноеСредство КАК ОсновноеСредство,
	|	ВТ_Регистрация.Период КАК Период,
	|	МАКСИМУМ(ЕСТЬNULL(ВТ_Снятые.Период, ДАТАВРЕМЯ(1, 1, 1))) КАК ПериодПредыдущегоСнятияСУчета
	|ПОМЕСТИТЬ ВТ_ПредыдущееСнятиеСУчета
	|ИЗ
	|	ВТ_Регистрация КАК ВТ_Регистрация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Снятые КАК ВТ_Снятые
	|		ПО ВТ_Регистрация.Организация = ВТ_Снятые.Организация
	|			И ВТ_Регистрация.ОсновноеСредство = ВТ_Снятые.ОсновноеСредство
	|			И ВТ_Регистрация.Период > ВТ_Снятые.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Регистрация.Организация,
	|	ВТ_Регистрация.ОсновноеСредство,
	|	ВТ_Регистрация.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПредыдущееСнятиеСУчета.Организация КАК Организация,
	|	ВТ_ПредыдущееСнятиеСУчета.ОсновноеСредство КАК ОсновноеСредство,
	|	ВТ_ПредыдущееСнятиеСУчета.Период КАК Период,
	|	МИНИМУМ(ВТ_Регистрация.Период) КАК ПериодПервоначальнойРегистрации
	|ПОМЕСТИТЬ ВТ_ПервоначальнаяРегистрация
	|ИЗ
	|	ВТ_ПредыдущееСнятиеСУчета КАК ВТ_ПредыдущееСнятиеСУчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Регистрация КАК ВТ_Регистрация
	|		ПО ВТ_ПредыдущееСнятиеСУчета.Организация = ВТ_Регистрация.Организация
	|			И ВТ_ПредыдущееСнятиеСУчета.ОсновноеСредство = ВТ_Регистрация.ОсновноеСредство
	|			И ВТ_ПредыдущееСнятиеСУчета.ПериодПредыдущегоСнятияСУчета < ВТ_Регистрация.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ПредыдущееСнятиеСУчета.Организация,
	|	ВТ_ПредыдущееСнятиеСУчета.ОсновноеСредство,
	|	ВТ_ПредыдущееСнятиеСУчета.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Регистрация.Организация КАК Организация,
	|	ВТ_Регистрация.ОсновноеСредство КАК ОсновноеСредство,
	|	ВТ_Регистрация.Период КАК Период,
	|	МИНИМУМ(ЕСТЬNULL(ВТ_Снятые.Период, ДАТАВРЕМЯ(1, 1, 1))) КАК ПериодСнятияСУчета
	|ПОМЕСТИТЬ ВТ_СнятиеСУчета
	|ИЗ
	|	ВТ_Регистрация КАК ВТ_Регистрация
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Снятые КАК ВТ_Снятые
	|		ПО ВТ_Регистрация.Организация = ВТ_Снятые.Организация
	|			И ВТ_Регистрация.ОсновноеСредство = ВТ_Снятые.ОсновноеСредство
	|			И ВТ_Регистрация.Период < ВТ_Снятые.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Регистрация.Организация,
	|	ВТ_Регистрация.ОсновноеСредство,
	|	ВТ_Регистрация.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ОсновноеСредство,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Регистрация.Организация КАК Организация,
	|	ВТ_Регистрация.ОсновноеСредство КАК ОсновноеСредство,
	|	МАКСИМУМ(ВТ_ПервоначальнаяРегистрация.ПериодПервоначальнойРегистрации) КАК ДатаРегистрации,
	|	МАКСИМУМ(ВТ_СнятиеСУчета.ПериодСнятияСУчета) КАК ДатаПрекращенияРегистрации,
	|	ВТ_Регистрация.Период КАК ДатаРегистрационныхДанных
	|ИЗ
	|	ВТ_Регистрация КАК ВТ_Регистрация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПервоначальнаяРегистрация КАК ВТ_ПервоначальнаяРегистрация
	|		ПО ВТ_Регистрация.Организация = ВТ_ПервоначальнаяРегистрация.Организация
	|			И ВТ_Регистрация.ОсновноеСредство = ВТ_ПервоначальнаяРегистрация.ОсновноеСредство
	|			И ВТ_Регистрация.Период = ВТ_ПервоначальнаяРегистрация.Период
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СнятиеСУчета КАК ВТ_СнятиеСУчета
	|		ПО ВТ_Регистрация.Организация = ВТ_СнятиеСУчета.Организация
	|			И ВТ_Регистрация.ОсновноеСредство = ВТ_СнятиеСУчета.ОсновноеСредство
	|			И ВТ_Регистрация.Период = ВТ_СнятиеСУчета.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Регистрация.Организация,
	|	ВТ_Регистрация.ОсновноеСредство,
	|	ВТ_Регистрация.Период";
	
	ДатыРегистрации = Запрос.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетТранспортногоНалога.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.РасчетТранспортногоНалога КАК РасчетТранспортногоНалога
	|ГДЕ
	|	РасчетТранспортногоНалога.ДатаРегистрации = ДАТАВРЕМЯ(1, 1, 1)
	|	ИЛИ РасчетТранспортногоНалога.ДатаПрекращенияРегистрации = ДАТАВРЕМЯ(1, 1, 1)";
	
	ВыборкаЗаписи = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаЗаписи.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.РасчетТранспортногоНалога.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаЗаписи.Регистратор);
		НаборЗаписей.Прочитать();
		
		Отбор = Новый Структура("Организация,ОсновноеСредство,ДатаРегистрационныхДанных");
		
		Для каждого СтрокаНабора Из НаборЗаписей Цикл
			
			Если ЗначениеЗаполнено(СтрокаНабора.ДатаРегистрации) И ЗначениеЗаполнено(СтрокаНабора.ДатаПрекращенияРегистрации) Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаНабора);
			ЗаписиОРегистрации = ДатыРегистрации.НайтиСтроки(Отбор);
			Если ЗаписиОРегистрации.Количество() > 0 Тогда
				СтрокаНабора.ДатаРегистрации = ЗаписиОРегистрации[0].ДатаРегистрации;
				СтрокаНабора.ДатаПрекращенияРегистрации = ЗаписиОРегистрации[0].ДатаПрекращенияРегистрации;
			КонецЕсли;
			
		КонецЦикла;
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		Исключение
			ШаблонСообщения	= НСтр("ru = 'Не выполнено обновление записей регистра сведений ""Расчет транспортного налога""
                                    |%1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.РасчетНалогаНаИмущество,, 
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;

	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли