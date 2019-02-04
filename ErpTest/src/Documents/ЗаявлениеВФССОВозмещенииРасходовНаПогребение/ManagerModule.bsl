#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать заявления о выплате пособия.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ЗаявлениеВФССПогребение";
	КомандаПечати.Представление = НСтр("ru = 'Заявление о возмещении расходов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриПечати.
Процедура Печать(МассивСсылок, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявлениеВФССПогребение") Тогда
		ТабличныйДокумент = ТабличныйДокументЗаявлениеВФССПогребение(МассивСсылок, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЗаявлениеВФССПогребение",
			НСтр("ru = 'Заявление о возмещении расходов'"),
			ТабличныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Оплаты.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ЗаявлениеВФССОВозмещенииРасходовНаПогребение;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеРеквизиты = ПрямыеВыплатыПособийСоциальногоСтрахования.ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииРасходовНаПогребение();
	ФиксируемыеТЧ = Новый Структура("Оплаты", СтрРазделить("ДокументОснование", ",", Ложь));
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксацииВторичныхДанных(ФиксируемыеРеквизиты, , ФиксируемыеТЧ);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТабличныйДокументЗаявлениеВФССПогребение(МассивСсылок, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ЗаявлениеВФССПогребение";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ПолеСверху  = 0;
	ТабличныйДокумент.ПолеСлева   = 0;
	ТабличныйДокумент.ПолеСнизу   = 0;
	ТабличныйДокумент.ПолеСправа  = 0;
	
	ДатаФорм2017 = ПрямыеВыплатыПособийСоциальногоСтрахования.ДатаВступленияВСилуФорм2017Года();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("ДатаФорм2017", ДатаФорм2017);
	
	СоздатьВТКадровыхДанных(Запрос);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка КАК Ссылка,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Номер,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата КАК Дата,
	|	ВЫБОР
	|		КОГДА ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата < &ДатаФорм2017
	|			ТОГДА ""ЗаявлениеВФССПогребение_2012""
	|		ИНАЧЕ ""ЗаявлениеВФССПогребение_2017""
	|	КОНЕЦ КАК ИмяМакета,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Проведен,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Организация,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НаименованиеТерриториальногоОрганаФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.РегистрационныйНомерФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ДополнительныйКодФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.КодПодчиненностиФСС,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Руководитель,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ДолжностьРуководителя,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.АдресОрганизации,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НаименованиеБанка,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НомерЛицевогоСчета,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.КБК,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.НомерСчета,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.БИКБанка,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.СтатусДокумента,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ТелефонСоставителя,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.АдресЭлектроннойПочтыОрганизации,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ЗаявлениеСоставил,
	|	ТЧОплаты.ФизическоеЛицо,
	|	ТЧОплаты.Статус,
	|	ТЧОплаты.ДокументОснование,
	|	ТЧОплаты.КоличествоСтраниц КАК КоличествоСтраниц,
	|	ТЧОплаты.РазмерПособия,
	|	ТЧОплаты.ФамилияУмершего,
	|	ТЧОплаты.ИмяУмершего,
	|	ТЧОплаты.ОтчествоУмершего,
	|	КадровыеДанныеРуководителей.ФИОПолные КАК ФИОРуководителя,
	|	ВТКадровыеДанныеФизическихЛиц.Фамилия КАК Фамилия,
	|	ВТКадровыеДанныеФизическихЛиц.Имя КАК Имя,
	|	ВТКадровыеДанныеФизическихЛиц.Отчество КАК Отчество,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|			ТОГДА Организации.НаименованиеСокращенное
	|		ИНАЧЕ ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000))
	|	КОНЕЦ КАК ОрганизацияНаименование,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ИНН,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.КПП
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение КАК ЗаявлениеВФССОВозмещенииРасходовНаПогребение
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеРуководителей
	|		ПО ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Руководитель = КадровыеДанныеРуководителей.ФизическоеЛицо
	|			И ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата = КадровыеДанныеРуководителей.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Оплаты КАК ТЧОплаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизическихЛиц
	|			ПО ТЧОплаты.ФизическоеЛицо = ВТКадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|				И ТЧОплаты.Ссылка.Дата = ВТКадровыеДанныеФизическихЛиц.Период
	|		ПО ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка = ТЧОплаты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Организация = Организации.Ссылка
	|ГДЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ИмяМакета") Цикл
		Макет = Неопределено;
		ВыведеноСтрок = 0;
		ИтогоПособия = 0;
		ВсегоСтраниц = 0;
		Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
			КоличествоСтрокВМакете = 5;
		Иначе
			КоличествоСтрокВМакете = 7;
		КонецЕсли;
		
		Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
			Пока Выборка.Следующий() Цикл
				ВыведеноСтрок = (ВыведеноСтрок + 1) % КоличествоСтрокВМакете;
				НомерСтроки = ?(ВыведеноСтрок = 0, КоличествоСтрокВМакете, ВыведеноСтрок);
				
				Если ВыведеноСтрок = 1 Тогда
					Если Макет <> Неопределено Тогда
						Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
							ВывестиИтогиЗаявленияОВозмещении_2012(Макет, ИтогоПособия, ВсегоСтраниц);
						Иначе
							ВывестиИтогиЗаявленияОВозмещении_2017(Макет, ИтогоПособия, ВсегоСтраниц);
						КонецЕсли;
						Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
							ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						КонецЕсли;
						ТабличныйДокумент.Вывести(Макет);
					КонецЕсли;
					ИтогоПособия = 0;
					ВсегоСтраниц = 0;
					
					Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение." + Выборка.ИмяМакета);
					Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
						ПрямыеВыплатыПособийСоциальногоСтрахования.ВывестиШапкуИПодвалЗаявленияОВозмещении_2012(Макет, Выборка);
					Иначе
						ПрямыеВыплатыПособийСоциальногоСтрахования.ВывестиШапкуИПодвалЗаявленияОВозмещении_2017(Макет, Выборка);
					КонецЕсли;
				КонецЕсли;
				
				Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
					ВывестиСтрокуЗаявленияОВозмещении_2012(Макет, Выборка, НомерСтроки);
				Иначе
					ВывестиСтрокуЗаявленияОВозмещении_2017(Макет, Выборка, НомерСтроки);
				КонецЕсли;
				
				ИтогоПособия = ИтогоПособия + Выборка.РазмерПособия;
				ВсегоСтраниц = ВсегоСтраниц + Выборка.КоличествоСтраниц;
				
			КонецЦикла;
		КонецЦикла;
		
		Если Выборка.ИмяМакета = "ЗаявлениеВФССПогребение_2012" Тогда
			ВывестиИтогиЗаявленияОВозмещении_2012(Макет, ИтогоПособия, ВсегоСтраниц);
		Иначе
			ВывестиИтогиЗаявленияОВозмещении_2017(Макет, ИтогоПособия, ВсегоСтраниц);
		КонецЕсли;
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ТабличныйДокумент.Вывести(Макет);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

Процедура ВывестиСтрокуЗаявленияОВозмещении_2012(Макет, Выборка, НомерСтроки)
	
	ПрефиксСтроки = "ФИО_" + Формат(НомерСтроки,"ЧЦ=2; ЧВН=") + "_";
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.Фамилия),  Макет, ПрефиксСтроки, 24);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.Имя),      Макет, ПрефиксСтроки, 24, 25);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(ВРег(Выборка.Отчество), Макет, ПрефиксСтроки, 24, 49);
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(Выборка.РазмерПособия, Макет, "РазмерПособия" + НомерСтроки + "_", 8);
	Макет.Области["Статус" + НомерСтроки].Текст = Выборка.Статус;
	
КонецПроцедуры

Процедура ВывестиСтрокуЗаявленияОВозмещении_2017(Макет, Выборка, НомерСтроки)
	
	Макет.Параметры["Фамилия"  + НомерСтроки] = Выборка.Фамилия;
	Макет.Параметры["Имя"      + НомерСтроки] = Выборка.Имя;
	Макет.Параметры["Отчество" + НомерСтроки] = Выборка.Отчество;
	Макет.Параметры["ФамилияУмершего"  + НомерСтроки] = Выборка.ФамилияУмершего;
	Макет.Параметры["ИмяУмершего"      + НомерСтроки] = Выборка.ИмяУмершего;
	Макет.Параметры["ОтчествоУмершего" + НомерСтроки] = Выборка.ОтчествоУмершего;
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(Выборка.РазмерПособия, Макет, "РазмерПособия" + НомерСтроки + "_", 8);
	Макет.Области["Статус" + НомерСтроки].Текст = Выборка.Статус;
	
КонецПроцедуры

Процедура ВывестиИтогиЗаявленияОВозмещении_2012(Макет, ИтогоПособия, ВсегоСтраниц)
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия_", 9);
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия2_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Строка(ВсегоСтраниц), Макет, "КоличествоСтраниц_", 2);
	
КонецПроцедуры

Процедура ВывестиИтогиЗаявленияОВозмещении_2017(Макет, ИтогоПособия, ВсегоСтраниц)
	
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия_", 9);
	ЗарплатаКадры.ВывестиСуммуВРубляхКопейкахВЯчейки(ИтогоПособия, Макет, "ИтогоРазмерПособия2_", 9);
	ЗарплатаКадры.ВывестиДанныеПоБуквенно(Строка(ВсегоСтраниц), Макет, "КоличествоСтраниц_", 2);
	
КонецПроцедуры

Процедура СоздатьВТКадровыхДанных(Запрос)
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Оплаты.ФизическоеЛицо,
	|	Оплаты.Ссылка.Дата КАК Период
	|ПОМЕСТИТЬ ВТФизическиеЛицаОбщийСписок
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Оплаты КАК Оплаты
	|ГДЕ
	|	Оплаты.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Руководитель,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение КАК ЗаявлениеВФССОВозмещенииРасходовНаПогребение
	|ГДЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.ЗаявлениеСоставил,
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Дата
	|ИЗ
	|	Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение КАК ЗаявлениеВФССОВозмещенииРасходовНаПогребение
	|ГДЕ
	|	ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТФизическиеЛицаОбщийСписок.ФизическоеЛицо,
	|	ВТФизическиеЛицаОбщийСписок.Период
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	ВТФизическиеЛицаОбщийСписок КАК ВТФизическиеЛицаОбщийСписок";
	
	Запрос.Выполнить();
	
	Описатель = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТФизическиеЛица");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(Описатель, Истина, "ФИОПолные,ФамилияИО,Фамилия,Имя,Отчество");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
