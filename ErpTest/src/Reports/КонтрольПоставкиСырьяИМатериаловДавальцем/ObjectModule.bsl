#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
		
		РеквизитыЗаказа = РеквизитыЗаказаДавальца(Параметры.ПараметрКоманды);
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Давалец", РеквизитыЗаказа.Партнер);
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Договор", РеквизитыЗаказа.Договор);
		
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

Функция РеквизитыЗаказаДавальца(ЗаказДавальца)
	
	УстановитьПривилегированныйРежим(Истина);
	РеквизитыЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказДавальца, "Партнер, Договор");
	Возврат РеквизитыЗаказа;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли