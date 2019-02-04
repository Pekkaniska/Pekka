#Область ПрограммныйИнтерфейс

// Функция определяет массив узлов-получателей для объекта при заданном плане обмена.
//
// Параметры:
//  Объект         - Произвольный - СправочникОбъект, ДокументОбъект и т.п. объект, для которого необходимо выполнить
//                   правила регистрации, и определить список узлов-получателей.
//  ИмяПланаОбмена - Строка - имя плана обмена как оно задано в конфигураторе.
// 
// Возвращаемое значение:
//  МассивУзловРезультат - Массив - массив узлов-получателей для объекта.
//
Функция ОпределитьПолучателей(СсылкаНаОбъект, ИмяПланаОбмена) Экспорт
	
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Объект = СсылкаНаОбъект.ПолучитьОбъект();
	
	Если Объект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбменДаннымиСобытия.ОпределитьПолучателей(Объект, ИмяПланаОбмена);
	
КонецФункции

// Возвращает массив с присоединенными файлами
//
// Параметры:
//		СсылкаНаОбъект - Произвольный - СправочникСсылка, ДокументСсылка и т.п.
//										Ссылка на объект, для которого требуется получить присоединенные файлы.
//
// Возвращаемое значение:
//		МассивФайлов - Массив - массив с присоединенными файлами
//
Функция ПрисоединенныеФайлыКОбъекту(СсылкаНаОбъект) Экспорт
	
	МассивФайлов = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(СсылкаНаОбъект, МассивФайлов);
	
	Возврат МассивФайлов;
	
КонецФункции

// Возвращает регистры сведений, в которых объект присутствует в ведущем измерении.
//
// Параметры:
//		ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//		СсылкаНаОбъект - Произвольный - СправочникСсылка, ДокументСсылка и т.п.
//										Ссылка на объект, который может содержать присоединенные файлы.
//
// Возвращаемое значение:
//		СвязанныеРегистрыСведенийОбъекта - Структура - в качестве ключа указывается имя регистра.
//												В качестве значения указывается результат запроса.
//
Функция СвязанныеРегистрыСведенийОбъекта(ИмяПланаОбмена, СсылкаНаОбъект) Экспорт
	
	ПолноеИмяОбъектаМетаданных = СсылкаНаОбъект.Метаданные().ПолноеИмя();
	МассивСвязанныхДанных = ОбменДаннымиПовтИспЗарплатаКадрыРасширенный.МассивСвязанныхДанных(ИмяПланаОбмена, ПолноеИмяОбъектаМетаданных);
	
	СвязанныеРегистрыСведенийОбъекта = Новый Структура;
	
	Для Каждого СвязанныеДанные Из МассивСвязанныхДанных Цикл
		
		МетаданныеРС = Метаданные.РегистрыСведений[СвязанныеДанные.Ключ];
		ИзмеренияРС = МетаданныеРС.Измерения;
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
		
		Запрос.Текст = "
		| ВЫБРАТЬ РАЗЛИЧНЫЕ ";
		
		Для каждого ИзмерениеРС Из ИзмеренияРС Цикл
			Если ИзмерениеРС.ОсновнойОтбор Тогда
				Запрос.Текст = Запрос.Текст + "СвязанныеДанные." + ИзмерениеРС.Имя + ", ";
			КонецЕсли;
		КонецЦикла;
		Если МетаданныеРС.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			Запрос.Текст = Запрос.Текст + "СвязанныеДанные.Период, ";
		КонецЕсли;
		
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 2);
		
		Запрос.Текст = Запрос.Текст + "
		| Из
		| РегистрСведений." + СвязанныеДанные.Ключ + " КАК СвязанныеДанные
		| ГДЕ
		| СвязанныеДанные." + СвязанныеДанные.Значение + " = &Ссылка";
		
		СвязанныеРегистрыСведенийОбъекта.Вставить(СвязанныеДанные.Ключ, Запрос.Выполнить());
		
	КонецЦикла;
	
	Возврат СвязанныеРегистрыСведенийОбъекта;
	
КонецФункции

// Регистрирует изменения для регистров сведений, в которых объект присутствует в ведущем измерении.
//
// Параметры:
//  ИмяПланаОбмена - Строка - Имя метаданных плана обмена
//  Отказ - Булево - флаг отказа от выполнения правил регистрации.
//      Отказ от выполнения правил означает, что объект и присоединенные файлы не будет зарегистрированы на узлах плана обмена,
//      для которого создано это правило.
//  СсылкаНаОбъект - Ссылка на объект, который может содержать присоединенные файлы.
//  ОбъектМетаданных - объект метаданных, соответствующий параметру Объект.
//  Выгрузка - (только чтение) - Булево - параметр определяет контекст выполнения правила регистрации.
//      Истина - правило регистрации выполняется в контексте выгрузки объекта.
//      Ложь - правило регистрации выполняется в контексте перед записью объекта
//  Получатели - Массив - список узлов-получателей, на которых будут зарегистрированы изменения для присоединенных файлов.
//
Процедура ЗарегистрироватьСвязанныеРегистрыСведенийОбъекта(ИмяПланаОбмена, Отказ, СсылкаНаОбъект, ОбъектМетаданных, Выгрузка, Получатели) Экспорт
	
	Если Выгрузка Или Получатели.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивСвязанныхДанных = Новый Структура;
	
	МассивСлужебныхРегистров = Новый Массив;
	МассивСлужебныхРегистров.Добавить("СоответствияОбъектовИнформационныхБаз");
	
	Для Каждого Состав Из Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав Цикл
		МДСостава = Состав.Метаданные;
		Если Не ОбщегоНазначения.ЭтоРегистрСведений(МДСостава) Тогда
			Продолжить;
		КонецЕсли;
		Если МассивСлужебныхРегистров.Найти(МДСостава.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если МДСостава.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Измерение Из Состав.Метаданные.Измерения Цикл
			Если Не Измерение.Ведущее Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТипИзмерения Из Измерение.Тип.Типы() Цикл
				Если Метаданные.НайтиПоТипу(ТипИзмерения) = ОбъектМетаданных Тогда
					МассивСвязанныхДанных.Вставить(Состав.Метаданные.Имя, Измерение.Имя);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого СвязанныеДанные Из МассивСвязанныхДанных Цикл
		
		МетаданныеРС = Метаданные.РегистрыСведений[СвязанныеДанные.Ключ];
		ИзмеренияРС = МетаданныеРС.Измерения;
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
		
		Запрос.Текст = "
		| ВЫБРАТЬ РАЗЛИЧНЫЕ ";
		
		Для каждого ИзмерениеРС Из ИзмеренияРС Цикл
			Если ИзмерениеРС.ОсновнойОтбор Тогда
				Запрос.Текст = Запрос.Текст + "СвязанныеДанные." + ИзмерениеРС.Имя + ", ";
			КонецЕсли;
		КонецЦикла;
		Если МетаданныеРС.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			Запрос.Текст = Запрос.Текст + "СвязанныеДанные.Период, ";
		КонецЕсли;
		
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 2);
		
		Запрос.Текст = Запрос.Текст + "
		| Из
		| РегистрСведений." + СвязанныеДанные.Ключ + " КАК СвязанныеДанные
		| ГДЕ
		| СвязанныеДанные." + СвязанныеДанные.Значение + " = &Ссылка";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НаборЗаписей = РегистрыСведений[СвязанныеДанные.Ключ].СоздатьНаборЗаписей();
		
		Пока Выборка.Следующий() Цикл
			Для каждого ИзмерениеРС Из ИзмеренияРС Цикл
				Если ИзмерениеРС.ОсновнойОтбор Тогда
					НаборЗаписей.Отбор[ИзмерениеРС.Имя].Установить(Выборка[ИзмерениеРС.Имя]);
				КонецЕсли;
			КонецЦикла;
			Если МетаданныеРС.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
				НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
			КонецЕсли;
			НаборЗаписей.Прочитать();
			
			ПланыОбмена.ЗарегистрироватьИзменения(Получатели, НаборЗаписей);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МассивСвязанныхДанных(ИмяПланаОбмена, ПолноеИмяОбъектаМетаданных) Экспорт
	
	МассивСвязанныхДанных = Новый Структура;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат МассивСвязанныхДанных;
	КонецЕсли;
	
	МассивСлужебныхРегистров = Новый Массив;
	МассивСлужебныхРегистров.Добавить("СоответствияОбъектовИнформационныхБаз");
	
	Для Каждого Состав Из Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав Цикл
		МДСостава = Состав.Метаданные;
		Если Не ОбщегоНазначения.ЭтоРегистрСведений(МДСостава) Тогда
			Продолжить;
		КонецЕсли;
		Если МассивСлужебныхРегистров.Найти(МДСостава.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если МДСостава.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Измерение Из Состав.Метаданные.Измерения Цикл
			Если Не Измерение.Ведущее Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТипИзмерения Из Измерение.Тип.Типы() Цикл
				Если Метаданные.НайтиПоТипу(ТипИзмерения) = ОбъектМетаданных Тогда
					МассивСвязанныхДанных.Вставить(Состав.Метаданные.Имя, Измерение.Имя);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивСвязанныхДанных;
	
КонецФункции

#КонецОбласти

