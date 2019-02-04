#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Подразделение");
	Результат.Добавить("ИспользуютсяВариантыНаладки");
	Результат.Добавить("ЕдиницаВремениПереналадки");
	Результат.Добавить("ПараллельнаяЗагрузка");
	Результат.Добавить("ЕдиницаИзмеренияЗагрузки");
	Результат.Добавить("ВариантЗагрузки;ВариантЗагрузкиАсинхронный,ВариантЗагрузкиСинхронный1,ВариантЗагрузкиСинхронный2");
	
	Возврат Результат;
	
КонецФункции

// Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Подразделение");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Возвращает максимальную доступность видов РЦ в интервале планирования.
//
// Параметры:
//  ВидыРабочихЦентров	 - Массив - ссылки на виды рабочих центров.
// 
// Возвращаемое значение:
//  Соответствие - ключ - ссылка на вид РЦ, значение - максимальная доступность.
//
Функция МаксимальнаяДоступностьВСекундах(ВидыРабочихЦентров) Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВидыРабочихЦентров.Ссылка КАК Ссылка,
		|	ВидыРабочихЦентров.МаксимальнаяДоступностьРЦ КАК МаксимальнаяДоступность,
		|	ВидыРабочихЦентров.ЕдиницаИзмеренияДоступностиРЦ КАК ЕдиницаИзмеренияДоступности,
		|	ВидыРабочихЦентров.Подразделение.ИнтервалПланирования КАК ИнтервалПланирования
		|ИЗ
		|	Справочник.ВидыРабочихЦентров КАК ВидыРабочихЦентров
		|ГДЕ
		|	ВидыРабочихЦентров.Ссылка В(&Ссылки)");
	
	Запрос.УстановитьПараметр("Ссылки", ВидыРабочихЦентров);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.МаксимальнаяДоступность) Тогда
			
			Доступность = ПланированиеПроизводстваКлиентСервер.ПолучитьВремяВСекундах(
				Выборка.МаксимальнаяДоступность,
				Выборка.ЕдиницаИзмеренияДоступности);
				
		Иначе
			
			Если Выборка.ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Час Тогда
				Доступность = 3600;
			ИначеЕсли Выборка.ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.День Тогда
				Доступность = 86400;
			ИначеЕсли Выборка.ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Неделя Тогда
				Доступность = 604800;
			ИначеЕсли Выборка.ИнтервалПланирования = Перечисления.ТочностьГрафикаПроизводства.Месяц Тогда
				Доступность = 2592000; // 30 дней
			КонецЕсли;
			
		КонецЕсли;
		
		Результат.Вставить(Выборка.Ссылка, Доступность);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли