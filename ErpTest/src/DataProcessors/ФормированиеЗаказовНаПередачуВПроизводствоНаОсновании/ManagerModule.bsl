#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команду создания объекта.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.ФормированиеЗаказовНаПередачуВПроизводствоНаОсновании) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.СоздатьЗаказыНаПередачуВПроизводство";
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Обработки.ФормированиеЗаказовНаПередачуВПроизводствоНаОсновании.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление =  НСтр("ru='Заказы материалов в производство'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьПроизводство";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Возвращает параметры выбора спецификаций для изделий, указанных в документе.
//
// Параметры:
//   Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров выбора спецификаций.
//
// Возвращаемое значение:
//   Структура - Структура, переопределяющая умолчания, заданные в функции УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций().
//
Функция ПараметрыВыбораСпецификаций(Объект) Экспорт
	
	ПараметрыВыбораСпецификаций = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификаций();
	
	ПараметрыВыбораСпецификаций.ДоступныеТипы.Добавить(Перечисления.ТипыПроизводственныхПроцессов.Сборка);
	ПараметрыВыбораСпецификаций.ДоступныеСтатусы.Добавить(Перечисления.СтатусыСпецификаций.Действует);
	
	Возврат ПараметрыВыбораСпецификаций;
	
КонецФункции

// Имена реквизитов, от значений которых зависят параметры выбора спецификаций
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровВыбораСпецификаций() Экспорт
	
	ИменаРеквизитов = "";
	Возврат ИменаРеквизитов;
	
КонецФункции

#КонецОбласти

#КонецЕсли


