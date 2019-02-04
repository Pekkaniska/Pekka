
#Область ПрограммныйИнтерфейс

// Помещает данные переданного элемента вида отчета во временное хранилище формы.
//
// Параметры:
//  Элемент  - ДанныеФормыЭлементДерева,
//             ДанныеФормыЭлементКоллекции,
//             СтрокаДереваЗначений,
//             Структура,
//             СправочникСсылка.ЭлементыФинансовыхОтчетов, 
//             СправочникОбъект.ЭлементыФинансовыхОтчетов - помещаемый элемент отчета
//  АдресХранилища - УИД - УИД формы вида отчета
//  ОчиститьСсылки - Булево - Если истина тогда ссылка элемента справочника и ссылка владельца отчета будут очищены.
//                            При записи такого элемента отчета будет сформирована новая ссылка т.о. помещаемый элемент
//                            будет скопирован.
//
// Возвращаемое значение:
//   Строка - Адрес в хранилище
//
Функция ПоместитьЭлементВХранилище(Элемент, АдресХранилища = Неопределено, ОчиститьСсылки = Ложь) Экспорт
	
	// Если формируем хранилище на основании строки - 
	// тогда формируем по элементу, если есть, иначе по самой строке.
	Если ТипЗнч(Элемент) = Тип("ДанныеФормыЭлементДерева")
		ИЛИ ТипЗнч(Элемент) = Тип("ДанныеФормыЭлементКоллекции")
		ИЛИ ТипЗнч(Элемент) = Тип("СтрокаДереваЗначений") Тогда
		
		Если ЗначениеЗаполнено(Элемент.ЭлементОтчета) Тогда
			Возврат ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(Элемент.ЭлементОтчета, АдресХранилища, ОчиститьСсылки);
		Иначе
			
			СтруктураЭлемента = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
			ТипИтога = ПредопределенноеЗначение("Перечисление.ТипыИтогов.СальдоДт");
			ЗаполнитьЗначенияСвойств(СтруктураЭлемента, Элемент);
			СтруктураЭлемента.Вставить("ЭтоСвязанный", Ложь);
			Если Элемент.ЭтоСвязанный Тогда
				СтруктураЭлемента.Вставить("ЭтоСвязанный", Истина);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыводитьЗаголовокЭлемента", Истина);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КодСтрокиОтчета", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Примечание", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыделитьЭлемент", Ложь);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ЗаголовокОтчета")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("НередактируемыйТекст")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("РедактируемыйТекст")Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Текст", Элемент.СчетПоказательИзмерение);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ТаблицаПоказателиВСтроках")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ТаблицаПоказателиВКолонках")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ТаблицаСложная")Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыводитьЗаголовокЭлемента", Ложь);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("МонетарныйПоказатель") Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_СчетПланаСчетов", Элемент.СчетПоказательИзмерение);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ТипИтога", ТипИтога);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_НачальноеСальдо", Ложь);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КодСтрокиОтчета", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Примечание", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыделитьЭлемент", Ложь);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("НемонетарныйПоказатель") Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_НемонетарныйПоказатель", Элемент.СчетПоказательИзмерение);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КодСтрокиОтчета", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Примечание", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыделитьЭлемент", Ложь);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ПроизводныйПоказатель") Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Формула", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КодСтрокиОтчета", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Примечание", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыделитьЭлемент", Ложь);
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("Группа")
				ИЛИ СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ИтогПоГруппе") Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ВыводитьЗаголовокЭлемента", Истина);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КодСтрокиОтчета", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Примечание", "");
				
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("ЭлементТаблицы") Тогда
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_КодСтрокиОтчета", "");
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Примечание", "");
			
			ИначеЕсли СтруктураЭлемента.ВидЭлемента = ВидЭлемента("Измерение") Тогда
				ТипИзмерения = ОпределитьТипИзмеренияПоТипуЗначения(Элемент.СчетПоказательИзмерение, Элемент);
				СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ТипИзмерения", ТипИзмерения);
				
				Если ТипИзмерения = ТипИзмерения("ИзмерениеРегистраБухгалтерии") Тогда
					ИмяДопРеквизита = "ДополнительныйРеквизит_ИмяИзмерения";
				ИначеЕсли ТипИзмерения = ТипИзмерения("Период") Тогда
					ИмяДопРеквизита = "ДополнительныйРеквизит_Периодичность";
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_Сортировка", "ВОЗР");
					СтруктураЭлемента.Вставить("ДополнительныйРеквизит_ПредставлениеПериода", ПредопределенноеЗначение("Перечисление.ПредставлениеПериода.КонечнаяДата"));
				ИначеЕсли ТипИзмерения = ТипИзмерения("Субконто") Тогда
					ИмяДопРеквизита = "ДополнительныйРеквизит_ВидСубконто";
				КонецЕсли;
				
				СтруктураЭлемента.Вставить(ИмяДопРеквизита, Элемент.СчетПоказательИзмерение);
				
			КонецЕсли;
			
			Возврат ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(СтруктураЭлемента, АдресХранилища, ОчиститьСсылки);
			
		КонецЕсли;
	Иначе
		Возврат ФинансоваяОтчетностьВызовСервера.ПоместитьЭлементВХранилище(Элемент, АдресХранилища, ОчиститьСсылки);
	КонецЕсли;
	
КонецФункции

// Помещает данные переданного элемента вида отчета во временное хранилище формы без ссылки элемента справочника.
// При записи такого элемента отчета будет сформирована новая ссылка т.о. помещаемый элемент будет скопирован.
//
// Параметры:
//  Элемент  - ДанныеФормыЭлементДерева,
//             ДанныеФормыЭлементКоллекции,
//             СтрокаДереваЗначений,
//             Структура,
//             СправочникСсылка.ЭлементыФинансовыхОтчетов, 
//             СправочникОбъект.ЭлементыФинансовыхОтчетов - помещаемый элемент отчета
//  АдресХранилища - УИД - УИД формы вида отчета.
//
// Возвращаемое значение:
//   Строка - Адрес в хранилище
//
Функция ПоместитьКопиюЭлементаВХранилище(Элемент, АдресХранилища = Неопределено) Экспорт
	
	Возврат ПоместитьЭлементВХранилище(Элемент, АдресХранилища, Истина);
	
КонецФункции

// Функция возвращает структуру параметров для процедуры ЗаполнитьСтрокуДерева
//
// Параметры:
//  ДополнительныеРеквизитыСтроки - Строка - могут быть переданы дополнительные реквизиты строки дерева.
//
// Возвращаемое значение:
//  Структура - параметры для заполнения новой строки дерева значений элементов отчета.
//
Функция НовыеДанныеЗаполненияСтроки(ДополнительныеРеквизитыСтроки = "") Экспорт

	Если ПустаяСтрока(ДополнительныеРеквизитыСтроки) Тогда
		ДополнительныеРеквизитыСтроки = "СчетПланаСчетов,ТипИтога,НачальноеСальдо,НемонетарныйПоказатель,Текст,КодСтрокиОтчета,Примечание,ВыводитьЗаголовокЭлемента";
	КонецЕсли;

	Параметры = Новый Структура;
	Параметры.Вставить("Источник");
	Параметры.Вставить("СтрокаПриемник");
	Параметры.Вставить("АдресЭлементаВХранилище");
	Параметры.Вставить("Поле");
	Параметры.Вставить("ДополнительныеРеквизитыСтроки", ДополнительныеРеквизитыСтроки);
	Возврат Параметры;

КонецФункции

// Формирует стандартную структуру параметров для получения дерева элементов отчета
//
// Возвращаемое значение:
//  Структура - поля для формирования дерева новых (сохраненных) элементов финансовой отчетности.
//
Функция НовыеПараметрыДереваЭлементов() Экспорт

	РежимРаботы = ПредопределенноеЗначение("Перечисление.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчета");
	ВидПоказателей = ПредопределенноеЗначение("Перечисление.ВидыПоказателейОтчетности.Международные");
	ПараметрыДерева = Новый Структура;
	ПараметрыДерева.Вставить("ИмяЭлементаДерева", "ДеревоНовыхЭлементов");
	ПараметрыДерева.Вставить("РежимРаботы",       РежимРаботы);
	ПараметрыДерева.Вставить("ВидПоказателей",    ВидПоказателей);
	ПараметрыДерева.Вставить("БыстрыйПоиск",      "");
	ПараметрыДерева.Вставить("ФильтрПоВидуОтчета");
	ПараметрыДерева.Вставить("ТекущийВидОтчета");
	Возврат ПараметрыДерева;

КонецФункции

// Формирует стандартную структуру параметров формирования финансовой отчетности
//
// Возвращаемое значение:
//  Структура - поля параметров для формирования финансовой отчетности.
//
Функция НовыеПараметрыФормированияОтчета() Экспорт

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВидПериода");
	ПараметрыОтчета.Вставить("НачалоПериода");
	ПараметрыОтчета.Вставить("КонецПериода");
	ПараметрыОтчета.Вставить("Организация");
	ПараметрыОтчета.Вставить("Подразделение");
	ПараметрыОтчета.Вставить("НаправлениеДеятельности");
	ПараметрыОтчета.Вставить("ОткрытьФормы", Ложь);
	ПараметрыОтчета.Вставить("ФлагОткрытьФормы", Ложь);
	ПараметрыОтчета.Вставить("СуммыВТысячах", Ложь);
	ПараметрыОтчета.Вставить("ВидПоказателей");
	
	Возврат ПараметрыОтчета;

КонецФункции

// Формирует стандартную структуру одиночного элемента финансового отчета
//
// Возвращаемое значение:
//  Структура - поля одиночного элемента финансового отчета.
//
Функция НовыеДанныеОперанда() Экспорт

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("АдресСтруктурыЭлемента","");
	ПараметрыОтчета.Вставить("Идентификатор","");
	ПараметрыОтчета.Вставить("НестандартнаяКартинка");
	ПараметрыОтчета.Вставить("ВидЭлемента");
	ПараметрыОтчета.Вставить("ЭлементОтчета");
	ПараметрыОтчета.Вставить("НаименованиеДляПечати", "");
	ПараметрыОтчета.Вставить("СчетПоказательИзмерение");
	ПараметрыОтчета.Вставить("СчетПланаСчетов");
	ПараметрыОтчета.Вставить("ТипИтога");
	ПараметрыОтчета.Вставить("НачальноеСальдо", Ложь);
	ПараметрыОтчета.Вставить("НемонетарныйПоказатель");
	ПараметрыОтчета.Вставить("ЕстьНастройки", Ложь);
	ПараметрыОтчета.Вставить("ЭтоСвязанный", Ложь);
	ПараметрыОтчета.Вставить("ЕстьНастройки", Ложь);
	ПараметрыОтчета.Вставить("СвязанныйЭлемент");
	ПараметрыОтчета.Вставить("Код","");
	Возврат ПараметрыОтчета;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция определяет тип измерения финансового отчета
//
// Параметры:
//  Значение  - Произвольный - значение измерения финансового отчета
//                             на основании которого определяется тип измерения
//  ДополнительныеПараметры  - Структура - дополнительные сведения.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ТипыИзмеренийБюджетныхОтчетов - тип измерения.
//
Функция ОпределитьТипИзмеренияПоТипуЗначения(Значение, ДополнительныеПараметры = Неопределено)
	
	Если ТипЗнч(Значение) = Тип("ПеречислениеСсылка.Периодичность") Тогда
		
		Возврат ТипИзмерения("Период");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные")
		ИЛИ ТипЗнч(Значение) = Тип("ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные") Тогда
		
		Возврат ТипИзмерения("Субконто");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		
		Возврат ТипИзмерения("ИзмерениеРегистраБухгалтерии");
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестный тип измерения финансового отчета'");
		
	КонецЕсли;
	
КонецФункции

Функция ВидЭлемента(ИмяВидаЭлемента)
	
	Возврат ПредопределенноеЗначение("Перечисление.ВидыЭлементовФинансовогоОтчета."+ИмяВидаЭлемента);
	
КонецФункции

Функция ТипИзмерения(ИмяВидаЭлемента)
	
	Возврат ПредопределенноеЗначение("Перечисление.ТипыИзмеренийФинансовогоОтчета."+ИмяВидаЭлемента);
	
КонецФункции

#КонецОбласти
