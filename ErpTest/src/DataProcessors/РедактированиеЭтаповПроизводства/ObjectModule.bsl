//++ НЕ УТКА

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МенеджерВременныхТаблиц = Документы.ЭтапПроизводства2_2.СформироватьВременныеТаблицыДляПроверки(ЭтотОбъект);
	
	Документы.ЭтапПроизводства2_2.ПроверитьЗаполнениеОбъекта(
		ЭтотОбъект,
		МенеджерВременныхТаблиц,
		Отказ,
		ПроверяемыеРеквизиты);
	
	Для Каждого ДанныеЭтапа Из Этапы Цикл
		СтруктураПоиска = Новый Структура("Распоряжение, Отменено", ДанныеЭтапа.Распоряжение, Ложь);
		Если ДанныеЭтапа.ЭтоВыпускающийЭтап Тогда
			НайденныеСтроки = ВыходныеИзделия.НайтиСтроки(СтруктураПоиска);
		Иначе
			НайденныеСтроки = ПобочныеИзделия.НайтиСтроки(СтруктураПоиска);
		КонецЕсли;
		Если НайденныеСтроки.Количество() = 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для этапа %1 необходимо указать выходное изделие.'"), ДанныеЭтапа.Распоряжение);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
		КонецЕсли;
	КонецЦикла;
	
	ПроверитьДолиСтоимостиВыходныхИзделий(Отказ);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Обработки.РедактированиеЭтаповПроизводства);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий.ОбеспечениеМатериаламиИРаботами, Отказ, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполненияРеквизитов

Процедура ПроверитьДолиСтоимостиВыходныхИзделий(Отказ)
	
	ПараметрыРаспределенияЗатрат = Документы.ЭтапПроизводства2_2.ПараметрыРаспределенияЗатрат(
		Документы.ЭтапПроизводства2_2.ПустаяСсылка());
	
	ПоляСвязи        = ПараметрыРаспределенияЗатрат.ПоляСвязи;
	ПолеГруппыЗатрат = "ПартияПроизводства";
	
	ТекстЗапроса = Документы.ЭтапПроизводства2_2.ТекстЗапросаПроверитьДолиСтоимости(
		ЭтотОбъект,	ПоляСвязи, ПолеГруппыЗатрат);
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ТаблицаИсточник", 
		ВыходныеИзделия.Выгрузить(, "НомерСтроки, Номенклатура, Характеристика, Распоряжение, ДоляСтоимости, Отменено"));
		
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	
	Результат = МассивРезультатов[МассивРезультатов.ВГраница()];
	Если Не Результат.Пустой() Тогда
		
		ТекстСообщения = НСтр("ru = 'Реквизит ""Способ распределения затрат на выходные изделия""
									|должен иметь одинаковое значение для всех выпускающих этапов партии:
									|%1'");
		
		ТекстСообщенияПартии = "";
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстСообщенияПартии = ТекстСообщенияПартии + "
								   |	%1";
			ТекстСообщенияПартии = СтрШаблон(ТекстСообщенияПартии, Выборка.ПартияПроизводства);
		КонецЦикла;	
		
		ТекстСообщения = СтрШаблон(ТекстСообщения, ТекстСообщенияПартии);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЕсли;
	
	
	Результат = МассивРезультатов[МассивРезультатов.ВГраница() - 1];
	Если Не Результат.Пустой() Тогда
		
		Шаблон = НСтр("ru = 'При выпуске нескольких наименований выходных изделий требуется указать их долю стоимости (строка %1%2).'");
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НомерСтроки    = Формат(Выборка.НомерСтроки, "ЧГ=");
			ТекстСообщения = СтрШаблон(Шаблон, НомерСтроки, ?(Выборка.Ссылка = Неопределено, "", ", " + Выборка.Ссылка));
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВыходныеИзделия", Выборка.НомерСтроки, "ДоляСтоимости");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				Выборка.Ссылка, 
				Поле, 
				?(Выборка.Ссылка = Неопределено, "РедактированиеЭтапов", ""),
				Отказ);
				
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроверкиЗаполнения() Экспорт
	
	ДанныеДляПроверки = УправлениеПроизводством.ДанныеЭтаповДляПроверкиЗаполнения();
	
	СписокЭтапов = Этапы.ВыгрузитьКолонку("Распоряжение");
	
	// Шапка
	РеквизитыЭтапов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СписокЭтапов, "ЗаказПереработчику,ХозяйственнаяОперация");
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ПроизводствоОднойДатой", ПроизводствоОднойДатой);
	Если ПроизводствоОднойДатой Тогда
		ЗначенияЗаполнения.Вставить("ДатаПроизводства", ДатаПроизводства);
	КонецЕсли;
	ЗначенияЗаполнения.Вставить("НеОтгружатьЧастями", НеОтгружатьЧастями);
	Если НеОтгружатьЧастями Тогда
		ЗначенияЗаполнения.Вставить("ДатаОтгрузки", ДатаОтгрузки);
	КонецЕсли;
	Для каждого Строка Из Этапы Цикл
		НоваяСтрока = ДанныеДляПроверки.Реквизиты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка,, "Распоряжение");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЗначенияЗаполнения);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РеквизитыЭтапов[Строка.Распоряжение]);
		НоваяСтрока.Ссылка = Строка.Распоряжение;
	КонецЦикла;

	// ТЧ
	СписокТЧ = Новый Массив;
	СписокТЧ.Добавить("ВыходныеИзделия");
	СписокТЧ.Добавить("ПобочныеИзделия");
	СписокТЧ.Добавить("ОбеспечениеМатериаламиИРаботами");
	Для каждого ИмяТЧ Из СписокТЧ Цикл
		ДанныеДляПроверки["ПроверятьТЧ" + ИмяТЧ] = Истина;
		Для каждого Строка Из ЭтотОбъект[ИмяТЧ] Цикл
			НоваяСтрока = ДанныеДляПроверки[ИмяТЧ].Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.Ссылка = Строка.Распоряжение
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

Функция ПутьКДаннымРеквизитаФормыРедактирования() Экспорт
	
	Возврат "РедактированиеЭтапов";
	
КонецФункции

#КонецОбласти

#КонецЕсли

//-- НЕ УТКА
