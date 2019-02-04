
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчет2_4 = ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_4")
							И ТекущаяДатаСеанса() >= Константы.ДатаНачалаУчетаВнеоборотныхАктивов2_4.Получить();
							
	УстановитьТекстЗапросаСписок();
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", Неопределено);
	
	Если ИспользоватьУчет2_4 Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Состояние", Перечисления.СостоянияОС.ПустаяСсылка());
	КонецЕсли; 
	
	Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбраноОС;
	
	Если ИспользоватьУчет2_4 Тогда
		
		Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
			Элементы.СписокСостояниеУпр.Заголовок = НСтр("ru = 'Состояние'");
			Элементы.СписокСостояниеРегл.Видимость = Ложь;
		КонецЕсли; 
		
		Заголовок = НСтр("ru = 'Основные средства'");
	
		Если Константы.ВалютаРегламентированногоУчета.Получить() = Константы.ВалютаУправленческогоУчета.Получить() Тогда
			Элементы.СведенияТаблицаСумм2_4Валюта.Видимость = Ложь;
		КонецЕсли;
	
	Иначе
		Элементы.СписокСостояниеРегл.Заголовок = НСтр("ru = 'Состояние'");
		Элементы.СписокСостояниеУпр.Видимость = Ложь;
		Заголовок = НСтр("ru = 'ОС и объекты строительства'");
	КонецЕсли;
	
	ПоказатьСведения = Ложь;
	ЗаполнитьСвойстваЭлементовСведений();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СохраненноеЗначение = Настройки.Получить("ПоказатьСведения");
	ПоказатьСведения = ?(ЗначениеЗаполнено(СохраненноеЗначение), СохраненноеЗначение, Истина);
	ЗаполнитьСвойстваЭлементовСведений();
	
	ОтборСостояние = Настройки.Получить("ОтборСостояние");
	УстановитьОтборПоСостоянию(ЭтаФорма);
	
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", ЗначениеЗаполнено(ОтборОрганизация));
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", ОтборОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
	ОтборМОЛ = Настройки.Получить("ОтборМОЛ");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МОЛ",
		ОтборМОЛ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборМОЛ));
	
	ОтборАмортизационнаяГруппа = Настройки.Получить("ОтборАмортизационнаяГруппа");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"АмортизационнаяГруппа",
		ОтборАмортизационнаяГруппа,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборАмортизационнаяГруппа));
		
	ЗаполнитьСведения(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПринятиеКУчетуОС2_4"
		ИЛИ ИмяСобытия = "Запись_ПеремещениеОС2_4"
		ИЛИ ИмяСобытия = "Запись_СписаниеОС2_4"
		ИЛИ ИмяСобытия = "Запись_АмортизацияОС2_4"
		ИЛИ ИмяСобытия = "Запись_РасчетСтоимостиОС" Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УстановитьОтборПоСостоянию(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", ЗначениеЗаполнено(ОтборОрганизация));
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", ОтборОрганизация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборОрганизация));
	
	ЗаполнитьСведения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМОЛПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МОЛ",
		ОтборМОЛ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборМОЛ));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАмортизационнаяГруппаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"АмортизационнаяГруппа",
		ОтборАмортизационнаяГруппа,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборАмортизационнаяГруппа));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// Из-за серверного вызова активизация строки выполняется два раза.
	Если ПредыдущаяТекущаяСтрока <> Элементы.Список.ТекущаяСтрока Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
	ПредыдущаяТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияПринятКУчетуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "#Создать") <> 0 Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Основание", Элементы.Список.ТекущаяСтрока);
		ОткрытьФорму("Документ.ПринятиеКУчетуОС2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияМестонахождениеАдресОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(НавигационнаяСсылкаФорматированнойСтроки, "Яндекс.Карты");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сведения(Команда)
	
	ПоказатьСведения = Не ПоказатьСведения;
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Скрыть сведения'");
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Показать сведения'");
	КонецЕсли;
	
КонецПроцедуры

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТекстЗапросаСписок()

	Если ИспользоватьУчет2_4 Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникОбъектыЭксплуатации.Ссылка,
		|	СправочникОбъектыЭксплуатации.ПометкаУдаления,
		|	СправочникОбъектыЭксплуатации.Родитель,
		|	СправочникОбъектыЭксплуатации.ЭтоГруппа,
		|	СправочникОбъектыЭксплуатации.Код,
		|	СправочникОбъектыЭксплуатации.Наименование,
		|	СправочникОбъектыЭксплуатации.НаименованиеПолное,
		|	СправочникОбъектыЭксплуатации.Изготовитель,
		|	СправочникОбъектыЭксплуатации.ЗаводскойНомер,
		|	СправочникОбъектыЭксплуатации.НомерПаспорта,
		|	СправочникОбъектыЭксплуатации.ДатаВыпуска,
		|	СправочникОбъектыЭксплуатации.КодПоОКОФ КАК КодПоОКОФ,
		|	СправочникОбъектыЭксплуатации.ГруппаОС КАК ГруппаОС,
		|	СправочникОбъектыЭксплуатации.АмортизационнаяГруппа КАК АмортизационнаяГруппа,
		|	СправочникОбъектыЭксплуатации.ШифрПоЕНАОФ КАК ШифрПоЕНАОФ,
		|	СправочникОбъектыЭксплуатации.Комментарий,
		|	СправочникОбъектыЭксплуатации.Расположение,
		|	СправочникОбъектыЭксплуатации.Модель,
		|	СправочникОбъектыЭксплуатации.СерийныйНомер,
		|	МестонахождениеОС.АдресМестонахождения,
		|	ЕСТЬNULL(МестонахождениеОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСБУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету))
		|	КОНЕЦ КАК СостояниеРегл,
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) 
		|	КОНЕЦ КАК СостояниеУпр,
		|	СправочникОбъектыЭксплуатации.ИнвентарныйНомер,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ДатаПринятияКУчету,
		|	ЕСТЬNULL(МестонахождениеОС.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ,
		|	ЕСТЬNULL(МестонахождениеОС.Местонахождение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) КАК Подразделение
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК СправочникОбъектыЭксплуатации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОС
		|		ПО (МестонахождениеОС.ОсновноеСредство = СправочникОбъектыЭксплуатации.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОС.СрезПоследних КАК ПервоначальныеСведенияОС
		|		ПО СправочникОбъектыЭксплуатации.Ссылка = ПервоначальныеСведенияОС.ОсновноеСредство
		|			И ПервоначальныеСведенияОС.Организация = МестонахождениеОС.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСБУ.СрезПоследних(
		|				,
		|				НЕ &ОтборПоОрганизации
		|					ИЛИ Организация = &ОтборОрганизация) КАК ПорядокУчетаОСБУ
		|		ПО (ПервоначальныеСведенияОС.ОсновноеСредство = ПорядокУчетаОСБУ.ОсновноеСредство)
		|			И (ПервоначальныеСведенияОС.Организация = ПорядокУчетаОСБУ.Организация)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСУУ.СрезПоследних(
		|				,
		|				НЕ &ОтборПоОрганизации
		|					ИЛИ Организация = &ОтборОрганизация) КАК ПорядокУчетаОСУУ
		|		ПО (ПервоначальныеСведенияОС.ОсновноеСредство = ПорядокУчетаОСУУ.ОсновноеСредство)
		|			И (ПервоначальныеСведенияОС.Организация = ПорядокУчетаОСУУ.Организация)
		|ГДЕ
		|	(&Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		ИЛИ ЕСТЬNULL(ПорядокУчетаОСБУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) = &Состояние
		|		ИЛИ ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) = &Состояние)";
		
	Иначе
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникОбъектыЭксплуатации.Ссылка,
		|	СправочникОбъектыЭксплуатации.ПометкаУдаления,
		|	СправочникОбъектыЭксплуатации.Родитель,
		|	СправочникОбъектыЭксплуатации.ЭтоГруппа,
		|	СправочникОбъектыЭксплуатации.Код,
		|	СправочникОбъектыЭксплуатации.Наименование,
		|	СправочникОбъектыЭксплуатации.НаименованиеПолное,
		|	СправочникОбъектыЭксплуатации.Изготовитель,
		|	СправочникОбъектыЭксплуатации.ЗаводскойНомер,
		|	СправочникОбъектыЭксплуатации.НомерПаспорта,
		|	СправочникОбъектыЭксплуатации.ДатаВыпуска,
		|	СправочникОбъектыЭксплуатации.КодПоОКОФ КАК КодПоОКОФ,
		|	СправочникОбъектыЭксплуатации.ГруппаОС КАК ГруппаОС,
		|	СправочникОбъектыЭксплуатации.АмортизационнаяГруппа КАК АмортизационнаяГруппа,
		|	СправочникОбъектыЭксплуатации.ШифрПоЕНАОФ КАК ШифрПоЕНАОФ,
		|	СправочникОбъектыЭксплуатации.Комментарий,
		|	СправочникОбъектыЭксплуатации.Расположение,
		|	СправочникОбъектыЭксплуатации.Модель,
		|	СправочникОбъектыЭксплуатации.СерийныйНомер,
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.АдресМестонахождения,
		|	ЕСТЬNULL(СостоянияОСОрганизацийСрезПоследних.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
		|	ЕСТЬNULL(СостоянияОСОрганизацийСрезПоследних.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) КАК СостояниеРегл,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка) КАК СостояниеУпр,
		|	СправочникОбъектыЭксплуатации.ИнвентарныйНомер,
		|	ВЫБОР ЕСТЬNULL(СостоянияОСОрганизацийСрезПоследних.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету))
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету)
		|			ТОГДА СостоянияОСОрганизацийСрезПоследних.Период
		|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|	КОНЕЦ КАК ДатаПринятияКУчету,
		|	ЕСТЬNULL(МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ,
		|	ЕСТЬNULL(МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)) КАК Подразделение
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК СправочникОбъектыЭксплуатации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
		|		ПО СправочникОбъектыЭксплуатации.Ссылка = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОСОрганизаций.СрезПоследних(
		|				,
		|				НЕ &ОтборПоОрганизации
		|					ИЛИ Организация = &ОтборОрганизация) КАК СостоянияОСОрганизацийСрезПоследних
		|		ПО (ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство = СостоянияОСОрганизацийСрезПоследних.ОсновноеСредство)
		|			И (ВЫБОР
		|				КОГДА &ОтборПоОрганизации
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.Организация = СостоянияОСОрганизацийСрезПоследних.Организация
		|			КОНЕЦ)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
		|				,
		|				НЕ &ОтборПоОрганизации
		|					ИЛИ Организация = &ОтборОрганизация) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
		|		ПО (ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство)
		|			И (ВЫБОР
		|				КОГДА &ОтборПоОрганизации
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.Организация = МестонахождениеОСБухгалтерскийУчетСрезПоследних.Организация
		|			КОНЕЦ)"
					
	КонецЕсли;
	
	Список.ТекстЗапроса = ТекстЗапроса;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваЭлементовСведений()
	
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Скрыть сведения'");
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru='Показать сведения'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаБУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='БУ'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаНУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='НУ'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаПР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='ПР'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаВР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='ВР'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьСведения()

	ЗаполнитьСведения(ЭтаФорма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСведения(Форма)
	
	Если НЕ Форма.ПоказатьСведения Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ТекущиеДанные = Неопределено;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ДанныеСтроки(ТекущаяСтрока);
		Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоГруппа Тогда
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбраноОС;
		Возврат;
	КонецЕсли;
	
	Если Форма.ИспользоватьУчет2_4 Тогда
		
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведения2_4;
		
		Форма.СведенияТаблицаСумм2_4.Очистить();
		ПредставлениеСведений = Неопределено;
		
		ЕстьСуммы = Ложь;
		ТекущаяСтрока = Форма.Элементы.Список.ТекущаяСтрока;
		Сведения2_4 = ПолучитьСведения2_4(ТекущиеДанные.Ссылка);
	
		Для Каждого ЭлМассива Из Сведения2_4.Суммы Цикл
			ЗаполнитьЗначенияСвойств(Форма.СведенияТаблицаСумм2_4.Добавить(), ЭлМассива);
			ЕстьСуммы = ЭлМассива.ВосстановительнаяСтоимость <> 0 
							ИЛИ ЭлМассива.НакопленнаяАмортизация <> 0 
							ИЛИ ЭлМассива.ОстаточнаяСтоимость <> 0 
							ИЛИ ЕстьСуммы;
		КонецЦикла;
		
		ПредставлениеСведений = Сведения2_4.ПредставлениеСведений;
		Если ПредставлениеСведений <> Неопределено Тогда
			
			Элементы.ОбщаяКомандаДокументыПоОсновномуСредству.Видимость = ПредставлениеСведений.Период <> '000101010000';
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияПринятКУчету1, ПредставлениеСведений.СведенияПринятКУчету1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияПринятКУчету2, ПредставлениеСведений.СведенияПринятКУчету2);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеОрганизация, ПредставлениеСведений.СведенияМестонахождениеОрганизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеПодразделение, ПредставлениеСведений.СведенияМестонахождениеПодразделение);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеМОЛ, ПредставлениеСведений.СведенияМестонахождениеМОЛ);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеАдрес, ПредставлениеСведений.СведенияМестонахождениеАдрес);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияГруппаОС, Сведения2_4.СведенияГруппаОС);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияКодПоОКОФ, Сведения2_4.СведенияКодПоОКОФ);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияАмортизационнаяГруппа, Сведения2_4.СведенияАмортизационнаяГруппа);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования1, ПредставлениеСведений.СведенияСрокИспользования1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования2, ПредставлениеСведений.СведенияСрокИспользования2);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования3, ПредставлениеСведений.СведенияСрокИспользования3);
			
		Иначе
			
			Элементы.ОбщаяКомандаДокументыПоОсновномуСредству.Видимость = Ложь;
			Элементы.СведенияПринятКУчету1.Видимость = Ложь;
			Элементы.СведенияПринятКУчету2.Видимость = Ложь;
			Элементы.СведенияМестонахождениеОрганизация.Видимость = Ложь;
			Элементы.СведенияМестонахождениеПодразделение.Видимость = Ложь;
			Элементы.СведенияМестонахождениеМОЛ.Видимость = Ложь;
			Элементы.СведенияМестонахождениеАдрес.Видимость = Ложь;
			Элементы.СведенияГруппаОС.Видимость = Ложь;
			Элементы.СведенияКодПоОКОФ.Видимость = Ложь;
			Элементы.СведенияАмортизационнаяГруппа.Видимость = Ложь;
			Элементы.СведенияСрокИспользования1.Видимость = Ложь;
			Элементы.СведенияСрокИспользования2.Видимость = Ложь;
			Элементы.СведенияСрокИспользования3.Видимость = Ложь;
			
		КонецЕсли; 
		
	Иначе
		
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведения2_2;
		
		Форма.СведенияТаблицаСумм.Очистить();
		Если Элементы.Список.ВыделенныеСтроки.Количество() <> 0 Тогда
			Массив = ПолучитьСведения2_2(Элементы.Список.ТекущаяСтрока, Форма.ОтборОрганизация);
			Для Каждого ЭлМассива Из Массив Цикл
				ЗаполнитьЗначенияСвойств(Форма.СведенияТаблицаСумм.Добавить(), ЭлМассива);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведения2_2(Знач ВнеоборотныйАктив, Знач ОтборОрганизация)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("СтоимостьБУ", 0);
	ЗначенияПоУмолчанию.Вставить("СтоимостьНУ", 0);
	ЗначенияПоУмолчанию.Вставить("СтоимостьПР", 0);
	ЗначенияПоУмолчанию.Вставить("СтоимостьВР", 0);
	ЗначенияПоУмолчанию.Вставить("АмортизацияБУ", 0);
	ЗначенияПоУмолчанию.Вставить("АмортизацияНУ", 0);
	ЗначенияПоУмолчанию.Вставить("АмортизацияПР", 0);
	ЗначенияПоУмолчанию.Вставить("АмортизацияВР", 0);
	ЗначенияПоУмолчанию.Вставить("НачислениеИзноса", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидСубконтоОС", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства);
	Запрос.УстановитьПараметр("ОтборПоОрганизации", ЗначениеЗаполнено(ОтборОрганизация));
	Запрос.УстановитьПараметр("ОтборОрганизация", ОтборОрганизация);
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ВнеоборотныйАктив);
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ПервоначальныеСведения.ОсновноеСредство КАК ОбъектУчета,
	|	СчетаОтражения.СчетУчета КАК СчетУчета,
	|	СчетаОтражения.СчетНачисленияАмортизации КАК СчетАмортизации,
	|	ЕСТЬNULL(ПараметрыЦелевогоФинансирования.ПрименениеЦелевогоФинансирования, ЛОЖЬ) КАК ПрименениеЦелевогоФинансирования,
	|	ПараметрыЦелевогоФинансирования.СчетУчета КАК СчетУчетаЦФ,
	|	ПараметрыЦелевогоФинансирования.СчетАмортизации КАК СчетАмортизацииЦФ,
	|	ВЫБОР
	|		КОГДА ПервоначальныеСведения.ПорядокПогашенияСтоимости = ЗНАЧЕНИЕ(Перечисление.ПорядокПогашенияСтоимостиОС.НачислениеИзносаПоЕНАОФ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НачислениеИзноса
	|ПОМЕСТИТЬ втАктивыИСчетаУчета
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(, ОсновноеСредство = &ВнеоборотныйАктив) КАК ПервоначальныеСведения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|				,
	|				ОсновноеСредство = &ВнеоборотныйАктив
	|					И (НЕ &ОтборПООрганизации
	|						ИЛИ Организация = &ОтборОрганизация)) КАК СчетаОтражения
	|		ПО ПервоначальныеСведения.ОсновноеСредство = СчетаОтражения.ОсновноеСредство
	|			И (ВЫБОР
	|				КОГДА &ОтборПООрганизации
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ПервоначальныеСведения.Организация = СчетаОтражения.Организация
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЦелевогоФинансированияОС.СрезПоследних(, ОсновноеСредство = &ВнеоборотныйАктив) КАК ПараметрыЦелевогоФинансирования
	|		ПО ПервоначальныеСведения.ОсновноеСредство = ПараметрыЦелевогоФинансирования.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктивыИСчетаУчета.СчетУчета КАК Счет
	|ПОМЕСТИТЬ втСчетаОстатков
	|ИЗ
	|	втАктивыИСчетаУчета КАК АктивыИСчетаУчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктивыИСчетаУчета.СчетАмортизации
	|ИЗ
	|	втАктивыИСчетаУчета КАК АктивыИСчетаУчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктивыИСчетаУчета.СчетУчетаЦФ
	|ИЗ
	|	втАктивыИСчетаУчета КАК АктивыИСчетаУчета
	|ГДЕ
	|	АктивыИСчетаУчета.ПрименениеЦелевогоФинансирования
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АктивыИСчетаУчета.СчетАмортизацииЦФ
	|ИЗ
	|	втАктивыИСчетаУчета КАК АктивыИСчетаУчета
	|ГДЕ
	|	АктивыИСчетаУчета.ПрименениеЦелевогоФинансирования
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Субконто1 КАК ОбъектУчета,
	|	ХозрасчетныйОстатки.Счет КАК Счет,
	|	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаБУ,
	|	ХозрасчетныйОстатки.СуммаНУОстаток КАК СуммаНУ,
	|	ХозрасчетныйОстатки.СуммаПРОстаток КАК СуммаПР,
	|	ХозрасчетныйОстатки.СуммаВРОстаток КАК СуммаВР
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			,
	|			Счет В
	|				(ВЫБРАТЬ
	|					Т.Счет
	|				ИЗ
	|					втСчетаОстатков КАК Т),
	|			&ВидСубконтоОС,
	|			Субконто1 В (&ВнеоборотныйАктив)
	|				И (НЕ &ОтборПООрганизации
	|					ИЛИ Организация = &ОтборОрганизация)) КАК ХозрасчетныйОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Стоимость.СуммаБУ, 0) + ЕСТЬNULL(СтоимостьЦФ.СуммаБУ, 0) КАК СтоимостьБУ,
	|	ЕСТЬNULL(Стоимость.СуммаНУ, 0) + ЕСТЬNULL(СтоимостьЦФ.СуммаНУ, 0) КАК СтоимостьНУ,
	|	ЕСТЬNULL(Стоимость.СуммаПР, 0) + ЕСТЬNULL(СтоимостьЦФ.СуммаПР, 0) КАК СтоимостьПР,
	|	ЕСТЬNULL(Стоимость.СуммаВР, 0) + ЕСТЬNULL(СтоимостьЦФ.СуммаВР, 0) КАК СтоимостьВР,
	|	ЕСТЬNULL(-Амортизация.СуммаБУ, 0) + ЕСТЬNULL(-АмортизацияЦФ.СуммаБУ, 0) КАК АмортизацияБУ,
	|	ЕСТЬNULL(-Амортизация.СуммаНУ, 0) + ЕСТЬNULL(-АмортизацияЦФ.СуммаНУ, 0) КАК АмортизацияНУ,
	|	ЕСТЬNULL(-Амортизация.СуммаПР, 0) + ЕСТЬNULL(-АмортизацияЦФ.СуммаПР, 0) КАК АмортизацияПР,
	|	ЕСТЬNULL(-Амортизация.СуммаВР, 0) + ЕСТЬNULL(-АмортизацияЦФ.СуммаВР, 0) КАК АмортизацияВР,
	|	втАктивыИСчетаУчета.НачислениеИзноса КАК НачислениеИзноса
	|ИЗ
	|	втАктивыИСчетаУчета КАК втАктивыИСчетаУчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК Стоимость
	|		ПО втАктивыИСчетаУчета.ОбъектУчета = Стоимость.ОбъектУчета
	|			И втАктивыИСчетаУчета.СчетУчета = Стоимость.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК Амортизация
	|		ПО втАктивыИСчетаУчета.ОбъектУчета = Амортизация.ОбъектУчета
	|			И втАктивыИСчетаУчета.СчетАмортизации = Амортизация.Счет
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК СтоимостьЦФ
	|		ПО втАктивыИСчетаУчета.ОбъектУчета = СтоимостьЦФ.ОбъектУчета
	|			И втАктивыИСчетаУчета.СчетУчетаЦФ = СтоимостьЦФ.Счет
	|			И втАктивыИСчетаУчета.ПрименениеЦелевогоФинансирования
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК АмортизацияЦФ
	|		ПО втАктивыИСчетаУчета.ОбъектУчета = АмортизацияЦФ.ОбъектУчета
	|			И втАктивыИСчетаУчета.СчетАмортизацииЦФ = АмортизацияЦФ.Счет
	|			И втАктивыИСчетаУчета.ПрименениеЦелевогоФинансирования";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЗначенияПоУмолчанию, Выборка);
	КонецЕсли;
	
	ЗаголовокВалюты = Строка(Константы.ВалютаРегламентированногоУчета.Получить());
	
	Поля = "Представление, СуммаБУ, СуммаНУ, СуммаПР, СуммаВР";
	
	Массив = Новый Массив;
	
	Строка = Новый Структура(Поля);
	Строка.Представление = НСтр("ru='Восстановительная стоимость:'");
	Строка.СуммаБУ = ЗначенияПоУмолчанию.СтоимостьБУ;
	Строка.СуммаНУ = ЗначенияПоУмолчанию.СтоимостьНУ;
	Строка.СуммаПР = ЗначенияПоУмолчанию.СтоимостьПР;
	Строка.СуммаВР = ЗначенияПоУмолчанию.СтоимостьВР;
	Массив.Добавить(Строка);
	
	ЗаголовокАмортизации = НСтр("ru='Накопленная амортизация:'");
	МножительАмортизации = 1;
	Если ЗначенияПоУмолчанию.НачислениеИзноса Тогда
		ЗаголовокАмортизации = НСтр("ru='Накопленный износ:'");
		МножительАмортизации = -1;
	КонецЕсли;
	
	Строка = Новый Структура(Поля);
	Строка.Представление = ЗаголовокАмортизации;
	Строка.СуммаБУ = ЗначенияПоУмолчанию.АмортизацияБУ * МножительАмортизации;
	Строка.СуммаНУ = ЗначенияПоУмолчанию.АмортизацияНУ * МножительАмортизации;
	Строка.СуммаПР = ЗначенияПоУмолчанию.АмортизацияПР * МножительАмортизации;
	Строка.СуммаВР = ЗначенияПоУмолчанию.АмортизацияВР * МножительАмортизации;
	Массив.Добавить(Строка);
	
	Если Не ЗначенияПоУмолчанию.НачислениеИзноса Тогда
		
		Строка = Новый Структура(Поля);
		Строка.Представление = НСтр("ru='Остаточная стоимость:'");
		Строка.СуммаБУ = ЗначенияПоУмолчанию.СтоимостьБУ-ЗначенияПоУмолчанию.АмортизацияБУ;
		Строка.СуммаНУ = ЗначенияПоУмолчанию.СтоимостьНУ-ЗначенияПоУмолчанию.АмортизацияНУ;
		Строка.СуммаПР = ЗначенияПоУмолчанию.СтоимостьПР-ЗначенияПоУмолчанию.АмортизацияПР;
		Строка.СуммаВР = ЗначенияПоУмолчанию.СтоимостьВР-ЗначенияПоУмолчанию.АмортизацияВР;
		Массив.Добавить(Строка);
		
	КонецЕсли;
	
	Возврат Массив;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСведения2_4(Знач ВнеоборотныйАктив)

	СведенияОбУчете = Справочники.ОбъектыЭксплуатации.СведенияОбУчете(ВнеоборотныйАктив);
	СтоимостьИАмортизация = ВнеоборотныеАктивы.СтоимостьИАмортизацияОС(ВнеоборотныйАктив);
	
	Если СведенияОбУчете <> Неопределено Тогда
		ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(СведенияОбУчете.Организация, ТекущаяДатаСеанса());
	Иначе
		ПлательщикНалогаНаПрибыль = Ложь;
	КонецЕсли; 

	МассивСумм = Новый Массив;
	
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУпр  = Константы.ВалютаУправленческогоУчета.Получить();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		
		// БУ
		ДанныеУчета = Новый Структура;
		ДанныеУчета.Вставить("Учет", "БУ");
		ДанныеУчета.Вставить("Валюта", ВалютаРегл);
		
		Если СведенияОбУчете <> Неопределено
			И СведенияОбУчете.СостояниеБУ = Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету Тогда
			ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.ЗалоговаяСтоимость);
			ДанныеУчета.Вставить("НакопленнаяАмортизация", 0);
			ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.ЗалоговаяСтоимость);
		Иначе
			ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл + СтоимостьИАмортизация.СтоимостьЦФ);
			ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияРегл + СтоимостьИАмортизация.АмортизацияЦФ);
			
			ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл 
															+ СтоимостьИАмортизация.СтоимостьЦФ 
															- СтоимостьИАмортизация.АмортизацияРегл 
															- СтоимостьИАмортизация.АмортизацияЦФ);
		КонецЕсли; 
		
		МассивСумм.Добавить(ДанныеУчета);
		
		Если ПлательщикНалогаНаПрибыль Тогда
			
			// НУ
			ДанныеУчета = Новый Структура;
			ДанныеУчета.Вставить("Учет", "НУ");
			ДанныеУчета.Вставить("Валюта", ВалютаРегл);
			ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьНУ + СтоимостьИАмортизация.СтоимостьНУЦФ);
			ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияНУ + СтоимостьИАмортизация.АмортизацияНУЦФ);
			
			ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьНУ 
															+ СтоимостьИАмортизация.СтоимостьНУЦФ 
															- СтоимостьИАмортизация.АмортизацияНУ 
															- СтоимостьИАмортизация.АмортизацияНУЦФ);
			МассивСумм.Добавить(ДанныеУчета);
			
			Если ПолучитьФункциональнуюОпцию("ПоддержкаПБУ18") Тогда
				
				// ПР
				ДанныеУчета = Новый Структура;
				ДанныеУчета.Вставить("Учет", "ПР");
				ДанныеУчета.Вставить("Валюта", ВалютаРегл);
				ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьПР + СтоимостьИАмортизация.СтоимостьПРЦФ);
				ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияПР + СтоимостьИАмортизация.АмортизацияПРЦФ);
				
				ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьПР 
																+ СтоимостьИАмортизация.СтоимостьПРЦФ 
																- СтоимостьИАмортизация.АмортизацияПР 
																- СтоимостьИАмортизация.АмортизацияПРЦФ);
				МассивСумм.Добавить(ДанныеУчета);
				
				// ВР
				ДанныеУчета = Новый Структура;
				ДанныеУчета.Вставить("Учет", "ВР");
				ДанныеУчета.Вставить("Валюта", ВалютаРегл);
				ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьВР + СтоимостьИАмортизация.СтоимостьВРЦФ);
				ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияВР + СтоимостьИАмортизация.АмортизацияВРЦФ);
				ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьВР 
																+ СтоимостьИАмортизация.СтоимостьВРЦФ 
																- СтоимостьИАмортизация.АмортизацияВР 
																- СтоимостьИАмортизация.АмортизацияВРЦФ);
				МассивСумм.Добавить(ДанныеУчета);
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	// УУ
	ДанныеУчета = Новый Структура;
	ДанныеУчета.Вставить("Учет", "УУ");
	ДанныеУчета.Вставить("Валюта", ВалютаУпр);
	ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.Стоимость);
	ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.Амортизация);
	ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.Стоимость - СтоимостьИАмортизация.Амортизация);
	МассивСумм.Добавить(ДанныеУчета);
	
	ПредставлениеСведений = Справочники.ОбъектыЭксплуатации.ПредставлениеСведенийОбУчете(СведенияОбУчете, Ложь);
	
	Сведения = Новый Структура;
	Сведения.Вставить("ПредставлениеСведений", ПредставлениеСведений);
	Сведения.Вставить("Суммы", МассивСумм);
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВнеоборотныйАктив, "ГруппаОС,КодПоОКОФ,АмортизационнаяГруппа");
	Если ЗначениеЗаполнено(РеквизитыОбъекта.ГруппаОС) Тогда
		ТекстСтроки = СтрШаблон(НСтр("ru = 'Группа ОС: %1'"), РеквизитыОбъекта.ГруппаОС);
		СведенияГруппаОС = Новый ФорматированнаяСтрока(ТекстСтроки);
		Сведения.Вставить("СведенияГруппаОС", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СведенияГруппаОС));
	Иначе
		Сведения.Вставить("СведенияГруппаОС", Неопределено);
	КонецЕсли; 
	Если ЗначениеЗаполнено(РеквизитыОбъекта.КодПоОКОФ) Тогда
		ТекстСтроки = СтрШаблон(НСтр("ru = 'Код по ОКОФ: %1'"), РеквизитыОбъекта.КодПоОКОФ);
		СведенияКодПоОКОФ = Новый ФорматированнаяСтрока(ТекстСтроки);
		Сведения.Вставить("СведенияКодПоОКОФ", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СведенияКодПоОКОФ));
	Иначе
		Сведения.Вставить("СведенияКодПоОКОФ", Неопределено);
	КонецЕсли; 
	Если ЗначениеЗаполнено(РеквизитыОбъекта.АмортизационнаяГруппа) Тогда
		ТекстСтроки = СтрШаблон(НСтр("ru = 'Амортизационная группа: %1'"), РеквизитыОбъекта.АмортизационнаяГруппа);
		СведенияАмортизационнаяГруппа = Новый ФорматированнаяСтрока(ТекстСтроки);
		Сведения.Вставить("СведенияАмортизационнаяГруппа", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СведенияАмортизационнаяГруппа));
	Иначе
		Сведения.Вставить("СведенияАмортизационнаяГруппа", Неопределено);
	КонецЕсли; 

	Возврат Сведения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСостоянию(Форма)

	Если Форма.ИспользоватьУчет2_4 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Форма.Список,
			"Состояние",
			Форма.ОтборСостояние);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Список,
			"СостояниеРегл",
			Форма.ОтборСостояние,
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Форма.ОтборСостояние));
	КонецЕсли; 

КонецПроцедуры
 
#КонецОбласти