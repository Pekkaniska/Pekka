#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеВозвратНалога.Форма.Форма2017_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2017_1";
	Стр.ОписаниеФормы = "Форма заявления о возврате излишне уплаченного налога в соответствии с приказом ФНС России от 14.02.2017 N ММВ-7-8/182@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Возврат ПечатьСразу_Форма2017_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Возврат СформироватьМакет_Форма2017_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2017_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2017_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2017_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2017_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Данные.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
		Данные.Вставить("ПодписантИмя", Объект.ПодписантИмя);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(СведенияОтправки)
	Префикс = "UT_ZVIUN";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация) Тогда 
		Если Не ЗначениеЗаполнено(Титульная.ИНН) 
			Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ИНН))
			Или СтрДлина(СокрЛП(Титульная.ИНН)) <> 10 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Титульная", "ИНН"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Титульная.КПП) 
			Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КПП))
			Или СтрДлина(СокрЛП(Титульная.КПП)) <> 9 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан КПП", "Титульная", "КПП"));
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
		Если Не ЗначениеЗаполнено(Данные.ПодписантИмя) Или Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан подписант", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		КонецЕсли;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НомерЗаявления) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан номер заявления", "Титульная", "НомерЗаявления"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО))
		Или СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Наименование) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации/ФИО физлица", "Титульная", "Наименование"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Пункт) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан пункт статьи НК РФ", "Титульная", "Пункт"));
	Иначе 
		МассивДляПроверки = Новый Массив;
		МассивДляПроверки.Добавить("78.");
		МассивДляПроверки.Добавить("79.");
		МассивДляПроверки.Добавить("176.");
		МассивДляПроверки.Добавить("203.");
		МассивДляПроверки.Добавить("333.40");
		Если МассивДляПроверки.Найти(СокрЛП(Титульная.Пункт) + "." + СокрЛП(Титульная.Подпункт)) = Неопределено Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Допустимы только следующие статьи НК: 78, 79, 176, 203, 333.40", "Титульная", "Пункт"));
		КонецЕсли;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Сумма) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана сумма к возврату", "Титульная", "Сумма"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.Год)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.Год))
		Или (СтрДлина(СокрЛП(Титульная.Год)) <> 4)Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан год", "Титульная", "Год"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Месяц)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.Месяц))
		Или (СтрДлина(СокрЛП(Титульная.Месяц)) <> 2)Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан период", "Титульная", "Месяц"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодПериода) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый период", "Титульная", "КодПериода"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ОКТМО) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ОКТМО)) 
		Или (Не (СтрДлина(СокрЛП(Титульная.ОКТМО)) = 8 Или СтрДлина(СокрЛП(Титульная.ОКТМО)) = 11)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно заполнен ОКТМО", "Титульная", "ОКТМО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КБК) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КБК))
		Или (Не (СтрДлина(СокрЛП(Титульная.КБК)) = 20))Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно заполнен КБК", "Титульная", "КБК"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Признак1) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак", "Титульная", "Признак1"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Признак2) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак", "Титульная", "Признак2"));
	КонецЕсли;
	
	Лист001 = Данные.ДанныеУведомления.Лист001;
	Если Не ЗначениеЗаполнено(Лист001.Л0101) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование банка", "Лист001", "Л0101"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Лист001.Л0102) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование счета", "Лист001", "Л0102"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Лист001.Л0103) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Лист001.Л0103))
		Или (Не (СтрДлина(СокрЛП(Лист001.Л0103)) = 20)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправльно указан корр. счет", "Лист001", "Л0103"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Лист001.Л0104)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Лист001.Л0104))
		Или (Не (СтрДлина(СокрЛП(Лист001.Л0104)) = 9)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправльно указан БИК", "Лист001", "Л0104"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Лист001.Л0105) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак счета", "Лист001", "Л0105"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Лист001.Л0106) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Лист001.Л0106))
		Или (Не (СтрДлина(СокрЛП(Лист001.Л0106)) = 20)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправльно указан счет", "Лист001", "Л0106"));
	КонецЕсли;
	
	Если Лист001.ПрОФЛ = Истина Тогда 
		Если Не ЗначениеЗаполнено(Лист001.ФамилияПолучатель) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия получателя", "Лист001", "ФамилияПолучатель"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист001.ИмяПолучатель) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано имя получателя", "Лист001", "ИмяПолучатель"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист001.Л0108) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код документа", "Лист001", "Л0108"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист001.Л0109) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана серия и номер документа", "Лист001", "Л0109"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист001.Л0110) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата выдачи документа", "Лист001", "Л0110"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист001.Л0111) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан орган, выдавший документ", "Лист001", "Л0111"));
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Лист001.Л0107) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование получателя", "Лист001", "Л0107"));
		КонецЕсли;
	КонецЕсли;
	
	Если Данные.ДанныеУведомления.Свойство("Лист002")
		И Не ЗначениеЗаполнено(Титульная.ИНН) Тогда
		
		Лист002 = Данные.ДанныеУведомления.Лист002;
		Если Не ЗначениеЗаполнено(Лист002.Л201) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код вида документа", "Лист002", "Л201"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист002.Л202) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указаны серия и номер документа", "Лист002", "Л202"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист002.Л203) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан орган, выдавший документ", "Лист002", "Л203"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист002.Л0204) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата выдачи документа", "Лист002", "Л0204"));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист002.КодРегиона) Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Лист002.КодРегиона)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнен/неправильно заполнен адрес", "Лист002", "КодРегиона"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Процедура Проверить_Форма2017_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетностьПереопределяемый.КраткоеНазваниеПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ТлфПодп", Данные.ДанныеУведомления.Титульная.Тлф);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("НаимДок", Данные.ДанныеУведомления.Титульная.НаимДок);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	ОсновныеСведения.Вставить("ПрОФЛ", Данные.ДанныеУведомления.Лист001.ПрОФЛ);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	ДанныеУведомления.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
	ДанныеУведомления.Вставить("ПодписантИмя", Объект.ПодписантИмя);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2017_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2017_1");
	ЗаполнитьДанными_Форма2017_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2017_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ДополнитьПараметры(Параметры)
	Если ЗначениеЗаполнено(Параметры.ДанныеУведомления.Титульная.Месяц) Тогда 
		Месяц = Прав("00" + Параметры.ДанныеУведомления.Титульная.Месяц, 2);
	Иначе
		Месяц = "00";
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ДанныеУведомления.Титульная.Год) Тогда 
		Год = Прав("0000" + Параметры.ДанныеУведомления.Титульная.Год, 4);
	Иначе
		Год = "0000";
	КонецЕсли;
	
	Параметры.ДанныеУведомления.Титульная.Вставить("НалПериод1", Строка(Параметры.ДанныеУведомления.Титульная.КодПериода) + "." + Месяц + "." + Год);
	НомерСтНК = Строка(Параметры.ДанныеУведомления.Титульная.Пункт);
	Если ЗначениеЗаполнено(Параметры.ДанныеУведомления.Титульная.Подпункт) Тогда 
		НомерСтНК = НомерСтНК + "." + Строка(Параметры.ДанныеУведомления.Титульная.Подпункт);
	КонецЕсли;
	Параметры.ДанныеУведомления.Титульная.Вставить("НомерСтНК", НомерСтНК);
	Параметры.ДанныеУведомления.Лист001.Л0110 = Формат(Параметры.ДанныеУведомления.Лист001.Л0110, "ДФ=dd.MM.yyyy");
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Узел, ПараметрыТекущейСтраницы = Неопределено, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если Стр.Тип = "А" Или Стр.Тип = "A" Или Стр.Тип = "П" Тогда
			Если ЗначениеЗаполнено(Стр.Ключ) Тогда
				ЗначениеПоказателя = Неопределено;
				Если ПараметрыТекущейСтраницы <> Неопределено И ПараметрыТекущейСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				ИначеЕсли ПараметрыТекущейСтраницы = Неопределено 
					И ЗначениеЗаполнено(Стр.Раздел)
					И ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Раздел, ЗначениеПоказателя) Тогда 
					Если ЗначениеПоказателя.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда
						РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда
				
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						Если УИДРодителя = Неопределено Или СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, СтрМнгч.Значение, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Стр, ПараметрыТекущейСтраницы, УИДРодителя)
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ПечатьСразу_Форма2017_1(Объект)
	ПечатнаяФорма = СформироватьМакет_Форма2017_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция СформироватьМакет_Форма2017_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.Вывести(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьМакет("МакетПредупреждениеОНевозможностиПечати"));
	Возврат ПечатнаяФорма;
КонецФункции

Процедура НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеВозвратНалога.ПолучитьМакет(ИмяМакета);
	Исключение
		Возврат;
	КонецПопытки;
	
	НомСтр = НомСтр + 1;
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
		ИначеЕсли КЗ.Значение = Неопределено Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ, МакетПФ.Области, "-");
		КонецЕсли;
	КонецЦикла;
	
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
	ЗаполнитьЗначенияСвойств(МакетПФ.Параметры, СтруктураДанныхСтраницы);
	ПечатнаяФорма.Вывести(МакетПФ);
КонецПроцедуры

Процедура НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПарам, ПечатнаяФорма, НомСтр, ИННКПП)
	МакетыПФ = СтрПарам.МакетыПФ;
	ИмяМакета = СтрПарам.ИмяМакета;
	
	Если Не ЗначениеЗаполнено(МакетыПФ) И Не ЗначениеЗаполнено(ИмяМакета) Тогда 
		Для Каждого СтрПодч Из СтрПарам.Строки Цикл
			НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПодч, ПечатнаяФорма, НомСтр, ИННКПП);
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МакетыПФ) Тогда 
		МассивИменМакетов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МакетыПФ, ";");
	Иначе 
		МассивИменМакетов = Новый Массив;
		МассивИменМакетов.Добавить("ПФ_" + ИмяМакета);
	КонецЕсли;
	
	Если СтруктураПараметров.ДанныеУведомления.Свойство(СтрПарам.ИДНаименования) Тогда 
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл 
			СтруктураДанныхСтраницы = СтруктураПараметров.ДанныеУведомления[СтрПарам.ИДНаименования];
			Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(СтруктураДанныхСтраницы) Тогда
				НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП);
				Если СтрПарам.ИДНаименования = "Титульная" Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
					ПечатнаяФорма.Области.ЭлАдрес.Текст = СтруктураДанныхСтраницы.ЭлАдрес;
					Если Не ЗначениеЗаполнено(СтруктураДанныхСтраницы.НомерКорректировки) Тогда
						УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("0--", "НомерКорректировки", ПечатнаяФорма.Области);
					КонецЕсли;
				КонецЕсли;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2017_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2017_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Лист001"], НомСтр, "Печать_Форма2017_1_Лист001", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	Если Не ЗначениеЗаполнено(СтруктураПараметров.ДанныеУведомления.Титульная.ИНН)
		И Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Лист002"], НомСтр, "Печать_Форма2017_1_Лист002", ПечатнаяФорма, ИННКПП);
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	КонецЕсли;
	
	Возврат Листы;
КонецФункции

Функция СформироватьПустоеДеревоСтраниц()
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("ИндексКартинки", Новый ОписаниеТипов("Число"));
	Дерево.Колонки.Добавить("ИмяМакета", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Многостраничность", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Многострочность", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("УИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Дерево.Колонки.Добавить("ИДНаименования", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("МакетыПФ", Новый ОписаниеТипов("Строка"));
	
	Стр001 = Дерево.Строки.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2017_1_Титульная";
	
	Стр001 = Дерево.Строки.Добавить();
	Стр001.Наименование = "Сведения о"+символы.ПС+"счете в банке";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист001";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист001";
	Стр001.МакетыПФ = "Печать_Форма2017_1_Лист001";
	
	Стр001 = Дерево.Строки.Добавить();
	Стр001.Наименование = "Сведения о физическом"+символы.ПС+"лице, не являющимся"+символы.ПС+"индивидуальным предпринимателем";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист002";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист002";
	Стр001.МакетыПФ = "Печать_Форма2017_1_Лист002";
	
	Возврат Дерево;
КонецФункции

Процедура СоздатьЗаявлениеОВозвратеНалога(ВыборкаСтрока) Экспорт
	Попытка
		Если Не ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.СообщенияВКонтролирующиеОрганы.КонвертацияОтчетовПриПереходеС82") Тогда
			Возврат;
		КонецЕсли;
		
		НачатьТранзакцию();
		РегОтчет = ВыборкаСтрока.Ссылка.ПолучитьОбъект();
		Уведомление = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		Уведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога;
		Уведомление.Организация = ВыборкаСтрока.Организация;
		
		ДанныеОтчета = ВыборкаСтрока.ДанныеОтчета.Получить();
		Уведомление.ИмяОтчета = "РегламентированноеУведомлениеВозвратНалога";
		Уведомление.ИмяФормы = "Форма2017_1";
		
		Уведомление.ПодписантФамилия = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ПодпФ;
		Уведомление.ПодписантИмя = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ПодпИ;
		Уведомление.ПодписантОтчество = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ПодпО;
		Уведомление.ДатаПодписи = РегОтчет.Дата;
		Уведомление.Дата = ТекущаяДатаСеанса();
		
		Титульный = Новый Структура;
		Для Каждого КЗ Из ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный Цикл 
			Титульный.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
		Лист001 = Новый Структура;
		Для Каждого КЗ Из ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаЛист001 Цикл 
			Лист001.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
		Лист002 = Новый Структура;
		Для Каждого КЗ Из ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаЛист002 Цикл 
			Лист002.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ДеревоСтраниц", СформироватьПустоеДеревоСтраниц());
		СтруктураПараметров.Вставить("ДанныеУведомления", Новый Структура("Титульный, Лист001, Лист002", Титульный, Лист001, Лист002));
		СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", Ложь);
		Уведомление.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
		
		РегОтчет.Комментарий = "##УведомлениеОСпецрежимахНалогообложения##" + ВыборкаСтрока.Комментарий;
		РегОтчет.ПометкаУдаления = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(РегОтчет);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Уведомление);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Уведомление = Уведомление;
		ЗаписьСоответствия.Записать(Истина);

		ЗафиксироватьТранзакцию();
	Исключение
		Если ТранзакцияАктивна() Тогда 
			ОтменитьТранзакцию();
		КонецЕсли;
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Регламентированная отчетность. Не удалось преобразовать отчет'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,ВыборкаСтрока.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
