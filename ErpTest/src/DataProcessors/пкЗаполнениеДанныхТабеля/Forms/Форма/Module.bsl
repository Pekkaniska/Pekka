&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//DEBUG = Истина;
	
	Если DEBUG Тогда		
		Элементы.СсылкаНаТабель.Видимость = ПараметрыСеанса.ТекущийПользователь.Наименование = "Малолетко Юрий";  
		ПериодРегистрации = Дата("20180101"); 
	Иначе 
		ПериодРегистрации = НачалоМесяца(ТекущаяДата());  
	КонецЕсли; 

	УстановитьДатаНачалаДатаОкончания();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ПериодРегистрации", "МесяцРегистрацииСтрокой");  
	
	ЗаполнитьОписаниеВидовВремени();
	
	НазначитьМетодыЭлелемтовФормНаСервере();   	
		
	УстановитьЗначенияШапокДней(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	
	Если DEBUG Тогда
		ПриИзмененииПериодаНаКлиенте();
	КонецЕсли; 
		
	УстановитьЗаголовокФормы(); 
	
	УстановитьВидимость();   
	
	ПриИзмененииПериодаНаКлиенте();
	
КонецПроцедуры 

&НаСервере
Процедура НазначитьМетодыЭлелемтовФормНаСервере() 
	
	Для Счетчик = 1 По 31 Цикл
		
		ТЭП = Элементы["ДанныеОВремениВремя" + Счетчик + "Представление"];
			
		ТЭП.УстановитьДействие("ОбработкаВыбора", "ДанныеОВремениВремяПредставлениеОбработкаВыбора");
		ТЭП.УстановитьДействие("АвтоПодбор", "ДанныеОВремениВремяПредставлениеАвтоПодбор");
		ТЭП.УстановитьДействие("ПриИзменении", "ДанныеОВремениВремяПредставлениеПриИзменении");
		
		ТЭП.ГоризонтальноеПоложениеВШапке = ГоризонтальноеПоложениеЭлемента.Центр;
		ТЭП.Ширина = 7;
		                                                                            
	КонецЦикла; 
	
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьОписаниеВидовВремени()
	
	СОВВ = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пкВидыУчетаВремени.Ссылка,
		|	пкВидыУчетаВремени.Код,
		|	пкВидыУчетаВремени.Наименование
		|ИЗ
		|	Справочник.пкВидыУчетаВремени КАК пкВидыУчетаВремени";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДЗ = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДЗ.Следующий() Цикл
		СОВВ.Вставить(ВыборкаДЗ.Код, Новый Структура("Наименование, ВидВремени", ВыборкаДЗ.Наименование, ВыборкаДЗ.Ссылка)); 
	КонецЦикла;     
	
	ОписаниеВидовВремени = Новый ФиксированноеСоответствие(СОВВ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПериодаНаКлиенте()
	
	ПериодРегистрацииПриИзменении();
		
	УстановитьВидимостьКолонок();
		
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "ПериодРегистрации", "МесяцРегистрацииСтрокой", Модифицированность);
	
	ПриИзмененииПериодаНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "ПериодРегистрации", "МесяцРегистрацииСтрокой", Направление, Модифицированность);
	
	ПриИзмененииПериодаНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ПриИзмененииПериодаНаКлиенте();	
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ПриИзмененииПериодаНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцРегистрацииСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "ПериодРегистрации", "МесяцРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииПериодаНаКлиенте();	
	
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзменении()
	
	//СохранитьДанныеТабеля();
	
	ПолучитьСсылкуНаТабель();
	
	ЗагрузитьДанныеТабеля();
	
	УстановитьДатаНачалаДатаОкончания();
	
	УстановитьЗначенияШапокДней();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКолонок()
	
	Для Счетчик = 29 По 31 Цикл 
		Элементы["ДанныеОВремениВремя" + Счетчик + "Представление"].Видимость = Истина; 
	КонецЦикла;   
	
	Если ЗначениеЗаполнено(ПериодРегистрации) Тогда
		
		КоличествоДней = День(КонецМесяца(ПериодРегистрации));	
		
		Для Счетчик = КоличествоДней + 1 По 31 Цикл  
			Элементы["ДанныеОВремениВремя" + Счетчик + "Представление"].Видимость = Ложь;
		КонецЦикла;                                 	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСсылкуНаТабель()
	
	СсылкаНаТабель = Документы.пкУчетРабочегоВремениСотрудников.ПустаяСсылка();
	
	Если НЕ ЗначениеЗаполнено(ПериодРегистрации) Тогда
		Возврат;	
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	пкУчетРабочегоВремениСотрудников.Ссылка
		|ИЗ
		|	Документ.пкУчетРабочегоВремениСотрудников КАК пкУчетРабочегоВремениСотрудников
		|ГДЕ
		|	РАЗНОСТЬДАТ(пкУчетРабочегоВремениСотрудников.Дата, &Дата, МЕСЯЦ) = 0";
	
	Запрос.УстановитьПараметр("Дата", ПериодРегистрации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ВыборкаДЗ = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДЗ.Следующий() Цикл
			СсылкаНаТабель = ВыборкаДЗ.Ссылка; 
		КонецЦикла;       		
		
	КонецЕсли;  
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеТабеля()
	
	//Для каждого Стр Из ДанныеОВремени Цикл  		
	//	Для Сч = 1 По 31 Цикл
	//		Стр["Время" + Сч + "Представление"] = "";			
	//	КонецЦикла; 
	//КонецЦикла; 
	
	ДанныеОВремени.Очистить();
	
	Если НЕ ЗначениеЗаполнено(СсылкаНаТабель) Тогда
		Возврат;	
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пкДанныеУчетаРабочегоВремениСотрудников.ВидУчетаВремени КАК ВидУчетаВремени,
		|	пкДанныеУчетаРабочегоВремениСотрудников.Часы,
		|	пкДанныеУчетаРабочегоВремениСотрудников.Период,
		|	пкДанныеУчетаРабочегоВремениСотрудников.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрНакопления.пкДанныеУчетаРабочегоВремениСотрудников КАК пкДанныеУчетаРабочегоВремениСотрудников
		|ГДЕ
		|	пкДанныеУчетаРабочегоВремениСотрудников.Регистратор = &Регистратор
		//|	И пкДанныеУчетаРабочегоВремениСотрудников.Сотрудник В(&Сотрудник)
		|	И пкДанныеУчетаРабочегоВремениСотрудников.ВидВремени = &ВидВремени
		|	И пкДанныеУчетаРабочегоВремениСотрудников.Активность
		|ИТОГИ ПО
		|	Сотрудник";
	
	Запрос.УстановитьПараметр("ВидВремени", ?(РежимВводаДокумента = 0, Перечисления.пкВидВремени.План, Перечисления.пкВидВремени.Факт));
	Запрос.УстановитьПараметр("Регистратор", СсылкаНаТабель);
	Запрос.УстановитьПараметр("Сотрудник", ДанныеОВремени.Выгрузить( , "Сотрудник"));
	
	РезультатЗапроса = Запрос.Выполнить();      	
	
	ВыборкаСотрудник = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	МассивСтрокПоСотруднику = Новый Массив;
	
	Пока ВыборкаСотрудник.Следующий() Цикл
		// Вставить обработку выборки ВыборкаСотрудник
		СотрудникСтроки = ВыборкаСотрудник.Сотрудник;	
		МассивСтрокПоСотруднику.Очистить();
		
		ВыборкаДЗ = ВыборкаСотрудник.Выбрать();
		
		Пока ВыборкаДЗ.Следующий() Цикл
			СтрокаТаблицы = ПолучитьСтрокуВнесенияИнформации(МассивСтрокПоСотруднику, ВыборкаДЗ.Период, СотрудникСтроки);
			СтрокаТаблицы["Время" + День(ВыборкаДЗ.Период) + "Представление"] = ВыборкаДЗ.ВидУчетаВремени.Код + " " + ВыборкаДЗ.Часы;
		КонецЦикла;
	КонецЦикла;
	
	ОбновитьИтогиПоСтрочкиДляВсех();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтогиПоСтрочкиДляВсех()
	
	СоответствиеПозицийВремени = ПолучитьСоответствиеПозицийВремени();
	ТаблицаЧасовПоВидамВремени = ПолучитьТаблицаЧасовПоВидамВремени();
	
	Для каждого Стр Из ДанныеОВремени Цикл  	
		
		ОчиститьТаблицаЧасовПоВидамВремени(ТаблицаЧасовПоВидамВремени);  
		
		Для Сч = 1 По 31 Цикл
			
			Если НЕ Стр["Время" + Сч + "Представление"] = "" Тогда
				
				СтруктураВремени = ПолучитьСтруктуруВремени(Стр["Время" + Сч + "Представление"]);
				
				Если СтруктураВремени.Отказ Тогда
					Продолжить;
				КонецЕсли;
				
				Индекс = СоответствиеПозицийВремени[СтруктураВремени.ВидУчетаВремени]; 
				ТаблицаЧасовПоВидамВремени[Индекс].Часы = ТаблицаЧасовПоВидамВремени[Индекс].Часы + СтруктураВремени.Часы;				
			
			КонецЕсли;	
			
		КонецЦикла; 
		
		Для Каждого Элемент Из ТаблицаЧасовПоВидамВремени Цикл
			
			Если Элемент.Часы = 0 Тогда
				Продолжить;			
			КонецЕсли; 
			
			Если Стр.ВремяИтог = "" Тогда
				Стр.ВремяИтог = Элемент.Обозначение + " " + Элемент.Часы;
			Иначе	
			    Стр.ВремяИтог = Стр.ВремяИтог + " " + Элемент.Обозначение + " " + Элемент.Часы;
			КонецЕсли;  
			
		КонецЦикла;
		
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтогиПоСтрочки(ТекущаяСтрокаНомер)
	
	СоответствиеПозицийВремени = ПолучитьСоответствиеПозицийВремени();
	ТаблицаЧасовПоВидамВремени = ПолучитьТаблицаЧасовПоВидамВремени();   	
	
	ОчиститьТаблицаЧасовПоВидамВремени(ТаблицаЧасовПоВидамВремени);  
	
	ТекущаяСтрока = ДанныеОВремени[ТекущаяСтрокаНомер];
	ТекущаяСтрока.ВремяИтог = "";
	
	Для Сч = 1 По 31 Цикл
		
		Если НЕ ТекущаяСтрока["Время" + Сч + "Представление"] = "" Тогда
			
			СтруктураВремени = ПолучитьСтруктуруВремени(ТекущаяСтрока["Время" + Сч + "Представление"]);
			
			Если СтруктураВремени.Отказ Тогда
				Продолжить;
			КонецЕсли;
			
			Индекс = СоответствиеПозицийВремени[СтруктураВремени.ВидУчетаВремени]; 
			ТаблицаЧасовПоВидамВремени[Индекс].Часы = ТаблицаЧасовПоВидамВремени[Индекс].Часы + СтруктураВремени.Часы;				
			
		КонецЕсли;	
		
	КонецЦикла; 
	
	Для Каждого Элемент Из ТаблицаЧасовПоВидамВремени Цикл
		
		Если Элемент.Часы = 0 Тогда
			Продолжить;			
		КонецЕсли; 
		
		Если ТекущаяСтрока.ВремяИтог = "" Тогда
			ТекущаяСтрока.ВремяИтог = Элемент.Обозначение + " " + Элемент.Часы;
		Иначе	
			ТекущаяСтрока.ВремяИтог = ТекущаяСтрока.ВремяИтог + " " + Элемент.Обозначение + " " + Элемент.Часы;
		КонецЕсли;  
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруВремени(СтрокаВремени)
	
	ВозвратСтруктура = Новый Структура("Отказ, ВидУчетаВремени, Часы", Ложь);
		
	Попытка
		ПозицияПробела = СтрНайти(СтрокаВремени, " "); 
		БуквыВидУчетаВремени = Лев(СтрокаВремени, ПозицияПробела);
		
		Если ПозицияПробела = 0 ИЛИ СокрЛП(БуквыВидУчетаВремени) = "" Тогда
			ВозвратСтруктура.Отказ = Истина; 		
		КонецЕсли; 
		
		СтрокаЧисло = Сред(СтрокаВремени, ПозицияПробела + 1);
		
		ВозвратСтруктура.ВидУчетаВремени = СокрЛП(БуквыВидУчетаВремени); 
		ВозвратСтруктура.Часы = Число(СтрокаЧисло);    		
	Исключение
		ВозвратСтруктура.Отказ = Истина;
	КонецПопытки; 
		
	Возврат ВозвратСтруктура;	

КонецФункции

&НаСервере
Функция ПолучитьСоответствиеПозицийВремени()
	
	СПВ = Новый Соответствие;
	
	СПВ.Вставить("Я",  0);
	СПВ.Вставить("СУ", 1);
	СПВ.Вставить("ДЖ", 2);
	СПВ.Вставить("К",  3);
	СПВ.Вставить("ОТ", 4);
	СПВ.Вставить("Б",  5);
	СПВ.Вставить("ДО", 6);
	СПВ.Вставить("С",  7);
	
	Возврат СПВ;
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицаЧасовПоВидамВремени()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пкВидыУчетаВремени.Код КАК Обозначение,
		|	0 КАК Часы
		|ИЗ
		|	Справочник.пкВидыУчетаВремени КАК пкВидыУчетаВремени
		|
		|УПОРЯДОЧИТЬ ПО
		|	пкВидыУчетаВремени.ПорядокВСписке";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ОчиститьТаблицаЧасовПоВидамВремени(ТЗ)
	
	Для каждого Стр Из ТЗ Цикл   	
		Стр.Часы = 0;         	
	КонецЦикла; 
		
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеТабеля()
		
	Если НЕ Модифицированность Тогда
		Возврат;	
	КонецЕсли; 
	
	Если ДанныеОВремени.Количество() = 0 Тогда		
		Возврат;
	КонецЕсли; 
	
	Если РежимВводаДокумента = 0 И РольДоступна("пкОтветственныйЗаТабель") Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Нарушение прав доступа!";
		Сообщение.Сообщить();
		
		Возврат;
	
	КонецЕсли; 
	
	ОбъектТабеля = Неопределено;
	
	Если ЗначениеЗаполнено(СсылкаНаТабель)  Тогда
		ОбъектТабеля = СсылкаНаТабель.ПолучитьОбъект();   	
	Иначе		
	    ОбъектТабеля = Документы.пкУчетРабочегоВремениСотрудников.СоздатьДокумент();
		ОбъектТабеля.Дата = ДатаНачалаПериода;
	КонецЕсли; 
	
	//Удалим старые
	ПараметрыОтбора = Новый Структура("ВидВремени", ?(РежимВводаДокумента = 0, Перечисления.пкВидВремени.План, Перечисления.пкВидВремени.Факт));
	
	НайденныеСтроки = ОбъектТабеля.СписокСотрудников.НайтиСтроки(ПараметрыОтбора);

	Для каждого СтрокаУдаления Из НайденныеСтроки Цикл
		ОбъектТабеля.СписокСотрудников.Удалить(СтрокаУдаления);	
	КонецЦикла; 
		
	//ОбъектТабеля.СписокСотрудников.Очистить();
	ПараметрыОтбора = Новый Структура("НомерСтрокиСотрудника, Сотрудник, ВидВремени");
	
	Для каждого Стр Из ДанныеОВремени Цикл
		
		Если НЕ ЗначениеЗаполнено(Стр.Сотрудник) Тогда
			Продолжить;		
		КонецЕсли; 
		
		//ПараметрыОтбора.НомерСтрокиСотрудника = Стр.НомерСтрокиСотрудника;
		//ПараметрыОтбора.Сотрудник 			= Стр.Сотрудник;
		//ПараметрыОтбора.ВидВремени 			= ?(РежимВводаДокумента = 0, Перечисления.пкВидВремени.План, Перечисления.пкВидВремени.Факт);
		//
		//НайденныеСтроки = ОбъектТабеля.СписокСотрудников.НайтиСтроки(ПараметрыОтбора);
		//
		//Если НайденныеСтроки.Количество() > 0 Тогда
		//	
		//	НоваяСтрока = НайденныеСтроки[0];
		//	
		//Иначе
			
			НоваяСтрока = ОбъектТабеля.СписокСотрудников.Добавить();
			НоваяСтрока.НомерСтрокиСотрудника = Стр.НомерСтрокиСотрудника;
			НоваяСтрока.Сотрудник 			= Стр.Сотрудник;
			НоваяСтрока.ВидВремени 			= ?(РежимВводаДокумента = 0, Перечисления.пкВидВремени.План, Перечисления.пкВидВремени.Факт);
			
		//КонецЕсли; 
		
		Для Сч = 1 По 31 Цикл
			
			Если РежимВводаДокумента = 0 Тогда
				НоваяСтрока["ПланД" + Сч] = Стр["Время" + Сч + "Представление"];
			Иначе 	
				НоваяСтрока["ФактД" + Сч] = Стр["Время" + Сч + "Представление"];
			КонецЕсли; 
			
		КонецЦикла; 
				
	КонецЦикла; 
	
	Попытка
	
		ОбъектТабеля.Записать(РежимЗаписиДокумента.Проведение);
		СсылкаНаТабель = ОбъектТабеля.Ссылка;
	
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ИнформацияОбОшибке().Описание;
		Сообщение.Сообщить(); 
	
	КонецПопытки;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуВнесенияИнформации(Массив, Период, Сотрудник)
	
	СтрокаВозврат = Неопределено;
	
	Для Счетчик = 0 По Массив.Количество() - 1 Цикл		
		Если Массив[Счетчик]["Время" + День(Период) + "Представление"] = "" Тогда
			СтрокаВозврат = Массив[Счетчик];
			Прервать;
		КонецЕсли;   		
	КонецЦикла; 
	
	Если СтрокаВозврат = Неопределено Тогда
		СтрокаВозврат = ДанныеОВремени.Добавить();
		СтрокаВозврат.Сотрудник = Сотрудник;
		СтрокаВозврат.НомерСтрокиСотрудника = ДанныеОВремени.Количество();
		Массив.Добавить(СтрокаВозврат);	
	КонецЕсли; 
	
	Возврат СтрокаВозврат;
		
КонецФункции

&НаСервере
Процедура УстановитьДатаНачалаДатаОкончания()
	
	ДатаНачалаПериода = НачалоМесяца(ПериодРегистрации);
	ДатаОкончанияПериода = КонецМесяца(ПериодРегистрации);   
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(ДатаНачалаПериода) <> НачалоМесяца(ПериодРегистрации) Тогда
		ДатаНачалаПериода = НачалоМесяца(ПериодРегистрации);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(ДатаОкончанияПериода) <> НачалоМесяца(ПериодРегистрации) Тогда
		ДатаОкончанияПериода = КонецМесяца(ПериодРегистрации);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВводаДокументаПриИзменении(Элемент)
	
	УстановитьЗаголовокФормы();
	
	ЗагрузитьДанныеТабеля();
	
	УстановитьВидимость();
	
	ИзменитьЦветТабличнойЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокФормы()
	ЭтаФорма.Заголовок = "Заполнение данных табеля: " + ?(РежимВводаДокумента = 0, "ПЛАН", "ФАКТ");
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	План = РежимВводаДокумента = 0;
	
	Элементы.ДанныеОВремениЗаполнитьПоУмолчанию.Видимость = План;
	Элементы.ДанныеОВремениЗаполнитьПоПлану.Видимость = НЕ План;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЦветТабличнойЧасти()
	
	Если РежимВводаДокумента = 0 Тогда
		Элементы.ДанныеОВремени.ЦветФона = WebЦвета.Белый; 
	Иначе
		Элементы.ДанныеОВремени.ЦветФона = WebЦвета.СветлоЖелтыйЗолотистый;	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияШапокДней()
	
	ДеньНачала = День(ДатаНачалаПериода);
	ДеньОкончания = День(ДатаОкончанияПериода);
	
	ЦветРабочегоДня = Новый Цвет(51, 51, 51);
	ЦветВыходногоДня = WebЦвета.Красный;

	Для Счетчик = ДеньНачала По ДеньОкончания Цикл
		
		ТЭП = Элементы["ДанныеОВремениВремя" + Счетчик + "Представление"];
		СчетчикТекущийДень = ДатаНачалаПериода + (Счетчик - ДеньНачала) * 86400; 
		ДеньНедели = ДеньНедели(СчетчикТекущийДень);

		ТЭП.Заголовок = "" + Счетчик + " " + ПолучитьПредствлениеДня(СчетчикТекущийДень);
		ТЭП.ЦветТекстаЗаголовка = ?(ДеньНедели = 6 Или ДеньНедели = 7, ЦветВыходногоДня, ЦветРабочегоДня); 
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьПредствлениеДня(Дата)

	ПредставлениеДняНедели = "";
	
	Если ДеньНедели(Дата) = 1 Тогда
		ПредставлениеДняНедели = "Пн";	
	ИначеЕсли ДеньНедели(Дата) = 2 Тогда
		ПредставлениеДняНедели = "Вт"; 	
	ИначеЕсли ДеньНедели(Дата) = 3 Тогда
		ПредставлениеДняНедели = "Ср"; 	
	ИначеЕсли ДеньНедели(Дата) = 4 Тогда
		ПредставлениеДняНедели = "Чт"; 	
	ИначеЕсли ДеньНедели(Дата) = 5 Тогда
		ПредставлениеДняНедели = "Пт"; 	
	ИначеЕсли ДеньНедели(Дата) = 6 Тогда
		ПредставлениеДняНедели = "Сб"; 	
	ИначеЕсли ДеньНедели(Дата) = 7 Тогда
		ПредставлениеДняНедели = "Вс"; 		
	КонецЕсли; 
	
	Возврат ПредставлениеДняНедели;
	
КонецФункции

&НаКлиенте
Процедура ДанныеОВремениПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЭтаФорма.Модифицированность = Истина;
	
	Если НоваяСтрока ИЛИ Копирование Тогда
		Элемент.ТекущиеДанные.НомерСтрокиСотрудника = ДанныеОВремени.Количество();	
	КонецЕсли; 
	
	ИзменитьПорядокПриКопировании(Копирование);
	
КонецПроцедуры 

&НаКлиенте
Процедура ИзменитьПорядокПриКопировании(Копирование)
	
	Если Не Копирование Тогда 	
		Возврат;              	
	КонецЕсли; 
	
	КоличествоСтрок = ДанныеОВремени.Количество();
	НомерИзменения = 0;
	
	СотрудникКопирования = ДанныеОВремени[КоличествоСтрок - 1].Сотрудник;
	
	Для Индекс = 2 По КоличествоСтрок Цикл
		
		Если СотрудникКопирования = ДанныеОВремени[КоличествоСтрок - Индекс].Сотрудник Тогда
			НомерИзменения = ДанныеОВремени[КоличествоСтрок - Индекс].НомерСтрокиСотрудника; 
			Прервать;		
		КонецЕсли;            		
	
	КонецЦикла; 
	
	ДанныеОВремени.Сдвинуть(КоличествоСтрок - 1, - (Индекс - 2)); 
	
	Для Индекс = НомерИзменения По КоличествоСтрок - 1 Цикл
		ДанныеОВремени[Индекс].НомерСтрокиСотрудника = Индекс + 1;	
	КонецЦикла;        
		
КонецПроцедуры  

&НаКлиенте
Функция рсТабельРазобратьСтрокуВремени(Знач ПредставлениеДанныхОВремени, Отказ = Ложь)
	
	ТабельЗаменитьРазделителиПробелами(ПредставлениеДанныхОВремени);
	Если ПустаяСтрока(ПредставлениеДанныхОВремени) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПредставлениеДанныхОВремени, " ");
	
	Если МассивПодстрок.Количество() > 2 Тогда
		Отказ = Истина;
		Возврат Неопределено;
	КонецЕсли;
	
	ЕстьПробел = СтрНайти(ПредставлениеДанныхОВремени, " ") > 0;
	
	Часы = 0;
	ЕстьБуквенноеОбозначение = Ложь;
	БуквенноеОбозначение = "";
	Для Каждого Подстрока Из МассивПодстрок Цикл
		СтрокаБезРазделителей = СтрЗаменить(Подстрока, ".", "");
		СтрокаБезРазделителей = СтрЗаменить(СтрокаБезРазделителей, ",", "");
		
		Если Не ПустаяСтрока(СтрокаБезРазделителей)
			И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаБезРазделителей)
			И СтрДлина(Подстрока) <= СтрДлина(СтрокаБезРазделителей) + 1 Тогда
			
			Часы = Число(СтрЗаменить(Подстрока, ".", ","));
		Иначе
			Если ЕстьБуквенноеОбозначение Тогда
				Отказ = Истина;
				Возврат Неопределено;
			КонецЕсли;
			
			БуквенноеОбозначение = ВРег(Подстрока); 
			ЕстьБуквенноеОбозначение = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура("БуквенноеОбозначение, Часы, ЕстьРазделитель", БуквенноеОбозначение, Часы, ЕстьБуквенноеОбозначение И ЕстьПробел)
	
КонецФункции

&НаКлиенте
Процедура ТабельЗаменитьРазделителиПробелами(ПредставлениеДанныхОВремени)
	
	СтрокаРазделителей = " -/:;" + Символы.ПС;
	
	СтрокаРезультат = "";
	
	ПредставлениеДанныхОВремени = СокрЛП(ПредставлениеДанныхОВремени);
	ДлинаСтроки = СтрДлина(ПредставлениеДанныхОВремени);
	
	ПредыдущийСимволРазделитель = Ложь;
	Для Сч = 1 По ДлинаСтроки Цикл
		Символ = Сред(ПредставлениеДанныхОВремени, Сч, 1);
		Если СтрНайти(СтрокаРазделителей, Символ) = 0 Тогда
			СтрокаРезультат = СтрокаРезультат + Символ;
			ПредыдущийСимволРазделитель = Ложь;
		ИначеЕсли Не ПредыдущийСимволРазделитель Тогда
			СтрокаРезультат = СтрокаРезультат + " ";
			ПредыдущийСимволРазделитель = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ПредставлениеДанныхОВремени = СтрокаРезультат;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(Текст) Тогда
		
		ДанныеОВремениСтруктура = рсТабельРазобратьСтрокуВремени(Текст); 
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		Если ДанныеОВремениСтруктура = Неопределено Тогда
			Возврат;
		КонецЕсли;	
			
		БуквенноеОбозначение = ДанныеОВремениСтруктура.БуквенноеОбозначение;	
		ДлинаТекста = СтрДлина(БуквенноеОбозначение);
		
		ДобавленныеЗначения = Новый Массив;
		
		Для Каждого ОписаниеВидаВремени Из ЭтаФорма.ОписаниеВидовВремени Цикл
			Если ВРег(ОписаниеВидаВремени.Ключ) = ВРег(БуквенноеОбозначение) Тогда
				ЗначениеВыбора = Новый Структура;
				Для Каждого КлючЗначение Из ОписаниеВидаВремени.Значение Цикл
					ЗначениеВыбора.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
				КонецЦикла;	
				ЗначениеВыбора.Вставить("БуквенноеОбозначение", ОписаниеВидаВремени.Ключ);
				ЗначениеВыбора.Вставить("Часы", ДанныеОВремениСтруктура.Часы);
				ЧасыСтрока = ?(ДанныеОВремениСтруктура.Часы = 0, "", " " + Формат(ДанныеОВремениСтруктура.Часы, "ЧГ="));
				ПредставлениеЗначенияВыбора = ОписаниеВидаВремени.Значение.Наименование + " (" + ОписаниеВидаВремени.Ключ + ")" + ЧасыСтрока;
				
 				ДанныеВыбора.Добавить(ЗначениеВыбора, ПредставлениеЗначенияВыбора);
				
				ДобавленныеЗначения.Добавить(ОписаниеВидаВремени.Ключ);
			КонецЕсли;
		КонецЦикла;	
		
		Если Не ДанныеОВремениСтруктура.ЕстьРазделитель Или ДобавленныеЗначения.Количество() = 0 Тогда
			Для Каждого ОписаниеВидаВремени Из ЭтаФорма.ОписаниеВидовВремени Цикл
				Если Лев(ВРег(ОписаниеВидаВремени.Ключ), ДлинаТекста) = ВРег(БуквенноеОбозначение) 
					И ДобавленныеЗначения.Найти(ОписаниеВидаВремени.Ключ) = Неопределено Тогда
								
					ЗначениеВыбора = Новый Структура;
					Для Каждого КлючЗначение Из ОписаниеВидаВремени.Значение Цикл
						ЗначениеВыбора.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
					КонецЦикла;	
					ЗначениеВыбора.Вставить("БуквенноеОбозначение", ОписаниеВидаВремени.Ключ);
					ЗначениеВыбора.Вставить("Часы", ДанныеОВремениСтруктура.Часы);
					ЧасыСтрока = ?(ДанныеОВремениСтруктура.Часы = 0, "", " " + Формат(ДанныеОВремениСтруктура.Часы, "ЧГ="));
					ПредставлениеЗначенияВыбора = ОписаниеВидаВремени.Значение.Наименование + " (" + ОписаниеВидаВремени.Ключ + ")" + ЧасыСтрока;
					
					ДанныеВыбора.Добавить(ЗначениеВыбора, ПредставлениеЗначенияВыбора);
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ТабельНомерДняПоИмениЭлемента(ИмяПоля) 
	
	ОбрабатываемыйТекст = СтрЗаменить(ИмяПоля, "ДанныеОВремениВремя", "");
	ОбрабатываемыйТекст = СтрЗаменить(ОбрабатываемыйТекст, "Представление", "");
	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ОбрабатываемыйТекст) Тогда
		Возврат Число(ОбрабатываемыйТекст);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ТабельВводДанныхОВремениЗаДень(ДанныеОВремени, ДанныеТекущейСтроки, НомерДня)
	Если ДанныеОВремени.Часы <> 0 Тогда
		Часы = ДанныеОВремени.Часы;
	Иначе
		Часы = 0;
	КонецЕсли;	
	           
	ДанныеТекущейСтроки["Время" + НомерДня + "Представление"] = ТабельПредставлениеВремениПоВиду(ДанныеОВремени.БуквенноеОбозначение, Часы);	
КонецПроцедуры

&НаКлиенте
Функция ТабельПредставлениеВремениПоВиду(ОбозначениеВремени, КоличествоЧасов)  
	
	Если Не ПустаяСтрока(ОбозначениеВремени) Или КоличествоЧасов <> 0 Тогда
		Возврат ОбозначениеВремени + " " + Формат(КоличествоЧасов, "ЧГ=");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда      
		НомерДня = ТабельНомерДняПоИмениЭлемента(Элемент.Имя);
		ДанныеТекущейСтроки = ЭтаФорма.Элементы.ДанныеОВремени.ТекущиеДанные;
		
		СтандартнаяОбработка = Ложь;
		Если ДанныеТекущейСтроки <> Неопределено Тогда
		
			Если Не ВыбранноеЗначение.Свойство("Часы") Тогда
				ВыбранноеЗначение.Вставить("Часы", 0);
			КонецЕсли;	
			
			ТабельВводДанныхОВремениЗаДень(ВыбранноеЗначение, ДанныеТекущейСтроки, НомерДня);
			ОбновитьИтогиПоСтрочки(ДанныеТекущейСтроки.НомерСтрокиСотрудника - 1);
		КонецЕсли;			
	КонецЕсли;	
	
	ЭтаФорма.Модифицированность = Истина; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ДеньНачала = День(ДатаНачалаПериода);
	ДеньОкончания = День(ДатаОкончанияПериода);
	
	ЦветВыходногоДня = WebЦвета.Красный;

	Для каждого Стр Из ДанныеОВремени Цикл
	
		Для Счетчик = ДеньНачала По ДеньОкончания Цикл
		
			ТЭП = Элементы["ДанныеОВремениВремя" + Счетчик + "Представление"];
			
			Если Стр["Время" + Счетчик + "Представление"] = "" И НЕ ТЭП.ЦветТекстаЗаголовка = ЦветВыходногоДня Тогда
				Стр["Время" + Счетчик + "Представление"] = "Я 8";
			КонецЕсли; 
						
		КонецЦикла; 
		
		Стр.ВремяИтог = "";
	
	КонецЦикла; 
	
	ОбновитьИтогиПоСтрочкиДляВсех();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеПриИзменении(Элемент)
	
	ДанныеТекущейСтроки = ЭтаФорма.Элементы.ДанныеОВремени.ТекущиеДанные;
		
	ОбновитьИтогиПоСтрочки(ДанныеТекущейСтроки.НомерСтрокиСотрудника - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСтроку(Команда)
	
	ДанныеТекущейСтроки = ЭтаФорма.Элементы.ДанныеОВремени.ТекущиеДанные;
	
	ДеньНачала = День(ДатаНачалаПериода);
	ДеньОкончания = День(ДатаОкончанияПериода);
	
	Для Счетчик = ДеньНачала По ДеньОкончания Цикл
		
		ДанныеТекущейСтроки["Время" + Счетчик + "Представление"] = "";
		
	КонецЦикла; 
	
	ДанныеТекущейСтроки.ВремяИтог = "";   	
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанныеТабеля();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПлану(Команда)

	ЗаполнитьПоПлануНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПлануНаСервере()
	
	Если СсылкаНаТабель.Пустая() Тогда
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениПриИзменении(Элемент) 	
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры
