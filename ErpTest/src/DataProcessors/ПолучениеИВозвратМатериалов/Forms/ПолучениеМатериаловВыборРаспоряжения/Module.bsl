#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Для каждого ДанныеМатериала Из Параметры.СписокМатериалов Цикл
		ЗаполнитьЗначенияСвойств(СписокМатериалов.Добавить(), ДанныеМатериала);
	КонецЦикла;
	
	ЗаполнитьСписокРаспоряжений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряженияНаОформление

&НаКлиенте
Процедура СписокРаспоряженияНаОформлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьРаспоряженияИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбратьИПродолжить(Команда)
	
	ВыбратьРаспоряженияИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолучаемыеМатериалы.Номенклатура КАК Номенклатура,
	|	ПолучаемыеМатериалы.Характеристика КАК Характеристика,
	|	ПолучаемыеМатериалы.Назначение КАК Назначение,
	|	ПолучаемыеМатериалы.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ПолучаемыеМатериалы
	|ИЗ
	|	&ПолучаемыеМатериалы КАК ПолучаемыеМатериалы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказыКОформлению.Распоряжение КАК Распоряжение,
	|	ЗаказыКОформлению.Ссылка КАК Ссылка,
	|	ЗаказыКОформлению.Номер КАК Номер,
	|	ЗаказыКОформлению.ДатаДокумента КАК ДатаДокумента,
	|	ЗаказыКОформлению.ТипРаспоряжения КАК ТипРаспоряжения,
	|	ЗаказыКОформлению.Организация КАК Организация,
	|	ЗаказыКОформлению.Склад,
	|	ЗаказыКОформлению.Подразделение,
	|	ЗаказыКОформлению.Ответственный,
	|	ВЫБОР
	|		КОГДА СУММА(ЗаказыКОформлению.КОформлениюРасход) = 0
	|				И СУММА(ЗаказыКОформлению.КОформлениюОстаток) > 0
	|			ТОГДА 1
	|		КОГДА СУММА(ЗаказыКОформлению.КОформлениюОстаток) > 0
	|			ТОГДА 2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СостояниеНакладной,
	|	МАКСИМУМ(ЗаказыКОформлению.СостояниеОрдера) КАК СоответствиеОрдера
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыКОтгрузке.ДокументОтгрузки КАК Распоряжение,
	|		ТоварыКОтгрузке.ДокументОтгрузки КАК Ссылка,
	|		ВЫБОР
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказМатериаловВПроизводство).ПометкаУдаления
	//++ НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказНаПроизводство).ПометкаУдаления
	//-- НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаМатериаловВПроизводство).ПометкаУдаления
	|		КОНЕЦ КАК ПометкаУдаления,
	|		ВЫБОР
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказМатериаловВПроизводство).Номер
	//++ НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказНаПроизводство).Номер
	//-- НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаМатериаловВПроизводство).Номер
	|		КОНЕЦ КАК Номер,
	|		ВЫБОР
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказМатериаловВПроизводство).Дата
	//++ НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказНаПроизводство).Дата
	//-- НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаМатериаловВПроизводство).Дата
	|		КОНЕЦ КАК ДатаДокумента,
	|		ТИПЗНАЧЕНИЯ(ТоварыКОтгрузке.ДокументОтгрузки) КАК ТипРаспоряжения,
	|		ВЫБОР
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказМатериаловВПроизводство).Проведен
	//++ НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказНаПроизводство).Проведен
	//-- НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаМатериаловВПроизводство).Проведен
	|		КОНЕЦ КАК Проведен,
	|		ВЫБОР
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказМатериаловВПроизводство).Организация
	//++ НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказНаПроизводство).Организация
	//-- НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаМатериаловВПроизводство).Организация
	|		КОНЕЦ КАК Организация,
	|		ВЫБОР
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказМатериаловВПроизводство).Ответственный
	//++ НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ЗаказНаПроизводство).Ответственный
	//-- НЕ УТКА
	|			КОГДА ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|				ТОГДА ВЫРАЗИТЬ(ТоварыКОтгрузке.ДокументОтгрузки КАК Документ.ПередачаМатериаловВПроизводство).Ответственный
	|		КОНЕЦ КАК Ответственный,
	|		ТоварыКОтгрузке.Склад КАК Склад,
	|		ТоварыКОтгрузке.Получатель КАК Подразделение,
	|		ТоварыКОтгрузке.Номенклатура КАК Номенклатура,
	|		ТоварыКОтгрузке.Характеристика КАК ХарактеристикаНоменклатуры,
	|		ТоварыКОтгрузке.Серия КАК Серия,
	|		ТоварыКОтгрузке.КОформлениюРасход КАК КОформлениюРасход,
	|		ТоварыКОтгрузке.КОформлениюКонечныйОстаток КАК КОформлениюОстаток,
	|		ВЫБОР
	|			КОГДА НЕ ТоварыКОтгрузке.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|					ИЛИ ТоварыКОтгрузке.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|						И ТоварыКОтгрузке.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке > &ТекущаяДата
	|				ТОГДА 0
	|			КОГДА ТоварыКОтгрузке.СобраноПриход + ТоварыКОтгрузке.КОтгрузкеРасход = 0
	|					И (ТоварыКОтгрузке.КОформлениюПриход > 0
	|						ИЛИ ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство)
	|				ТОГДА 1
	|			КОГДА ТоварыКОтгрузке.СобраноПриход + ТоварыКОтгрузке.КОтгрузкеРасход > 0
	|					И (ТоварыКОтгрузке.КОформлениюПриход > 0
	|						ИЛИ ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство)
	|					И ((ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	//++ НЕ УТКА
	|							ИЛИ ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	//-- НЕ УТКА
	|						)
	|							И ТоварыКОтгрузке.СобраноПриход + ТоварыКОтгрузке.КОтгрузкеРасход <> ТоварыКОтгрузке.КОформлениюРасход
	|						ИЛИ ТоварыКОтгрузке.ДокументОтгрузки ССЫЛКА Документ.ПередачаМатериаловВПроизводство
	|							И ТоварыКОтгрузке.КОтгрузкеКонечныйОстаток <> 0)
	|				ТОГДА 3
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК СостояниеОрдера
	|	ИЗ
	|		РегистрНакопления.ТоварыКОтгрузке.ОстаткиИОбороты(
	|				,
	|				,
	|				,
	|				,
	|				(ДокументОтгрузки ССЫЛКА Документ.ЗаказМатериаловВПроизводство
	//++ НЕ УТКА
	|					ИЛИ ДокументОтгрузки ССЫЛКА Документ.ЗаказНаПроизводство
	//-- НЕ УТКА
	|				)
	|					И (Номенклатура, Характеристика, Назначение, Получатель) В
	|						(ВЫБРАТЬ
	|							ПолучаемыеМатериалы.Номенклатура,
	|							ПолучаемыеМатериалы.Характеристика,
	|							ПолучаемыеМатериалы.Назначение,
	|							ПолучаемыеМатериалы.Подразделение
	|						ИЗ
	|							ПолучаемыеМатериалы)) КАК ТоварыКОтгрузке
	|	ГДЕ
	|		ТоварыКОтгрузке.КОформлениюКонечныйОстаток > 0) КАК ЗаказыКОформлению
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыКОформлению.Распоряжение,
	|	ЗаказыКОформлению.Ссылка,
	|	ЗаказыКОформлению.Номер,
	|	ЗаказыКОформлению.ДатаДокумента,
	|	ЗаказыКОформлению.ТипРаспоряжения,
	|	ЗаказыКОформлению.Организация,
	|	ЗаказыКОформлению.Склад,
	|	ЗаказыКОформлению.Подразделение,
	|	ЗаказыКОформлению.Ответственный";
	
	Запрос.УстановитьПараметр("ПолучаемыеМатериалы", СписокМатериалов.Выгрузить());
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	
	СписокРаспоряженияНаОформление.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРаспоряженияИЗакрыть()
	
	ОчиститьСообщения();
	
	Список = Элементы.СписокРаспоряженияНаОформление;
	ТипНакладная = Новый ОписаниеТипов("ДокументСсылка.ПередачаМатериаловВПроизводство");
	ДокументыПоВидам = НакладныеКлиент.СсылкиВыделенныхСтрокСпискаПоВидам(Список, ТипНакладная, "Ссылка,Организация,Склад,Подразделение");
	Если ДокументыПоВидам.Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	ПараметрыИИмяФормы = ПараметрыИИмяФормыОформленияНакладной(ДокументыПоВидам);
	
	Если ПараметрыИИмяФормы.ЕстьОшибки Тогда
		НакладныеКлиент.СообщитьОбОшибкахЗаполненияВнутреннейНакладной(ПараметрыИИмяФормы.ТекстОшибки);
	Иначе
		ПараметрыИИмяФормы.Параметры.Основание.Вставить("СписокМатериалов", СписокМатериалов);
		ОткрытьФорму(ПараметрыИИмяФормы.Имя, ПараметрыИИмяФормы.Параметры);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыИИмяФормыОформленияНакладной(ДокументыПоВидам)
	
	НастройкиФормы = НакладныеСервер.НастройкиФормыПереоформленияНакладных();
	НастройкиФормы.Заголовок = НСтр("ru = 'Переоформление передачи материалов по выбранным распоряжениям'");
	НастройкиФормы.ИмяФормыНакладной = "Документ.ПередачаМатериаловВПроизводство.ФормаОбъекта";
	
	КонтекстВызова = Новый Структура("ИмяТипаНакладной, НастройкиФормыПереоформления", "ПередачаМатериаловВПроизводство", НастройкиФормы);
	
	ПараметрыВыполненияКоманды = Новый Структура("ДокументыПоВидам, ПоОрдерам, Склад", ДокументыПоВидам, Ложь, Неопределено);
	
	Результат = Обработки.ПолучениеИВозвратМатериалов.ПроверитьВозможностьВыполненияКомандыОформить(КонтекстВызова, ПараметрыВыполненияКоманды);
	Если Не Результат.ЕстьОшибки Тогда
		Результат = Обработки.ПолучениеИВозвратМатериалов.ПараметрыИИмяФормыОформленияНакладной(КонтекстВызова, ПараметрыВыполненияКоманды, Результат.РеквизитыШапки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
