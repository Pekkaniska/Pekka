#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация     			= Параметры.Организация;
	ФормаСтатистики 			= Параметры.ФормаСтатистики;
	ОтборПоОбъектамНаблюдения 	= Параметры.ОтборПоОбъектамНаблюдения; // Стандартный Отбор по объектам наблюдения не обрабатывается.
	ОбъектыНаблюдения 			= Параметры.ОбъектыНаблюдения;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Организация") Тогда
			Организация = Параметры.Отбор.Организация;
		КонецЕсли;
	КонецЕсли;
	
	ДоступноРедактированиеНастроек = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.НастройкаЗаполненияФормСтатистики);
	Если Не ДоступноРедактированиеНастроек Тогда
		Элементы.НастройкиИзменить.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФормаСтатистики) Тогда
		
		АвтоЗаголовок = Ложь;
		Элементы.ФормаСтатистики.Видимость = Ложь;
		КраткоеПредставлениеФормы = Справочники.ФормыСтатистики.КраткоеПредставлениеФормы(ФормаСтатистики);
		
		Если ТипЗнч(Параметры.НастраиваемыеСтрокиОтчета) = Тип("Массив") И Параметры.НастраиваемыеСтрокиОтчета.Количество() > 0 Тогда
			
			Если Параметры.НастраиваемыеСтрокиОтчета.Количество() = 1 Тогда
				ШаблонЗаголовка = НСтр("ru = 'Настройка заполнения формы %1, строка %2'");
			Иначе
				ШаблонЗаголовка = НСтр("ru = 'Настройка заполнения формы %1, строки %2'");
			КонецЕсли;	
			
			СтрокиОтчета = СтрСоединить(Параметры.НастраиваемыеСтрокиОтчета, ",");
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, КраткоеПредставлениеФормы, СтрокиОтчета);
			
		Иначе
			ШаблонЗаголовка = НСтр("ru = 'Настройка заполнения формы %1'");
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, КраткоеПредставлениеФормы);
		КонецЕсли;	
	Иначе
		
		// Заполним список выбора Форм статистики. 
		СписокВыбора = Элементы.ФормаСтатистики.СписокВыбора;
		СписокВыбора.Добавить(
			Справочники.ФормыСтатистики.ПустаяСсылка(), 
			НСтр("ru = 'Все'")); // См. ЗаполнениеФормСтатистикиПереопределяемый.НастраиваемыеФормыСтатистикиПредоставляемыеОрганизацией()
		
		// Добавим в список формы, которые требуют настройки.
		Для Каждого ОписаниеФормыСтатистики Из ЗаполнениеФормСтатистики.НастраиваемыеФормыСтатистики() Цикл
			СписокВыбора.Добавить(ОписаниеФормыСтатистики.ФормаСтатистики);
		КонецЦикла;	
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
	ОбновитьСписокНастроек(Параметры.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "НастройкаЗаполненияФормСтатистики.Изменение" Тогда
		
		Если Параметр.Свойство("Организация") 
			И Параметр.Организация <> Организация Тогда
			Возврат;
		КонецЕсли;
		
		Если Параметр.Свойство("ОбъектНаблюдения")
			И Параметр.Свойство("Детализировать")
			И Параметр.Свойство("Заполнять") Тогда
			
			// Обновим только одну строку.
			УстановитьЗначенияНастройки(
				Параметр.ОбъектНаблюдения,
				Параметр.Детализировать,
				Параметр.Заполнять);
				
		Иначе
			// Обновим всю настройку.
			ОбновитьСписокНастроек();
			РазвернутьВсеУровниДереваНастроек();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормаСтатистикиПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	ОбновитьСписокНастроек();
	РазвернутьВсеУровниДереваНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьСписокНастроек();
	РазвернутьВсеУровниДереваНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройки

&НаКлиенте
Процедура НастройкиПередНачаломИзменения(Элемент, Отказ)
	
	// Редактируем связанные регистры сведений.
	Отказ = Истина;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Настройка выполняется для каждой организации отдельно.
                            |Выберите организацию'"));
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если Не ТекущиеДанные.Заполнять И Не ДоступноРедактированиеНастроек Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Для этого объекта настройка не выполнена.
			|Редактирование настройки недоступно'")); // Смотреть нечего.
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Детализировать Тогда
		
		// Редактируем список детальных строк.
		Отбор = Новый Структура;
		Отбор.Вставить("Организация",      Организация);
		Отбор.Вставить("ОбъектНаблюдения", ТекущиеДанные.ОбъектНаблюдения);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", Отбор);
		
		ОткрытьФорму("РегистрСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики.Форма.ФормаНабораЗаписей", ПараметрыФормы, ЭтаФорма);
		
	Иначе
		
		// Редактируем настройку объекта наблюдения.
		
		Если Не ДоступноРедактированиеНастроек И Не Элемент.ТекущиеДанные.Заполнять Тогда
			// Новую настройку этот пользователь создать не может.
			Возврат;
		КонецЕсли;
		
		ОписаниеПоказателя = Новый Структура;
		ОписаниеПоказателя.Вставить("Организация",       Организация);
		ОписаниеПоказателя.Вставить("ОбъектНаблюдения",  Элемент.ТекущиеДанные.ОбъектНаблюдения);
		
		ПараметрыКонструктора = Новый Массив;
		ПараметрыКонструктора.Добавить(ОписаниеПоказателя);
		
		КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.НастройкаЗаполненияФормСтатистики", ПараметрыКонструктора);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
		
		ОткрытьФорму("РегистрСведений.НастройкаЗаполненияФормСтатистики.ФормаЗаписи", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Заполнение списка настроек

&НаСервере
Процедура ОбновитьСписокНастроек(ТекущаяСтрока = Неопределено)
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока) Тогда
		// Запомним, на какой строке стоял курсор - потом оставим его на этой же.
		ТекущаяСтрока = Неопределено;
		Если Элементы.Настройки.ТекущаяСтрока <> Неопределено Тогда
			Строка = Настройки.НайтиПоИдентификатору(Элементы.Настройки.ТекущаяСтрока);
			Если Строка <> Неопределено Тогда
				ТекущаяСтрока = Строка.ОбъектНаблюдения;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтрокиНастройки = Настройки.ПолучитьЭлементы();
	СтрокиНастройки.Очистить();
			
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ФормыДляЗаполненияСпискаНастроек = ФормыДляЗаполненияСпискаНастроек();
	Запрос.УстановитьПараметр("ФормаСтатистики", ФормыДляЗаполненияСпискаНастроек);
	Запрос.УстановитьПараметр("ОтборПоОбъектамНаблюдения", 	ОтборПоОбъектамНаблюдения);
	Запрос.УстановитьПараметр("ОбъектыНаблюдения", 			ОбъектыНаблюдения);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПоляФормСтатистики.СтатистическийПоказатель.Владелец КАК ОбъектНаблюдения,
	|	ПоляФормСтатистики.СтатистическийПоказатель.Детализировать КАК Детализировать,
	|	ПоляФормСтатистики.НомерСтрокиОтчета КАК НомерСтрокиОтчета
	|ПОМЕСТИТЬ ПоляФормы
	|ИЗ
	|	Справочник.ПоляФормСтатистики КАК ПоляФормСтатистики
	|ГДЕ
	|	ПоляФормСтатистики.Владелец В(&ФормаСтатистики)
	|	И НЕ ПоляФормСтатистики.ПометкаУдаления
	|	И НЕ ПоляФормСтатистики.ЭтоГруппа
	|	И ПоляФормСтатистики.СтатистическийПоказатель <> ЗНАЧЕНИЕ(Справочник.СтатистическиеПоказатели.ПустаяСсылка)
	|	И ПоляФормСтатистики.СтатистическийПоказатель.Владелец.ТребуетНастройки
	|	И (ПоляФормСтатистики.СтатистическийПоказатель.Владелец В (&ОбъектыНаблюдения)
	|			ИЛИ НЕ &ОтборПоОбъектамНаблюдения)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОбъектНаблюдения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПоляФормы.ОбъектНаблюдения КАК ОбъектНаблюдения,
	|	ПоляФормы.Детализировать КАК Детализировать
	|ПОМЕСТИТЬ ОбъектыФормы
	|ИЗ
	|	ПоляФормы КАК ПоляФормы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОбъектНаблюдения,
	|	Детализировать";
	Запрос.Выполнить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ОтборПоОбъектамНаблюдения", 	ОтборПоОбъектамНаблюдения);
	Запрос.УстановитьПараметр("ОбъектыНаблюдения", 			ОбъектыНаблюдения);
	Запрос.Текст =
	// Текст этого запроса модифицируется: заменяется имя поля, по которому упорядочивать.
	"ВЫБРАТЬ
	|	ОбъектыСтатистическогоНаблюдения.Ссылка КАК ОбъектНаблюдения,
	|	ОбъектыСтатистическогоНаблюдения.ТребуетНастройки КАК ТребуетНастройки,
	|	ОбъектыСтатистическогоНаблюдения.Детализация КАК Детализация,
	|	ПоляФормы.Детализировать КАК Детализировать,
	|	ПоляФормы.НомерСтрокиОтчета КАК НомерСтрокиОтчета,
	|	ОбъектыСтатистическогоНаблюдения.РеквизитДопУпорядочивания КАК Порядок
	|ИЗ
	|	ПоляФормы КАК ПоляФормы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбъектыСтатистическогоНаблюдения КАК ОбъектыСтатистическогоНаблюдения
	|		ПО ПоляФормы.ОбъектНаблюдения = ОбъектыСтатистическогоНаблюдения.Ссылка
	|
	|ГДЕ
	|    ОбъектыСтатистическогоНаблюдения.Ссылка В (&ОбъектыНаблюдения)
	|    ИЛИ НЕ &ОтборПоОбъектамНаблюдения 
	|
	|УПОРЯДОЧИТЬ ПО
	|	%Порядок%
	|ИТОГИ
	|	МИНИМУМ(НомерСтрокиОтчета)
	|ПО
	|	ОбъектНаблюдения ИЕРАРХИЯ";
	Если ФормыДляЗаполненияСпискаНастроек.Количество() = 1 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%Порядок%", "НомерСтрокиОтчета");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%Порядок%", "Порядок");
	КонецЕсли;
	
	// Заполним иерархию объектов наблюдения.
	
	КэшИерархииОбъектовНаблюдения = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ЗаполнитьИерархиюНастроекРекурсивно(СтрокиНастройки, Выборка, КэшИерархииОбъектовНаблюдения);
	
	// Заполним состояние настроек и требования по настройке детальных строк.
	
	ПотребныеСводныеНастройки = Новый Массив;
	Для Каждого КлючИЗначение Из КэшИерархииОбъектовНаблюдения Цикл
		ПотребныеСводныеНастройки.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация",               Организация);
	Запрос.УстановитьПараметр("ПотребныеСводныеНастройки", ПотребныеСводныеНастройки);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыполненныеСводныеНастройки.ОбъектНаблюдения КАК ОбъектНаблюдения,
	|	ЛОЖЬ КАК Детализировать,
	|	МАКСИМУМ(ВыполненныеСводныеНастройки.Заполнять) КАК Заполнять
	|ПОМЕСТИТЬ ВыполненныеНастройки
	|ИЗ
	|	РегистрСведений.НастройкаЗаполненияФормСтатистики КАК ВыполненныеСводныеНастройки
	|ГДЕ
	|	ВыполненныеСводныеНастройки.Организация = &Организация
	|	И ВыполненныеСводныеНастройки.ОбъектНаблюдения В(&ПотребныеСводныеНастройки)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыполненныеСводныеНастройки.ОбъектНаблюдения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВыполненныеДетальныеНастройки.ОбъектНаблюдения,
	|	ИСТИНА,
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики КАК ВыполненныеДетальныеНастройки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОбъектыФормы КАК ПотребныеДетальныеНастройки
	|		ПО ВыполненныеДетальныеНастройки.ОбъектНаблюдения = ПотребныеДетальныеНастройки.ОбъектНаблюдения
	|ГДЕ
	|	ПотребныеДетальныеНастройки.Детализировать
	|	И ВыполненныеДетальныеНастройки.Организация = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыполненныеДетальныеНастройки.ОбъектНаблюдения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОбъектНаблюдения,
	|	Детализировать
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыполненныеНастройки.ОбъектНаблюдения КАК ОбъектНаблюдения,
	|	ВыполненныеНастройки.Детализировать КАК Детализировать,
	|	ВыполненныеНастройки.Заполнять КАК Заполнять,
	|	"""" КАК НомерСтрокиОтчета
	|ИЗ
	|	ВыполненныеНастройки КАК ВыполненныеНастройки
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПоляФормы.ОбъектНаблюдения,
	|	ПоляФормы.Детализировать,
	|	ЛОЖЬ,
	|	ПоляФормы.НомерСтрокиОтчета
	|ИЗ
	|	ПоляФормы КАК ПоляФормы
	|ИТОГИ
	|	МАКСИМУМ(Заполнять)
	|ПО
	|	ОбъектНаблюдения,
	|	Детализировать";
	// В последнем запросе пакета в поле НомерСтрокиОтчета безопасно возвращать пустую строку,
	// так как пустые строки пропускаются в СписокНомеровСтрок().
	
	// Заполним сведения о потребных детальных настройках и выполненных настройках (как сводных, так и детальных).
	ВыборкаОбъектНаблюдения = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаОбъектНаблюдения.Следующий() Цикл
		
		СуществующаяСтрока = КэшИерархииОбъектовНаблюдения[ВыборкаОбъектНаблюдения.ОбъектНаблюдения]; // Строка будет в кэше, потому что он заполнен теми же данными, которые возвращает запрос.
		
		ВыборкаДетализировать = ВыборкаОбъектНаблюдения.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаДетализировать.Следующий() Цикл
		
			Если Не ВыборкаДетализировать.Детализировать Тогда
				
				ЗаполняемаяСтрока = СуществующаяСтрока;
				
			Иначе
				
				// Детальную настройку покажем на следующем уровне - самой первой строкой.
				ЗаполняемаяСтрока = СуществующаяСтрока.ПолучитьЭлементы().Вставить(0);
				ЗаполнитьЗначенияСвойств(ЗаполняемаяСтрока, СуществующаяСтрока);
				ЗаполняемаяСтрока.Детализировать = Истина;
				
				ЗаполнитьПредставление(ЗаполняемаяСтрока);
				
				// Дополним информацию об объекте списком строк.
				ЗаполняемаяСтрока.НомераСтрокФормы = СписокНомеровСтрок(ВыборкаДетализировать); 
				
			КонецЕсли;
			
			ЗаполняемаяСтрока.Заполнять = ВыборкаДетализировать.Заполнять;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Восстановим положение курсора.
	Если СтрокиНастройки.Количество() > 0 Тогда
		
		ИдентификаторНайденнойСтроки = Неопределено;
		
		Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
			// Поиск по коллекции рекурсивным перебором.
			Отбор = Новый Структура("ОбъектНаблюдения", ТекущаяСтрока);
			ИдентификаторНайденнойСтроки = НайтиДанныеФормыДеревоРекурсивно(Отбор, Настройки.ПолучитьЭлементы());
		КонецЕсли;
		
		Если ИдентификаторНайденнойСтроки = Неопределено Тогда
			Элементы.Настройки.ТекущаяСтрока = СтрокиНастройки[0].ПолучитьИдентификатор();
		Иначе
			Элементы.Настройки.ТекущаяСтрока = ИдентификаторНайденнойСтроки;
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияНастройки(ОбъектНаблюдения, Детализировать, Заполнять)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ОбъектНаблюдения", ОбъектНаблюдения);
	Отбор.Вставить("Детализировать",   Детализировать);
	
	НайденнаяСтрока = НайтиДанныеФормыДеревоРекурсивно(Отбор, Настройки.ПолучитьЭлементы());
	
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = Настройки.НайтиПоИдентификатору(НайденнаяСтрока);
	
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока.Заполнять = Заполнять;
	
КонецПроцедуры

// ЧтоИскать - Структура - Ключ - Имя поля, Значение - Искомое значение.
&НаСервереБезКонтекста
Функция НайтиДанныеФормыДеревоРекурсивно(ЧтоИскать, ГдеИскать)
	
	Для Каждого ЭлементСписка Из ГдеИскать Цикл
		
		ВсеПоляСовпадают = Истина;
		Для Каждого ЭлементОтбора Из ЧтоИскать Цикл
			Если ЭлементСписка[ЭлементОтбора.Ключ] <> ЭлементОтбора.Значение Тогда
				ВсеПоляСовпадают = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ВсеПоляСовпадают Тогда
			Возврат ЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
		
		РезультатПоискаНиже = НайтиДанныеФормыДеревоРекурсивно(ЧтоИскать, ЭлементСписка.ПолучитьЭлементы());
		Если РезультатПоискаНиже <> Неопределено Тогда
			Возврат РезультатПоискаНиже;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПредставление(СтрокаНастройки)
	
	СтрокаНастройки.Представление = РегистрыСведений.НастройкаЗаполненияФормСтатистики.ПредставлениеОбъектаНастройки(
		СтрокаНастройки.ОбъектНаблюдения,
		СтрокаНастройки.Детализировать,
		СтрокаНастройки.Детализация);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИерархиюНастроекРекурсивно(СтрокиЗаполняемогоДерева, ВыборкаИсходныхДанных, КэшИерархии)
	
	// Здесь добавляем только то, что определяется иерархией.
	// Строки для детальных настроек добавляем позже, вне этой процедуры.
	
	// Заполним дерево
	Пока ВыборкаИсходныхДанных.Следующий() Цикл
		
		Если ВыборкаИсходныхДанных.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда
			
			НоваяСтрока = ДобавитьСводнуюНастройкуОбъектаНаблюдения(СтрокиЗаполняемогоДерева, ВыборкаИсходныхДанных, КэшИерархии);
			
			ВыборкаСледующийУровеньИерархии = ВыборкаИсходныхДанных.Выбрать(
				ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, 
				ВыборкаИсходныхДанных.Группировка());
				
			Если НоваяСтрока = Неопределено Тогда
				// В дерево не добавляем объекты наблюдения, которые не требуют настроек.
				// Поэтому некоторые уровни дерева могут быть пропущены.
				СтрокиСледующегоУровня = СтрокиЗаполняемогоДерева;
			Иначе
				СтрокиСледующегоУровня = НоваяСтрока.ПолучитьЭлементы();
			КонецЕсли;
				
			ЗаполнитьИерархиюНастроекРекурсивно(
				СтрокиСледующегоУровня,
				ВыборкаСледующийУровеньИерархии,
				КэшИерархии);
			
		ИначеЕсли ВыборкаИсходныхДанных.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда
			
			// Выводим этот уровень только тогда, когда он не выведен на уровне иерархии.
			СтрокаДереваОбъектНаблюдения = КэшИерархии[ВыборкаИсходныхДанных.ОбъектНаблюдения];
			Если СтрокаДереваОбъектНаблюдения = Неопределено Тогда
				СтрокаДереваОбъектНаблюдения = ДобавитьСводнуюНастройкуОбъектаНаблюдения(
					СтрокиЗаполняемогоДерева, 
					ВыборкаИсходныхДанных, 
					КэшИерархии);
			КонецЕсли;
			
			Если СтрокаДереваОбъектНаблюдения = Неопределено Тогда
				// В дерево не добавляем объекты наблюдения, которые не требуют настроек.
				// Поэтому некоторые уровни дерева могут быть пропущены.
				Продолжить;
			КонецЕсли;
			
			// Дополним информацию об объекте списком строк, в которых данные об объекте указаны сводно.
			СтрокаДереваОбъектНаблюдения.НомераСтрокФормы = СписокНомеровСтрок(ВыборкаИсходныхДанных, Истина); 
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ДобавитьСводнуюНастройкуОбъектаНаблюдения(СтрокиЗаполняемогоДерева, СтрокаИсходныхДанных, КэшИерархии)
	
	Если Не СтрокаИсходныхДанных.ТребуетНастройки Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НоваяСтрока = СтрокиЗаполняемогоДерева.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсходныхДанных);
	КэшИерархии.Вставить(НоваяСтрока.ОбъектНаблюдения, НоваяСтрока);
	
	ЗаполнитьПредставление(НоваяСтрока);
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция СписокНомеровСтрок(ВыборкаИсходныхДанных, ТолькоСводные = Ложь)
	
	НомераСтрок  = Новый Массив;
	ВыборкаСтрок = ВыборкаИсходныхДанных.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСтрок.Следующий() Цикл
		
		Если ТипЗнч(ВыборкаСтрок.НомерСтрокиОтчета) <> Тип("Строка") 
			Или ПустаяСтрока(ВыборкаСтрок.НомерСтрокиОтчета) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ТолькоСводные Или Не ВыборкаСтрок.Детализировать Тогда
			НомераСтрок.Добавить(ВыборкаСтрок.НомерСтрокиОтчета);
		КонецЕсли;
		
	КонецЦикла;
	Возврат СтрСоединить(НомераСтрок, ",");
	
КонецФункции

&НаСервере
Функция ФормыДляЗаполненияСпискаНастроек()
	
	СписокФорм = Новый Массив();
	
	Если ЗначениеЗаполнено(ФормаСтатистики) Тогда
		
		СписокФорм.Добавить(ФормаСтатистики);
		
	Иначе
		НастраиваемыеФормы 
			= ЗаполнениеФормСтатистикиПереопределяемый.НастраиваемыеФормыСтатистикиПредоставляемыеОрганизацией(Организация);
		СписокФорм = НастраиваемыеФормы.ВыгрузитьКолонку("Форма");
		
	КонецЕсли;
	
	Возврат СписокФорм;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Настройка формы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
    Форма.Элементы.НомераСтрокФормы.Видимость = ЗначениеЗаполнено(Форма.ФормаСтатистики);

КонецПроцедуры	


&НаКлиенте
Процедура РазвернутьВсеУровниДереваНастроек()
	
	Для Каждого СтрокаНастройки Из Настройки.ПолучитьЭлементы() Цикл
		Элементы.Настройки.Развернуть(СтрокаНастройки.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
