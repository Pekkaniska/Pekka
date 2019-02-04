#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область СозданиеНаОсновании

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.пкПогрузкаВыгрузкаПоДоставке.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);
	
КонецПроцедуры

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
// Возвращаемое значение:
//	 КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.уатПутевойЛист) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.уатПутевойЛист.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.уатПутевойЛист);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

#КонецОбласти 
#КонецОбласти 

// Определяет реквизиты выбранного документа
//
// Параметры:
//	ДокументСсылка - Ссылка на документа
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	СтруктураРеквизитов = Новый Структура();
	
	Возврат СтруктураРеквизитов;

КонецФункции

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			СтандартнаяОбработка = Ложь;
			//ВыбраннаяФорма = "ФормаДокументаСамообслуживание";
		КонецЕсли;
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
			СтандартнаяОбработка = Ложь;
			//ВыбраннаяФорма = "ФормаСпискаСамообслуживание";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаСостояниеТехники(Запрос, ТекстыЗапроса, Регистры);
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	пкПогрузкаВыгрузкаПоДоставке.Ссылка,
	|	пкПогрузкаВыгрузкаПоДоставке.Номер,
	|	пкПогрузкаВыгрузкаПоДоставке.Дата,
	|	пкПогрузкаВыгрузкаПоДоставке.Операция,
	|	пкПогрузкаВыгрузкаПоДоставке.Доставка,
	|	пкПогрузкаВыгрузкаПоДоставке.ЗаданиеНаПеревозку,
	|	пкПогрузкаВыгрузкаПоДоставке.Подразделение,
	|	пкПогрузкаВыгрузкаПоДоставке.Автор,
	|	пкПогрузкаВыгрузкаПоДоставке.Ответственный,
	|	пкПогрузкаВыгрузкаПоДоставке.Комментарий
	|ИЗ
	|	Документ.пкПогрузкаВыгрузкаПоДоставке КАК пкПогрузкаВыгрузкаПоДоставке
	|ГДЕ
	|	пкПогрузкаВыгрузкаПоДоставке.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Дата",								Реквизиты.Дата);
	Запрос.УстановитьПараметр("Подразделение",						Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("Автор",								Реквизиты.Автор);
	Запрос.УстановитьПараметр("Ответственный",						Реквизиты.Ответственный);
	Запрос.УстановитьПараметр("Операция",							Реквизиты.Операция);
	Запрос.УстановитьПараметр("Доставка",							Реквизиты.Доставка);
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку",					Реквизиты.ЗаданиеНаПеревозку);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаСостояниеТехники(Запрос, ТекстыЗапроса, Регистры)
    
    ИмяРегистра = "пкСостояниеТехники";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
    
    "ВЫБРАТЬ
    |	пкДоставкаЗаданияНаПеревозку.Дата КАК Период,
    |	&Ссылка КАК Регистратор,
    |	ЗНАЧЕНИЕ(ПланВидовХарактеристик.пкПоказателиСостоянияТехники.Местонахождения) КАК Показатель,
    |	пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.Техника КАК Техника,
    |	ВЫБОР
    |		КОГДА пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту)
    |				ИЛИ пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ВидОперации = ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
    |			ТОГДА пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ЗаявкаНаАрендуТехники.ОбъектСтроительства
    |		ИНАЧЕ пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.СкладПолучатель
    |	КОНЕЦ КАК Значение
    |ИЗ
    |	Документ.пкПогрузкаВыгрузкаПоДоставке КАК пкДоставкаЗаданияНаПеревозку
    |ГДЕ
    |	пкДоставкаЗаданияНаПеревозку.Ссылка = &Ссылка
    |	И пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.Техника <> ЗНАЧЕНИЕ(Справочник.ТранспортныеСредства.ПустаяСсылка)
    |	И пкДоставкаЗаданияНаПеревозку.Операция = ЗНАЧЕНИЕ(Перечисление.пкОперацииПогрузкаВыгрузка.Выгрузка)
	|	И (пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ВидОперации <> ЗНАЧЕНИЕ(Перечисление.пкВидыОперацийЗаданийНаПеревозку.Перекат)
	|		ИЛИ пкДоставкаЗаданияНаПеревозку.ЗаданиеНаПеревозку.ЗаданиеНаПеревозку <> ЗНАЧЕНИЕ(Документ.пкЗаданиеНаПеревозку.ПустаяСсылка))";
    
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ОтразитьСостояниеТехники(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицапкСостояниеТехники;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояниеТехники = Движения.пкСостояниеТехники;
	ДвиженияСостояниеТехники.Записывать = Истина;
	ДвиженияСостояниеТехники.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти 

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КомплектДокументов") Тогда
		КоллекцияПечатныхФорм.Очистить();
		СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати);
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьКомплектПечатныхФорм(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати) Экспорт
	
	Перем АдресКомплектаПечатныхФорм;
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("АдресКомплектаПечатныхФорм", АдресКомплектаПечатныхФорм) Тогда
		
		КомплектПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКомплектаПечатныхФорм);
		
	Иначе
		
		КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
			Метаданные.Документы.пкПогрузкаВыгрузкаПоДоставке.ПолноеИмя(),
			МассивОбъектов, Неопределено);
		
	КонецЕсли;
		
	Если КомплектПечатныхФорм = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураТипов = Новый Соответствие;
	СтруктураТипов.Вставить("Документ.пкПогрузкаВыгрузкаПоДоставке", МассивОбъектов);
	
	РегистрыСведений.НастройкиПечатиОбъектов.СформироватьКомплектВнешнихПечатныхФорм(
		"Документ.пкПогрузкаВыгрузкаПоДоставке",
		МассивОбъектов,
		ПараметрыПечати,
		КоллекцияПечатныхФорм,
		ОбъектыПечати);
	
КонецФункции

Функция КомплектПечатныхФорм() Экспорт
	
	КомплектПечатныхФорм = РегистрыСведений.НастройкиПечатиОбъектов.ПодготовитьКомплектПечатныхФорм();
	
	Возврат КомплектПечатныхФорм;
	
КонецФункции

Процедура ЗаполнитьСтруктуруПолучателейПечатныхФорм(СтруктураДанныхОбъектаПечати) Экспорт
	
	
КонецПроцедуры

Функция ДоступныеДляШаблоновПечатныеФормы() Экспорт

	МассивДоступныхПечатныхФорм = Новый Массив;
	ШаблоныСообщенийСервер.ДобавитьВМассивПечатныеФормыСчета(МассивДоступныхПечатныхФорм);
	
	Возврат МассивДоступныхПечатныхФорм

КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяОбъекта()
	
	Возврат "Документ.пкПогрузкаВыгрузкаПоДоставке";
	
КонецФункции

#КонецОбласти

#КонецОбласти

Процедура СформироватьОперациюПоДоставке(тДоставка, тЗаданиеНаПеревозку, стрОперация, ТолькоДобавлять = Ложь, ДатаОперации = "", ПроверятьПеркат = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(тДоставка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(тЗаданиеНаПеревозку) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДатаОперации = "" Тогда
		ДатаОперации	= ТекущаяДата();
	КонецЕсли;
	
	Если (тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента 
		ИЛИ тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат)
		И (Не ЗначениеЗаполнено(тЗаданиеНаПеревозку.Техника)) Тогда
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Не указана техника для возврата от Клиента!'");
		тСообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	//Для перката синхронизируем погрузку и выгрузку второй его части, симафор - ТолькоДобавлять
	Если тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат И ПроверятьПеркат Тогда
		Если ЗначениеЗаполнено(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку) Тогда
			СформироватьОперациюПоДоставке(тДоставка, тЗаданиеНаПеревозку.ЗаданиеНаПеревозку, стрОперация, ТолькоДобавлять, ДатаОперации, Ложь);
		Иначе
			ЗапросЗадания = Новый Запрос;
			ЗапросЗадания.Текст = 
			"ВЫБРАТЬ
			|	пкЗаданиеНаПеревозку.Ссылка
			|ИЗ
			|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
			|ГДЕ
			|	пкЗаданиеНаПеревозку.Проведен
			|	И пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
			|	И НЕ пкЗаданиеНаПеревозку.ПометкаУдаления";
			ЗапросЗадания.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
			СписокЗаданий = ЗапросЗадания.Выполнить().Выгрузить();
			Для Каждого текЗадание Из СписокЗаданий Цикл
				СформироватьОперациюПоДоставке(тДоставка, текЗадание.Ссылка, стрОперация, ТолькоДобавлять, ДатаОперации, Ложь);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если стрОперация = "Погрузка" Тогда
		тОперация		= Перечисления.пкОперацииПогрузкаВыгрузка.Погрузка;
	ИначеЕсли стрОперация = "Выгрузка" Тогда
		//Если выгрузка, проверим есть-ли погрузка
		СформироватьОперациюПоДоставке(тДоставка, тЗаданиеНаПеревозку, "Погрузка", Истина, ДатаОперации - 1);
		
		тОперация		= Перечисления.пкОперацииПогрузкаВыгрузка.Выгрузка;
	Иначе
		Возврат;
	КонецЕсли;

	//Найдем уже соданный документ
	ЗапросОперация = Новый Запрос;
	ЗапросОперация.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	пкПогрузкаВыгрузкаПоДоставке.Ссылка
	|ИЗ
	|	Документ.пкПогрузкаВыгрузкаПоДоставке КАК пкПогрузкаВыгрузкаПоДоставке
	|ГДЕ
	|	пкПогрузкаВыгрузкаПоДоставке.Доставка = &Доставка
	|	И пкПогрузкаВыгрузкаПоДоставке.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
	|	И пкПогрузкаВыгрузкаПоДоставке.Операция = &Операция";
	ЗапросОперация.УстановитьПараметр("Доставка", тДоставка);
	ЗапросОперация.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
	ЗапросОперация.УстановитьПараметр("Операция", тОперация);
	
	РезЗапроса = ЗапросОперация.Выполнить().Выбрать();
	
	Если РезЗапроса.Следующий() Тогда
		
		тОбъект = РезЗапроса.Ссылка.ПолучитьОбъект();
		
		Если тОбъект.ПометкаУдаления Тогда
			Попытка
				тОбъект.УстановитьПометкуУдаления(Ложь);
			Исключение
				тСообщение = Новый СообщениеПользователю;
				тСообщение.Текст = ОписаниеОшибки();
				тСообщение.Сообщить();
				Возврат;
			КонецПопытки;
		ИначеЕсли ТолькоДобавлять И тОбъект.Проведен Тогда
			//Когда только добавляем, то не меняем уже отраженную операцию, кроме когда меняем дату
			Возврат;
		КонецЕсли;
		
		Если Год(тОбъект.Дата) <> Год(ДатаОперации) Тогда
			//Нужно перенумеровать
			тОбъект.Дата = ДатаОперации;
			тобъект.УстановитьНовыйНомер();
		КонецЕсли;
		
	Иначе
		тОбъект = Документы.пкПогрузкаВыгрузкаПоДоставке.СоздатьДокумент();
		тОбъект.Дата = ДатаОперации;
		тобъект.УстановитьНовыйНомер();
	КонецЕсли;
	
	тОбъект.Заполнить(Новый Структура("Операция,
									|Доставка,
									|ЗаданиеНаПеревозку", 
									тОперация,
									тДоставка,
									тЗаданиеНаПеревозку));
	
	тОбъект.Дата = ДатаОперации;
	
	Если тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ПеремещениеМеждуРегионами Тогда
		Если тОперация = Перечисления.пкОперацииПогрузкаВыгрузка.Выгрузка Тогда
			тОбъект.Подразделение = тЗаданиеНаПеревозку.РегионПолучатель;
		Иначе
			тОбъект.Подразделение = тЗаданиеНаПеревозку.Подразделение;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		тОбъект.Записать(РежимЗаписиДокумента.Запись, РежимПроведенияДокумента.Неоперативный);
	Исключение
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = ОписаниеОшибки();
		тСообщение.Сообщить();
		Возврат;
	КонецПопытки;
	
	Попытка
		тОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
	Исключение
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = ОписаниеОшибки();
		тСообщение.Сообщить();
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтменитьОперациюПоДоставке(тДоставка, тЗаданиеНаПеревозку, стрОперация, ТолькоДобавлять = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(тДоставка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(тЗаданиеНаПеревозку) Тогда
		Возврат;
	КонецЕсли;
	
	//Для перката синхронизируем отмену погрузки и выгрузки второй его части, симафор - ТолькоДобавлять
	Если тЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат И Не ТолькоДобавлять Тогда
		Если ЗначениеЗаполнено(тЗаданиеНаПеревозку.ЗаданиеНаПеревозку) Тогда
			ОтменитьОперациюПоДоставке(тДоставка, тЗаданиеНаПеревозку.ЗаданиеНаПеревозку, стрОперация, Истина);
		Иначе
			ЗапросЗадания = Новый Запрос;
			ЗапросЗадания.Текст = 
			"ВЫБРАТЬ
			|	пкЗаданиеНаПеревозку.Ссылка
			|ИЗ
			|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
			|ГДЕ
			|	пкЗаданиеНаПеревозку.Проведен
			|	И пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
			|	И НЕ пкЗаданиеНаПеревозку.ПометкаУдаления";
			ЗапросЗадания.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
			СписокЗаданий = ЗапросЗадания.Выполнить().Выгрузить();
			Для Каждого текЗадание Из СписокЗаданий Цикл
				ОтменитьОперациюПоДоставке(тДоставка, текЗадание.Ссылка, стрОперация, Истина);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если стрОперация = "Погрузка" Тогда
		тОперация		= Перечисления.пкОперацииПогрузкаВыгрузка.Погрузка;
	ИначеЕсли стрОперация = "Выгрузка" Тогда
		тОперация		= Перечисления.пкОперацииПогрузкаВыгрузка.Выгрузка;
	Иначе
		Возврат;
	КонецЕсли;
	
	ЗапросОперация = Новый Запрос;
	ЗапросОперация.Текст = 
	"ВЫБРАТЬ
	|	пкПогрузкаВыгрузкаПоДоставке.Ссылка
	|ИЗ
	|	Документ.пкПогрузкаВыгрузкаПоДоставке КАК пкПогрузкаВыгрузкаПоДоставке
	|ГДЕ
	|	пкПогрузкаВыгрузкаПоДоставке.Доставка = &Доставка
	|	И пкПогрузкаВыгрузкаПоДоставке.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
	|	И пкПогрузкаВыгрузкаПоДоставке.Операция = &Операция
	|	И НЕ пкПогрузкаВыгрузкаПоДоставке.ПометкаУдаления
	|	И пкПогрузкаВыгрузкаПоДоставке.Проведен";
	ЗапросОперация.УстановитьПараметр("Доставка", тДоставка);
	ЗапросОперация.УстановитьПараметр("ЗаданиеНаПеревозку", тЗаданиеНаПеревозку);
	ЗапросОперация.УстановитьПараметр("Операция", тОперация);
	
	РезЗапроса = ЗапросОперация.Выполнить().Выбрать();
	
	Пока РезЗапроса.Следующий() Цикл
		
		тОбъект = РезЗапроса.Ссылка.ПолучитьОбъект();
		
		Попытка
			тОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения, РежимПроведенияДокумента.Неоперативный);
		Исключение
			тСообщение = Новый СообщениеПользователю;
			тСообщение.Текст = ОписаниеОшибки();
			тСообщение.Сообщить();
			Возврат;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

//+++rarus-spb_pavelk
Процедура СоздатьДокументЗаказНаряд(Ссылка) Экспорт
    	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	ТекстыЗапроса = Новый СписокЗначений;
	Запрос.Текст = ТекстЗапросаТаблицаСостояниеТехники(Запрос, ТекстыЗапроса, Неопределено);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Доставка = Ссылка.Доставка;
            ЗаданиеНаПеревозку = Ссылка.ЗаданиеНаПеревозку;
			Если Выборка.Значение = Ссылка.ЗаданиеНаПеревозку.СкладПолучатель 
				И ЗначениеЗаполнено(Доставка)
//Рарус Владимир Подрезов 31.08.2017
				И ЗаданиеНаПеревозку.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента 
//Рарус Владимир Подрезов Конец
				И НЕ ЗаданиеНаПеревозку.НеСоздаватьЗаказНарядНаОсмотр Тогда 
				
				ЗапросЗН = Новый Запрос("ВЫБРАТЬ
				|	пкЗаказНаряд.Ссылка
				|ИЗ
				|	Документ.пкЗаказНаряд КАК пкЗаказНаряд
				|ГДЕ
				|	пкЗаказНаряд.Проведен
				|	И пкЗаказНаряд.Доставка = &Доставка
				|	И пкЗаказНаряд.Техника = &Техника");
				ЗапросЗН.УстановитьПараметр("Доставка", Доставка);
				ЗапросЗН.УстановитьПараметр("Техника", Выборка.Техника);
				РезультатЗН = ЗапросЗН.Выполнить();
				Если РезультатЗН.Пустой() Тогда 
					ЗаказНаряд = Документы.пкЗаказНаряд.СоздатьДокумент();
                    ЗаказНаряд.Организация   = Доставка.Организация; 
                    ЗаказНаряд.Подразделение = Доставка.Подразделение;                    
                    ЗаказНаряд.ЗаводскойНомерТехники = Выборка.Техника.ЗаводскойНомер;
					ЗаказНаряд.Заполнить(Ссылка);
					Попытка
						ЗаказНаряд.Записать(РежимЗаписиДокумента.Проведение);
					Исключение
						ВызватьИсключение;
					КонецПопытки;	
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	
//---rarus-spb_pavelk
#КонецЕсли

