#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Заполняет новое поле "Подразделение" в регистре накопления "Трудозатраты к оформлению".
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра = "ТрудозатратыКОформлению";
	ПолноеИмяРегистра = "РегистрНакопления.ТрудозатратыКОформлению";
	
	СписокДокументов = Новый Массив;
	//++ НЕ УТКА
	СписокДокументов.Добавить("Документ.МаршрутныйЛистПроизводства");
	СписокДокументов.Добавить("Документ.ЗаказНаРемонт");
	СписокДокументов.Добавить("Документ.ЭтапПроизводства2_2");
	//-- НЕ УТКА
	СписокДокументов.Добавить("Документ.ПроизводствоБезЗаказа");
	СписокДокументов.Добавить("Документ.ВыработкаСотрудников");
	
	Для каждого ПолноеИмяДокумента Из СписокДокументов Цикл
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		ТекстЗапросаМеханизмаПроведения = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
		Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
			ТекстЗапросаМеханизмаПроведения, ПолноеИмяРегистра, ПолноеИмяДокумента);
		
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	КонецЦикла;
	
	// Точечная отметка к обработке, включая объекты, требующие обновления.
	// - ОтметитьРегистраторыКОбработке не подходит т.к. не выявит различий до обновления объекта
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДД.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ТрудозатратыКОформлению КАК ДД
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ДД.Распоряжение) В (ТИП(Документ.ПроизводствоБезЗаказа)
	//++ НЕ УТКА
	|									,ТИП(Документ.ЭтапПроизводства2_2)
	//-- НЕ УТКА
	|	) И ДД.ПартияПроизводства = ЗНАЧЕНИЕ(Справочник.ПартииПроизводства.ПустаяСсылка)
	|");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"), ПолноеИмяРегистра);
	
КонецПроцедуры

// Заполняет новое поле "Подразделение" в регистре накопления "Трудозатраты к оформлению".
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	//++ НЕ УТКА
	Регистраторы.Добавить("Документ.МаршрутныйЛистПроизводства");
	Регистраторы.Добавить("Документ.ЗаказНаРемонт");
	Регистраторы.Добавить("Документ.ЭтапПроизводства2_2");
	//-- НЕ УТКА
	Регистраторы.Добавить("Документ.ПроизводствоБезЗаказа");
	Регистраторы.Добавить("Документ.ВыработкаСотрудников");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, "РегистрНакопления.ТрудозатратыКОформлению", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли