#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОтменаРегистрацииЛицевыхСчетов")
		И ДополнительныеСвойства.ОтменаРегистрацииЛицевыхСчетов = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// Проверка того, что не меняются лицевые счета, введенные документом.
	ТекущийНабор = ЭтотОбъект.Выгрузить();
	
	НаборЗаписей = РегистрыСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам.СоздатьНаборЗаписей();
	Для Каждого ЭлементОтбора Из Отбор Цикл
		НаборЗаписей.Отбор[ЭлементОтбора.ПутьКДанным].Установить(ЭлементОтбора.Значение);
	КонецЦикла;
	
	НаборЗаписей.Прочитать();
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		
		Если ЗначениеЗаполнено(ЗаписьНабора.ДокументОснование) Тогда
			
			ИзменениеЗапрещено = Ложь;
			СтрокиТекущегоНабора = ТекущийНабор.НайтиСтроки(Новый Структура("ФизическоеЛицо,ЗарплатныйПроект",ЗаписьНабора.ФизическоеЛицо, ЗаписьНабора.ЗарплатныйПроект));
			Если СтрокиТекущегоНабора.Количество() > 0 Тогда
				
				Если ЗначениеЗаполнено(СтрокиТекущегоНабора[0].ДокументОснование)
					И ЗначениеЗаполнено(ЗаписьНабора.ДокументОснование)
					И СтрокиТекущегоНабора[0].ДатаОткрытияЛицевогоСчета < ЗаписьНабора.ДатаОткрытияЛицевогоСчета Тогда
					
					ИзменениеЗапрещено = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если ИзменениеЗапрещено Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Нельзя изменять лицевые счета, введенные документом %1.'"),
					ЗаписьНабора.ДокументОснование);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЗаписьНабора.ДокументОснование, , , Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТекущийНабор", Выгрузить(, "ЗарплатныйПроект, НомерЛицевогоСчета, ФизическоеЛицо"));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТекущийНабор.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ТекущийНабор.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
		|	ТекущийНабор.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТТекущийНабор
		|ИЗ
		|	&ТекущийНабор КАК ТекущийНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛицевыеСчетаСотрудников.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ЛицевыеСчетаСотрудников.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
		|	ТекущийНабор.ФизическоеЛицо КАК ФизическоеЛицоТекущегоНабора,
		|	ЛицевыеСчетаСотрудников.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТЛицевыеСчетаСотрудниковПоЗарплатнымПроектам
		|ИЗ
		|	РегистрСведений.ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТекущийНабор КАК ТекущийНабор
		|		ПО ЛицевыеСчетаСотрудников.ЗарплатныйПроект = ТекущийНабор.ЗарплатныйПроект
		|			И ЛицевыеСчетаСотрудников.НомерЛицевогоСчета = ТекущийНабор.НомерЛицевогоСчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛицевыеСчетаСотрудников.ЗарплатныйПроект КАК ЗарплатныйПроект,
		|	ЛицевыеСчетаСотрудников.НомерЛицевогоСчета КАК НомерЛицевогоСчета
		|ПОМЕСТИТЬ ВТЗадвоенныеЛицевыеСчета
		|ИЗ
		|	ВТЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудников
		|
		|СГРУППИРОВАТЬ ПО
		|	ЛицевыеСчетаСотрудников.ЗарплатныйПроект,
		|	ЛицевыеСчетаСотрудников.НомерЛицевогоСчета
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЛицевыеСчетаСотрудников.ФизическоеЛицо) > 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗадвоенныеЛицевыеСчета.ЗарплатныйПроект КАК ЗарплатныйПроект
		|ИЗ
		|	ВТЗадвоенныеЛицевыеСчета КАК ЗадвоенныеЛицевыеСчета";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Отказ = Истина;
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЗадвоенныеЛицевыеСчета.ЗарплатныйПроект КАК ЗарплатныйПроект,
			|	ЗадвоенныеЛицевыеСчета.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
			|	ЛицевыеСчетаСотрудников.ФизическоеЛицоТекущегоНабора КАК ФизическоеЛицоТекущегоНабора,
			|	ЛицевыеСчетаСотрудников.ФизическоеЛицо КАК ФизическоеЛицо
			|ИЗ
			|	ВТЗадвоенныеЛицевыеСчета КАК ЗадвоенныеЛицевыеСчета
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЛицевыеСчетаСотрудниковПоЗарплатнымПроектам КАК ЛицевыеСчетаСотрудников
			|		ПО ЗадвоенныеЛицевыеСчета.ЗарплатныйПроект = ЛицевыеСчетаСотрудников.ЗарплатныйПроект
			|			И ЗадвоенныеЛицевыеСчета.НомерЛицевогоСчета = ЛицевыеСчетаСотрудников.НомерЛицевогоСчета
			|ГДЕ
			|	ЛицевыеСчетаСотрудников.ФизическоеЛицоТекущегоНабора <> ЛицевыеСчетаСотрудников.ФизическоеЛицо
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЗарплатныйПроект,
			|	НомерЛицевогоСчета,
			|	ФизическоеЛицо";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("ЗарплатныйПроект") Цикл
			
			Пока Выборка.СледующийПоЗначениюПоля("НомерЛицевогоСчета") Цикл
				
				Сотрудники = Новый Массив;
				Пока Выборка.Следующий() Цикл
					Сотрудники.Добавить(Выборка.ФизическоеЛицо);
				КонецЦикла;
				
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Лицевой счет %1 (%2) сотрудника %3 не уникален - он уже назначен сотруднику %4'"),
					Выборка.НомерЛицевогоСчета,
					Выборка.ЗарплатныйПроект,
					Выборка.ФизическоеЛицоТекущегоНабора,
					СтрСоединить(Сотрудники, ", "));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.ЗарплатныйПроект, , , Отказ);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли