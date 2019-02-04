#Область ПрограммныйИнтерфейс

// Процедура, вызываемая из одноименного обработчика события формы узла плана обмена "Обмен с сайтом".
//
// Параметры:
//  Форма - УправляемаяФорма - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ - Булево - признак отказа от выполнения действия.
//
Процедура ФормаУзлаПриОткрытии(Форма, Отказ) Экспорт
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы узла плана обмена "Обмен с сайтом".
//
// Параметры:
//  Форма - УправляемаяФорма - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ - Булево - признак отказа от выполнения действия.
//  ПараметрыЗаписи - Структура - Структура, содержащая параметры записи. 
//
Процедура ФормаУзлаПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	Если НЕ (Форма.ИспользуютсяГруппыДоступаПартнеров 
	        И (Форма.ИспользоватьПартнеровКакКонтрагентов
	         ИЛИ Форма.СоздаватьПартнеровДляНовыхКонтрагентов)) Тогда
		
		Форма.ГруппаДоступаПартнеров = ПредопределенноеЗначение("Справочник.ГруппыДоступаПартнеров.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовФормы

// Обработчик события При изменении добавляемого поля ввода формы узла плана обмена.
// Параметры:
//  Элемент - ЭлементФормы - источник события.
//  Форма - УправляемаяФорма - Форма узла плана обмена.
//  Объект - ДанныеФормыСтруктура - данные формы узла плана обмена Обмен с сайтом.
//
Процедура ПолеВводаПриИзменении(Элемент, Форма, Объект) Экспорт
	
	
	
КонецПроцедуры

// Обработчик события При изменении добавляемого поля флажка формы узла плана обмена.
//
// Параметры:
//  Элемент - ЭлементФормы - источник события.
//  Форма - УправляемаяФорма - Форма узла плана обмена.
//  Объект - ДанныеФормыСтруктура - данные формы узла плана обмена Обмен с сайтом.
//
Процедура ПолеФлажкаПриИзменении(Элемент, Форма, Объект) Экспорт
		
	Если ВРег(Элемент.Имя) = ВРег("СоздаватьПартнеровДляНовыхКонтрагентов") Тогда
	
		ОбменССайтамиУТКлиент.УстановитьДоступностьЭлементовФормыУзла(Форма, Объект);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПередОкончаниемРедактирования табличной части формы узла обмена.
//
// Параметры:
//  Элемент - Строка - источник события.
//  НоваяСтрока - Булево - Истина, если строка была добавлена или скопирована.
//  ОтменаРедактирования - Булево - Истина, если произошла отмена редактирования.
//  Отказ - Булево - Признак отказа от записи объекта.
//  Форма - УправляемаяФорма - Форма узла обмена.
//  Объект - ДанныеФормыСтруктура - данные формы узла плана обмена Обмен с сайтом.
//
Процедура ТаблицаФормыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ,
		Форма, Объект) Экспорт
		
	Если ВРег(Элемент.Имя) = ВРег("СоответствиеСтатусовЗаказов") Тогда
	
		ОбменССайтамиУТКлиент.ПроверитьДублированиеСтатусов(Форма, Объект, ОтменаРедактирования, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
