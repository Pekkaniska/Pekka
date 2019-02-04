&НаКлиенте
Перем НужноЗакрытьФорму;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ВосстановитьНастройки()
	
	СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить("Обработка.уатАРММеханик.Форма.Форма", "ОбщиеНастройки");
	
	Возврат СтруктураНастроек;                          
	
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОтображатьВыбывшие", Элементы.СписокТСОтобразитьВыбывшие.Пометка);
	СтруктураНастроек.Вставить("СписокТСОтборПоТС",  ФлагОтбораТС);
	
	ХранилищеНастроекДанныхФорм.Сохранить("Обработка.уатАРММеханик.Форма.Форма", "ОбщиеНастройки", СтруктураНастроек);
КонецПроцедуры

&НаСервере
Процедура СформироватьПодчиненныеТаблицыПоВыбранномуТС(СсылкаТС)
	
	ТЗТабличноеПолеШины         = уатОбщегоНазначения.уатШиныТС(СсылкаТС);
	ТЗТабличноеПолеАккумуляторы = уатОбщегоНазначения.уатАккумуляторыТС(СсылкаТС);
	
	ЗначениеВДанныеФормы(ТЗТабличноеПолеШины,         ТабличноеПолеШины);
	ЗначениеВДанныеФормы(ТЗТабличноеПолеАккумуляторы, ТабличноеПолеАккумуляторы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЗШинПоТС(ВыбТС)
	
	ТЗТабличноеПолеУстановкаШины = уатОбщегоНазначения.уатШиныТС(ВыбТС);
	ЗначениеВДанныеФормы(ТЗТабличноеПолеУстановкаШины, ТабличноеПолеУстановкаШины);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияДанныхАвтомобиляВФорме()
	
	ВыбТСПолеВвода   = уатОбщегоНазначения.уатПредставлениеТС(ВыбТС, ТекОрганизация);
	
	ЗаполнитьТЗШинПоТС(ВыбТС);
	
	КешПоУстШинам.Очистить();
	Для Каждого Стр Из ТабличноеПолеУстановкаШины Цикл
		НоваяСтр = КешПоУстШинам.Добавить();
		НоваяСтр.Шина           = Стр.СерияНоменклатуры;
		НоваяСтр.МестоУстановки = Стр.МестоУстановки;
		НоваяСтр.Свободно       = Ложь; 
	КонецЦикла; 
	
	ИнициализацияДанныхМакетаТС();
	ТаблицаУстанавливаемыхАгрегатов.Очистить();
	БуферДляШин.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияДанныхМакетаТС()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	уатМестаУстановкиШин.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.уатМестаУстановкиШин КАК уатМестаУстановкиШин");
	
	СписокМестУстановки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	НастройкаРисунка.Очистить();
	Для Каждого ТекСтрока Из СписокМестУстановки Цикл
		НоваяШина = НастройкаРисунка.Добавить();
		НоваяШина.МестоУстановки = ТекСтрока.Ссылка;
		НоваяШина.Объект = СокрЛП("Шина_" + ТекСтрока.Ссылка);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ВыбТС.уатМодель.МакетТС) Тогда 
		ДокОбъект = ВыбТС.уатМодель.МакетТС.ПолучитьОбъект();
		РисунокКорпусаТС = ДокОбъект.ХранилищеМакета.Получить();
		ДеревоНастроек = ДокОбъект.ДеревоМакета.Получить();
		Если ДеревоНастроек <> Неопределено Тогда
			Если ДеревоНастроек.Колонки.Найти("РедактироватьЗначение") = Неопределено Тогда
				ДеревоНастроек.Колонки.Добавить("РедактироватьЗначение");
			КонецЕсли;
			Если ДеревоНастроек.Колонки.Найти("РедактироватьОбъект") = Неопределено Тогда
				ДеревоНастроек.Колонки.Добавить("РедактироватьОбъект");
			КонецЕсли;
			Попытка
				ЗначениеВРеквизитФормы(ДеревоНастроек, "НастройкаМакетаТС");
			Исключение
			КонецПопытки;
		КонецЕсли;
		
		//если рисунок не указан, по умолчанию рисуем корпус грузового авто
		Если НЕ ЗначениеЗаполнено(РисунокКорпусаТС) Тогда
			РисунокКорпусаТС = БиблиотекаКартинок.уатМакетГрузовогоАвто;
		КонецЕсли;
		
		ЗагрузитьДанныеИзМакета();
		
		ОтрисоватьМакет(ДокОбъект.ХранитьМакетВоВнешнемФайле);
	Иначе 
		ТабДок = Новый ТабличныйДокумент;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтрисоватьМакет(МакетВоВнешнемФайле)
	ДопМакет = Справочники.уатМакетыТС.ПолучитьМакет("Макет");
	
	ОтрисоватьКорпус(ДопМакет, МакетВоВнешнемФайле);
	ОтрисоватьШины(ДопМакет);
	
	ТабДок = ДопМакет;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеИзМакета()
	//Данные по корпусу авто
	КординатаX = 0;
	КординатаY = 0;
	ВысотаРисунка = 74;
	ШиринаРисунка = 12;
	
	НастройкаМакетаТСДерево = РеквизитФормыВЗначение("НастройкаМакетаТС");
	
	//Первоначальная загрузка, новый макет - строк нет
	Если НастройкаМакетаТСДерево.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ВеткаКорпусАвто = НастройкаМакетаТСДерево.Строки.Найти("КорпусАвто", "Объект");
	Если ВеткаКорпусАвто <> Неопределено Тогда
		Для Каждого ТекСтрокаНастройкаКорпусАвто Из ВеткаКорпусАвто.Строки Цикл
			Если ТекСтрокаНастройкаКорпусАвто.Объект = "Кордината X" Тогда
				КординатаX = ТекСтрокаНастройкаКорпусАвто.Значение;
			ИначеЕсли ТекСтрокаНастройкаКорпусАвто.Объект = "Кордината Y" Тогда
				КординатаY = ТекСтрокаНастройкаКорпусАвто.Значение;
			ИначеЕсли ТекСтрокаНастройкаКорпусАвто.Объект = "Ширина" Тогда
				ШиринаРисунка = ТекСтрокаНастройкаКорпусАвто.Значение;
			ИначеЕсли ТекСтрокаНастройкаКорпусАвто.Объект = "Высота" Тогда
				ВысотаРисунка = ТекСтрокаНастройкаКорпусАвто.Значение;
			ИначеЕсли ТекСтрокаНастройкаКорпусАвто.Объект = "Путь" Тогда
				ИмяФайла = ТекСтрокаНастройкаКорпусАвто.Значение;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	
	НастройкаРисункаТабл = РеквизитФормыВЗначение("НастройкаРисунка");
	
	//Таблица шин
	ВеткаШины = НастройкаМакетаТСДерево.Строки.Найти("Шины", "Объект");
	Если ВеткаШины <> Неопределено Тогда
		Для Каждого ТекСтрокаШины Из ВеткаШины.Строки Цикл
			СтрокаШиныВДереве = НастройкаРисункаТабл.Найти(ТекСтрокаШины.Объект, "Объект");
			Если СтрокаШиныВДереве <> Неопределено Тогда
				Для Каждого ТекСтрокаНастройкаШины Из ТекСтрокаШины.Строки Цикл
					Если ТекСтрокаНастройкаШины.Объект = "Кордината X" Тогда
						СтрокаШиныВДереве.КординатаX = ТекСтрокаНастройкаШины.Значение;
					ИначеЕсли ТекСтрокаНастройкаШины.Объект = "Кордината Y" Тогда
						СтрокаШиныВДереве.КординатаY = ТекСтрокаНастройкаШины.Значение;
					ИначеЕсли ТекСтрокаНастройкаШины.Объект = "Ширина" Тогда
						СтрокаШиныВДереве.Ширина = ТекСтрокаНастройкаШины.Значение;
					ИначеЕсли ТекСтрокаНастройкаШины.Объект = "Высота" Тогда
						СтрокаШиныВДереве.Высота = ТекСтрокаНастройкаШины.Значение;
					ИначеЕсли ТекСтрокаНастройкаШины.Объект = "Установлено" Тогда
						СтрокаШиныВДереве.Установлена = ТекСтрокаНастройкаШины.Значение;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(НастройкаРисункаТабл, "НастройкаРисунка");
КонецПроцедуры

&НаСервере
Процедура ОтрисоватьКорпус(МакетВывода, МакетВоВнешнемФайле)
	
	НоваяКартинка = МакетВывода.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
	НоваяКартинка.Лево = КординатаX;
	НоваяКартинка.Верх = КординатаY;
	НоваяКартинка.Высота = ВысотаРисунка;
	НоваяКартинка.Ширина = ШиринаРисунка;
	НоваяКартинка.РазмерКартинки = РазмерКартинки.Пропорционально;
	НоваяКартинка.ГраницаСлева = Ложь;
	НоваяКартинка.ГраницаСправа = Ложь;
	НоваяКартинка.ГраницаСверху = Ложь;
	НоваяКартинка.ГраницаСнизу = Ложь;
	
	Если МакетВоВнешнемФайле Тогда
		ФайлНаДиске = Новый Файл(ИмяФайла);
		Если ФайлНаДиске.Существует() Тогда
			Попытка
				НоваяКартинка.Картинка = Новый Картинка(ИмяФайла);  
			Исключение
				Сообщить("Ошибка открытия файла картинки: " + ИнформацияОбОшибке().Описание + " по причине " + ИнформацияОбОшибке().Причина, СтатусСообщения.Внимание)
			КонецПопытки;
		КонецЕсли;
	Иначе
		Попытка
			НоваяКартинка.Картинка = РисунокКорпусаТС;
		Исключение
			Сообщить("Ошибка отображения картинки: " + ИнформацияОбОшибке().Описание + " по причине " + ИнформацияОбОшибке().Причина, СтатусСообщения.Внимание)
		КонецПопытки;
	КонецЕсли;
	
	РисунокКорпусаТС = НоваяКартинка.Картинка;
	
	Если РисунокКорпусаТС = БиблиотекаКартинок.уатМакетГрузовогоАвто Тогда
		СтандартныйРисунок = 0;
	ИначеЕсли РисунокКорпусаТС = БиблиотекаКартинок.уатМакетЛегковогоАвто Тогда
		СтандартныйРисунок = 1;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтрисоватьШины(МакетВывода)
	НастройкаРисункаТабл = РеквизитФормыВЗначение("НастройкаРисунка");
	Для Каждого СтрокаШины Из НастройкаРисункаТабл Цикл
		Если НЕ СтрокаШины.Установлена Тогда
			Продолжить;
		КонецЕсли;
		НоваяКартинка = МакетВывода.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		НоваяКартинка.Лево = СтрокаШины.КординатаX;
		НоваяКартинка.Верх = СтрокаШины.КординатаY;
		НоваяКартинка.Ширина = СтрокаШины.Ширина;
		НоваяКартинка.Высота = СтрокаШины.Высота;
		НоваяКартинка.РазмерКартинки = РазмерКартинки.Пропорционально;
		НоваяКартинка.ЦветЛинии = ЦветаСтиля.ЦветРамки;
		НоваяКартинка.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.Сплошная, 2);
		Если СтрокаШины.Установлена Тогда 
			ПараметрыПоиска = Новый Структура("МестоУстановки", СтрокаШины.МестоУстановки);
			НайдСтроки = ТабличноеПолеУстановкаШины.НайтиСтроки(ПараметрыПоиска);
			Если НайдСтроки.Количество() Тогда 
				НоваяКартинка.ЦветФона = ЦветаСтиля.ТекстИнформационнойНадписи;
			Иначе 
				НоваяКартинка.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			КонецЕсли;
		Иначе 
			НоваяКартинка.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписокТС()
	
	Если ФлагОтбораТС Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокТС.Отбор, "ТО", 0,,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокТС.Отбор, "ТО", 0,,, Ложь);
	КонецЕсли;
	
	Если ФлагОтбораТС Тогда
		Элементы.СписокТСОтборПоТС.Заголовок = "Показать все ТС";
	Иначе
		Элементы.СписокТСОтборПоТС.Заголовок = "Отбор по ТС (Подошел срок ТО)";
	КонецЕсли;
	
	ФлагОтбораТС = Не ФлагОтбораТС;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКешПОНоменклатуре()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	уатАгрегатыТС.СерияНоменклатуры,
	|	уатАгрегатыТС.СерияНоменклатуры.Номер КАК СерийныйНомер,
	|	уатАгрегатыТС.ТипАгрегата,
	|	уатАгрегатыТС.Номенклатура,
	|	уатАгрегатыТС.МодельАгрегата КАК Модель,
	|	уатАгрегатыТС.Наименование,
	|	уатАгрегатыТС.МодельАгрегата.Производитель КАК Производитель
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС КАК уатАгрегатыТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатСостояниеАгрегатовТС.СрезПоследних КАК уатСостояниеАгрегатовТССрезПоследних
	|		ПО уатАгрегатыТС.СерияНоменклатуры = уатСостояниеАгрегатовТССрезПоследних.СерияНоменклатуры
	|			И уатАгрегатыТС.ТипАгрегата = уатСостояниеАгрегатовТССрезПоследних.ТипАгрегата
	|ГДЕ
	|	(уатСостояниеАгрегатовТССрезПоследних.СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	|			ИЛИ уатСостояниеАгрегатовТССрезПоследних.СостояниеАгрегата ЕСТЬ NULL )";
	
	ТЗКешПоОстаткамНоменклатуры = Запрос.Выполнить().Выгрузить();
	ТЗКешПоОстаткамНоменклатуры.Индексы.Добавить("Модель");
	
	ЗначениеВДанныеФормы(ТЗКешПоОстаткамНоменклатуры, КешПоОстаткамНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуОстатков()
	
	ОстаткиПоАгрегатам.Очистить();
	
	Если Элементы.ТаблицаПодбораАгрегатов.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	МассивНайденныхСтрок = КешПоОстаткамНоменклатуры.НайтиСтроки(Новый Структура("Модель", Элементы.ТаблицаПодбораАгрегатов.ТекущаяСтрока));
	Если МассивНайденныхСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлМассива Из МассивНайденныхСтрок Цикл 
		НоваяСтрока = ОстаткиПоАгрегатам.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлМассива);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВыболнитьОтборПоУсловиямКомпоновщика()
	
	Построитель = Новый ПостроительОтчета;
	Построитель.Текст =
	"ВЫБРАТЬ
	|	уатАгрегатыТС.Номенклатура КАК Номенклатура,
	|	уатАгрегатыТС.МодельАгрегата Как Модель
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС КАК уатАгрегатыТС
	|{ГДЕ
	|	уатАгрегатыТС.СерияНоменклатуры.Номер КАК СерийныйНомер,
	|	уатАгрегатыТС.Номенклатура.* КАК Номенклатура,
	|	уатАгрегатыТС.МодельАгрегата.* КАК Модель,
	|	уатАгрегатыТС.ТипАгрегата.* КАК ТипАгрегата,
	|	уатАгрегатыТС.МодельАгрегата.ШинаСезонность.* КАК ШинаСезонность}";
	
	Построитель.Параметры.Вставить("Дата", ТекущаяДата());
	
	Для Каждого ТекОтбор Из Фильтры.Настройки.Отбор.Элементы Цикл 
		Если ТекОтбор.Использование И ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипАгрегата") Тогда 
			ПолеОтбора = Построитель.Отбор.Добавить("ТипАгрегата",,"Тип агрегата");
			ПолеОтбора.ВидСравнения  = ВидСравнения.Равно;
			ПолеОтбора.Использование = Истина;
			ПолеОтбора.Значение      = ТекОтбор.ПравоеЗначение;
		КонецЕсли;
		Если ТекОтбор.Использование И ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Модель") Тогда 
			ПолеОтбора = Построитель.Отбор.Добавить("Модель",,"Модель");
			ПолеОтбора.ВидСравнения  = ВидСравнения.Равно;
			ПолеОтбора.Использование = Истина;
			ПолеОтбора.Значение      = ТекОтбор.ПравоеЗначение;
		КонецЕсли;
		Если ТекОтбор.Использование И ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ШинаСезонность") Тогда 
			ПолеОтбора = Построитель.Отбор.Добавить("ШинаСезонность",,"Сезонность");
			ПолеОтбора.ВидСравнения  = ВидСравнения.Равно;
			ПолеОтбора.Использование = Истина;
			ПолеОтбора.Значение      = ТекОтбор.ПравоеЗначение;
		КонецЕсли;
		Если ТекОтбор.Использование И ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номенклатура") Тогда 
			ПолеОтбора = Построитель.Отбор.Добавить("Номенклатура",,"Номенклатура");
			ПолеОтбора.ВидСравнения  = ВидСравнения.Равно;
			ПолеОтбора.Использование = Истина;
			ПолеОтбора.Значение      = ТекОтбор.ПравоеЗначение;
		КонецЕсли;
		Если ТекОтбор.Использование И ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СерийныйНомер") Тогда 
			ПолеОтбора = Построитель.Отбор.Добавить("СерийныйНомер",,"Серийный номер");
			ПолеОтбора.ВидСравнения  = ВидСравнения.Равно;
			ПолеОтбора.Использование = Истина;
			ПолеОтбора.Значение      = ТекОтбор.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;
	
	Построитель.Выполнить();
	
	РезультатЗапросаПоФильтру = Построитель.Результат.Выгрузить().ВыгрузитьКолонку("Модель");
	СписокНоменклатуры.ЗагрузитьЗначения(РезультатЗапросаПоФильтру);
	
	ТаблицаПодбораАгрегатов.Отбор.Элементы.Очистить();
	Отбор = ТаблицаПодбораАгрегатов.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Ссылка");
	Отбор.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
	Отбор.ПравоеЗначение   = СписокНоменклатуры;
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Отбор.Использование    = Истина;
	
КонецФункции // ВыболнитьОтборПоУсловиямКомпоновщика()

&НаСервере
Функция СоздатьДокументСервер()
	
	ДокОбъект = РеквизитФормыВЗначение("ОперацииСАгрегатами");;
	ДокОбъект.Дата = ТекущаяДата();
		
	уатОбщегоНазначенияСервер.ЗаполнитьШапкуДокумента(ДокОбъект,,,,,,,);
	
	ДокОбъект.Организация      = ТекОрганизация;
	ДокОбъект.Ответственный    = ПользователиКлиентСервер.ТекущийПользователь();
	
	ТЗТаблицаУстанавливаемыхАгрегатов = РеквизитФормыВЗначение("ТаблицаУстанавливаемыхАгрегатов", Тип("ТаблицаЗначений"));
	
	Для Каждого СтрТз Из БуферДляШин Цикл
		НайдСтроки = ТабличноеПолеУстановкаШины.НайтиСтроки(Новый Структура("СерияНоменклатуры", СтрТз.СерияНоменклатуры));
		Если НайдСтроки.Количество() Тогда 
			НоваяСтр = ТЗТаблицаУстанавливаемыхАгрегатов.Добавить();
			НоваяСтр.СерияНоменклатуры = СтрТз.СерияНоменклатуры;
			НоваяСтр.Установить        = -1;
			НоваяСтр.МестоУстановки    = СтрТз.МестоУстановки;
			НоваяСтр.Характеристики    = СтрТз.Характеристики;
			НоваяСтр.Производитель     = СтрТз.Производитель;
		КонецЕсли;
	КонецЦикла;
	ТЗТаблицаУстанавливаемыхАгрегатов.Свернуть("Характеристики,Производитель,СерияНоменклатуры,МестоУстановки","Установить");
	МассСтрок = ТЗТаблицаУстанавливаемыхАгрегатов.НайтиСтроки(Новый Структура("Установить",0));
	Для Каждого МассСтрокЭл Из МассСтрок Цикл
		ТаблицаУстанавливаемыхАгрегатов.Удалить(МассСтрокЭл);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗТаблицаУстанавливаемыхАгрегатов, "ТаблицаУстанавливаемыхАгрегатов");
	
	ОбновитьОтображениеТаблицыУстанавливаемыхАгрегатов();
	
	Для Каждого СтрТз Из ТаблицаУстанавливаемыхАгрегатов Цикл
		НоваяСтр = ДокОбъект.ПрочиеАгрегаты.Добавить();
		НоваяСтр.ТС = ВыбТС;
		НоваяСтр.СерияНоменклатуры = СтрТз.СерияНоменклатуры;
		НоваяСтр.МестоУстановки    = СтрТз.МестоУстановки;
		Если СтрТз.Установить = 1 Тогда
			Если СтрТз.МестоУстановки  = Справочники.уатМестаУстановкиШин.ЗАП Тогда
				НоваяСтр.Состояние = Перечисления.уатСостоянияАгрегатов.УстановленоВЗапас;
			Иначе
				НоваяСтр.Состояние = Перечисления.уатСостоянияАгрегатов.УстановленоВРаботе;
			КонецЕсли;
		Иначе
			НоваяСтр.Состояние = Перечисления.уатСостоянияАгрегатов.Снято;
		КонецЕсли;
	КонецЦикла;
	
	Рез = Ложь;
	
	Если ДокОбъект.ПроверитьЗаполнение() Тогда
		Попытка 
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
			ЗначениеВРеквизитФормы(ДокОбъект, "ОперацииСАгрегатами");
			Рез = Истина;
		Исключение
			Сообщить(ИнформацияОбОшибке().Описание + ": " + ИнформацияОбОшибке().Причина);
		КонецПопытки;
	КонецЕсли;
	
	Возврат Рез;
	
КонецФункции

// Обновляет остатки шин в ТЧ
//
&НаКлиенте
Процедура ОбновитьДанныеПриСозданииРЛШин(Параметр1, Параметр2) Экспорт 
	
	СформироватьКешПОНоменклатуре();
	ОбновитьТаблицуОстатков();
	
КонецПроцедуры // ОбновитьДанныеПриСозданииРЛШин()

&НаСервере
Процедура ОбновитьОтображениеТаблицыУстанавливаемыхАгрегатов()
	
	ТЗТаблицаУстанавливаемыхАгрегатов = ДанныеФормыВЗначение(ТаблицаУстанавливаемыхАгрегатов, Тип("ТаблицаЗначений"));
	
	ТЗТаблицаУстанавливаемыхАгрегатов.Свернуть("Характеристики,Производитель,СерияНоменклатуры,МестоУстановки","Установить");
	МассСтрок = ТЗТаблицаУстанавливаемыхАгрегатов.НайтиСтроки(Новый Структура("Установить",0));
	Для Каждого МассСтрокЭл Из МассСтрок Цикл
		ТЗТаблицаУстанавливаемыхАгрегатов.Удалить(МассСтрокЭл);
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ТЗТаблицаУстанавливаемыхАгрегатов, ТаблицаУстанавливаемыхАгрегатов);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФильтры()
	
	МакетКомпоновки  = Обработки.уатАРММеханик.ПолучитьМакет("НастройкиОтбора");
	URLСхемы         = ПоместитьВоВременноеХранилище(МакетКомпоновки,УникальныйИдентификатор);
	
	Фильтры.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
	Фильтры.ЗагрузитьНастройки(МакетКомпоновки.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	УстановитьОтборСписокТС();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМестаУстановки()
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст =
	"ВЫБРАТЬ
	|	уатМестаУстановкиШин.Ссылка,
	|	уатМестаУстановкиШин.Наименование
	|ИЗ
	|	Справочник.уатМестаУстановкиШин КАК уатМестаУстановкиШин";
	
	Выборка = мЗапрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		МестаУстановки.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция МожноУстановитьШину(Место)
	мШина = КешПоУстШинам.НайтиСтроки(Новый Структура("МестоУстановки", Место));
	Если мШина.Количество() = 0 Тогда
		Стр = КешПоУстШинам.Добавить(); 
		Стр.МестоУстановки = Место;
		Стр.Свободно = Истина;
		Возврат Истина;
	КонецЕсли;
	Возврат мШина[0].Свободно;
КонецФункции

&НаСервере
Процедура ДобавитьШинуВТабУА(АгрегатСтруктура, МестоУст)
	
	СтрТз = ТаблицаУстанавливаемыхАгрегатов.Добавить();
	СтрТз.Установить        = 1;
	СтрТз.Характеристики    = АгрегатСтруктура.Наименование;
	СтрТз.Производитель     = АгрегатСтруктура.Производитель;
	СтрТз.СерияНоменклатуры = АгрегатСтруктура.Агрегат;
	СтрТз.МестоУстановки    = МестоУст;
	СтрКеш = КешПоУстШинам.НайтиСтроки(Новый Структура("МестоУстановки", МестоУст));
	Если СтрКеш.Количество() = 0 Тогда
		НоваяСтр = КешПоУстШинам.Добавить();
		НоваяСтр.Шина     = СтрТз.СерияНоменклатуры;
		НоваяСтр.Место    = СтрТз.МестоУстановки;
		НоваяСтр.Свободно = Ложь; 
	Иначе
		СтрКеш[0].Шина     = СтрТз.СерияНоменклатуры;
		СтрКеш[0].Свободно = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПереместитьШинуВБуфер(мШина)
	
	СтрТз = БуферДляШин.Добавить();
	СтрТз.Характеристики    = мШина.Характеристики;
	СтрТз.Производитель     = мШина.Производитель;                                                       
	СтрТз.СерияНоменклатуры = мШина.СерияНоменклатуры;
	СтрТз.МестоУстановки    = мШина.МестоУстановки;
	СтрКеш = КешПоУстШинам.НайтиСтроки(Новый Структура("МестоУстановки", мШина.МестоУстановки));
	Если СтрКеш.Количество() = 0 Тогда
		НоваяСтр = КешПоУстШинам.Добавить();
		НоваяСтр.Место    = СтрТЗ.МестоУстановки;
		НоваяСтр.Свободно = Истина; 
	Иначе
		СтрКеш[0].Свободно = Истина; 
	КонецЕсли;
	Масс = ТаблицаУстанавливаемыхАгрегатов.НайтиСтроки(Новый Структура("СерияНоменклатуры", мШина.СерияНоменклатуры));
	Для Каждого МассЭл Из Масс Цикл
		ТаблицаУстанавливаемыхАгрегатов.Удалить(МассЭл);
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВыбывшие()
	
	Если Элементы.СписокТСОтобразитьВыбывшие.Пометка Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокТС.Отбор, "ДатаВыбытия", '00010101',,, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокТС.Отбор, "ДатаВыбытия", '00010101',,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		НужноЗакрытьФорму = Неопределено;
	Иначе
		НужноЗакрытьФорму = Истина;
		Закрыть();
    КонецЕсли;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		АвтоТест = Истина;
	КонецЕсли;
	
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекОрганизация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.ТекущийПользователь(), "ОсновнаяОрганизация");
	
	ТекПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	мВремяДоОкончанияДействияДокументовТС = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ТекПользователь, "ОсновнаяОрганизация"),
		ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ДниДоОкончанияДействияДокументовТС"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокТС, "ДниДоОкончанияДействияДокументовТС", мВремяДоОкончанияДействияДокументовТС);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокТС, "ДатаОкончания", ТекущаяДата());
	
	СформироватьКешПОНоменклатуре();
	//СформироватьКритерииОтбора();
	Элементы.СписокТСОтборПоТС.Заголовок = "Отбор по ТС (Подошел срокТО)";
	
	ЗначениеВДанныеФормы(уатОбщегоНазначения.уатШиныТС(ВыбТС), ТабличноеПолеУстановкаШины);
	//ЗначениеВДанныеФормы(уатОбщегоНазначения.уатАккумуляторыТС(ВыбТС), ТабличноеПолеУстановкаАккумуляторы);
	ОбновитьОтображениеТаблицыУстанавливаемыхАгрегатов();
	
	НастроитьФильтры();
	
	УстановитьВидимостьДоступность();
	
	ЗаполнитьМестаУстановки();
	             
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтруктураНастроек    = ВосстановитьНастройки();
	НастройкиНекорректны = (СтруктураНастроек = Неопределено Или ТипЗнч(СтруктураНастроек) <> Тип("Структура"));
	
	//отображение выбывших ТС
	Если НастройкиНекорректны Или (Не СтруктураНастроек.Свойство("ОтображатьВыбывшие")) Тогда
		ОтображатьВыбывшие = Ложь;
	Иначе
		ОтображатьВыбывшие = СтруктураНастроек.ОтображатьВыбывшие;
	КонецЕсли;
	
	//отбор по ТС
	Если НастройкиНекорректны Или (Не СтруктураНастроек.Свойство("СписокТСОтборПоТС")) Тогда
		ФлагОтбораТС = Ложь;
	Иначе
		ФлагОтбораТС = Не СтруктураНастроек.СписокТСОтборПоТС;
	КонецЕсли;
	
	УстановитьОтборСписокТС();
	
	Элементы.СписокТСОтобразитьВыбывшие.Пометка = ОтображатьВыбывшие;
	УстановитьОтборВыбывшие();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда 
		НужноЗакрытьФорму = Истина;
		Возврат;
		
	ИначеЕсли Не АвтоТест И НужноЗакрытьФорму <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение,"АРМ Механика будет закрыт. Продолжить?", Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПодбораАгрегатовПриАктивизацииСтроки(Элемент)
	
	ОбновитьТаблицуОстатков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоАгрегатамНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ФИспользоватьБуфер = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаПриИзменении(Элемент)
	
	уатИнтерфейсВводаТС.НомерТСПриИзменении(ВыбТСПолеВвода, ВыбТС, ТекОрганизация);
	Если ЗначениеЗаполнено(ВыбТС) Тогда
		ИнициализацияДанныхАвтомобиляВФорме();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	
	СтруктураОтбора = Новый Структура;
	Если ЗначениеЗаполнено(ОперацииСАгрегатами.Организация) Тогда
		СтруктураОтбора.Вставить("уатОрганизация", ОперацииСАгрегатами.Организация);
	КонецЕсли;
	уатИнтерфейсВводаТС.НомерТСНачалоВыбора(Элемент, ВыбТС, СтруктураОтбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаОчистка(Элемент, СтандартнаяОбработка)
	
	Очистить(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаОткрытие(Элемент, СтандартнаяОбработка)
	
	уатИнтерфейсВводаТС.НомерТСОткрытие(ВыбТС, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	мТС = ВыбТС;
	
	уатИнтерфейсВводаТС.НомерТСОбработкаВыбора(ВыбТСПолеВвода, ВыбТС, ВыбранноеЗначение, СтандартнаяОбработка, ТекОрганизация);
	
	Если Не мТС = ВыбТС Тогда
		ИнициализацияДанныхАвтомобиляВФорме();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	уатИнтерфейсВводаТС.НомерТСАвтоПодборТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, ТекОрганизация);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбТСПолеВводаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.НомерТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка, ОперацииСАгрегатами.Организация);
КонецПроцедуры

&НаКлиенте
Процедура ВыбСкладПриИзменении(Элемент)
	
	НайдОтбор = Неопределено;
	
	Для Каждого ТекОтбор Из Фильтры.Настройки.Отбор.Элементы Цикл 
		Если ТекОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Склад") Тогда 
			НайдОтбор = ТекОтбор;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не НайдОтбор = Неопределено Тогда
		НайдОтбор.Использование = Истина;
		НайдОтбор.ПравоеЗначение = ОперацииСАгрегатами.СкладОтправитель;
	Иначе 
		// добавить строку отбора
	КонецЕсли;
	
	СформироватьКешПОНоменклатуре();
	ВыболнитьОтборПоУсловиямКомпоновщика();
	ОбновитьТаблицуОстатков();
	
КонецПроцедуры

&НаКлиенте
Процедура БуферДляШинНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ФИспользоватьБуфер = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура БуферДляШинПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	//ФлагОтмена = Истина;
	//Если Не (ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Картинка") ) Тогда
	//	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	//КонецЕСли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура БуферДляШинПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Не ЗначениеЗаполнено(ОперацииСАгрегатами.СкладПолучатель) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(Неопределено, "Не заполнен склад-получатель!", 10);
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыПеретаскивания.Значение.Количество() = 0 Тогда 
		Если ПараметрыПеретаскивания.Значение[0].Свойство("Склад") Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьПредупреждение(Неопределено, "Нельзя перетаскивать шины со склада в это поле", 10);
			Возврат;
		КонецЕсли;
		СтруктураСтроки = Новый Структура("Характеристики, Производитель, СерияНоменклатуры, МестоУстановки");
		СтруктураСтроки.Характеристики    = ПараметрыПеретаскивания.Значение[0].Характеристики;
		СтруктураСтроки.Производитель     = ПараметрыПеретаскивания.Значение[0].Производитель;
		СтруктураСтроки.СерияНоменклатуры = ПараметрыПеретаскивания.Значение[0].СерияНоменклатуры;
		СтруктураСтроки.МестоУстановки    = ПараметрыПеретаскивания.Значение[0].МестоУстановки;
		ПереместитьШинуВБуфер(СтруктураСтроки);
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура БуферДляШинПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУстанавливаемыхАгрегатовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУстанавливаемыхАгрегатовПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУстанавливаемыхАгрегатовПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ВыбТС) Тогда
		ПоказатьПредупреждение(Неопределено, "Не выбрано ТС",,"Ошибка");
		Возврат;
	КонецЕсли;
	
	Если ФИспользоватьБуфер Тогда
		Если Элементы.БуферДляШин.ТекущиеДанные = Неопределено Тогда
			ПоказатьПредупреждение(Неопределено, "Не выбран элемент для перетаскивания",,"Ошибка");
				Возврат;
		КонецЕсли; 
		Агрегат = Элементы.БуферДляШин.ТекущиеДанные.СерияНоменклатуры;
		ТипАгрегата = уатОбщегоНазначенияТиповыеСервер.ПолучитьЗначениеРеквизита(Агрегат, "ТипАгрегата");
		Если Не ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
			ПоказатьПредупреждение(Неопределено, "Перетаскивать можно только шины",,"Ошибка");
			Возврат;
		КонецЕсли;
		
		МестаУстановки.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ТаблицаУстанавливаемыхАгрегатовПеретаскиваниеЗавершение",
			ЭтотОбъект, Новый Структура("Агрегат", Агрегат)), "Укажите место установки");
        Возврат;
		
	Иначе
		ТекСтрока = Элементы.ОстаткиПоАгрегатам.ТекущиеДанные;
		Если ТекСтрока = Неопределено Тогда
			ПоказатьПредупреждение(Неопределено, "Не выбран элемент для перетаскивания",,"Ошибка");
			Возврат;
		КонецЕсли;
		
		Если ТекСтрока.ТипАгрегата <> ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
			ПоказатьПредупреждение(Неопределено, "Перетаскивать можно только шины",,"Ошибка");
			Возврат;
		КонецЕсли;
		
		ПроверкаШины = КешПоУстШинам.НайтиСтроки(Новый Структура("Шина", ТекСтрока.СерийныйНомер));
		Для Каждого Стр Из ПроверкаШины Цикл
			Если Стр.Свободно = Ложь Тогда
				ПоказатьПредупреждение(Неопределено, "Эта шина уже стоит на ТС",,"Ошибка");
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
		ДопПараметры = Новый Структура("Агрегат, Наименование, Производитель", ТекСтрока.СерияНоменклатуры, ТекСтрока.Наименование, ТекСтрока.Производитель);
		МестаУстановки.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ТаблицаУстанавливаемыхАгрегатовПеретаскиваниеЗавершение1",
			ЭтотОбъект, ДопПараметры), "Укажите место установки");
        Возврат;
		
	КонецЕсли;
	
	ОбновитьОтображениеТаблицыУстанавливаемыхАгрегатов();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУстанавливаемыхАгрегатовПеретаскиваниеЗавершение1(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда 
		ПоказатьПредупреждение(Неопределено, "Не выбрано место установки шины",,"Ошибка");
		Возврат;
	Иначе
		МестоУст = ВыбранныйЭлемент.Значение;
		Если МожноУстановитьШину(МестоУст) Тогда 
			ДобавитьШинуВТабУА(ДополнительныеПараметры, МестоУст);
		Иначе
			ПоказатьПредупреждение(Неопределено, "На данном месте уже есть шина",,"Ошибка");
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьОтображениеТаблицыУстанавливаемыхАгрегатов();

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУстанавливаемыхАгрегатовПеретаскиваниеЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, "Не выбрано место установки шины",,"Ошибка");
		Возврат;
	Иначе
		МестоУст = ВыбранныйЭлемент.Значение;
		Если МожноУстановитьШину(МестоУст) Тогда 
			ДобавитьШинуВТабУА(ДополнительныеПараметры.Агрегат, МестоУст);
			ТекСтрока = Элементы.БуферДляШин.ТекущиеДанные;
			БуферДляШин.Удалить(ТекСтрока);
		Иначе
			ПоказатьПредупреждение(Неопределено, "На данном месте уже есть шина",,"Ошибка");
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьОтображениеТаблицыУстанавливаемыхАгрегатов();

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУстанавливаемыхАгрегатовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеУстановкаШиныПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыНастройкиОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СформироватьКешПОНоменклатуре();
	ВыболнитьОтборПоУсловиямКомпоновщика();
	ОбновитьТаблицуОстатков();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекСтрока = Элементы.СписокТС.ТекущиеДанные;
	
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбТС) Тогда
		ОписанОповещ = Новый ОписаниеОповещения("СписокТСВыборЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписанОповещ, "На закладке Агрегаты значение ТС изменится на выбранное. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Иначе
		УстановитьТСПриВыбореИзСпискаТС();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокТСВыборЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		УстановитьТСПриВыбореИзСпискаТС();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТСПриВыбореИзСпискаТС()
	ТекСтрока = Элементы.СписокТС.ТекущиеДанные;
	
	ВыбТС = ТекСтрока.Ссылка;
	ИнициализацияДанныхАвтомобиляВФорме();
	Элементы.ГруппаСтраницРазделов.ТекущаяСтраница = Элементы.ГруппаСтраницРазделов.ПодчиненныеЭлементы.Агрегаты;
КонецПроцедуры

&НаКлиенте
Процедура СписокТСПриАктивизацииСтроки(Элемент)
	
	// Вывод информации о подходе ТО
	Если Элементы.СписокТС.ТекущаяСтрока = Неопределено Или
		Элементы.СписокТС.ТекущаяСтрока = ПредопределенноеЗначение("Справочник.ТранспортныеСредства.ПустаяСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	//вывод информации по агрегатам
	СформироватьПодчиненныеТаблицыПоВыбранномуТС(Элементы.СписокТС.ТекущаяСтрока);
	
	//связанные документы
	СостояниеАгрегатовТС.Отбор.Элементы.Очистить();
	ЭлементОтбора                  = СостояниеАгрегатовТС.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ТС");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение   = Элементы.СписокТС.ТекущаяСтрока;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование    = Истина;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ОтборПоТС(Команда)
	
	УстановитьОтборСписокТС();
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	СформироватьКешПоНоменклатуре();
	ОбновитьОтображениеДанных();
	ОбновитьТаблицуОстатков();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	//проверяем склад для снятия
	Если БуферДляШин.Количество() > 0 И ОперацииСАгрегатами.СкладПолучатель.Пустая() Тогда
		Сообщить("Не указан склад-получатель для снимаемых шин!");
		Возврат;
	КонецЕсли;
	
	//проверяем склад для установки
	Если ТаблицаУстанавливаемыхАгрегатов.Количество() > 0 И ОперацииСАгрегатами.СкладОтправитель.Пустая() Тогда
		Сообщить("Не указан склад-отправитель для устанавливаемых шин!");
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьДокументЗавершение", ЭтотОбъект),
		"Будет сформирован документ ""Операции с аграгатами"". Продолжить?",
		РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		флСоздан = СоздатьДокументСервер();
		
		Если флСоздан Тогда
			Если флОткрыватьДокументыПриСоздании Тогда
				ПоказатьЗначение(Неопределено, ОперацииСАгрегатами.Ссылка);
			КонецЕсли;
			Если флОчищатьПриСозданииДокументов Тогда
				Очистить(Неопределено);
			КонецЕсли;
			ОбновитьОтображениеДанных();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьСервер();
	ИнициализацияДанныхАвтомобиляВФорме();
КонецПроцедуры

&НаСервере
Процедура ОчиститьСервер()
	ДокОперации = Документы.уатОперацииСАгрегатами.СоздатьДокумент();
	ЗначениеВРеквизитФормы(ДокОперации, "ОперацииСАгрегатами");
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВыбывшие(Команда)
	
	Элементы.СписокТСОтобразитьВыбывшие.Пометка = НЕ Элементы.СписокТСОтобразитьВыбывшие.Пометка;
	УстановитьОтборВыбывшие();
	СохранитьНастройки();
	
КонецПроцедуры
