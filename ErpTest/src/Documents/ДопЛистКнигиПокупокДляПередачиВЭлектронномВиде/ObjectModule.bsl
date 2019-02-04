#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выгружает документ и возвращает свойства файла выгрузки.
//
// Параметры:
//  УникальныйИдентификатор - УникальныйИдентификатор - адрес во временном хранилище.
//
// Возвращаемое значение:
//  Массив - массив структур. Пустой если не удалось сформировать файл выгрузки. Ключи структуры:
//    * АдресФайлаВыгрузки - адрес двоичных данных файла выгрузки во временном хранилище;
//    * ИмяФайлаВыгрузки - короткое имя файла выгрузки (с расширением).
//
Функция ВыгрузитьДокумент(УникальныйИдентификатор = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НалоговыйПериод >= '2017-10-01' Тогда
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеДопЛистовКнигиПокупок_503(ЭтотОбъект);
		
	ИначеЕсли НалоговыйПериод >= '2014-10-01' Тогда
		Результат = УчетНДСФормированиеОтчетности.ЭлектронноеПредставлениеДопЛистовКнигиПокупок_502(ЭтотОбъект);
		
	Иначе
		СодержаниеВыгрузки = ЭлектронноеПредставление();
		
		Для Каждого ЭлементВыгрузки Из СодержаниеВыгрузки Цикл
			
			Если Результат = Неопределено Тогда
				Результат = Новый Массив;
			КонецЕсли;
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
			СохраняемыйФайл = Новый ТекстовыйДокумент;
			СохраняемыйФайл.УстановитьТекст(ЭлементВыгрузки.ТекстФайла);
			СохраняемыйФайл.Записать(ИмяВременногоФайла, ЭлементВыгрузки.КодировкаТекста);
			
			ФайлВыгрузки = Новый ДвоичныеДанные(ИмяВременногоФайла);
			Если УникальныйИдентификатор <> Неопределено Тогда
				СсылкаНаДвоичныеДанныеФайла = ПоместитьВоВременноеХранилище(ФайлВыгрузки, УникальныйИдентификатор);
			Иначе
				СсылкаНаДвоичныеДанныеФайла = ПоместитьВоВременноеХранилище(ФайлВыгрузки);
			КонецЕсли;
			
			СтруктураВыгрузки = Новый Структура;
			СтруктураВыгрузки.Вставить("АдресФайлаВыгрузки", СсылкаНаДвоичныеДанныеФайла);
			СтруктураВыгрузки.Вставить("ИмяФайлаВыгрузки", ЭлементВыгрузки.ИмяФайла);
			
			Результат.Добавить(СтруктураВыгрузки);

			// Удаляем временный файл.
			Попытка
				УдалитьФайлы(ИмяВременногоФайла);
			Исключение
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Отчеты по НДС в электронном виде.Доп лист книги покупок'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда 
		НалоговыйПериод = НачалоКвартала(НачалоКвартала(Дата)-1);
	КонецЕсли;
	НомерДополнительногоЛиста	= ПолучитьСледующийНомерДополнительногоЛиста();
	ПериодПоСКНП 				= УчетНДСКлиентСервер.ПолучитьКодПоСКНП(НалоговыйПериод, Реорганизация);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйПериод				= НачалоКвартала(НалоговыйПериод);
	ПериодСоставления			= НачалоКвартала(Дата); 
	НомерДополнительногоЛиста	= ПолучитьСледующийНомерДополнительногоЛиста();
	
	НайденныеДокументы	= Документы.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод, Дата, ?(НалоговыйПериод < '20141001',0,2));
	Если НЕ НайденныеДокументы = Неопределено Тогда
		
		Для каждого Документ Из НайденныеДокументы Цикл
			
			Если НЕ Документ = Ссылка Тогда
				ТекстСообщения	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Уже имеется оформленный дополнительный лист книги покупок за %1 по периоду %2'"), 
					Формат(Дата, "ДЛФ=ДД"), 
					ПредставлениеПериода(НачалоКвартала(НалоговыйПериод), КонецКвартала(НалоговыйПериод), "ФП = Истина"));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Документ, , , Отказ);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("АдресДанныхДляПередачи") Тогда 
		
		ДанныеДляПередачи = ПолучитьИзВременногоХранилища(ДополнительныеСвойства.АдресДанныхДляПередачи);
		РазделыОтчета = ПроверкаКонтрагентов.РазделыОтчета(ДанныеДляПередачи);
		Если РазделыОтчета.Количество() = 0 Тогда 
			ТекстСообщения	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Нет данных для заполнения дополнительного листа книги покупок за период %1'"), 
							ПредставлениеПериода(НачалоКвартала(НалоговыйПериод), КонецКвартала(НалоговыйПериод), "ФП = Истина"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Документ, , , Отказ);
			Возврат;
		КонецЕсли;
		ПредставлениеОтчета = РазделыОтчета[0].ХранилищеОтчета;
		
		ДанныеОтчета = Новый ХранилищеЗначения(ДанныеДляПередачи.ДанныеОтчета);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если НачалоДня(Дата) <= КонецКвартала(НалоговыйПериод)
		И НалоговыйПериод < '20141001' Тогда
		ТекстСообщения	= НСтр("ru = 'Дата документа должна быть позже конца налогового периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Дата", , Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата			= НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный	= Пользователи.ТекущийПользователь();
	
	НалоговыйПериод				= НачалоКвартала(НачалоКвартала(Дата)-1);
	НомерДополнительногоЛиста	= ПолучитьСледующийНомерДополнительногоЛиста();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСледующийНомерДополнительногоЛиста()
	Перем СледующийНомерДополнительногоЛиста;
	
	СледующийНомерДополнительногоЛиста	= 1;
	
	НайденныеДокументы	= Документы.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод, Дата,  -1);
	Если НЕ НайденныеДокументы = Неопределено Тогда
		ПоследнийДокумент	= НайденныеДокументы[НайденныеДокументы.ВГраница()];
		СледующийНомерДополнительногоЛиста	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПоследнийДокумент, "НомерДополнительногоЛиста") + 1;
	КонецЕсли;
	
	Возврат СледующийНомерДополнительногоЛиста;

КонецФункции

// Формирует сведения необходимые для сохранения и передачи файла (файлов) электронного
// представления документа.
//
// Возвращаемое значение:
//  ТаблицаЗначений - сведения электронного представления документа, включающие в себя
//                    имя файла(файлов), текст(тексты) и кодировку представления.
//
Функция ЭлектронноеПредставление() Экспорт
	
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления();
	
	СтруктураВыгрузки = ИзвлечьСтруктуруXML();
	ЗаполнитьДанными(СтруктураВыгрузки, ОсновныеСведения);
	
	Текст = ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
	
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления()
	
	ОсновныеСведения = Новый Структура;
	
	ОсновныеСведения.Вставить("ДатаФормированияФайла", ТекущаяДатаСеанса());
	
	ЭтоПБОЮЛ = НЕ РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация);
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", ЭтоПБОЮЛ);
	ОсновныеСведения.Вставить("ЭтоЮЛ", НЕ ЭтоПБОЮЛ);
	ОсновныеСведения.Вставить("ЭтоИП", ЭтоПБОЮЛ);
	
	СведенияОбОрганизации = СведенияОбОрганизации();
	
	Если ЭтоПБОЮЛ Тогда
		ОсновныеСведения.Вставить("ИННФЛ", СведенияОбОрганизации.ИННЮЛ);
		СведенияОЮрФизЛице  = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация, КонецКвартала(НалоговыйПериод));
		СвидетельствоОРегистрации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОЮрФизЛице, "Свидетельство");
		ОсновныеСведения.Вставить("СвГосРегИП", СвидетельствоОРегистрации);
		
		СведенияОбИП = СведенияОбИП();
		ОсновныеСведения.Вставить("ФамилияИП",  СведенияОбИП.Фамилия);
		ОсновныеСведения.Вставить("ИмяИП",      СведенияОбИП.Имя);
		ОсновныеСведения.Вставить("ОтчествоИП", СведенияОбИП.Отчество);
	Иначе
		ОсновныеСведения.Вставить("НаимОрг", СведенияОбОрганизации.НаимЮЛПол);
		ОсновныеСведения.Вставить("ИННЮЛ", СведенияОбОрганизации.ИННЮЛ);
		ОсновныеСведения.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИФНС) Тогда
		ОсновныеСведения.Вставить("КодНО", ИФНС.Код);
	Иначе
		ОсновныеСведения.Вставить("КодНО", СведенияОбОрганизации.КодНО);
	КонецЕсли;
	
	ДобавитьСведенияОПодписанте(ОсновныеСведения);
	
	ОсновныеСведения.Вставить("Период", ПериодПоСКНП);
	
	ОтчетныйГод = Формат(НалоговыйПериод, "ДФ=yyyy");
	ОсновныеСведения.Вставить("ОтчГод", ОтчетныйГод);
	
	ОсновныеСведения.Вставить("НомерДополнительногоЛиста", НомерДополнительногоЛиста);
	ОсновныеСведения.Вставить("ДатаДополнительногоЛиста", Формат(Дата, "ДФ=dd.MM.yyyy"));
	
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
	
КонецФункции

Функция СведенияОбОрганизации()
	
	СтрокаСведений = "ИННЮЛ, КППЮЛ, НаимЮЛПол, КодНО, ТелОрганизации, ФИО, ОКВЭД, ОКАТО";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		Организация,
		КонецКвартала(НалоговыйПериод),
		СтрокаСведений);
	
	Возврат СведенияОбОрганизации;
	
КонецФункции

Процедура ДобавитьСведенияОПодписанте(ОсновныеСведения)
	
	Если ЗначениеЗаполнено(ИФНС) И ЗначениеЗаполнено(ИФНС.Представитель) Тогда
		Если ТипЗнч(ИФНС.Представитель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			ФИОПодписанта = СведенияОФизЛице(ИФНС.Представитель);
			ОсновныеСведения.Вставить("ПрПодп", "2");
			ОсновныеСведения.Вставить("ПодпФамилия",  ФИОПодписанта.Фамилия);
			ОсновныеСведения.Вставить("ПодпИмя",      ФИОПодписанта.Имя);
			ОсновныеСведения.Вставить("ПодпОтчество", ФИОПодписанта.Отчество);
			ОсновныеСведения.Вставить("НаимДокПодп",  ИФНС.ДокументПредставителя);
			
		ИначеЕсли НЕ ПустаяСтрока(ИФНС.УполномоченноеЛицоПредставителя) Тогда
			ОсновныеСведения.Вставить("ПрПодп", "2");
			СоставляющиеФИО = СоставляющиеФИО(ИФНС.УполномоченноеЛицоПредставителя);
			ОсновныеСведения.Вставить("ПодпФамилия",  СоставляющиеФИО.Фамилия);
			ОсновныеСведения.Вставить("ПодпИмя",      СоставляющиеФИО.Имя);
			ОсновныеСведения.Вставить("ПодпОтчество", СоставляющиеФИО.Отчество);
			ОсновныеСведения.Вставить("НаимДокПодп",  ИФНС.ДокументПредставителя);
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ОсновныеСведения.Свойство("ПрПодп") ИЛИ (ОсновныеСведения.Свойство("ПрПодп") И ОсновныеСведения.ПрПодп <> "2") Тогда
		Если ЗначениеЗаполнено(Подписант) Тогда
			ФИОПодписанта = СведенияОФизЛице(Подписант);
			ОсновныеСведения.Вставить("ПрПодп", "1");
			ОсновныеСведения.Вставить("ПодпФамилия",  ФИОПодписанта.Фамилия);
			ОсновныеСведения.Вставить("ПодпИмя",      ФИОПодписанта.Имя);
			ОсновныеСведения.Вставить("ПодпОтчество", ФИОПодписанта.Отчество);
			
		Иначе
			ФИОПодписанта = СведенияОРуководителе();
			ОсновныеСведения.Вставить("ПрПодп", "1");
			ОсновныеСведения.Вставить("ПодпФамилия",  ФИОПодписанта.Фамилия);
			ОсновныеСведения.Вставить("ПодпИмя",      ФИОПодписанта.Имя);
			ОсновныеСведения.Вставить("ПодпОтчество", ФИОПодписанта.Отчество);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СведенияОРуководителе()
	
	Результат = Новый Структура("Фамилия, Имя, Отчество", "", "", "");
	
	РеквизитыОтветственныхЛиц = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, Дата);
	Если ЗначениеЗаполнено(РеквизитыОтветственныхЛиц.Руководитель) Тогда
		Результат.Фамилия 	= СокрЛП(РеквизитыОтветственныхЛиц.РуководительФИО.Фамилия);
		Результат.Имя 		= СокрЛП(РеквизитыОтветственныхЛиц.РуководительФИО.Имя);
		Результат.Отчество	= СокрЛП(РеквизитыОтветственныхЛиц.РуководительФИО.Отчество);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СведенияОФизЛице(ФизЛицо)
	
	Результат = Новый Структура("Фамилия, Имя, Отчество", "", "", "");
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		ДанныеФЛ = РегистрыСведений.ФИОФизическихЛиц.СрезПоследних(Дата, Новый Структура("ФизическоеЛицо", ФизЛицо));
		Если ДанныеФЛ.Количество() > 0 Тогда
			Результат.Фамилия  = СокрЛП(ДанныеФЛ[0].Фамилия);
			Результат.Имя      = СокрЛП(ДанныеФЛ[0].Имя);
			Результат.Отчество = СокрЛП(ДанныеФЛ[0].Отчество);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СоставляющиеФИО(Знач ФИОСтр)
	
	ФИОСтр = СокрЛП(ФИОСтр);
	ФИО = Новый Структура("Фамилия, Имя, Отчество", "", "", "");
	
	ПервыйПробел = СтрНайти(ФИОСтр, " ");
	Если ПервыйПробел = 0 Тогда
		ФИО.Фамилия = ФИОСтр;
		Возврат ФИО;
	КонецЕсли;
	ФИО.Фамилия = СокрЛП(Лев(ФИОСтр, ПервыйПробел - 1));
	ФИОСтр = СокрЛП(Сред(ФИОСтр, ПервыйПробел + 1));
	
	ВторойПробел = СтрНайти(ФИОСтр, " ");
	Если ВторойПробел = 0 Тогда
		ФИО.Имя = ФИОСтр;
		Возврат ФИО;
	КонецЕсли;
	ФИО.Имя = СокрЛП(Лев(ФИОСтр, ВторойПробел - 1));
	
	ФИО.Отчество = СокрЛП(Сред(ФиоСтр, ВторойПробел + 1));
	
	Возврат ФИО;
	
КонецФункции

Функция СведенияОбИП()
	
	Результат = Новый Структура("Фамилия, Имя, Отчество", "", "", "");
	
	ФЛ = Организация.ИндивидуальныйПредприниматель;
	Если ФЛ = Справочники.ФизическиеЛица.ПустаяСсылка() Тогда
		ФИОИП = Организация.НаименованиеПолное;
	Иначе
		ДанныеФЛ = РегистрыСведений.ФИОФизическихЛиц.СрезПоследних(Дата, Новый Структура("ФизическоеЛицо", ФЛ));
		Если ДанныеФЛ.Количество() > 0 Тогда
			Результат.Фамилия = СокрЛП(ДанныеФЛ[0].Фамилия);
			Результат.Имя = СокрЛП(ДанныеФЛ[0].Имя);
			Результат.Отчество = СокрЛП(ДанныеФЛ[0].Отчество);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления(СведенияОтправки)
	
	Префикс = "1115105";
	Если СведенияОтправки.ЭтоПБОЮЛ Тогда
		ИдентификаторОтправителя = СокрЛП(СведенияОтправки.ИННФЛ);
	Иначе
		ИдентификаторОтправителя = СокрЛП(СведенияОтправки.ИННЮЛ) + СокрЛП(СведенияОтправки.КПП);
	КонецЕсли;
	ИдентификаторПолучателя = СведенияОтправки.КодНО;
	ИдентификационныйНомер1 = Строка(Новый УникальныйИдентификатор);
	ДатаФормированияФайла = Формат(СведенияОтправки.ДатаФормированияФайла, "ДФ=yyyyMMdd");
	ИдентификационныйНомер2 = Строка(Новый УникальныйИдентификатор);
	
	ИдентификаторФайла = Префикс
	                   + "_" + ИдентификаторОтправителя
	                   + "_" + ИдентификаторПолучателя
	                   + "_" + ИдентификационныйНомер1
	                   + "_" + ДатаФормированияФайла
	                   + "_" + ИдентификационныйНомер2;
	
	Возврат ИдентификаторФайла;
	
КонецФункции

Функция ИзвлечьСтруктуруXML()
	
	ДеревоСтруктуры = Новый ДеревоЗначений;
	ДеревоСтруктуры.Колонки.Добавить("Код");
	ДеревоСтруктуры.Колонки.Добавить("ЗначениеПоУмолчанию");
	ДеревоСтруктуры.Колонки.Добавить("Значение");
	ДеревоСтруктуры.Колонки.Добавить("Представление");
	ДеревоСтруктуры.Колонки.Добавить("Тип");
	ДеревоСтруктуры.Колонки.Добавить("Формат");
	ДеревоСтруктуры.Колонки.Добавить("МинРазмерность");
	ДеревоСтруктуры.Колонки.Добавить("МаксРазмерность");
	ДеревоСтруктуры.Колонки.Добавить("Обязательность");
	ДеревоСтруктуры.Колонки.Добавить("Многостраничность");
	ДеревоСтруктуры.Колонки.Добавить("Многострочность");
	ДеревоСтруктуры.Колонки.Добавить("Раздел");
	ДеревоСтруктуры.Колонки.Добавить("Ключ");
	ДеревоСтруктуры.Колонки.Добавить("Условие");
	ДеревоСтруктуры.Колонки.Добавить("Показатели");
	
	Макет = ПолучитьМакет("СхемаВыгрузки501");
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	
	УчтенныеГруппы = Новый Соответствие;
	
	Для Уровень = 0 По Макет.КоличествоУровнейГруппировокСтрок() - 1 Цикл
		Макет.ПоказатьУровеньГруппировокСтрок(Уровень);
		Для НомерСтроки = 2 По ВысотаТаблицы Цикл
			НомСтр = ВысотаТаблицы - НомерСтроки + 2;
			Если Макет.Область(НомСтр, 0, НомСтр, 0).Видимость И УчтенныеГруппы.Получить(НомСтр) = Неопределено Тогда
				
				РодительскийУзел = ДеревоСтруктуры;
				Если Уровень <> 0 Тогда
					Для Инд = 1 По НомСтр - 2 Цикл
						Узел = УчтенныеГруппы.Получить(НомСтр - Инд);
						Если Узел <> Неопределено Тогда
							РодительскийУзел = Узел;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				НовСтр = РодительскийУзел.Строки.Вставить(0);
				НовСтр.Код = СокрЛП(Макет.Область(НомСтр, 1, НомСтр, 1).Текст);
				НовСтр.Раздел = СокрЛП(Макет.Область(НомСтр, 2, НомСтр, 2).Текст);
				НовСтр.Ключ = СокрЛП(Макет.Область(НомСтр, 3, НомСтр, 3).Текст);
				НовСтр.Тип = СокрЛП(Макет.Область(НомСтр, 4, НомСтр, 4).Текст);
				НовСтр.Формат = СокрЛП(Макет.Область(НомСтр, 5, НомСтр, 5).Текст);
				МинРазмерность = СокрЛП(Макет.Область(НомСтр, 6, НомСтр, 6).Текст);
				НовСтр.МинРазмерность = ?(ПустаяСтрока(МинРазмерность), ?(НовСтр.Формат = "N", 99999, 0), Число(МинРазмерность));
				МаксРазмерность = СокрЛП(Макет.Область(НомСтр, 7, НомСтр, 7).Текст);
				НовСтр.МаксРазмерность = ?(ПустаяСтрока(МаксРазмерность), 99999, Число(МаксРазмерность));
				НовСтр.Обязательность = СокрЛП(Макет.Область(НомСтр, 8, НомСтр, 8).Текст);
				НовСтр.Многостраничность = НЕ ПустаяСтрока(Макет.Область(НомСтр, 9, НомСтр, 9).Текст);
				НовСтр.Многострочность = НЕ ПустаяСтрока(Макет.Область(НомСтр, 10, НомСтр, 10).Текст);
				НовСтр.Условие = СокрЛП(Макет.Область(НомСтр, 11, НомСтр, 11).Текст);
				НовСтр.ЗначениеПоУмолчанию = СокрЛП(Макет.Область(НомСтр, 12, НомСтр, 12).Текст);
				НовСтр.Представление = СокрЛП(Макет.Область(НомСтр, 13, НомСтр, 13).Текст);
				
				УчтенныеГруппы.Вставить(НомСтр, НовСтр);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДеревоСтруктуры;
	
КонецФункции

Процедура ЗаполнитьДанными(ДеревоВыгрузки, Параметры)
	
	ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	ЗаполнитьДаннымиИтого(Параметры, ДеревоВыгрузки);
	ЗаполнитьДаннымиВсего(Параметры, ДеревоВыгрузки);
	ЗаполнитьДаннымиТабличнойЧасти(Параметры, ДеревоВыгрузки);
	ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
	
КонецПроцедуры

Процедура ОбработатьУсловныеЭлементы(Знач Параметры, Узел)
	
	КоличествоСтрок = Узел.Строки.Количество();
	Для Инд = 1 По КоличествоСтрок Цикл
		ТекСтр = Узел.Строки.Получить(КоличествоСтрок - Инд);
		Если НЕ ПустаяСтрока(ТекСтр.Условие) Тогда
			Если НЕ УсловиеВыполнено(Параметры, ТекСтр.Условие) Тогда
				Узел.Строки.Удалить(ТекСтр);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		ОбработатьУсловныеЭлементы(Параметры, ТекСтр);
	КонецЦикла;
	
КонецПроцедуры

Функция УсловиеВыполнено(Параметры, Условие)
	
	Попытка
		РезультатВычисленияВыражения = ОбщегоНазначения.ВычислитьВБезопасномРежиме(СтрЗаменить(Условие, "&", "Параметры."));
		Возврат НЕ (РезультатВычисленияВыражения = Ложь);
	Исключение
		Возврат Истина;
	КонецПопытки;
	
КонецФункции

Процедура ЗаполнитьПараметры(Параметры, Узел)
	
	Для Каждого Стр из Узел.Строки Цикл
		Если Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда // учтем оба варианта: кириллицу и латиницу
			ЗаполнитьПараметры(Параметры, Стр);
		Иначе
			Если ПустаяСтрока(Стр.ЗначениеПоУмолчанию) Тогда
				Если НЕ ПустаяСтрока(Стр.Ключ) Тогда
					ВывестиПоказательВXML(Стр, Параметры[Стр.Ключ]);
				Иначе
					Стр.Значение = "";
				КонецЕсли;
			ИначеЕсли Лев(Стр.ЗначениеПоУмолчанию, 1) = "&" Тогда
				ИмяПараметра = Сред(Стр.ЗначениеПоУмолчанию, 2);
				Если Параметры.Свойство(ИмяПараметра) Тогда
					ВывестиПоказательВXML(Стр, Параметры[ИмяПараметра]);
				КонецЕсли;
			Иначе
				Стр.Значение = Стр.ЗначениеПоУмолчанию;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ВывестиПоказательВXML(Узел, ЗначениеПоказателя)
	
	МинШирина = Узел.МинРазмерность;
	МаксШирина = Узел.МаксРазмерность;
	
	Если Узел.Формат = "T" ИЛИ Узел.Формат = "Т" Тогда // учтем оба варианта: кириллицу и латиницу
		Узел.Значение = ?(МаксШирина < СтрДлина(СокрЛП(ЗначениеПоказателя)), СокрЛП(Лев(СокрЛП(ЗначениеПоказателя), МаксШирина)), СокрЛП(ЗначениеПоказателя));
	ИначеЕсли Узел.Формат = "N" Тогда
		СтрокаФормата = "ЧРД=.;ЧН=0;ЧГ=;";
		Если Узел.МаксРазмерность <> 0 И Узел.МаксРазмерность <> 99999 Тогда
			СтрокаФормата = СтрокаФормата + "ЧЦ=" + Формат(Узел.МаксРазмерность, "ЧГ=") + ";";
		КонецЕсли;
		Если Узел.МинРазмерность <> 99999 Тогда
			СтрокаФормата = СтрокаФормата + "ЧДЦ=" + Формат(Узел.МинРазмерность, "ЧГ=") + ";";
		КонецЕсли;
		Узел.Значение = СокрЛП(Формат(ЗначениеПоказателя, СтрокаФормата));
	ИначеЕсли Узел.Формат = "gYear" Тогда
		Если ТипЗнч(ЗначениеПоказателя) = Тип("Дата") Тогда
			Узел.Значение = СокрЛП(Формат(ЗначениеПоказателя, "ДФ=гггг"));
		Иначе
			Узел.Значение = Прав(СокрЛП(ЗначениеПоказателя), 4);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьДаннымиИтого(Параметры, ДеревоВыгрузки)
	
	УзелДокумент = ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	
	УзелСвДопЛКнПок = ПолучитьПодчиненныйЭлемент(УзелДокумент, "СвДопЛКнПок");
	
	УзелВсего = ПолучитьПодчиненныйЭлемент(УзелСвДопЛКнПок, "Итого");
	УстановитьЗначениеЭлемента(УзелВсего, "СтТовУчНалВсего", ВсегоПокупокДо);
	
	ОбразецУзлаВтЧисле = ПолучитьПодчиненныйЭлемент(УзелВсего, "ВтчСтоимПок");
	УдалятьОбразецУзлаВтЧисле = Ложь;
	// НДС 18%.
	Если СуммаБезНДС18До <> 0 ИЛИ НДС18До <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "18", СуммаБезНДС18До, НДС18До);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС 10%.
	Если СуммаБезНДС10До <> 0 ИЛИ НДС10До <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "10", СуммаБезНДС10До, НДС10До);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС 0%.
	Если НДС0До <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "0", НДС0До);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС 20%.
	Если СуммаБезНДС20До <> 0 ИЛИ НДС20До <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "20", СуммаБезНДС20До, НДС20До);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС Без НДС.
	Если СуммаСовсемБезНДСДо <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "без НДС", СуммаСовсемБезНДСДо); // Не локализуется
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	Если УдалятьОбразецУзлаВтЧисле Тогда
		УдалитьУзел(ОбразецУзлаВтЧисле);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДаннымиВсего(Параметры, ДеревоВыгрузки)
	
	УзелДокумент = ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	
	УзелСвДопЛКнПок = ПолучитьПодчиненныйЭлемент(УзелДокумент, "СвДопЛКнПок");
	
	УзелВсего = ПолучитьПодчиненныйЭлемент(УзелСвДопЛКнПок, "Всего");
	УстановитьЗначениеЭлемента(УзелВсего, "СтТовУчНалВсего", ВсегоПокупок);
	
	ОбразецУзлаВтЧисле = ПолучитьПодчиненныйЭлемент(УзелВсего, "ВтчСтоимПок");
	УдалятьОбразецУзлаВтЧисле = Ложь;
	// НДС 18%.
	Если СуммаБезНДС18 <> 0 ИЛИ НДС18 <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "18", СуммаБезНДС18, НДС18);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС 10%.
	Если СуммаБезНДС10 <> 0 ИЛИ НДС10 <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "10", СуммаБезНДС10, НДС10);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС 0%.
	Если НДС0 <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "0", НДС0);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС 20%.
	Если СуммаБезНДС20 <> 0 ИЛИ НДС20 <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "20", СуммаБезНДС20, НДС20);
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	// НДС Без НДС.
	Если СуммаСовсемБезНДС <> 0 Тогда
		НовыйУзелВтЧисле = ПродублированныйУзелОбразец(ОбразецУзлаВтЧисле);
		ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтЧисле, "без НДС", СуммаСовсемБезНДС); // Не локализуется
		УдалятьОбразецУзлаВтЧисле = Истина;
	КонецЕсли;
	Если УдалятьОбразецУзлаВтЧисле Тогда
		УдалитьУзел(ОбразецУзлаВтЧисле);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДаннымиТабличнойЧасти(Параметры, ДеревоВыгрузки)
	
	УзелДокумент = ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	
	ОбразецУзелСвПокупка = ПолучитьПодчиненныйЭлемент(УзелДокумент, "СвПокупка");
	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		НовыйУзелСвПокупка = ПродублированныйУзелОбразец(ОбразецУзелСвПокупка);
		
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "НомПП", СтрокаТабличнойЧасти.Ном);
		
		ДатаНомерСчетаФактуры = СтрокаТабличнойЧасти.ДатаНомер;
		РеквизитыСчетаФактуры = РасщепленнаяСтрока(ДатаНомерСчетаФактуры, ";");
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ДатаСчФ", СокрЛП(РеквизитыСчетаФактуры[0]));
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "НомСчФ", СокрЛП(РеквизитыСчетаФактуры[1]));
		
		НомерДатаИсправленияСчетаФактуры = СтрокаТабличнойЧасти.НомерДатаИсправления;
		РеквизитыИсправленияСчетаФактуры = РасщепленнаяСтрока(НомерДатаИсправленияСчетаФактуры, ";");
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "НомИспрСчФ", СокрЛП(РеквизитыИсправленияСчетаФактуры[0]));
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ДатаИспрСчФ", СокрЛП(РеквизитыИсправленияСчетаФактуры[1]));
		
		НомерДатаКорректировочногоСчетаФактуры = СтрокаТабличнойЧасти.НомерДатаКорректировки;
		РеквизитыКорректировочногоСчетаФактуры = РасщепленнаяСтрока(НомерДатаКорректировочногоСчетаФактуры, ";");
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "НомерКСчФ", СокрЛП(РеквизитыКорректировочногоСчетаФактуры[0]));
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ДатаКСчФ", СокрЛП(РеквизитыКорректировочногоСчетаФактуры[1]));
		
		НомерДатаИсправленияКорректировочногоСчетаФактуры = СтрокаТабличнойЧасти.НомерДатаИсправленияКорректировки;
		РеквизитыИсправленияКорректировочногоСчетаФактуры = РасщепленнаяСтрока(НомерДатаИсправленияКорректировочногоСчетаФактуры, ";");
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "НомИспрКСчФ", СокрЛП(РеквизитыИсправленияКорректировочногоСчетаФактуры[0]));
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ДатаИспрКСчФ", СокрЛП(РеквизитыИсправленияКорректировочногоСчетаФактуры[1]));
		
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ДатаПринУчет", СтрокаТабличнойЧасти.ДатаОприходования);
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "НаимПрод", СтрокаТабличнойЧасти.Продавец);
		ИНН = СокрЛП(СтрокаТабличнойЧасти.ПродавецИНН);
		Если СтрДлина(ИНН) = 12 Тогда
			УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ИННФЛ", ИНН);
		ИНаче
			УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "ИННЮЛ", ИНН);
			УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "КПП", СтрокаТабличнойЧасти.ПродавецКПП);
		КонецЕсли;
		
		УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "СтТовУчНалВсего", СтрокаТабличнойЧасти.ВсегоПокупок);
		
		ОбразецУзлаДатаОплСчФПрод = ПолучитьПодчиненныйЭлемент(НовыйУзелСвПокупка, "ДатаОплСчФПрод");
		УдалятьОбразецУзлаДатаОплСчФПрод = Ложь;
		
		ДатыОплаты = МассивПодстрок(СтрокаТабличнойЧасти.ДатаОплаты, ",");
		Для Каждого СтрокаДатыОплаты Из ДатыОплаты Цикл
			Если ЗначениеЗаполнено(СтрокаДатыОплаты) Тогда
				НовыйУзелДатаОплСчФПрод = ПродублированныйУзелОбразец(ОбразецУзлаДатаОплСчФПрод);
				ВывестиПоказательВXML(НовыйУзелДатаОплСчФПрод, Лев(СокрЛП(СтрокаДатыОплаты), 10));
				УдалятьОбразецУзлаДатаОплСчФПрод = Истина;
			КонецЕсли;
		КонецЦикла;
		Если УдалятьОбразецУзлаДатаОплСчФПрод Тогда
			УдалитьУзел(ОбразецУзлаДатаОплСчФПрод);
		КонецЕсли;
		
		ОбразецУзлаВтчСтоимПок = ПолучитьПодчиненныйЭлемент(НовыйУзелСвПокупка, "ВтчСтоимПок");
		УдалятьОбразецУзлаВтчСтоимПок = Ложь;
		// НДС 18%.
		Если СтрокаТабличнойЧасти.СуммаБезНДС18 <> 0 ИЛИ СтрокаТабличнойЧасти.НДС18 <> 0 Тогда
			НовыйУзелВтчСтоимПок = ПродублированныйУзелОбразец(ОбразецУзлаВтчСтоимПок);
			ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтчСтоимПок, "18", СтрокаТабличнойЧасти.СуммаБезНДС18, СтрокаТабличнойЧасти.НДС18);
			УдалятьОбразецУзлаВтчСтоимПок = Истина;
		КонецЕсли;
		// НДС 10%.
		Если СтрокаТабличнойЧасти.СуммаБезНДС10 <> 0 ИЛИ СтрокаТабличнойЧасти.НДС10 <> 0 Тогда
			НовыйУзелВтчСтоимПок = ПродублированныйУзелОбразец(ОбразецУзлаВтчСтоимПок);
			ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтчСтоимПок, "10", СтрокаТабличнойЧасти.СуммаБезНДС10, СтрокаТабличнойЧасти.НДС10);
			УдалятьОбразецУзлаВтчСтоимПок = Истина;
		КонецЕсли;
		// НДС 0%.
		Если СтрокаТабличнойЧасти.НДС0 <> 0 Тогда
			НовыйУзелВтчСтоимПок = ПродублированныйУзелОбразец(ОбразецУзлаВтчСтоимПок);
			ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтчСтоимПок, "0", СтрокаТабличнойЧасти.НДС0);
			УдалятьОбразецУзлаВтчСтоимПок = Истина;
		КонецЕсли;
		// НДС 20%.
		Если СтрокаТабличнойЧасти.СуммаБезНДС20 <> 0 ИЛИ СтрокаТабличнойЧасти.НДС20 <> 0 Тогда
			НовыйУзелВтчСтоимПок = ПродублированныйУзелОбразец(ОбразецУзлаВтчСтоимПок);
			ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтчСтоимПок, "20", СтрокаТабличнойЧасти.СуммаБезНДС20, СтрокаТабличнойЧасти.НДС20);
			УдалятьОбразецУзлаВтчСтоимПок = Истина;
		КонецЕсли;
		// НДС Без НДС.
		Если СтрокаТабличнойЧасти.СуммаСовсемБезНДС <> 0 Тогда
			НовыйУзелВтчСтоимПок = ПродублированныйУзелОбразец(ОбразецУзлаВтчСтоимПок);
			ЗаполнитьДаннымиПоСтавкеНДС(НовыйУзелВтчСтоимПок, "без НДС", СтрокаТабличнойЧасти.СуммаСовсемБезНДС); // Не локализуется
			УдалятьОбразецУзлаВтчСтоимПок = Истина;
		КонецЕсли;
		Если УдалятьОбразецУзлаВтчСтоимПок Тогда
			УдалитьУзел(ОбразецУзлаВтчСтоимПок);
		КонецЕсли;
		
		ОбразецУзлаНомерТД = ПолучитьПодчиненныйЭлемент(НовыйУзелСвПокупка, "НомТД");
		
		ПроисхождениеТовара = СтрокаТабличнойЧасти.НомерГТД;
		РеквизитыПроисхожденияТовара = МассивПодстрок(ПроисхождениеТовара, ";");
		Если РеквизитыПроисхожденияТовара.Количество() >= 2 Тогда
			УстановитьЗначениеЭлемента(НовыйУзелСвПокупка, "КодСтрПроисх", Лев(СокрЛП(РеквизитыПроисхожденияТовара[0]), 3));
			Для Инд = 1 По РеквизитыПроисхожденияТовара.Количество() - 1 Цикл
				НовыйУзелНомерТД = ПродублированныйУзелОбразец(ОбразецУзлаНомерТД);
				ВывестиПоказательВXML(НовыйУзелНомерТД, Лев(СокрЛП(РеквизитыПроисхожденияТовара[Инд]), 29));
			КонецЦикла;
		КонецЕсли;
		
		УдалитьУзел(ОбразецУзлаНомерТД);
		
	КонецЦикла;
	УдалитьУзел(ОбразецУзелСвПокупка);
	
КонецПроцедуры

Функция РасщепленнаяСтрока(СтрокаЗначения, Разделитель)
	
	Результат = Новый Массив;
	
	ПозицияРазделителя = СтрНайти(СтрокаЗначения, Разделитель);
	Если ПозицияРазделителя = 0 Тогда
		Результат.Добавить(СтрокаЗначения);
		Результат.Добавить("");
	Иначе
		Результат.Добавить(Лев(СтрокаЗначения, ПозицияРазделителя - 1));
		Результат.Добавить(Сред(СтрокаЗначения, ПозицияРазделителя + 1));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция МассивПодстрок(Знач ИсходнаяСтрока, Разделитель)
	
	Результат = Новый Массив;
	
	ДлинаРазделителя = СтрДлина(Разделитель);
	
	Пока Истина Цикл
		ПозицияРазделителя = СтрНайти(ИсходнаяСтрока, Разделитель);
		Если ПозицияРазделителя = 0 Тогда
			Результат.Добавить(ИсходнаяСтрока);
			Прервать;
		КонецЕсли;
		
		Результат.Добавить(Лев(ИсходнаяСтрока, ПозицияРазделителя - 1));
		ИсходнаяСтрока = Сред(ИсходнаяСтрока, ПозицияРазделителя + ДлинаРазделителя);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьДаннымиПоСтавкеНДС(ЗаполняемыйУзел, Знач СтавкаНДС, СтоимостьБезНДС, СуммаНДС = 0)
	
	Если ТипЗнч(СтавкаНДС) <> Тип("Строка") Тогда
		СтавкаНДС = Строка(СтавкаНДС);
	КонецЕсли;
	
	УстановитьЗначениеЭлемента(ЗаполняемыйУзел, "СтТовБезНДС", СтоимостьБезНДС);
	
	Если СтавкаНДС = "без НДС" Тогда // Не локализуется
		ТипСтавки = "текст";
		ЗначениеСуммы = "без НДС"; // Не локализуется
	Иначе
		ТипСтавки = "процент";
		ЗначениеСуммы = Формат(СуммаНДС, "ЧДЦ=2; ЧРД=.; ЧН=-; ЧГ=0");
	КонецЕсли;
	
	УзелНалСт = ПолучитьПодчиненныйЭлемент(ЗаполняемыйУзел, "НалСт");
	УстановитьЗначениеЭлемента(УзелНалСт, "НалСтВел", СтавкаНДС);
	УстановитьЗначениеЭлемента(УзелНалСт, "НалСтТип", ТипСтавки);
	
	УзелСумНал = ПолучитьПодчиненныйЭлемент(ЗаполняемыйУзел, "СумНал");
	УстановитьЗначениеЭлемента(УзелСумНал, "СумНДС", ЗначениеСуммы);
	
КонецПроцедуры

Функция ПолучитьПодчиненныйЭлемент(Узел, КодЭлемента)
	
	Для Каждого Стр Из Узел.Строки Цикл
		Если Стр.Код = КодЭлемента Тогда
			Возврат Стр;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

Функция ПродублированныйУзелОбразец(УзелОбразец);
	
	РодительУзла = УзелОбразец.Родитель;
	
	ПозицияИсходногоУзла = РодительУзла.Строки.Индекс(УзелОбразец);
	НовыйУзел = РодительУзла.Строки.Вставить(ПозицияИсходногоУзла);
	ЗаполнитьЗначенияСвойств(НовыйУзел, УзелОбразец, , "Родитель, Строки");
	Для Каждого Стр из УзелОбразец.Строки Цикл
		СкопироватьУзел(НовыйУзел, Стр);
	КонецЦикла;
	Возврат НовыйУзел;
	
КонецФункции

Функция СкопироватьУзел(Родитель, Узел)
	
	НовыйУзел = Родитель.Строки.Добавить();
	ЗаполнитьЗначенияСвойств(НовыйУзел, Узел, , "Родитель, Строки");
	Для Каждого Стр из Узел.Строки Цикл
		СкопироватьУзел(НовыйУзел, Стр);
	КонецЦикла;
	Возврат НовыйУзел;
	
КонецФункции

Процедура УстановитьЗначениеЭлемента(УзелРодитель, ИмяЭлемента, ЗначениеЭлемента)
	
	ПодчиненныйЭлемент = ПолучитьПодчиненныйЭлемент(УзелРодитель, ИмяЭлемента);
	ВывестиПоказательВXML(ПодчиненныйЭлемент, ЗначениеЭлемента);
	
КонецПроцедуры

Процедура УдалитьУзел(Узел)
	
	РодительУзла = ?(Узел.Родитель = Неопределено, Узел.Владелец(), Узел.Родитель);
	РодительУзла.Строки.Удалить(Узел);
	
КонецПроцедуры

Процедура ОтсечьНезаполненныеНеобязательныеУзлы(Узел)
	
	КоличествоСтрок = Узел.Строки.Количество();
	Для Инд = 1 По КоличествоСтрок Цикл
		Стр = Узел.Строки.Получить(КоличествоСтрок - Инд);
		ОтсечьНезаполненныеНеобязательныеУзлы(Стр);
	КонецЦикла;
	
	Если ТипЗнч(Узел) <> Тип("ДеревоЗначений") Тогда
		Если (СтрНайти(Узел.Обязательность, "Н") <> 0 ИЛИ СтрНайти(Узел.Обязательность, "H") <> 0) И УзелПуст(Узел) Тогда // учтем оба варианта: кириллицу и латиницу
			УдалитьУзел(Узел);
		ИначеЕсли (СтрНайти(Узел.Обязательность, "М") <> 0 ИЛИ СтрНайти(Узел.Обязательность, "M") <> 0) // учтем оба варианта: кириллицу и латиницу
		И УзелПуст(Узел)
		И ?(СтрНайти(Узел.Обязательность, "О") <> 0 ИЛИ СтрНайти(Узел.Обязательность, "O") <> 0, ИмеютсяАналогичныеСоседниеУзлы(Узел), Истина) Тогда
			УдалитьУзел(Узел);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция УзелПуст(Узел)
	
	ПустойУзел = ?(Узел.Формат = "N", Узел.Значение = "0" ИЛИ (НЕ ЗначениеЗаполнено(Узел.Значение)), НЕ ЗначениеЗаполнено(Узел.Значение));
	Для Каждого Стр из Узел.Строки Цикл
		Если НЕ УзелПуст(Стр) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат ПустойУзел;
	
КонецФункции

Функция ИмеютсяАналогичныеСоседниеУзлы(Стр)
	
	Возврат (Стр.Родитель.Строки.НайтиСтроки(Новый Структура("Ключ", Стр.Ключ), Ложь).Количество() > 1);
	
КонецФункции

Функция ВыгрузитьДеревоВXML(ДеревоВыгрузки, Параметры)
	
	ПотокXML = СоздатьНовыйПотокXML(); // создаем новый поток для записи
	ЗаписатьУзелДереваВXML(ДеревоВыгрузки, ПотокXML, Параметры); // пишем дерево в поток
	ТекстДляЗаписи = ПотокXML.Закрыть(); // получаем текст XML
	ТекстДляЗаписи = "<?xml version=""1.0"" encoding=""windows-1251""?>" + Сред(ТекстДляЗаписи, СтрНайти(ТекстДляЗаписи, Символы.ПС));
	Возврат ТекстДляЗаписи;
	
КонецФункции

Функция СоздатьНовыйПотокXML()
	
	ПотокXML = Новый ЗаписьXML();
	ПотокXML.УстановитьСтроку("UTF-8");
	ПотокXML.ЗаписатьОбъявлениеXML();
	ПотокXML.Отступ = Истина;
	Возврат ПотокXML;
	
КонецФункции

Функция ЗаписатьУзелДереваВXML(СтрокаДерева, ПотокXML, Параметры)
	
	Если ТипЗнч(СтрокаДерева) = Тип("ДеревоЗначений") Тогда
		ПотокXML.ЗаписатьНачалоЭлемента("Файл");
		ПотокXML.ЗаписатьАтрибут("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
		Для Каждого Стр Из СтрокаДерева.Строки Цикл
			ЗаписатьУзелДереваВXML(Стр, ПотокXML, Параметры);
		КонецЦикла;
		ПотокXML.ЗаписатьКонецЭлемента();
	Иначе
		Если СтрокаДерева.Тип = "А" ИЛИ СтрокаДерева.Тип = "A" Тогда 
			ПотокXML.ЗаписатьАтрибут(СтрокаДерева.Код, Строка(СтрокаДерева.Значение));
		Иначе
			ПотокXML.ЗаписатьНачалоЭлемента(СтрокаДерева.Код);
			Для Каждого Лист из СтрокаДерева.Строки Цикл
				ЗаписатьУзелДереваВXML(Лист, ПотокXML, Параметры);
			КонецЦикла;
			ПотокXML.ЗаписатьТекст(Строка(СтрокаДерева.Значение));
			ПотокXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецЕсли