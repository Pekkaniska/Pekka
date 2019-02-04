////////////////////////////////////////////////////////////////////////////////
// Подсистема "Переработка на стороне".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//++ НЕ УТКА

// Формирует данные для формирования заказов переработчикам.
//
// Параметры:
//  СписокСтрок	 - Массив - Содержит данные выбранных строк на основании которых оформляются заказы.
// 
// Возвращаемое значение:
//  Структура - Содержит данные необходимые для формирования заказов переработчикам.
//
Функция ДанныеДляФормированияЗаказовПереработчикам(СписокСтрок) Экспорт
	
	Организация = Неопределено;
	Переработчик = Неопределено;
	Склад = Неопределено;
	Подразделение = Неопределено;
	ГруппаСкладов = Неопределено;
	НаправлениеДеятельности = Неопределено;
	ВариантПриемкиТоваров = Неопределено;
	ТипРаспоряжения = Неопределено;
	
	РеквизитыШапки = Новый Структура;
	ЭтапыГрафика = Новый Массив;
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		
		РазрешенВыборГруппы = (ДанныеСтроки.ВыборГруппы = ПредопределенноеЗначение("Перечисление.ВыборГруппыСкладов.РазрешитьВЗаказах")
								ИЛИ ДанныеСтроки.ВыборГруппы = ПредопределенноеЗначение("Перечисление.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных"));
		
		Если (Склад <> Неопределено 
					И Склад <> ДанныеСтроки.Склад 
					И (ГруппаСкладов <> ДанныеСтроки.ГруппаСкладов
						ИЛИ НЕ РазрешенВыборГруппы)
					И ТипЗнч(ДанныеСтроки.Распоряжение) <> Тип("ДокументСсылка.ЭтапПроизводства2_2"))
			ИЛИ (ЗначениеЗаполнено(Переработчик)
					И ЗначениеЗаполнено(ДанныеСтроки.Переработчик)
					И Переработчик <> ДанныеСтроки.Переработчик) Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Для оформления документа необходимо выбрать продукцию 
												|одного переработчика, поступающую на один склад.'"));
			Возврат Неопределено;
		КонецЕсли; 
		
		Если Организация <> Неопределено 
			И Организация <> ДанныеСтроки.Организация Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Для оформления документа необходимо выбрать заказы одной организации.'"));
			Возврат Неопределено;
		КонецЕсли; 
		
		Если НаправлениеДеятельности <> Неопределено
			И НаправлениеДеятельности <> ДанныеСтроки.НаправлениеДеятельности Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Для оформления документа необходимо выбрать заказы одного направления деятельности.'"));
			Возврат Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеСтроки.ВариантПриемкиТоваров) Тогда
			Если ЗначениеЗаполнено(ВариантПриемкиТоваров)
				И ВариантПриемкиТоваров <> ДанныеСтроки.ВариантПриемкиТоваров Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Для оформления документа необходимо выбрать заказы, использующие один вариант приемки продукции.'"));
				Возврат Неопределено;
			КонецЕсли;
			ВариантПриемкиТоваров = ДанныеСтроки.ВариантПриемкиТоваров;
		КонецЕсли;
		
		Если ТипРаспоряжения <> Неопределено 
			И ТипРаспоряжения <> ТипЗнч(ДанныеСтроки.Распоряжение) Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Для оформления документа необходимо выбрать распоряжения одного типа.'"));
			Возврат Неопределено;
		КонецЕсли;
		
		Организация = ДанныеСтроки.Организация;
		Склад = ДанныеСтроки.Склад;
		Подразделение = ДанныеСтроки.Подразделение;
		НаправлениеДеятельности = ДанныеСтроки.НаправлениеДеятельности;
		ГруппаСкладов = ДанныеСтроки.ГруппаСкладов;
		ТипРаспоряжения = ТипЗнч(ДанныеСтроки.Распоряжение);
		
		// Переработчик может быть не указан в заказе на производство
		Переработчик = ?(ЗначениеЗаполнено(ДанныеСтроки.Переработчик), ДанныеСтроки.Переработчик, Переработчик);
		
		Если ТипРаспоряжения = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
			ДанныеЭтапа = Новый Структура("Распоряжение,КодСтрокиЭтапыГрафик");
			ЗаполнитьЗначенияСвойств(ДанныеЭтапа, ДанныеСтроки);
			ЭтапыГрафика.Добавить(ДанныеЭтапа);
		Иначе
			ЭтапыГрафика.Добавить(ДанныеСтроки.Распоряжение);
		КонецЕсли; 
		
	КонецЦикла; 
	
	РеквизитыШапки.Вставить("Организация", Организация);
	РеквизитыШапки.Вставить("Партнер", Переработчик);
	РеквизитыШапки.Вставить("Подразделение", Подразделение);
	РеквизитыШапки.Вставить("НаправлениеДеятельности", НаправлениеДеятельности);
	РеквизитыШапки.Вставить("ГруппировкаЗатрат", ?(ТипРаспоряжения = Тип("ДокументСсылка.ЗаказНаПроизводство"), 
														ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЗаказамНаПроизводство"),
														ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства")));
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ЭтапыГрафика", ЭтапыГрафика);
	ДанныеЗаполнения.Вставить("РеквизитыШапки", РеквизитыШапки);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

//-- НЕ УТКА

#КонецОбласти
