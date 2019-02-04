#Область ПрограммныйИнтерфейс

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьШтрихкодовУпаковок(ОбъектыПечати, Форма) Экспорт
	
	//++ НЕ ГОСИС
	ИспользоватьЭтикетки = Истина;
	
	Если ИспользоватьЭтикетки Тогда
		
		ОписаниеКоманды = Новый Структура;
		ОписаниеКоманды.Вставить("Вид",           "Печать");
		ОписаниеКоманды.Вставить("Идентификатор", "ШтрихкодыУпаковокПоПереданнымПараметрам");
		ОписаниеКоманды.Вставить("Обработчик",    "ПечатьШтрихкодовУпаковок.ПечатьШтрихкодовУпаковок");
		ОписаниеКоманды.Вставить("ОбъектыПечати", ОбъектыПечати);
		ОписаниеКоманды.Вставить("Представление", НСтр("ru = 'Печать штрихкодов упаковок!'"));
		ОписаниеКоманды.Вставить("Форма",         Форма);
		
		УправлениеПечатьюУТКлиент.ПечатьШтрихкодовУпаковок(ОписаниеКоманды);
	Иначе
		
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ГенерацияШтрихкодовУпаковок",
			"ШтрихкодыУпаковокТоваров",
			ПараметрКоманды,
			Форма,
			ПолучитьПараметрыДляШтрихкодовУпаковок(ОбъектыПечати, Форма));
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыДляШтрихкодовУпаковок(ОбъектыПечати, Форма)
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище"       , ПоместитьВоВременноеХранилище(ОбъектыПечати, Форма.УникальныйИдентификатор));
	ПараметрыПечати.Вставить("КоличествоЭкземпляров" , 1);
	
	Возврат ПараметрыПечати;
	
КонецФункции

#КонецОбласти