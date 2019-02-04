
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеФайла = ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	
	Если ДанныеФайла <> Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПолучитьФайлПродолжить", ЭтотОбъект, ДанныеФайла);
		
		Шаблон = НСтр("ru='Открыть или сохранить файл?
			|
			|%1'");
		
		ТекстВопроса = СтрШаблон(Шаблон, ДанныеФайла.ИмяФайла);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Открыть");
		Кнопки.Добавить("Сохранить");
		Кнопки.Добавить("Отмена");
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки,, "Отмена", НСтр("ru = 'Получить файл'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(Знач ПакетЭД, Знач УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПакетЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ПакетЭДПрисоединенныеФайлы КАК ПакетЭДПрисоединенныеФайлы
	|ГДЕ
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ПакетЭД);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	РезультатЗапроса.Следующий();
	
	Если Не ЗначениеЗаполнено(РезультатЗапроса.Ссылка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не обнаружен файл пакета электронного документа.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайлами.ДанныеФайла(РезультатЗапроса.Ссылка, УникальныйИдентификатор);
	
	Возврат ДанныеФайла;
	
КонецФункции

#Область ОбработчикиАсинхронныхДиалогов

&НаКлиенте
Процедура ПолучитьФайлПродолжить(Результат, ДанныеФайла) Экспорт
	
	Если Результат = "Открыть" Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	ИначеЕсли Результат = "Сохранить" Тогда
		РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
