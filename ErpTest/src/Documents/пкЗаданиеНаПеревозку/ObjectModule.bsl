
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
///////////////////////////////////////////////////////////////////////
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
    КонецЕсли;
    
//Рарус Владимир Подрезов 09.10.2017 5502
	Если (НЕ ЭтоНовый())
			И Ссылка.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат 
			И ВидОперации <> Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат
	Тогда
		//сняли перекат
		Если ЗначениеЗаполнено(ЗаданиеНаПеревозку) Тогда
			//Выбранное задание - возврат
			тОбъект = ЗаданиеНаПеревозку.ПолучитьОбъект();
			тОбъект.ВидОперации				= Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента;
			тОбъект.ОбменДанными.Загрузка	= Истина;
			Попытка
				тОбъект.Записать(РежимЗаписиДокумента.Запись, РежимПроведенияДокумента.Неоперативный);
			Исключение
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось отменить перекат для задания %1.'"), тОбъект.Ссылка);
				ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка
					,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				тСообщение = Новый СообщениеПользователю;
				тСообщение.Текст = ОписаниеОшибки();
				тСообщение.Сообщить();
				Отказ = Истина;
				Возврат;
			КонецПопытки;
			Если тОбъект.Проведен Тогда
				тОбъект.ОбменДанными.Загрузка = Ложь;
				Попытка
					тОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				Исключение
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось отменить перекат для задания %1.'"), тОбъект.Ссылка);
					ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка
						,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					тСообщение = Новый СообщениеПользователю;
					тСообщение.Текст = ОписаниеОшибки();
					тСообщение.Сообщить();
					Отказ = Истина;
					Возврат;
				КонецПопытки;
			КонецЕсли;
			
			ЗаданиеНаПеревозку = "";
			
		Иначе
			//Текущее задание возврат, найдем все встречные и установим ДоставкуКлиенту
			ЗапросЗ = Новый Запрос;
			ЗапросЗ.Текст = 
			"ВЫБРАТЬ
			|	пкЗаданиеНаПеревозку.Ссылка
			|ИЗ
			|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
			|ГДЕ
			|	пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
			|	И пкЗаданиеНаПеревозку.Проведен
			|	И НЕ пкЗаданиеНаПеревозку.ПометкаУдаления";
			ЗапросЗ.УстановитьПараметр("ЗаданиеНаПеревозку", Ссылка);
			РезЗапроса = ЗапросЗ.Выполнить().Выбрать();
			Пока РезЗапроса.Следующий() Цикл
				тОбъект = РезЗапроса.Ссылка.ПолучитьОбъект();
				тОбъект.ВидОперации				= Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту;
				тОбъект.ЗаданиеНаПеревозку		= "";
				тОбъект.ОбменДанными.Загрузка	= Истина;
				Попытка
					тОбъект.Записать(РежимЗаписиДокумента.Запись, РежимПроведенияДокумента.Неоперативный);
				Исключение
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось отменить перекат для задания %1.'"), тОбъект.Ссылка);
					ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка
						,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					тСообщение = Новый СообщениеПользователю;
					тСообщение.Текст = ОписаниеОшибки();
					тСообщение.Сообщить();
					Отказ = Истина;
					Возврат;
				КонецПопытки;
				Если тОбъект.Проведен Тогда
					тОбъект.ОбменДанными.Загрузка = Ложь;
					Попытка
						тОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
					Исключение
						ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Не удалось отменить перекат для задания %1.'"), тОбъект.Ссылка);
						ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка
							,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						тСообщение = Новый СообщениеПользователю;
						тСообщение.Текст = ОписаниеОшибки();
						тСообщение.Сообщить();
						Отказ = Истина;
						Возврат;
					КонецПопытки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
//Рарус Владимир Подрезов Конец

    Если ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту
      ИЛИ (ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат И НЕ ЗначениеЗаполнено(ЗаданиеНаПеревозку)) Тогда
        Дата = ЗаявкаНаАрендуТехники.Дата + 1;
    ИначеЕсли ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента
      ИЛИ (ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат И ЗначениеЗаполнено(ЗаданиеНаПеревозку)) Тогда
        Дата = ЗаявкаНаАрендуТехники.Дата + 2;
    КонецЕсли;    
    
    Если ЗначениеЗаполнено(Ссылка) Тогда
        Если Ссылка.КПроверке Тогда
            КПроверке = Ложь; 
        КонецЕсли;    
    КонецЕсли;    

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;

//Рарус Владимир Подрезов 15.05.2017
	Если ЗначениеЗаполнено(Ссылка) И Год(Ссылка.Дата) <> Год(Дата) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
//Рарус Владимир Подрезов Конец
	
	Если ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат Тогда
		//СпособДоставки = Перечисления.СпособыДоставки.пкПерекатНаОбъекте;
	Иначе
		ЗаданиеНаПеревозку = "";
	КонецЕсли;
	
//Рарус Владимир Подрезов 18.09.2017
	Если ЗначениеЗаполнено(ЗаявкаНаАрендуТехники) И (НЕ ЗначениеЗаполнено(АдресДоставки)) Тогда
		АдресДоставки = ЗаявкаНаАрендуТехники.АдресДоставки;
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗаявкаНаАрендуТехники) И (НЕ ЗначениеЗаполнено(АдресДоставки)) И ЗначениеЗаполнено(ЗаявкаНаАрендуТехники.ОбъектСтроительства) Тогда
		АдресДоставки = ?(ЗаявкаНаАрендуТехники.ОбъектСтроительства.пкАдресДоставки = "", ЗаявкаНаАрендуТехники.ОбъектСтроительства.Наименование, ЗаявкаНаАрендуТехники.ОбъектСтроительства.пкАдресДоставки);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗаявкаНаАрендуТехники) И (НЕ ЗначениеЗаполнено(КонтактноеЛицо)) Тогда
		КонтактноеЛицо = ЗаявкаНаАрендуТехники.КонтактноеЛицо;
	КонецЕсли;
//Рарус Владимир Подрезов Конец

	Если ЗначениеЗаполнено(ЗаданиеНаПеревозку) Тогда
		Если (Не ЗначениеЗаполнено(Техника)) И ЗначениеЗаполнено(ЗаданиеНаПеревозку.Техника) Тогда
			Техника = ЗаданиеНаПеревозку.Техника;
		КонецЕсли;
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(ДатаАренды) Тогда
        ДатаАренды = ДатаОтгрузки;    
    КонецЕсли; 
    
    Если РежимЗаписи = РежимЗаписиДокумента.Проведение И НЕ РольДоступна("пкПодтверждениеЗаявокНаАрендуТехники") И НЕ РольДоступна("ПолныеПрава") И НЕ РольДоступна("пкПолныеПрава")
      И ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту
      И Статус = Перечисления.пкСтатусыЗаданийНаПеревозку.КДоставке Тогда
        Сообщить("Нет прав на отправку заданий в отдел логистики");
        Отказ = Истина;
    КонецЕсли; 
    
    Если РежимЗаписи = РежимЗаписиДокумента.Проведение И ЗначениеЗаполнено(Техника) И НЕ Отказ Тогда
        Если ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту  Тогда
            Запрос = Новый Запрос;
            Запрос.Текст = 
            "ВЫБРАТЬ
            |   пкРезервТехникиСрезПоследних.Резерв,
            |   пкРезервТехникиСрезПоследних.ЗаявкаНаАрендуТехники
            |ИЗ
            |   РегистрСведений.пкРезервТехники.СрезПоследних(
            |           &Дата,
            |           Регистратор <> &Ссылка
            |               И Техника = &Техника) КАК пкРезервТехникиСрезПоследних";
            
            Запрос.УстановитьПараметр("Дата",    ДатаОтгрузки);
            Запрос.УстановитьПараметр("Техника", Техника);
            Запрос.УстановитьПараметр("Ссылка",  Ссылка);
            
            Результат = Запрос.Выполнить();
            Выборка = Результат.Выбрать();
            
            Если Выборка.Следующий() Тогда
                Если Выборка.Резерв Тогда
                    Сообщить("Техника """ + Техника + """ уже зарезервирована под " + Выборка.ЗаявкаНаАрендуТехники);
                    Отказ = Истина;
                КонецЕсли;    
            КонецЕсли;
        ИначеЕсли ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента Тогда
            Запрос = Новый Запрос;
            Запрос.Текст = 
            "ВЫБРАТЬ
            |   пкДатыАрендыСрезПоследних.Регистратор КАК ЗаданиеНаПеревозку
            |ИЗ
            |   РегистрСведений.пкДатыАренды.СрезПоследних(
            |           ,
            |           ЗаявкаНаАрендуТехники = &ЗаявкаНаАрендуТехники
            |               И Техника = &Техника
            |               И ЭтоВозврат
            |               И Регистратор.Техника = ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка)
            |               И Регистратор <> &Ссылка) КАК пкДатыАрендыСрезПоследних";
            
            Запрос.УстановитьПараметр("Ссылка",                Ссылка);
            Запрос.УстановитьПараметр("Техника",               Техника);
            Запрос.УстановитьПараметр("ЗаявкаНаАрендуТехники", ЗаявкаНаАрендуТехники);
            
            Результат = Запрос.Выполнить();
            Выборка = Результат.Выбрать();
            
            Если Выборка.Следующий() Тогда
                ЗаданиеСВыбраннойТехникой = Выборка.ЗаданиеНаПеревозку.ПолучитьОбъект();
                
                Если Ссылка.ЗаявкаНаАрендуТехники <> ЗаявкаНаАрендуТехники Тогда
                    ЗаданиеСВыбраннойТехникой.ЗаявкаНаАрендуТехники = Ссылка.ЗаявкаНаАрендуТехники; 
                    
                    Попытка
                        ЗаданиеСВыбраннойТехникой.Записать(РежимЗаписиДокумента.Проведение);
                    Исключение
                    КонецПопытки;
                Иначе 
                    Запрос = Новый Запрос;
                    Запрос.Текст =
                    "ВЫБРАТЬ ПЕРВЫЕ 1
                    |   пкСтатусыТехникиСрезПоследних.Техника
                    |ИЗ
                    |   РегистрСведений.пкСтатусыТехники.СрезПоследних(
                    |           ,
                    |           (Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыТехники.ВАренде)
                    |               ИЛИ Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыТехники.КОтгрузке)
                    |               ИЛИ Статус = ЗНАЧЕНИЕ(Перечисление.пкСтатусыТехники.ВПути))
                    |               И ЗаявкаНаАрендуТехники = &ЗаявкаНаАрендуТехники
                    |               И Техника.пкМодель = &Модель
                    |               И Техника <> &Техника) КАК пкСтатусыТехникиСрезПоследних
                    |       ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.пкДатыАренды.СрезПоследних(
                    |               ,
                    |               ЭтоВозврат) КАК пкДатыАрендыСрезПоследних
                    |       ПО пкСтатусыТехникиСрезПоследних.Техника = пкДатыАрендыСрезПоследних.Техника
                    |           И пкСтатусыТехникиСрезПоследних.ЗаявкаНаАрендуТехники = пкДатыАрендыСрезПоследних.ЗаявкаНаАрендуТехники
                    |ГДЕ
                    |   пкДатыАрендыСрезПоследних.Техника ЕСТЬ NULL
                    |
                    |УПОРЯДОЧИТЬ ПО
                    |   пкСтатусыТехникиСрезПоследних.ПланируемаяДатаЗавершения";
                    
                    Запрос.УстановитьПараметр("ЗаявкаНаАрендуТехники", ЗаявкаНаАрендуТехники);
                    Запрос.УстановитьПараметр("Модель",                Модель);
                    Запрос.УстановитьПараметр("Техника",               Техника);

                    Результат = Запрос.Выполнить();
                    Выборка = Результат.Выбрать();
                    
                    Если Выборка.Следующий() Тогда
                        ЗаданиеСВыбраннойТехникой.Техника = Выборка.Техника;
                        
                        Попытка
                            ЗаданиеСВыбраннойТехникой.Записать(РежимЗаписиДокумента.Проведение);
                        Исключение
                        КонецПопытки;
                    Иначе
                        ЗаданиеСВыбраннойТехникой.КПроверке = Истина;
                        
                        Попытка
                            ЗаданиеСВыбраннойТехникой.Записать(РежимЗаписиДокумента.Проведение);
                        Исключение
                        КонецПопытки;
                    КонецЕсли;
                КонецЕсли;
            КонецЕсли;        
		ИначеЕсли ЗначениеЗаполнено(ДатаОтгрузки) И ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ПеремещениеМеждуРегионами Тогда
			СтатусТехники = пкУправлениеТехникойСервер.ПолучитьСтатусТехники(Техника,ДатаОтгрузки);
				Если СтатусТехники <> Перечисления.пкСтатусыТехники.НаБазе Тогда
			 		Сообщить("Данная техника "+Строка(Техника)+" в статусе "+Строка(СтатусТехники)+", уточните технику.");
					//Отказ = Истина;
				КонецЕсли;	
		КонецЕсли;    
    КонецЕсли;  
    
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ЗаявкаНаАрендуТехники")
			И ЗначениеЗаполнено(ДанныеЗаполнения.ЗаявкаНаАрендуТехники)
		Тогда
			
		    ВидОперации				= Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту;
			ДатаОтгрузки			= ТекущаяДата() + 1 * 24*60*60; //На завтра
			ЗаявкаНаАрендуТехники	= ДанныеЗаполнения.ЗаявкаНаАрендуТехники;
			
			Модель					= "";
			Техника					= "";
			
			РегионПолучатель		= "";
			
			АдресДоставки			= ДанныеЗаполнения.ЗаявкаНаАрендуТехники.АдресДоставки;
			СпособДоставки			= ДанныеЗаполнения.ЗаявкаНаАрендуТехники.СпособДоставки;
			
			ВремяДоставкиС			= "";
			ВремяДоставкиПо 		= "";
            
			Если Не ЗначениеЗаполнено(Подразделение) Тогда
	            Подразделение           = ДанныеЗаполнения.ЗаявкаНаАрендуТехники.ПодразделениеОтгрузки;
			КонецЕсли;
				
		КонецЕсли;
		
		//На случай, когда все определено в Данных заполнения - оно имеет больший приоритет!
		Для Каждого КлючИЗначение Из ДанныеЗаполнения Цикл
			Если ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
				ЭтотОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		
			ВидОперации 			= Перечисления.пкВидыОперацийЗаданийНаПеревозку.ПеремещениеМеждуРегионами;
			ДатаОтгрузки			= ТекущаяДата() + 1 * 24*60*60; //На завтра
			
			ЗаявкаНаАрендуТехники	= "";
			ЗаданиеНаПеревозку 		= "";
			
			Модель					= ДанныеЗаполнения.пкМодель;
			Техника					= ДанныеЗаполнения;
			
			РегионПолучатель		= "";
			
			АдресДоставки			= "";
			СпособДоставки			= "";
			
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.пкЗаданиеНаПеревозку") Тогда
		
		Если ДанныеЗаполнения.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат Тогда
			
			ВидОперации 			= Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат;
			ДатаОтгрузки			= ДанныеЗаполнения.ДатаОтгрузки;
			
			ЗаявкаНаАрендуТехники	= "";
			ЗаданиеНаПеревозку 		= ДанныеЗаполнения.Ссылка;
			
			Модель					= "";
			Техника					= "";
			
			РегионПолучатель		= "";
			
			АдресДоставки			= "";
			СпособДоставки			= ДанныеЗаполнения.СпособДоставки;
			
		Иначе //Возврат
			//ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Проведен, ПометкаУдаления, Номер, Дата, Подразделение, СкладПолучатель");
			
			Если ДанныеЗаполнения.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту Тогда
				ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента;
			ИначеЕсли ДанныеЗаполнения.ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента Тогда
				ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту;
			КонецЕсли;
			
			СпособДоставки	= ДанныеЗаполнения.СпособДоставки;
				
			//тСтрокиПоКоду = пкУправлениеТехникойСервер.ПолучитьСтруктуруСтрокиЗаявкиНаТехнику(ДанныеЗаполнения.ЗаявкаНаАрендуТехники, ДанныеЗаполнения.КодСтроки);
			//Если тСтрокиПоКоду <> Неопределено Тогда
			//	ДатаОтгрузки	= ?(ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента, тСтрокиПоКоду.ДатаВозврата, тСтрокиПоКоду.ДатаОтгрузки);
			//КонецЕсли;
			
		КонецЕсли;
		
		//Это точно необходимо указывать пользователю
		ВремяДоставкиС	= "";
		ВремяДоставкиПо = "";
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидОперации) Тогда
		ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Пользователи.ТекущийПользователь());
	КонецЕсли;
	
	Дата = ТекущаяДата();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПроверяемыеРеквизиты.Добавить("Подразделение");
	ПроверяемыеРеквизиты.Добавить("ВидОперации");
	ПроверяемыеРеквизиты.Добавить("ДатаОтгрузки");
//Рарус Владимир Подрезов 18.09.2017
//	ПроверяемыеРеквизиты.Добавить("АдресДоставки");
//Рарус Владимир Подрезов Конец
	ПроверяемыеРеквизиты.Добавить("Модель");
	
	Если (ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту) Тогда
		
		ПроверяемыеРеквизиты.Добавить("ЗаявкаНаАрендуТехники");
		
	ИначеЕсли (ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента) Тогда
		
		ПроверяемыеРеквизиты.Добавить("ЗаявкаНаАрендуТехники");
		
	ИначеЕсли (ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат) Тогда
		
		ПроверяемыеРеквизиты.Добавить("ЗаявкаНаАрендуТехники");
		
		Если ЗначениеЗаполнено(ЗаданиеНаПеревозку) Тогда
			Отказ = Отказ ИЛИ Не Документы.пкЗаданиеНаПеревозку.СоотвествиеДанныхМоделиИТехники(ЭтотОбъект, ЗаданиеНаПеревозку);
		//Иначе
		//	
		//	ЗапросПерекат = Новый Запрос;
		//	ЗапросПерекат.Текст = 
		//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		//	|	пкЗаданиеНаПеревозку.Ссылка
		//	|ИЗ
		//	|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
		//	|ГДЕ
		//	|	пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
		//	|	И НЕ пкЗаданиеНаПеревозку.ПометкаУдаления
		//	|	И пкЗаданиеНаПеревозку.Проведен";
		//	ЗапросПерекат.УстановитьПараметр("ЗаданиеНаПеревозку", ЭтотОбъект.Ссылка);
		//	РезЗапроса = ЗапросПерекат.Выполнить().Выбрать();
		//	Пока РезЗапроса.Следующий() Цикл
		//		Отказ = Отказ ИЛИ Не Документы.пкЗаданиеНаПеревозку.СоотвествиеДанныхМоделиИТехники(ЭтотОбъект, РезЗапроса.Ссылка);
		//	КонецЦикла;
		//	
		КонецЕсли;
		
	ИначеЕсли (ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ПеремещениеМеждуРегионами) Тогда
		
		ПроверяемыеРеквизиты.Добавить("РегионПолучатель");
		ПроверяемыеРеквизиты.Добавить("Техника");
		
    КонецЕсли;
    
    //+++rarus-spb_zlov 12.09.2016    
    Если ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ВозвратОтКлиента 
      ИЛИ ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ПеремещениеМеждуРегионами Тогда
		ПроверяемыеРеквизиты.Добавить("СкладПолучатель");
    КонецЕсли;  
    //---rarus-spb_zlov 12.09.2016 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
    
    ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
    Документы.пкЗаданиеНаПеревозку.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
    ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
    
    Если НЕ КПроверке Тогда
        Документы.пкЗаданиеНаПеревозку.Отразить_пкМоделиКДоставкеПоЗаявкамНаАрендуТехники(ДополнительныеСвойства, Движения, Отказ);
        Документы.пкЗаданиеНаПеревозку.Отразить_пкТехникаКПеремещениюМеждуРегионами(ДополнительныеСвойства, Движения, Отказ);
    КонецЕсли;
    
    СформироватьСписокРегистровДляКонтроля();
    ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
    ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
    Документы.пкЗаданиеНаПеревозку.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
    ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
    
    Если НЕ КПроверке Тогда
        РегистрыСведений.пкРезервТехники.СформироватьЗаписи(Отказ, РежимПроведения, ЭтотОбъект);
        РегистрыСведений.пкСтатусыТехники.СформироватьЗаписи(Отказ, РежимПроведения, ЭтотОбъект);
        РегистрыСведений.пкДатыАренды.СформироватьЗаписи(Отказ, РежимПроведения, ЭтотОбъект);
        
        РегистрыСведений.пкСрокиАренды.СформироватьЗаписи(ЭтотОбъект, Отказ, РежимПроведения);
   КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат Тогда
		ЗапросПерекат = Новый Запрос;
		ЗапросПерекат.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	пкЗаданиеНаПеревозку.Ссылка
		|ИЗ
		|	Документ.пкЗаданиеНаПеревозку КАК пкЗаданиеНаПеревозку
		|ГДЕ
		|	пкЗаданиеНаПеревозку.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
		|	И НЕ пкЗаданиеНаПеревозку.ПометкаУдаления
		|	И пкЗаданиеНаПеревозку.Проведен";
		ЗапросПерекат.УстановитьПараметр("ЗаданиеНаПеревозку", ЭтотОбъект.Ссылка);
		РезЗапроса = ЗапросПерекат.Выполнить().Выбрать();
		Пока РезЗапроса.Следующий() Цикл
			тОбъект = РезЗапроса.Ссылка.ПолучитьОбъект();
			
			тОбъект.Техника = Техника;
			Попытка
				тОбъект.Записать(?(тОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись), РежимПроведенияДокумента.Неоперативный);
			Исключение
				
				тСообщение = Новый СообщениеПользователю;
				тСообщение.Текст = ОписаниеОшибки();
				тСообщение.Сообщить();
				
				Отказ = Истина;
				Возврат;
				
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	Если Проведен Тогда
		
		//Перепроведем Погрузки/выгрузки
		ЗапросОперации = Новый Запрос;
		ЗапросОперации.Текст = 
		"ВЫБРАТЬ
		|	пкПогрузкаВыгрузкаПоДоставке.Ссылка
		|ИЗ
		|	Документ.пкПогрузкаВыгрузкаПоДоставке КАК пкПогрузкаВыгрузкаПоДоставке
		|ГДЕ
		|	пкПогрузкаВыгрузкаПоДоставке.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
		|	И пкПогрузкаВыгрузкаПоДоставке.Проведен
		|	И НЕ пкПогрузкаВыгрузкаПоДоставке.ПометкаУдаления";
		ЗапросОперации.УстановитьПараметр("ЗаданиеНаПеревозку", Ссылка);
		РезЗапроса = ЗапросОперации.Выполнить().Выбрать();
		Пока РезЗапроса.Следующий() Цикл
			тОбъект = РезЗапроса.Ссылка.ПолучитьОбъект();
			Попытка
				тОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
			Исключение
				
				тСообщение = Новый СообщениеПользователю;
				тСообщение.Текст = ОписаниеОшибки();
				тСообщение.Сообщить();
				
				Отказ = Истина;
				Возврат;
				
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
//Рарус Владимир Подрезов 11.10.2017 5505
	Если Проведен Тогда
		
		Если ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.ДоставкаКлиенту
			ИЛИ ВидОперации = Перечисления.пкВидыОперацийЗаданийНаПеревозку.Перекат
				И ЗначениеЗаполнено(ЗаданиеНаПеревозку)
		Тогда
			
			//Перепроведем Задания на возврат: определять будем по модели и заявке через сроки аренды
			ЗапросВозврат = Новый Запрос;
			ЗапросВозврат.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Возврат.Регистратор КАК Ссылка
			|ИЗ
			|	РегистрСведений.пкСрокиАренды.СрезПоследних(
			|			,
			|			ЗаявкаНаАрендуТехники = &ЗаявкаНаАрендуТехники
			|				И Модель = &Модель
			|				И ТипДокумента = ЗНАЧЕНИЕ(Перечисление.пкТипыДокументовДляСроковАренды.ЗаданиеНаПеревозку)
			|				И НЕ ЭтоОкончаниеАренды) КАК Отгрузка
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.пкСрокиАренды.СрезПоследних(
			|				,
			|				ЗаявкаНаАрендуТехники = &ЗаявкаНаАрендуТехники
			|					И Модель = &Модель
			|					И ТипДокумента = ЗНАЧЕНИЕ(Перечисление.пкТипыДокументовДляСроковАренды.ЗаданиеНаПеревозку)
			|					И ЭтоОкончаниеАренды) КАК Возврат
			|		ПО Отгрузка.ЗаявкаНаАрендуТехники = Возврат.ЗаявкаНаАрендуТехники
			|			И Отгрузка.Модель = Возврат.Модель
			|			И Отгрузка.НомерМодели = Возврат.НомерМодели
			|ГДЕ
			|	НЕ Возврат.Регистратор ЕСТЬ NULL";
			ЗапросВозврат.УстановитьПараметр("ЗаявкаНаАрендуТехники", ЗаявкаНаАрендуТехники);
			ЗапросВозврат.УстановитьПараметр("Модель", Модель);
			РезЗапроса = ЗапросВозврат.Выполнить().Выбрать();
			Пока РезЗапроса.Следующий() Цикл
				тОбъект = РезЗапроса.Ссылка.ПолучитьОбъект();
				Попытка
					тОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
				Исключение
					
					тСообщение = Новый СообщениеПользователю;
					тСообщение.Текст = ОписаниеОшибки();
					тСообщение.Сообщить();
					
					Отказ = Истина;
					Возврат;
					
				КонецПопытки;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
//Рарус Владимир Подрезов Конец

	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Подразделение	= ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Пользователи.ТекущийПользователь());
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный	= Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Автор) Тогда
		Автор 			= Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Массив.Добавить(Движения.пкМоделиКДоставкеПоЗаявкамНаАрендуТехники);
	//Массив.Добавить(Движения.пкТехникаКПеремещениюМеждуРегионами);
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти
#КонецОбласти
#КонецЕсли
