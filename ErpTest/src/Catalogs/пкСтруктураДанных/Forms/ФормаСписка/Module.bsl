
&НаКлиенте
Процедура СгенерироватьАвтоматически(Команда)
	СгенерироватьАвтоматическиНаСервере();
КонецПроцедуры

&НаСервере
Процедура СгенерироватьАвтоматическиНаСервере ()
	Для Каждого ЭлСостава Из Метаданные.ПланыОбмена.пкОбменСМобильнымиУстройствами.Состав Цикл
		Если ЭлСостава.АвтоРегистрация = АвтоРегистрацияИзменений.Разрешить Или ИСТИНА Тогда
			ЭлМета     = ЭлСостава.Метаданные;
			ПолноеИмя  = ЭлМета.ПолноеИмя();
			ИмяТипа    = Лев(ПолноеИмя,Найти(ПолноеИмя,".") - 1);
			Имятаблицы = Прав(ПолноеИмя,СтрДлина(ПолноеИмя) - Найти(ПолноеИмя,"."));
			Если ИмяТипа = "Константа" Тогда
				Продолжить;
			КонецЕсли;	
			ИмяУзла    = Справочники.пкСтруктураДанных.ПолучитьИмяОбъектаАнглПоТипу(ИмяТипа) + "." + Имятаблицы;
			Эл         = Справочники.пкСтруктураДанных.НайтиПоРеквизиту("ИмяУзла",ИмяУзла);
			Если Не ЗначениеЗаполнено(Эл) Тогда
				НовыйЭл = Справочники.пкСтруктураДанных.СоздатьЭлемент();
				НовыйЭл.Наименование       = ПолноеИмя;
				НовыйЭл.СтандартнаяВыборка = Истина;
				НовыйЭл.ИмяТипа            = ИмяТипа;
				НовыйЭл.ИмяУзла            = ИмяУзла;
				НовыйЭл.ИмяТаблицы         = Имятаблицы;
				НовыйЭл.ЗаполнитьРеквизитыНаСервере();
				Для Каждого СтрокаТЧ Из НовыйЭл.Реквизиты Цикл
					СтрокаТЧ.Выгружать = Истина;
				КонецЦикла;	
				Для Каждого СтрокаТЧ Из НовыйЭл.ТабличныеЧасти Цикл
					СтрокаТЧ.Выгружать = Истина;
				КонецЦикла;	
				Для Каждого СтрокаТЧ Из НовыйЭл.РеквизитыТабличныхЧастей Цикл
					СтрокаТЧ.Выгружать = Истина;
				КонецЦикла;	
				НовыйЭл.Записать();
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьИзМакета (НеРегистрироватьИзменения = ЛОЖЬ)
	
	ИмяZip = ПолучитьИмяВременногоФайла("zip");
	Макет = Справочники.пкСтруктураДанных.ПолучитьМакет("СтруктураДанныхПоУмолчанию");
	Макет.Записать(ИмяZip);
	ЧтениеZip = Новый ЧтениеZipФайла(ИмяZip);
	Для Каждого Эл Из ЧтениеZip.Элементы Цикл
		ЧтениеZip.Извлечь(Эл,КаталогВременныхФайлов());
		ИмяВФ = КаталогВременныхФайлов() + "\" + Эл.Имя;
	КонецЦикла;
	ЧтениеZip.Закрыть();
	
	УдалитьФайлы(ИмяZip);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяВФ,,,"UTF-8");
	
	// проверка формата файла обмена
	Если Не ЧтениеXML.Прочитать() ТОГДА
		#Если Клиент Тогда
			Предупреждение("Неверный формат файла выгрузки", 10, "Ошибка загрузки!!!");
		#КонецЕсли
		Возврат;
	КонецЕсли;
	
	Если Не ЧтениеXML.Прочитать() Тогда 
	КонецЕсли;
	
	СписокЭлементовДляРегистрацииДанных = Новый Массив;
	СписокИзмененныхФильтров = Новый Массив;
	
	СЧОбъектов = 0;
	Пока ВозможностьЧтенияXML(ЧтениеXML) Цикл
		Попытка
			мОбъект       = ПрочитатьXML(ЧтениеXML);
			мОбъект.ОбменДанными.Загрузка = Истина;
			
			Если ТипЗнч(мОбъект) = Тип ("СправочникОбъект.пкСтруктураДанных") Тогда
				мТекстЗапроса = мОбъект.ТекстЗапроса;
				МассивСтрок   = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(мТекстЗапроса,Символы.ПС);
				мТекстЗапроса = "";
				Для Каждого мСтрока Из МассивСтрок Цикл
					Если Не ПустаяСтрока(мСтрока) Тогда
						мТекстЗапроса = мТекстЗапроса + СокрП(мСтрока) + Символы.ПС;
					КонецЕсли;
				КонецЦикла; 	
				мОбъект.ТекстЗапроса = СокрЛП(мТекстЗапроса);
			КонецЕсли;
			
			Если ЕстьОтличияВОбъектах(мОбъект,мОбъект.Ссылка) Тогда
				мОбъект.Записать();
				СЧОбъектов = СЧОбъектов + 1;
				Сообщение            = Новый СообщениеПользователю;
				Сообщение.Текст      = "Изменен: " + мОбъект.Ссылка;
				Сообщение.КлючДанных = мОбъект.Ссылка;
				Сообщение.Сообщить();
				Если ТипЗнч(мОбъект) = Тип ("СправочникОбъект.пкСтруктураДанных") И мОбъект.Активность Тогда
					СписокЭлементовДляРегистрацииДанных.Добавить(мОбъект.Ссылка);
				ИначеЕсли ТипЗнч(мОбъект) = Тип ("СправочникОбъект.пкФильтрыОтбора") Тогда
					СписокИзмененныхФильтров.Добавить(мОбъект.Ссылка);
				КонецЕсли;
			КонецЕсли;
		Исключение
			ВызватьИсключение ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;	
	
	Если НЕ НеРегистрироватьИзменения Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТЧ.Ссылка
		|ИЗ
		|	Справочник.пкСтруктураДанных.ФильтрыОтбора КАК ТЧ
		|ГДЕ
		|	ТЧ.Фильтр В (&Фильтр)";
		Запрос.УстановитьПараметр("Фильтр",СписокИзмененныхФильтров);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокЭлементовДляРегистрацииДанных.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
		ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(СписокЭлементовДляРегистрацииДанных);
		
		Для Каждого Эл Из СписокЭлементовДляРегистрацииДанных Цикл 
			ЗарегистрироватьИзмененияДляВсехУзловСервер(ЭЛ);
		КонецЦикла;	
		
	КонецЕсли;
	
	ЧтениеXML.Закрыть();
	
	Сообщить("Изменено " + СЧОбъектов + " элементов.");
	УдалитьФайлы(ИмяВФ);
	
	Элементы.Список.Обновить();
КонецПроцедуры	

&НаСервере
Функция ЕстьОтличияВОбъектах (Объект1, Объект2)
	
	ТипыМета = Новый Массив;
	ТипыМета.Добавить("СтандартныеРеквизиты");
	ТипыМета.Добавить("Реквизиты");
	
	Мета = Объект1.Метаданные();
	
	Для Каждого ТипМета Из ТипыМета Цикл
		Для Каждого Рекв Из Мета[ТипМета] Цикл
			Если Объект1[Рекв.Имя] <> Объект2[Рекв.Имя] Тогда
				Возврат Истина;
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ТЧ Из Мета.ТабличныеЧасти Цикл
		Если Объект1[ТЧ.Имя].Количество() <> Объект2[ТЧ.Имя].Количество() Тогда
			Возврат Истина;
		КонецЕсли;
		СЧ = -1;
		Для Каждого СтрокаТЧ Из Объект1[ТЧ.Имя] Цикл
			СЧ = СЧ + 1;
			Для Каждого ТипМета Из ТипыМета Цикл
				Для Каждого Рекв Из ТЧ[ТипМета] Цикл
					Если СтрокаТЧ[Рекв.Имя] <> Объект2[ТЧ.Имя][СЧ][Рекв.Имя] Тогда
						Возврат Истина;
					КонецЕсли;	
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;	
	КонецЦикла;	
	
	Возврат ЛОЖЬ;
	
КонецФункции	

&НаКлиенте
Процедура ЗаполнитьИзМакета1(Команда)
	ЗаполнитьИзМакета();
КонецПроцедуры

&НаСервере
Функция ВыгрузитьВМакетНаСервере()
	Запись = Новый ЗаписьXML();
	ИмяВФ  = ПолучитьИмяВременногоФайла("xml");
	Запись.ОткрытьФайл(ИмяВФ,"UTF-8");
	Запись.ЗаписатьНачалоЭлемента("DATA");
	Выборка = Справочники.пкФильтрыОтбора.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаписатьXML(Запись,Выборка.Ссылка.ПолучитьОбъект());
	КонецЦикла;
	Выборка = Справочники.пкСтруктураДанных.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаписатьXML(Запись,Выборка.Ссылка.ПолучитьОбъект());
	КонецЦикла;
	Запись.ЗаписатьКонецЭлемента();
	Запись.Закрыть();
	
	ИмяZip    = ПолучитьИмяВременногоФайла("zip");
	ЗаписьZip = Новый ЗаписьZipФайла;
	ЗаписьZip.Открыть(ИмяZip,,,МетодСжатияZIP.Сжатие,УровеньСжатияZIP.Максимальный);
	ЗаписьZip.Добавить(ИмяВФ);
	ЗаписьZip.Записать();
	
	УдалитьФайлы(ИмяВФ);
	
	ДД = Новый ДвоичныеДанные(ИмяZip);
	
	АдресФайла = ПоместитьВоВременноеХранилище(ДД,Новый УникальныйИдентификатор);
	
	МассивПередаваемыхФайлов = Новый Массив;
	МассивПередаваемыхФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(,АдресФайла));
	
	УдалитьФайлы(ИмяZip);
	
	Возврат МассивПередаваемыхФайлов;
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьВМакет(Команда)
	#ЕСЛИ НЕ ВЕБКЛИЕНТ ТОГДА
	МассивПередаваемыхФайлов   = ВыгрузитьВМакетНаСервере();
	Оповещение                 = Новый ОписаниеОповещения("ВыгрузитьВМакетЗавершение",ЭтаФорма);
	Диалог                     = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Фильтр              = "*.zip|*.zip";
	Диалог.МножественныйВыбор  = Ложь;
	НачатьПолучениеФайлов(Оповещение,МассивПередаваемыхФайлов,Диалог,Истина);
	#КОНЕЦЕСЛИ
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВМакетЗавершение(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	Если ПолученныеФайлы <> Неопределено Тогда
		Для Каждого Эл Из ПолученныеФайлы Цикл
			ЗапуститьПриложение(Эл.Имя);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ЗарегистрироватьИзмененияДляВсехУзловСервер (ПараметрКоманды) 
	Выборка = ПланыОбмена.пкОбменСМобильнымиУстройствами.Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если Не Выборка.ПометкаУдаления И НЕ Выборка.ЭтотУзел Тогда
			Справочники.пкСтруктураДанных.ЗарегистрироватьИзмененияПоСтруктуреДанных(ПараметрКоманды,Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьИзМакетаБезРегистрацииИзменений(Команда)
	ЗаполнитьИзМакета(Истина);
КонецПроцедуры


