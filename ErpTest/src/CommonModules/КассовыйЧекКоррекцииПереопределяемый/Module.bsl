#Область ПрограммныйИнтерфейс

#Область МодульОбъекта

// Переопределяемая процедура обработки заполнения.
// Вызывается из модуля объекта "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  ДанныеЗаполнения - Данные заполнения, переданные при программном и интерфейсном вызове процедуры
//  СтандартнаяОбработка - Булево, см. описание процедуры ОбработкаЗаполнения модуля документа
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Объект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая перед записью.
// Вызывается из модуля объекта "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  Отказ, РежимЗаписи, РежимПроведения - см. описание процедуры "ПередЗаписью" модуля документа
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура обработки проведения.
// Вызывается из модуля объекта "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  Отказ, РежимПроведения - см. описание процедуры "ОбработкаПроведения" модуля документа
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая при копировании.
// Вызывается из модуля объекта "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  ОбъектКопирования - ДокументОбъект.КассовыйЧекКоррекции, копируемый документ
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	Объект.НомерЧекаККМ   = 0;
	Объект.ПробитЧек      = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ФормаДокумента

#Область ФормаДокументаОбработчикиСобытийФормы

// Переопределяемая процедура, вызываемая при создании.
// Вызывается из модуля формы документа "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  Форма  - Форма документа КассовыйЧекКоррекции
//  Отказ, СтандартнаяОбработка - см. описание процедуры "ПриСозданииНаСервере" модуля формы документа
//
Процедура ПриСозданииНаСервере(Объект, Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Форма.ИспользоватьПодключаемоеОборудование = МенеджерОборудованияВызовСервераПереопределяемый.ИспользоватьПодключаемоеОборудование();
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая при чтении.
// Вызывается из модуля формы документа "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  Форма  - Форма документа КассовыйЧекКоррекции
//  ТекущийОбъект - см. описание процедуры "ПриЧтенииНаСервере" модуля формы документа
//
Процедура ПриЧтенииНаСервере(Объект, Форма, ТекущийОбъект) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая перед записью на сервере.
// Вызывается из модуля формы документа "КассовыйЧекКоррекции"
// 
// Параметры:
//  Форма  - Форма документа КассовыйЧекКоррекции
//  Отказ, ТекущийОбъект, ПараметрыЗаписи - см. описание процедуры "ПередЗаписьюНаСервере" модуля формы документа
//
Процедура ПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ФормаДокументаОбработчикиСобытийЭлементовШапки

// Переопределяемая процедура, вызываемая при изменении кассы ККМ.
// Вызывается из модуля формы документа "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//
Процедура КассаККМПриИзменении(Объект) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая при изменении основания для коррекции.
// Вызывается из модуля формы документа "КассовыйЧекКоррекции"
// 
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//
Процедура ОснованиеДляКоррекцииПриИзменении(Объект) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ФормаДокументаСлужебныеПроцедурыИФункции

//Переопределяемая процедура устанавливает правила работы формы документа. 
//
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  Форма  - Форма документа КассовыйЧекКоррекции
//
Процедура УстановитьДоступностьЭлементовИФормы(Объект, Форма) Экспорт
	
КонецПроцедуры

//Переопределяемая процедура проверяет возможность печати чека, при этом подготавливает информацию для печати. 
//
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//  Отказ - Булево.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование, устройство фискализирующее чек
//  ИспользоватьКассуБезПодключенияОборудования - Булево.
//
Процедура ПодготовитьИПроверитьПечатьЧека(Объект,
										  Отказ, 
										  ИдентификаторУстройства, 
										  ИспользоватьКассуБезПодключенияОборудования)	Экспорт
	
	Если ТипЗнч(Объект.КассаККМ) = Тип("СправочникСсылка.КассыККМ") Тогда
		ИдентификаторУстройства = ПодключаемоеОборудованиеУТВызовСервера.ОборудованиеПодключенноеККассеККМ(Объект.КассаККМ).ККТ;
	ИначеЕсли ТипЗнч(Объект.КассаККМ) = Тип("СправочникСсылка.Кассы") Тогда
		ИдентификаторУстройства = ПодключаемоеОборудованиеУТВызовСервера.ОборудованиеПодключенноеККассе(Объект.КассаККМ).ККТ;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ИспользоватьКассуБезПодключенияОборудования = 
		Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИдентификаторУстройства, "ТипОборудования") = Перечисления.ТипыПодключаемогоОборудования.ККТ;
	КонецЕсли;
	
КонецПроцедуры

// Переопределяемая процедура получает данные для отправки по кассиру (ответственному)
//
// Параметры:
//  Объект - ДокументОбъект.КассовыйЧекКоррекции, заполняемый документ
//
Функция ПолучитьРеквизитыКассира(Объект) Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Наименование", "Кассир");
	СтруктураРеквизитов.Вставить("ИНН", Неопределено);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Переопределяемая процедура получает доступные системы налогообложения для организации.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияБПО, Организация по которой получаются системы налогообложения.
//  МассивСистемНалогообложения - Массив элементов Перечисление.ТипыСистемНалогообложенияККТ.
//
Процедура ПолучитьДоступныеСистемыНалогообложения(Организация, МассивСистемНалогообложения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
