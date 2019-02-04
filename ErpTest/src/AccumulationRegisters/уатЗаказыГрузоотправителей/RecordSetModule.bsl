Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

Перем МетаданныеДокумента, МетаданныеТабЧасти, ИмяДокумента, ИмяТабличнойЧасти, ИмяТаблицы, СтруктураШапкиДокумента, Отказ, Заголовок; 

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
// 
Процедура ВыполнитьПриход() Экспорт
	
	Если НЕ ЗначениеЗаполнено(мПериод) тогда
		мПериод = ЭтотОбъект.Отбор.Регистратор.Значение.Дата;
	КонецЕсли;

	Для каждого текСтрока Из мТаблицаДвижений Цикл
		НоваяЗапись = Добавить();
		НоваяЗапись.ВидДвижения           = ВидДвиженияНакопления.Приход;
		НоваяЗапись.Период                = мПериод;
		НоваяЗапись.Регистратор           = ЭтотОбъект.Отбор.Регистратор.Значение;
		НоваяЗапись.Контрагент            = ТекСтрока.Контрагент;
		НоваяЗапись.ДоговорКонтрагента    = текСтрока.ДоговорКонтрагента;
		НоваяЗапись.ЗаказГрузоотправителя = текСтрока.ЗаказГрузоотправителя;
		НоваяЗапись.Пакет                 = текСтрока.Пакет;
		НоваяЗапись.Количество            = текСтрока.Количество;
	КонецЦикла; 
	Записать();
	
КонецПроцедуры

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт
	
	Если НЕ ЗначениеЗаполнено(мПериод) тогда
		мПериод = ЭтотОбъект.Отбор.Регистратор.Значение.Дата;
	КонецЕсли;
	
	Для каждого текСтрока Из мТаблицаДвижений Цикл
		НоваяЗапись = Добавить();
		НоваяЗапись.ВидДвижения           = ВидДвиженияНакопления.Расход;
		НоваяЗапись.Период                = мПериод;
		НоваяЗапись.Регистратор           = ЭтотОбъект.Отбор.Регистратор.Значение;
		НоваяЗапись.Контрагент            = ТекСтрока.Контрагент;
		НоваяЗапись.ДоговорКонтрагента    = текСтрока.ДоговорКонтрагента;
		НоваяЗапись.ЗаказГрузоотправителя = текСтрока.ЗаказГрузоотправителя;
		НоваяЗапись.Пакет                 = ТекСтрока.Пакет;
		НоваяЗапись.Количество            = текСтрока.Количество;
	КонецЦикла; 
	// запись движений
	Записать();
	
КонецПроцедуры

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщение.
//
// Параметры:
//  ДокументОбъект - объект проводимого документа, 
//  Параметры      - структура, содержащая значения параметров необходимых для контроля остатков
//  Отказ          - флаг отказа в проведении,
//  Заголовок      - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабЧасти, СтруктураШапки, ОтказПроведения, ЗаголовокСообщения) Экспорт
	
	Если ИмяТабЧасти <> "" Тогда  
		Если ДокументОбъект[ИмяТабЧасти].Количество()=0 Тогда //если в таб.части ничего нет - не надо проверять
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ИмяТабличнойЧасти 		= ИмяТабЧасти;
	Отказ 					= ОтказПроведения;
   	СтруктураШапкиДокумента = СтруктураШапки;
	Заголовок 				= ЗаголовокСообщения;


	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;

	Если ИмяТабЧасти <>"" Тогда
		ИмяТаблицы = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);
	Иначе
		ИмяТаблицы = ИмяДокумента;
	КонецЕсли;

	Если ИмяТабЧасти <>"" Тогда
		МетаданныеТабЧасти       = МетаданныеДокумента.ТабличныеЧасти[ИмяТабЧасти];
	КонецЕсли;

	Если ИмяДокумента = "уатМаршрутныйЛист" Тогда
		КонтрольОстатков_МаршрутныйЛист(ДокументОбъект);
	Иначе
		Сообщить("Для документа "+ДокументОбъект+" не предусмотрен вызов процедуры 'Контроль остатков' модуля регистра 'Заказы на ТС'");
	КонецЕсли;
	
	ОтказПроведения = Отказ;
    ЗаголовокСообщения = Заголовок;

КонецПроцедуры // КонтрольОстатков()

Процедура КонтрольОстатков_МаршрутныйЛист(ДокументОбъект)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МаршрутныйЛист.ЗаказГрузоотправителя								КАК ЗаказНаТС,
	|	МаршрутныйЛист.Номенклатура 							КАК Номенклатура,
	|	МаршрутныйЛист.КоличествоВЕдиницеХраненияОстатков 		КАК КоличествоДокументЕдХрОстатков,   	//количество по документу в единице измерения остатков
	|	МаршрутныйЛист.Количество 								КАК КоличествоДокумент, 				//количество в единице измерения документа
	|	МаршрутныйЛист.ЕдиницаИзмерения							КАК ЕдиницаИзмеренияДокумент,
	|	ЕстьNULL(уатЗаказыНаТСОстатки.КоличествоОстаток, 0)		КАК КоличествоОстатокЗаказ,			// остаток по заказу в единице хранения остатков  
	|	ЕстьNULL(уатЗаказыНаТСОстатки.ЕдиницаИзмерения, МаршрутныйЛист.ЕдиницаИзмеренияПоЗаказу) КАК ЕдиницаИзмеренияЗаказ,
	|	МаршрутныйЛист.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаХраненияОстатков
	|ИЗ
	|	(ВЫБРАТЬ
	|		уатМаршрутныйЛистЗаказы.ЗаказГрузоотправителя 				 КАК ЗаказГрузоотправителя,
	|		уатМаршрутныйЛистЗаказы.Номенклатура 		 КАК Номенклатура,
	|		СУММА(уатМаршрутныйЛистЗаказы.Количество) 	 КАК Количество,         
	|		уатМаршрутныйЛистЗаказы.ЕдиницаИзмерения 	 КАК ЕдиницаИзмерения,
	|		ЕстьNULL(СУММА(ВЫРАЗИТЬ(уатМаршрутныйЛистЗаказы.Количество КАК Число(15,3))), 0) *
	|		ВЫБОР КОГДА уатМаршрутныйЛистЗаказы.ЕдиницаИзмерения = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА 1
	|			ИНАЧЕ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1)
	|		КОНЕЦ КАК КоличествоВЕдиницеХраненияОстатков,
	|		уатМаршрутныйЛистЗаказы.ЕдиницаИзмеренияПоЗаказу КАК ЕдиницаИзмеренияПоЗаказу
	|	ИЗ
	|		Документ.уатМаршрутныйЛист.Заказы КАК уатМаршрутныйЛистЗаказы
	|	ГДЕ
	|		уатМаршрутныйЛистЗаказы.Ссылка = &СсылкаМаршрутныйЛист
	|		И уатМаршрутныйЛистЗаказы.ТипТочкиМаршрута = &ТипТочкиМаршрутаРазгрузка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		уатМаршрутныйЛистЗаказы.ЗаказГрузоотправителя,
	|		уатМаршрутныйЛистЗаказы.Номенклатура,
	|		уатМаршрутныйЛистЗаказы.ЕдиницаИзмерения,
	|		уатМаршрутныйЛистЗаказы.ЕдиницаИзмеренияПоЗаказу
	|   ) КАК МаршрутныйЛист
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатЗаказыГрузоотправителей.Остатки(&Момент, ) КАК уатЗаказыНаТСОстатки
	|		ПО МаршрутныйЛист.ЗаказГрузоотправителя.Контрагент = уатЗаказыНаТСОстатки.Контрагент
	|			И МаршрутныйЛист.ЗаказГрузоотправителя = уатЗаказыНаТСОстатки.ЗаказГрузоотправителя
	|			И МаршрутныйЛист.Номенклатура = уатЗаказыНаТСОстатки.Номенклатура
	|			И МаршрутныйЛист.ЕдиницаИзмеренияПоЗаказу = уатЗаказыНаТСОстатки.ЕдиницаИзмерения";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"уатМаршрутныйЛистЗаказы.ЕдиницаИзмерения",
			"уатМаршрутныйЛистЗаказы.Номенклатура"));
			
	Запрос.УстановитьПараметр("Момент",						ДокументОбъект.МоментВремени());
	Запрос.УстановитьПараметр("СсылкаМаршрутныйЛист",		ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ТипТочкиМаршрутаРазгрузка",  Перечисления.уатТипыТочекМаршрута.Разгрузка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтрокаСообщения = "";
	Пока Выборка.Следующий() цикл
		Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПревышение = Выборка.КоличествоДокументЕдХрОстатков - Выборка.КоличествоОстатокЗаказ; //превышение в единице хранения остатков
		Если КоличествоПревышение > 0 Тогда
			СтрокаСообщения = "" + Символы.Таб + "Превышение списываемого количества для: '" + Выборка.ЗаказНаТС + "' по номенклатуре: '" + Выборка.Номенклатура  + "'.
				|"; 
			СтрокаСообщения = СтрокаСообщения
				+ "Превышение: " + КоличествоПревышение	+ " " + Выборка.ЕдиницаХраненияОстатков + "; "
				+ "Неразвезенный остаток: " + Выборка.КоличествоОстатокЗаказ + " " + Выборка.ЕдиницаХраненияОстатков + "; "
				+ "Количество по документу: " + Выборка.КоличествоДокумент + " " + Выборка.ЕдиницаИзмеренияДокумент + " ("
					+ Выборка.КоличествоДокумент + " " + ?(Выборка.ЕдиницаИзмеренияЗаказ = Неопределено, "",
					Выборка.ЕдиницаИзмеренияЗаказ.Наименование) + ").";
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
