
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИменаСтраниц();
	
	ХозяйствующийСубъект = Параметры.ХозяйствующийСубъект;
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГИСМ;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаЕГАИС;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбработатьПереходНаСледующуюСтраницу();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ОбработатьПереходНаСледующуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы - 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(ТекстОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 1]];
	КонецЕсли;
	
	ПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВНачало(Команда)
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	ПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящееСообщение") Тогда
		ПоказатьЗначение(, ИсходящееСообщение);
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящееСообщение") Тогда
		ПоказатьЗначение(, ВходящееСообщение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеЗаявокВЕТИС_API

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСНачало()
	
	КоличествоЭлементов = 1000;
	
	РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросПользователейХозяйствующегоСубъекта(
	                  ХозяйствующийСубъект, КоличествоЭлементов, УникальныйИдентификатор);
	
	ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСОкончание()
	
	ОповеститьОбИзменениях();
	ПоказатьУспешныйРезультатОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		ИсходящееСообщение = РезультатОбмена.Изменения[0].ИсходящееСообщение;
		СформироватьТекстОжидание();
	КонецЕсли;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	ДанныеДляОбработки = Неопределено;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ЗапросПользователейХозяйствующегоСубъекта") Тогда
			ДанныеДляОбработки = ЭлементДанных;
		ИначеЕсли ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросПользователейХозяйствующегоСубъекта") Тогда
			ДанныеДляОбработки = ЭлементДанных;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ДанныеДляОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВходящееСообщение = ДанныеДляОбработки.ВходящееСообщение;
	
	Если ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаОтклонена")
		ИЛИ НЕ ПустаяСтрока(ДанныеДляОбработки.ТекстОшибки) Тогда
		ПоказатьОшибкуОбмена(ДанныеДляОбработки.ТекстОшибки);
	ИначеЕсли ДанныеДляОбработки.НовыйСтатус = ПредопределенноеЗначение("Перечисление.СтатусыОбработкиСообщенийВЕТИС.ЗаявкаВыполнена") Тогда
		ВыполнениеЗаявкиВЕТИСОкончание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзменениях()
	
	Оповестить("Изменение_ПраваДоступаПользователейВЕТИС",     ХозяйствующийСубъект, ЭтотОбъект);
	Оповестить("Изменение_АдресаЗонОтветственностиВЕТИС",      ХозяйствующийСубъект, ЭтотОбъект);
	Оповестить("Изменение_ПредприятияЗонОтветственностиВЕТИС", ХозяйствующийСубъект, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеИнтерфейсом

&НаКлиенте
Процедура СформироватьТекстОжидание()
	
	Строки = Новый Массив();
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'пользователей хозяйствующего субъекта'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='передан в ВетИС.'")));
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Получение ответа от сервера может занять продолжительное время.'")));
	
	ТекстОжидание = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуОбмена(ТекстОшибки)
	
	Строки = Новый Массив();
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'пользователей хозяйствующего субъекта'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'завершился с'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибкой'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Строки.Добавить(":");
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
	
	ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка;
	
	ПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьУспешныйРезультатОбмена()
	
	Строки = Новый Массив();
	
	Строки.Добавить(НСтр("ru = 'На'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'пользователей хозяйствующего субъекта'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'получен'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ответ'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
	Строки.Добавить(".");
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Связь пользователей с хозяйствующим субъектом и права доступа'")));
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='синхронизированы с ВетИС.'")));
	
	ТекстРезультат = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат;
	
	ПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаСтраниц()
	
	СтраницыФормы = Новый Массив();
	
	СтраницыФормы.Добавить("СтраницаИсходныеДанные");
	СтраницыФормы.Добавить("СтраницаЗапросОжидание");
	СтраницыФормы.Добавить("СтраницаЗапросОшибка");
	СтраницыФормы.Добавить("СтраницаЗапросРезультат");
	
	ИменаСтраниц = Новый ФиксированныйМассив(СтраницыФормы);
	
КонецПроцедуры // ЗаполнитьИменаСтраниц()

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницуНавигации(Форма)
	
	СтраницыФормы     = Форма.Элементы.ГруппаСтраницы;
	СтраницыНавигации = Форма.Элементы.Навигация;
	
	ИндексСтраницы    = Форма.ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	КоличествоСтраниц = Форма.ИменаСтраниц.Количество();
	
	Если ИндексСтраницы = 0 Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияНачало;
		Форма.Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ИндексСтраницы = (КоличествоСтраниц - 1) Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОкончание;
		Форма.Элементы.ОкончаниеЗакрыть.КнопкаПоУмолчанию = Истина;
	ИначеЕсли СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОшибка;
		Форма.Элементы.ОшибкаНазад.КнопкаПоУмолчанию = Истина;
	Иначе
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияПродолжение;
		Если НЕ Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию Тогда
			Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		СтраницыНавигации.Доступность = Ложь;
	Иначе
		СтраницыНавигации.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПереходНаСледующуюСтраницу()
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы + 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(ТекстОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 1]];
	КонецЕсли;
	
	ПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	Если ТекущаяСтраница = Элемент.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		ВыполнениеЗаявкиВЕТИСНачало();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
