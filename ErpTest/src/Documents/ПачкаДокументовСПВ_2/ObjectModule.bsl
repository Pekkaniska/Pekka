#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗапросДляПроверкиЗаполнения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТаблицаЗаписиОСтаже", ЗаписиОСтаже);
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудники.НомерСтроки,
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.Фамилия,
	|	ТаблицаСотрудники.Имя,
	|	ТаблицаСотрудники.Отчество,
	|	ТаблицаСотрудники.СтраховойНомерПФР,
	|	ТаблицаСотрудники.НачисленоНаОПС,
	|	ТаблицаСотрудники.НачисленоПоДополнительнымТарифам,
	|	ТаблицаСотрудники.ДатаСоставления
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК ТаблицаСотрудники
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСотрудники.Сотрудник,
	|	МИНИМУМ(ВТСотрудники.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудникиНомераСтрок
	|ИЗ
	|	ВТСотрудники КАК ВТСотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСотрудники.Сотрудник";
	
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, ОтчетныйПериод, ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК КонфликтующаяСтрока,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	МИНИМУМ(ДублиСтрокСтраховыеНомера.НомерСтроки) КАК КонфликтующаяСтрокаСтраховойНомер,
	|	СотрудникиДокумента.НачисленоНаОПС,
	|	СотрудникиДокумента.НачисленоПоДополнительнымТарифам,
	|	СотрудникиДокумента.ДатаСоставления
	|ПОМЕСТИТЬ ВТСотрудникиДокумента
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|			И СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрокСтраховыеНомера
	|		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрокСтраховыеНомера.НомерСтроки
	|			И СотрудникиДокумента.СтраховойНомерПФР = ДублиСтрокСтраховыеНомера.СтраховойНомерПФР
	|			И СотрудникиДокумента.Сотрудник <> ДублиСтрокСтраховыеНомера.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.Сотрудник.Наименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	СотрудникиДокумента.НачисленоНаОПС,
	|	СотрудникиДокумента.НачисленоПоДополнительнымТарифам,
	|	СотрудникиДокумента.ДатаСоставления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗаписиОСтаже.Сотрудник,
	|	ТаблицаЗаписиОСтаже.НомерСтроки,
	|	ТаблицаЗаписиОСтаже.НомерОсновнойЗаписи,
	|	ТаблицаЗаписиОСтаже.НомерДополнительнойЗаписи,
	|	ТаблицаЗаписиОСтаже.ДатаНачалаПериода,
	|	ТаблицаЗаписиОСтаже.ДатаОкончанияПериода,
	|	ТаблицаЗаписиОСтаже.ТерриториальныеУсловия,
	|	ТаблицаЗаписиОСтаже.ПараметрТерриториальныхУсловий,
	|	ТаблицаЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ТаблицаЗаписиОСтаже.КодПозицииСписка,
	|	ТаблицаЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа,
	|	ТаблицаЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ТаблицаЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ТаблицаЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ТаблицаЗаписиОСтаже.ТретийПараметрВыслугиЛет
	|ПОМЕСТИТЬ ВТТаблицаСтажа
	|ИЗ
	|	&ТаблицаЗаписиОСтаже КАК ТаблицаЗаписиОСтаже
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаписиОСтаже.Сотрудник,
	|	ЗаписиОСтаже.НомерСтроки,
	|	ЗаписиОСтаже.НомерОсновнойЗаписи,
	|	ЗаписиОСтаже.НомерДополнительнойЗаписи,
	|	ЗаписиОСтаже.ДатаНачалаПериода,
	|	ЗаписиОСтаже.ДатаОкончанияПериода,
	|	ЗаписиОСтаже.ТерриториальныеУсловия,
	|	ЗаписиОСтаже.ПараметрТерриториальныхУсловий,
	|	ЗаписиОСтаже.ОсобыеУсловияТруда,
	|	ЗаписиОСтаже.КодПозицииСписка,
	|	ЗаписиОСтаже.ОснованиеИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ПервыйПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ВторойПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ТретийПараметрИсчисляемогоСтажа,
	|	ЗаписиОСтаже.ОснованиеВыслугиЛет,
	|	ЗаписиОСтаже.ПервыйПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ВторойПараметрВыслугиЛет,
	|	ЗаписиОСтаже.ТретийПараметрВыслугиЛет,
	|	СотрудникиНомераСтрок.НомерСтроки КАК НомерСтрокиСотрудник
	|ПОМЕСТИТЬ ВТЗаписиОСтаже
	|ИЗ
	|	ВТТаблицаСтажа КАК ЗаписиОСтаже
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиНомераСтрок КАК СотрудникиНомераСтрок
	|		ПО ЗаписиОСтаже.Сотрудник = СотрудникиНомераСтрок.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСтажа.Сотрудник,
	|	МАКСИМУМ(ТаблицаСтажа.ДатаОкончанияПериода) КАК ДатаОкончанияПериода
	|ПОМЕСТИТЬ ВТДатыОкончанияСтажевыхПериодов
	|ИЗ
	|	ВТТаблицаСтажа КАК ТаблицаСтажа
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСтажа.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.СотрудникНаименование,
	|	СотрудникиДокумента.СтраховойНомерПФР,
	|	СотрудникиДокумента.СотрудникРаботаетВОрганизации,
	|	СотрудникиДокумента.КонфликтующаяСтрока,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.НачисленоНаОПС,
	|	СотрудникиДокумента.НачисленоПоДополнительнымТарифам,
	|	СотрудникиДокумента.ДатаСоставления,
	|	СотрудникиДокумента.КонфликтующаяСтрокаСтраховойНомер,
	|	"""" КАК АдресДляИнформирования,
	|	ЕСТЬNULL(ДатыОкончанияСтажевыхПериодов.ДатаОкончанияПериода, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОкончанияПериодаСтажа
	|ИЗ
	|	ВТСотрудникиДокумента КАК СотрудникиДокумента
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТДатыОкончанияСтажевыхПериодов КАК ДатыОкончанияСтажевыхПериодов
	|		ПО СотрудникиДокумента.Сотрудник = ДатыОкончанияСтажевыхПериодов.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтрокиСотрудник";
	
	Возврат Запрос;
	
КонецФункции

// Процедура выполняет полную проверку документа на
// соответствие формату 2-НДФЛ.
//
// Параметры:
//	Отказ - булево, в этот параметр помещается признак наличия ошибок в документе.
//
Процедура ВыполнитьПолнуюПроверкуДокумента(Отказ = Ложь, ЕстьОшибки = Ложь) Экспорт
	ВыполнятьОсновныеПроверки = Истина;
	ВыполнятьДополнительныеПроверки = Ложь;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ВыполнятьОсновныеПроверки = Ложь;
	ВыполнятьДополнительныеПроверки = Истина;
	
	Если Не ПроверитьЗаполнение() Тогда 
		ЕстьОшибки = Истина;
	КонецЕсли;	
	
	ВыполнятьОсновныеПроверки = Истина;
	ВыполнятьДополнительныеПроверки = Ложь;
КонецПроцедуры	

Процедура ПроверитьДанныеДокумента(Отказ = Ложь, НеПроверяемыеРеквизиты = Неопределено) Экспорт 
	Ошибки = Новый Массив;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	

	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);	
	
	ЗапросПоСтрокамДокумента = Неопределено;
	
	ПравилаПроверкиДанныхЗЛ = ПерсонифицированныйУчет.ДокументыСЗВПравилаПроверкиДанныхЗЛ(Ложь);
	
	ЗапросПоСтрокамДокумента = СформироватьЗапросДляПроверкиЗаполнения();
	
	ВыборкаПоСтрокамДокумента = ЗапросПоСтрокамДокумента.Выполнить().Выбрать();

	Пока ВыборкаПоСтрокамДокумента.СледующийПоЗначениюПоля("НомерСтрокиСотрудник") Цикл
		
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда 
			
			Если ВыборкаПоСтрокамДокумента.КонфликтующаяСтрока <> Null Тогда  
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %1 была введена в документе ранее.'"), ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				
				ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияСпискаСотрудников(
					Ошибки, 
					Ссылка, 
					ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник,
					ТекстОшибки,
					"Сотрудник",
					Отказ);
																							
			ИначеЕсли ВыборкаПоСтрокамДокумента.КонфликтующаяСтрокаСтраховойНомер <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: информация о сотруднике с таким же страховым номером была введена в документе ранее.'"), ВыборкаПоСтрокамДокумента.СотрудникНаименование);
				
				ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияСпискаСотрудников(
					Ошибки, 
					Ссылка, 
					ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник,
					ТекстОшибки,
					"СтраховойНомерПФР",
					Отказ);
			КонецЕсли;	
			
			ДанныеЗастрахованногоЛица = ПерсонифицированныйУчет.ДокументыСЗВДанныеЗастрахованногоЛица(ВыборкаПоСтрокамДокумента);
			
			ПерсонифицированныйУчет.ПроверитьДанныеЗастрахованногоЛица(
				ДанныеЗастрахованногоЛица, 
				ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник, 
				ПравилаПроверкиДанныхЗЛ, 
				Ошибки, 
				Ссылка,
				Отказ);
				
				Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаОкончанияПериодаСтажа) Тогда 
					
					Если ВыборкаПоСтрокамДокумента.ДатаСоставления < ВыборкаПоСтрокамДокумента.ДатаОкончанияПериодаСтажа Тогда
					
						ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: дата окончания последнего периода стажа должна быть меньше, чем дата составления.'"), ВыборкаПоСтрокамДокумента.СотрудникНаименование);
						
						ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияСпискаСотрудников(
							Ошибки, 
							Ссылка, 
							ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник,
							ТекстОшибки,
							"ДатаСоставления",
							Отказ);
					КонецЕсли;
				ИначеЕсли ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: не заполнены данные о стаже.'"), ВыборкаПоСтрокамДокумента.СотрудникНаименование);
						
					ПерсонифицированныйУчетКлиентСервер.ДобавитьОшибкуЗаполненияСпискаСотрудников(
						Ошибки, 
						Ссылка, 
						ВыборкаПоСтрокамДокумента.НомерСтрокиСотрудник,
						ТекстОшибки,
						"ДатаСоставления",
						Отказ);
				КонецЕсли;	
		КонецЕсли;
		
	КонецЦикла;	
	
	Если ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда  		
		ПериодСтажа = ?(ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод);
		
		ПерсонифицированныйУчет.ПроверитьЗаписиОСтаже(ЗапросПоСтрокамДокумента.МенеджерВременныхТаблиц, Ссылка, ПериодСтажа, Отказ, Истина, Истина);		
	КонецЕсли;		
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
КонецФункции

#КонецОбласти

#КонецЕсли
