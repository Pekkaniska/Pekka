
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Устанавливает транзакционные блокировки на записи регистра сведений БлокировкиПооперационногоРасписания2_2,
//	в разрезе заданного подразделения.
//
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение,
//		на записи которого необходимо установить блокироку.
//  Режим - РежимБлокировкиДанных - режим устанавливаемой блокировки.
//
Процедура ЗаблокироватьПодразделение(Подразделение, Режим) Экспорт
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БлокировкиПооперационногоРасписания2_2");
	ЭлементБлокировки.Режим = Режим;
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		ЭлементБлокировки.УстановитьЗначение("Подразделение", Подразделение);
	КонецЕсли;
	
	Блокировка.Заблокировать();
	
КонецПроцедуры

// Устанавливает транзакционные блокировки на записи регистра сведений БлокировкиПооперационногоРасписания2_2,
//	в разрезе заданной коллекции подразделений.
//
// Параметры:
//  Коллекция - РезультатЗапроса, ТабличнаяЧасть, ТаблицаЗначений - коллекция,
//		содержащая подразделения для блокировки. Должна содержать поле "Подразделение",
//		содержащее блокируемые значения.
//  ПолеКоллекции - Строка - имя поля коллекции, содержащее подразделения.
//  Режим - РежимБлокировкиДанных - режим устанавливаемой блокировки.
//
Процедура ЗаблокироватьКоллекциюПодразделений(Коллекция, ПолеКоллекции, Режим) Экспорт
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БлокировкиПооперационногоРасписания2_2");
	ЭлементБлокировки.Режим = Режим;
	
	Если ЗначениеЗаполнено(Коллекция) Тогда
		ЭлементБлокировки.ИсточникДанных = Коллекция;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Подразделение", ПолеКоллекции);
	КонецЕсли;
	
	Блокировка.Заблокировать();
	
КонецПроцедуры

// Записывает данные о блокировке расписания подразделения.
//	Тип устанавливаемой блокировки: Подразделение.
//
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, расписание которого необходимо заблокировать.
//
Процедура ЗаблокироватьИзмененСпособУправления(Подразделение) Экспорт
	
	ПричинаБлокировки = Перечисления.ПричиныБлокировокПооперационногоРасписания.ИзмененСпособУправления;
	
	Набор = РегистрыСведений.БлокировкиПооперационногоРасписания2_2.СоздатьНаборЗаписей();
	Набор.Отбор.Подразделение.Установить(Подразделение);
	Набор.Отбор.ПричинаБлокировки.Установить(ПричинаБлокировки);
	
	Запись = Набор.Добавить();
	Запись.Подразделение = Подразделение;
	Запись.ПричинаБлокировки = ПричинаБлокировки;
	Запись.Пользователь = Пользователи.ТекущийПользователь();
	
	Набор.Записать();
	
КонецПроцедуры

// Удаляет данные о блокировке расписания подразделения.
//
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, расписание которого необходимо разблокировать.
//
Процедура РазблокироватьИзмененСпособУправления(Подразделение) Экспорт
	
	Набор = РегистрыСведений.БлокировкиПооперационногоРасписания2_2.СоздатьНаборЗаписей();
	Набор.Отбор.Подразделение.Установить(Подразделение);
	Набор.Отбор.ПричинаБлокировки.Установить(Перечисления.ПричиныБлокировокПооперационногоРасписания.ИзмененСпособУправления);
	Набор.Записать();
	
КонецПроцедуры

// Записывает данные о блокируемых операциях расписания в регистр сведений БлокировкиПооперационногоРасписания2_2.
//	Тип устанавливаемой блокировки: Операция.
//
// Параметры:
//  НомерСеанса	- Число - номер сеанса пользователя, который устанавливает блокировку расписания.
//  НачалоСеанса - Дата - дата (и время) начала сеанса пользователя, который устанавливает блокировку расписания.
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, которому принадлежат блокируемые операции.
//  Пользователь - СправочникСсылка.Пользователи - пользователь, устанавливающий блокировку.
//  Операции - Массив - содержит структуры блокируемых операций.
//
Процедура ЗаблокироватьРасчетРасписания(НомерСеанса, НачалоСеанса, Подразделение, Пользователь, Операции) Экспорт
	
	ПричинаБлокировки = Перечисления.ПричиныБлокировокПооперационногоРасписания.РасчетРасписания;
	
	Набор = РегистрыСведений.БлокировкиПооперационногоРасписания2_2.СоздатьНаборЗаписей();
	Набор.Отбор.НомерСеанса.Установить(НомерСеанса);
	Набор.Отбор.НачалоСеанса.Установить(НачалоСеанса);
	Набор.Отбор.Подразделение.Установить(Подразделение);
	Набор.Отбор.ПричинаБлокировки.Установить(ПричинаБлокировки);
	
	Для каждого Операция Из Операции Цикл
		
		Запись = Набор.Добавить();
		Запись.НомерСеанса = НомерСеанса;
		Запись.НачалоСеанса = НачалоСеанса;
		Запись.Подразделение = Подразделение;
		Запись.Этап = Операция.Этап;
		Запись.Операция = Операция.Операция;
		Запись.ИдентификаторОперации = Операция.ИдентификаторОперации;
		Запись.ПричинаБлокировки = ПричинаБлокировки;
		Запись.Пользователь = Пользователь;
		
	КонецЦикла;
	
	Набор.Записать();
	
КонецПроцедуры

// Удаляет записи о блокировке операций, установленных заданным пользователем.
//
// Параметры:
//  НомерСеанса	- Число - номер сеанса пользователя, блокировку которого необходимо удалить.
//  НачалоСеанса - Дата - дата (и время) начала сеанса пользователя, блокировку которого необходимо удалить.
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, которому принадлежат разблокируемые операции операции.
//
Процедура РазблокироватьРасчетРасписания(НомерСеанса, НачалоСеанса, Подразделение=Неопределено) Экспорт
	
	Набор = РегистрыСведений.БлокировкиПооперационногоРасписания2_2.СоздатьНаборЗаписей();
	
	Набор.Отбор.НомерСеанса.Установить(НомерСеанса);
	Набор.Отбор.НачалоСеанса.Установить(НачалоСеанса);
	Набор.Отбор.ПричинаБлокировки.Установить(Перечисления.ПричиныБлокировокПооперационногоРасписания.РасчетРасписания);
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Набор.Отбор.Подразделение.Установить(Подразделение);
	КонецЕсли;
	
	Набор.Записать();
	
КонецПроцедуры

// Возвращает флаг наличия актуальных блокировок операций для заданного подразделения.
//
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, операции которого необходимо проверить.
//	ПричинаБлокировки - ПеречислениеСсылка.ПричиныБлокировокПооперационногоРасписания - тип блокировки,
//		наличие которой необходимо проверить.
//
// Возвращаемое значение:
//  Булево - флаг наличия блокировок.
//
Функция РасписаниеПодразделенияЗаблокировано(Подразделение, ПричинаБлокировки=Неопределено) Экспорт
	
	Возврат РасписаниеЗаблокировано(Подразделение,, ПричинаБлокировки);
	
КонецФункции

// Возвращает флаг наличия актуальных блокировок для заданного множества операций.
//
// Параметры:
//  Операции - Массив - массив идентифиаторов операций.
//
// Возвращаемое значение:
//  Булево - флаг наличия блокировок.
//
Функция ОперацииЗаблокированы(Операции) Экспорт
	
	ПричинаБлокировки = Перечисления.ПричиныБлокировокПооперационногоРасписания.РасчетРасписания;
	Возврат РасписаниеЗаблокировано(, Операции, ПричинаБлокировки);
	
КонецФункции

// Возвращает пользователя, установившего блокировку заданного подразделения.
//
// Параметры:
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, автора блокировки которого требуется получить.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - автор блокировки.
//
Функция РасписаниеПодразделенияАвторБлокировки(Подразделение) Экспорт
	
	Блокировки = УстановленныеБлокировки(Подразделение);
	Если ЗначениеЗаполнено(Блокировки) Тогда
		Возврат Блокировки[0].Пользователь;
	Иначе
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РасписаниеЗаблокировано(Подразделение = Неопределено, Операции = Неопределено, ПричинаБлокировки = Неопределено)
	
	Блокировки = УстановленныеБлокировки(Подразделение, Операции, ПричинаБлокировки);
	
	Если ЗначениеЗаполнено(Блокировки) Тогда
		
		Результат = Ложь;
		Для каждого Блокировка Из Блокировки Цикл
			
			Если Блокировка.ПричинаБлокировки = Перечисления.ПричиныБлокировокПооперационногоРасписания.ИзмененСпособУправления Тогда
				Результат = Истина;
			Иначе
				
				Актуальна = БлокировкаСеансаАктуальна(Блокировка.НомерСеанса, Блокировка.НачалоСеанса);
				Если Актуальна Тогда
					Результат = Истина;
				Иначе
					УдалитьБлокировкуСеанса(Блокировка.НомерСеанса, Блокировка.НачалоСеанса);
				КонецЕсли;
			КонецЕсли;
		
		КонецЦикла;
		
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция УстановленныеБлокировки(Подразделение = Неопределено, Операции = Неопределено, ПричинаБлокировки = Неопределено)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БлокировкиПооперационногоРасписания.НомерСеанса КАК НомерСеанса,
	|	БлокировкиПооперационногоРасписания.НачалоСеанса КАК НачалоСеанса,
	|	БлокировкиПооперационногоРасписания.ПричинаБлокировки КАК ПричинаБлокировки,
	|	БлокировкиПооперационногоРасписания.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.БлокировкиПооперационногоРасписания2_2 КАК БлокировкиПооперационногоРасписания
	|ГДЕ
	|	(НЕ &ОтборПодразделение
	|			ИЛИ БлокировкиПооперационногоРасписания.Подразделение = &Подразделение)
	|	И (НЕ &ОтборОперации
	|			ИЛИ БлокировкиПооперационногоРасписания.ИдентификаторОперации В (&Операции))
	|	И (НЕ &ОтборПричинаБлокировки
	|			ИЛИ БлокировкиПооперационногоРасписания.ПричинаБлокировки = &ПричинаБлокировки)");
	
	Запрос.УстановитьПараметр("ОтборПодразделение", ЗначениеЗаполнено(Подразделение));
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Запрос.УстановитьПараметр("ОтборОперации", ЗначениеЗаполнено(Операции));
	Запрос.УстановитьПараметр("Операции", ?(ЗначениеЗаполнено(Операции), Операции, Новый Массив));
	
	Запрос.УстановитьПараметр("ОтборПричинаБлокировки", ЗначениеЗаполнено(ПричинаБлокировки));
	Запрос.УстановитьПараметр("ПричинаБлокировки", ПричинаБлокировки);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция БлокировкаСеансаАктуальна(НомерСеанса, НачалоСеанса)
	
	Актуальна = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Сеанс Из Сеансы Цикл
		
		Если Сеанс.НомерСеанса = НомерСеанса 
			И Сеанс.НачалоСеанса = НачалоСеанса Тогда
			
			Актуальна = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Актуальна;
	
КонецФункции

Процедура УдалитьБлокировкуСеанса(НомерСеанса, НачалоСеанса)
	
	Набор = РегистрыСведений.БлокировкиПооперационногоРасписания2_2.СоздатьНаборЗаписей();
	Набор.Отбор.НомерСеанса.Установить(НомерСеанса);
	Набор.Отбор.НачалоСеанса.Установить(НачалоСеанса);
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли