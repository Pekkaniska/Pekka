#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ПолучитьИзВременногоХранилища(Параметры.АдресРезультатаПроверки);
	
	ХозяйственныеОперацииБезПравилОтражения.Загрузить(РезультатПроверки.ХозяйственныеОперацииБезПравилОтражения);
	СчетаБезПравилОтражения.Загрузить(РезультатПроверки.СчетаБезПравилОтражения);
	
	Организация = Параметры.Организация;
	
	УстановитьВидимостьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("ЗакрытаФормаНастройкиНеобходимыхПравилОтраженияВУчете");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ХозяйственныеОперацииБезПравилОтраженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьНастройкуШаблоновПроводок(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственныеОперацииБезПравилОтраженияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикиПолучитьСписокДокументовПоХозяйственнойОперации", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаБезПравилОтраженияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикиПолучитьСписокДокументовПоСчету", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСчетаБезПравилОтражения Тогда
		ОбработчикиПолучитьСписокДокументовПоСчету();
	Иначе
		ОбработчикиПолучитьСписокДокументовПоХозяйственнойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПоСчетуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(, ТекущиеДанные.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПоОперацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(, ТекущиеДанные.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаБезПравилОтраженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	НастроитьСоответствиеСчетов(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьШаблонПроводки(Команда)
	
	ОткрытьНастройкуШаблоновПроводок(Элементы.ХозяйственныеОперацииБезПравилОтражения.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСоответствиеСчетов(Команда)
	
	ОткрытьНастройкуСоотвествияСчетов(Элементы.СчетаБезПравилОтражения.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ПроверитьНастройкуПравилСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиМеждународногоУчетаПоДокументуОперации(Команда)
	
	ПроводкиМеждународногоУчетаПоДокументу(Элементы.СписокДокументовПоОперации.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиМеждународногоУчетаПоДокументуСчета(Команда)
	
	ПроводкиМеждународногоУчетаПоДокументу(Элементы.СписокДокументовПоСчету.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиРеглУчетаДокументаПоСчету(Команда)
	
	ПроводкиРеглУчетаПоДокументу(Элементы.СписокДокументовПоСчету.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиРеглУчетаДокументуПоОперации(Команда)
	
	ПроводкиРеглУчетаПоДокументу(Элементы.СписокДокументовПоОперации.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументОперации(Команда)
	
	ОткрытьДокумент(Элементы.СписокДокументовПоОперации.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументСчета(Команда)
	
	ОткрытьДокумент(Элементы.СписокДокументовПоСчету.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	Элементы.СтраницаХозяйственныеОперацииБезПравилОтражения.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Шаблоны проводок (%1)'"), 
			ХозяйственныеОперацииБезПравилОтражения.Количество());
	
	Элементы.СтраницаСчетаБезПравилОтражения.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Соответствующие счета международного учета (%1)'"), 
			СчетаБезПравилОтражения.Количество());
	
	Элементы.СтраницаХозяйственныеОперацииБезПравилОтражения.Видимость = ХозяйственныеОперацииБезПравилОтражения.Количество() > 0;
	
	Элементы.СтраницаСчетаБезПравилОтражения.Видимость = СчетаБезПравилОтражения.Количество() > 0;;
	
	Элементы.СтраницаНастроеныВсеПравилаОтражения.Видимость = 
		(ХозяйственныеОперацииБезПравилОтражения.Количество() = 0) И (СчетаБезПравилОтражения.Количество() = 0);
	
	ВидимыеСтраницы = Новый Массив;
	Для каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		Если Страница.Видимость Тогда
			ВидимыеСтраницы.Добавить(Страница);
		КонецЕсли;
	КонецЦикла;
	
	Элементы.Страницы.ОтображениеСтраниц = 
		?(ВидимыеСтраницы.Количество() = 1, ОтображениеСтраницФормы.Нет, ОтображениеСтраницФормы.ЗакладкиСверху);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(ИдентификаторСтроки)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(,ТекущиеДанные.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиРеглУчетаПоДокументу(ИдентификаторСтроки)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыОтбора = Новый Структура("Регистратор", ТекущиеДанные.Документ);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("Обработка.ОтражениеДокументовВРеглУчете.Форма.ПроводкиРегламентированногоУчета", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПроводкиМеждународногоУчетаПоДокументу(ИдентификаторСтроки)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыОтбора = Новый Структура("Регистратор", ТекущиеДанные.Документ);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("РегистрБухгалтерии.Международный.Форма.ПроводкиМеждународногоУчета",
		ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуШаблоновПроводок(ИдентификаторСтроки)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ХозяйственныеОперацииБезПравилОтражения.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяПолитика", ТекущиеДанные.УчетнаяПолитика);
	ПараметрыФормы.Вставить("ХозяйственнаяОперация", ТекущиеДанные.Операция);
	ОткрытьФорму("Обработка.НастройкаШаблоновПроводокДляМеждународногоУчета.Форма.НастройкаШаблоновПроводок", 
		ПараметрыФормы, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуСоотвествияСчетов(ИдентификаторСтроки)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = СчетаБезПравилОтражения.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяПолитика", ТекущиеДанные.УчетнаяПолитика);
	ПараметрыФормы.Вставить("СчетРеглУчета", ТекущиеДанные.Счет);
	ОткрытьФорму("Обработка.НастройкаСоответствияСчетовИОборотовМеждународногоУчета.Форма", 
		ПараметрыФормы, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкуПравилСервер()
	
	РезультатПроверки = Обработки.ОтражениеДокументовВМеждународномУчете.ПроверитьНастройкуПравилОтраженияУчете(Организация);
	
	ХозяйственныеОперацииБезПравилОтражения.Загрузить(РезультатПроверки.ХозяйственныеОперацииБезПравилОтражения);
	СчетаБезПравилОтражения.Загрузить(РезультатПроверки.СчетаБезПравилОтражения);
	
	УстановитьВидимостьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикиПолучитьСписокДокументовПоХозяйственнойОперации()

	ТекущиеДанные = Элементы.ХозяйственныеОперацииБезПравилОтражения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		СписокДокументов.Очистить();
	Иначе
		ЗаполнитьСписокДокументовПоХозяйственнойОперации(
			ТекущиеДанные.ХозяйственнаяОперация, 
			ТекущиеДанные.ИсточникДанных, 
			ТекущиеДанные.УчетнаяПолитика);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикиПолучитьСписокДокументовПоСчету()

	ТекущиеДанные = Элементы.СчетаБезПравилОтражения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		СписокДокументов.Очистить();
	Иначе
		ЗаполнитьСписокДокументовПоСчету(ТекущиеДанные.Счет, ТекущиеДанные.УчетнаяПолитика);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовПоХозяйственнойОперации(ХозяйственнаяОперация, ИсточникДанных, УчетнаяПолитика)
	
	МассивРегистров = Обработки.ОтражениеДокументовВМеждународномУчете.РегистрыКОтражениюВМеждународномУчете();
	Если МассивРегистров.Найти(ИсточникДанных) <> Неопределено Тогда
		ТекстЗапросаДанныеРегистра = ТекстЗапросаПоРегистру(ИсточникДанных);
	ИначеЕсли ИсточникДанных = "ВыручкаИСебестоимостьПродаж" Тогда
		ТекстЗапросаДанныеРегистра = ТекстЗапросаПоВыручкеИСебестоимости();
	ИначеЕсли ИсточникДанных = "НДСЗаписиКнигиПродаж"
		ИЛИ ИсточникДанных = "НДСЗаписиКнигиПокупок" Тогда
		ТекстЗапросаДанныеРегистра = ТекстЗапросаНДССАвансов();
	ИначеЕсли ИсточникДанных = "РасчетыСКлиентамиПоДокументам" Тогда
		ТекстЗапросаДанныеРегистра = ТекстЗапросаПоЗачетуАвансаКлиента();
	ИначеЕсли ИсточникДанных = "РасчетыСПоставщикамиПоДокументам" Тогда
		ТекстЗапросаДанныеРегистра = ТекстЗапросаПоЗачетуАвансаПоставщикам();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекстЗапросаДанныеРегистра) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДанныеРегистра +
	"/////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыКОтражению.Период КАК Дата,
	|	ДокументыКОтражению.Регистратор КАК Документ,
	|	ДокументыКОтражению.Организация КАК Организация,
	|	МАКСИМУМ(УчетнаяПолитикаОрганизаций.Период) КАК ПериодУчетнойПолитики
	|ПОМЕСТИТЬ ДокументыКОтражению
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ДанныеРегистра КАК ДанныеРегистра
	|	ПО
	|		ДокументыКОтражению.Регистратор = ДанныеРегистра.Документ
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ДокументыКОтражению.Организация = УчетнаяПолитикаОрганизаций.Организация
	|		И ДокументыКОтражению.Период >= УчетнаяПолитикаОрганизаций.Период
	|	
	|ГДЕ
	|	ДокументыКОтражению.Организация = &Организация
	|	И ДокументыКОтражению.Статус В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете))
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументыКОтражению.Период,
	|	ДокументыКОтражению.Регистратор,
	|	ДокументыКОтражению.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Дата,
	|	Документ
	|;
	|
	|ВЫБРАТЬ
	|	ДокументыКОтражению.Дата,
	|	ДокументыКОтражению.Документ,
	|	ДокументыКОтражению.Организация,
	|	ОтражениеДокументовВМеждународномУчете.Комментарий
	|ИЗ 
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ДокументыКОтражению.Организация = УчетнаяПолитикаОрганизаций.Организация
	|		И ДокументыКОтражению.ПериодУчетнойПолитики = УчетнаяПолитикаОрганизаций.Период
	|		И УчетнаяПолитика = &УчетнаяПолитика
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ОтражениеДокументовВМеждународномУчете
	|	ПО
	|		ДокументыКОтражению.Организация = ОтражениеДокументовВМеждународномУчете.Организация
	|		И ДокументыКОтражению.Дата = ОтражениеДокументовВМеждународномУчете.Период
	|		И ДокументыКОтражению.Документ = ОтражениеДокументовВМеждународномУчете.Регистратор
	|		
	|";
 
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СписокДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументовПоСчету(Счет, УчетнаяПолитика)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументыКОтражению.Период КАК Дата,
	|	ДокументыКОтражению.Регистратор КАК Документ,
	|	ДокументыКОтражению.Организация КАК Организация,
	|	МАКСИМУМ(УчетнаяПолитикаОрганизаций.Период) КАК ПериодУчетнойПолитики
	|ПОМЕСТИТЬ ДокументыКОтражению
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ДокументыКОтражению
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ДокументыКОтражению.Организация = УчетнаяПолитикаОрганизаций.Организация
	|		И ДокументыКОтражению.Период >= УчетнаяПолитикаОрганизаций.Период
	|ГДЕ
	|	ДокументыКОтражению.Организация = &Организация
	|	И ДокументыКОтражению.Статус В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете))
	|	
	|СГРУППИРОВАТЬ ПО
	|	ДокументыКОтражению.Период,
	|	ДокументыКОтражению.Регистратор,
	|	ДокументыКОтражению.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ХозрасчетныйДвиженияССубконто.Регистратор
	|ПОМЕСТИТЬ ПроводкиДокументов
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
	|			,
	|			,
	|			(Организация, Период, Регистратор) В
	|				(ВЫБРАТЬ
	|					ДокументыКОтражению.Организация,
	|					ДокументыКОтражению.Дата,
	|					ДокументыКОтражению.Документ
	|				ИЗ
	|					ДокументыКОтражению КАК ДокументыКОтражению),
	|			,
	|			) КАК ХозрасчетныйДвиженияССубконто
	|ГДЕ
	|	(ХозрасчетныйДвиженияССубконто.СчетДт = &Счет
	|			ИЛИ ХозрасчетныйДвиженияССубконто.СчетКт = &Счет)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ХозрасчетныйДвиженияССубконто.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыКОтражению.Дата,
	|	ДокументыКОтражению.Документ,
	|	ДокументыКОтражению.Организация,
	|	ОтражениеДокументовВМеждународномУчете.Комментарий
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|			ПроводкиДокументов КАК ПроводкиДокументов
	|		ПО 
	|			ДокументыКОтражению.Документ = ПроводкиДокументов.Регистратор
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|			РегистрСведений.УчетнаяПолитикаОрганизацийДляМеждународногоУчета КАК УчетнаяПолитикаОрганизаций
	|		ПО
	|			ДокументыКОтражению.Организация = УчетнаяПолитикаОрганизаций.Организация
	|			И ДокументыКОтражению.ПериодУчетнойПолитики = УчетнаяПолитикаОрганизаций.Период
	|			И УчетнаяПолитика = &УчетнаяПолитика
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ОтражениеДокументовВМеждународномУчете
	|		ПО
	|			ДокументыКОтражению.Организация = ОтражениеДокументовВМеждународномУчете.Организация
	|			И ДокументыКОтражению.Дата = ОтражениеДокументовВМеждународномУчете.Период
	|			И ДокументыКОтражению.Документ = ОтражениеДокументовВМеждународномУчете.Регистратор";
	
	Запрос.УстановитьПараметр("Счет", Счет);
	Запрос.УстановитьПараметр("УчетнаяПолитика", УчетнаяПолитика);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	СписокДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаПоРегистру(ИмяРегистра)

	ШаблонТекстаЗапросаПоРегистру = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Документ
	|ПОМЕСТИТЬ ДанныеРегистра
	|ИЗ
	|	РегистрНакопления.%ИмяРегистра% КАК ДанныеРегистра
	|	
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И Организация = &Организация
	|	И ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|";
	
	Возврат СтрЗаменить(ШаблонТекстаЗапросаПоРегистру, "%ИмяРегистра%", ИмяРегистра);
	
КонецФункции

&НаСервере
Функция ТекстЗапросаПоВыручкеИСебестоимости()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Документ
	|ПОМЕСТИТЬ ДанныеРегистра
	|ИЗ
	|	РегистрНакопления.ВыручкаИСебестоимостьПродаж КАК ДанныеРегистра
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|	ПО
	|		ДанныеРегистра.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|		И АналитикаПоПартнерам.Организация = &Организация
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ТекстЗапросаНДССАвансов()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Документ
	|ПОМЕСТИТЬ ДанныеРегистра
	|ИЗ
	|	РегистрНакопления.НДСЗаписиКнигиПродаж КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.Организация = &Организация
	|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) В (
	|		ТИП(Документ.СчетФактураВыданныйАванс),
	|		ТИП(Документ.СчетФактураПолученныйАванс))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор  КАК Документ
	|ИЗ
	|	РегистрНакопления.НДСЗаписиКнигиПокупок КАК ДанныеРегистра
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.Организация = &Организация
	|	И ТИПЗНАЧЕНИЯ(ДанныеРегистра.Регистратор) В (
	|		ТИП(Документ.СчетФактураВыданныйАванс),
	|		ТИП(Документ.СчетФактураПолученныйАванс))
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|";
	
	Возврат ТекстЗапроса;

КонецФункции

&НаСервере
Функция ТекстЗапросаПоЗачетуАвансаКлиента()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|   ДанныеРегистра.Регистратор КАК Документ
	|ПОМЕСТИТЬ ДанныеРегистра
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК ДанныеРегистра
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|	ПО
	|		ДанныеРегистра.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|		И АналитикаПоПартнерам.Организация = &Организация
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.ПредоплатаРегл > 0 
	|	И ДанныеРегистра.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|";
	
	Возврат ТекстЗапроса;

КонецФункции

&НаСервере
Функция ТекстЗапросаПоЗачетуАвансаПоставщикам()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|   ДанныеРегистра.Регистратор КАК Документ
	|ПОМЕСТИТЬ ДанныеРегистра
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК ДанныеРегистра
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаПоПартнерам
	|	ПО
	|		ДанныеРегистра.АналитикаУчетаПоПартнерам = АналитикаПоПартнерам.КлючАналитики
	|		И АналитикаПоПартнерам.Организация = &Организация
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.ПредоплатаРегл > 0 
	|	И ДанныеРегистра.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти