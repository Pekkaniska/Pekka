
&НаКлиенте
Перем Оповестить;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПолучательИндекс 			 = Параметры.ПолучательИндекс;
	ПолучательНаименование       = Параметры.ПолучательНаименование;
	ПолучательНаселенныйПункт    = Параметры.ПолучательНаселенныйПункт;
	ПолучательОбласть 			 = Параметры.ПолучательОбласть;
	ПолучательРБ_УНП 			 = Параметры.ПолучательРБ_УНП;
	ПолучательРК_БИН 			 = Параметры.ПолучательРК_БИН;	
	ПолучательРК_ИИН 			 = Параметры.ПолучательРК_ИИН;
	ПолучательРФ_ИНН			 = Параметры.ПолучательРФ_ИНН;
	ПолучательРФ_КПП 		     = Параметры.ПолучательРФ_КПП;
	ПолучательРФ_ОГРН 			 = Параметры.ПолучательРФ_ОГРН;
	ПолучательСтранаКод 		 = Параметры.ПолучательСтранаКод;
	ПолучательСтранаНаименование = Параметры.ПолучательСтранаНаименование;
	ПолучательУлицаНомерДома     = Параметры.ПолучательУлицаНомерДома;
	
	Параметры.Свойство("ПолучательКГ_ИНН", ПолучательКГ_ИНН);
	Параметры.Свойство("ПолучательКГ_ОКПО", ПолучательКГ_ОКПО);
	Параметры.Свойство("ПолучательКодКГ", ПолучательКодКГ);
	Параметры.Свойство("ПолучательРА_Соц", ПолучательРА_Соц);
	Параметры.Свойство("ПолучательРА_УНН", ПолучательРА_УНН);
	
	Если Параметры.Свойство("Получатель_ВидДокКод", Получатель_ВидДокКод) Тогда 
		Параметры.Свойство("Получатель_ВидДокНаим", Получатель_ВидДокНаим);
		Параметры.Свойство("Получатель_СерДок", Получатель_СерДок);
		Параметры.Свойство("Получатель_НомДок", Получатель_НомДок);
		Параметры.Свойство("Получатель_ДатаДок", Получатель_ДатаДок);
		Параметры.Свойство("Получатель_ОргДок", Получатель_ОргДок);
		Параметры.Свойство("Получатель_Тел", Получатель_Тел);
		Параметры.Свойство("Получатель_Факс", Получатель_Факс);
		Параметры.Свойство("Получатель_Телекс", Получатель_Телекс);
		Параметры.Свойство("Получатель_Почта", Получатель_Почта);
	Иначе
		Элементы.Группа2.Видимость = Ложь;
	КонецЕсли;
	
	Параметры.Свойство("Получатель_Форма", Получатель_Форма);
	Элементы.Получатель_Форма.Видимость = Параметры.Свойство("Получатель_Форма") И ("RU" = ПолучательСтранаКод);
	Если Не Элементы.Получатель_Форма.Видимость Тогда 
		Получатель_Форма = Неопределено;
		Элементы.Получатель_Форма.АвтоОтметкаНезаполненного = Неопределено;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	МассивРеквизитов = ПолучитьРеквизиты();
	Для Каждого Реквизит Из МассивРеквизитов Цикл
		Если Реквизит.Имя <> "СтруктураРеквизитов" И Реквизит.Имя <> "ВидыУдостЛичности" Тогда
			СтруктураРеквизитов.Вставить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановкаДляРФ = Ложь;
	УстановкаДляРБ = Ложь;
	УстановкаДляРК = Ложь;
	УстановкаДляАМ = Ложь;
	УстановкаДляКГ = Ложь;
	
	Если ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "РФ" Тогда
	
		УстановкаДляРФ = Истина;
		ПолучательСтранаКод = "RU";
		ПолучательСтранаНаименование = "РОССИЯ";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "РБ" Тогда
		
		УстановкаДляРБ = Истина;
		ПолучательСтранаКод = "BY";
		ПолучательСтранаНаименование = "БЕЛАРУСЬ";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "РК" Тогда
		
		УстановкаДляРК = Истина;
		ПолучательСтранаКод = "KZ";
		ПолучательСтранаНаименование = "КАЗАХСТАН";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "АМ" Тогда
		
		УстановкаДляАМ = Истина;
		ПолучательСтранаКод = "AM";
		ПолучательСтранаНаименование = "АРМЕНИЯ";
		
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "КГ" Тогда
		
		УстановкаДляКГ = Истина;
		ПолучательСтранаКод = "KG";
		ПолучательСтранаНаименование = "КИРГИЗИЯ";

	
	КонецЕсли; 
	
	Элементы.ПолучательРФ_ОГРН.Доступность = УстановкаДляРФ;
	Элементы.ПолучательРФ_ИНН.Доступность  = УстановкаДляРФ;
	Элементы.ПолучательРФ_КПП.Доступность  = УстановкаДляРФ;
	
	Элементы.ПолучательРБ_УНП.Доступность  = УстановкаДляРБ;
	
	Элементы.ПолучательРК_БИН.Доступность  = УстановкаДляРК;
	Элементы.ПолучательРК_ИИН.Доступность  = УстановкаДляРК;
	
	Элементы.ПолучательРА_Соц.Доступность  = УстановкаДляАМ;
	Элементы.ПолучательРА_УНН.Доступность  = УстановкаДляАМ;
	
	Элементы.ПолучательКГ_ИНН.Доступность = УстановкаДляКГ;
	Элементы.ПолучательКГ_ОКПО.Доступность = УстановкаДляКГ;
	Элементы.ПолучательКодКГ.Доступность = УстановкаДляКГ;
	
	Если Не УстановкаДляКГ Тогда 
		ПолучательКодКГ = Неопределено;
		Элементы.ПолучательКодКГ.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Россия.Видимость = УстановкаДляРФ;
	Элементы.Беларусь.Видимость = УстановкаДляРБ;
	Элементы.Казахстан.Видимость = УстановкаДляРК;
	Элементы.Армения.Видимость = УстановкаДляАМ;
	Элементы.Кыргызстан.Видимость = УстановкаДляКГ;
	
	Модифицированность = Ложь;
	Оповестить = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОКНажатие(Команда)
	    	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеПродолжение", ЭтотОбъект);
	ПрименитьИзменения(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
		
			ТекстПредупреждения = НСтр("ru='Данные были изменены.
											|Перед завершением работы рекомендуется сохранить измененные данные,
											|иначе изменения будут утеряны.'");
			
			Возврат;
		
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Применить изменения?'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,  РежимДиалогаВопрос.ДаНетОтмена);
						
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершениеПродолжение", ЭтотОбъект);
		ПрименитьИзменения(ОписаниеОповещения);
				
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершениеПродолжение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Истина Тогда
		
		Модифицированность = Ложь;
		Закрыть(СтруктураРеквизитов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПустуюСтруктуруРеквизитов() Экспорт
	
	ПустаяСтруктураРеквизитовФормы = Новый Структура;
		
	Для Каждого ЭлементФормы Из ЭтаФорма.Элементы Цикл
		
		Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") Тогда
			Если ЗначениеЗаполнено(ЭлементФормы.ПутьКДанным) Тогда
				
				ПустаяСтруктураРеквизитовФормы.Вставить(ЭлементФормы.ПутьКДанным);
								
			КонецЕсли; 
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПустаяСтруктураРеквизитовФормы;
	
КонецФункции	

&НаКлиенте
Процедура ПрименитьИзменения(ВыполняемоеОповещение)
		
	РеквСтрокаСообщения	= "";
		
	Для Каждого РеквизитФормы Из СтруктураРеквизитов Цикл
						
		СтруктураРеквизитов[РеквизитФормы.Ключ] = ЭтаФорма[РеквизитФормы.Ключ];
								
		//Проверка на заполненность полей, обязательных к заполнению
		Если ТипЗнч(Элементы[РеквизитФормы.Ключ]) = Тип("ПолеФормы") Тогда
			Если Элементы[РеквизитФормы.Ключ].Доступность И Элементы[РеквизитФормы.Ключ].АвтоОтметкаНезаполненного = Истина Тогда
				Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов[РеквизитФормы.Ключ]) Тогда
							
					ПредставлениеРекв = Элементы[РеквизитФормы.Ключ].Заголовок;
					РеквСтрокаСообщения = РеквСтрокаСообщения + ?(ПустаяСтрока(РеквСтрокаСообщения), "", "," + Символы.ПС) + """" + ПредставлениеРекв + """";
							 
				КонецЕсли;	
			КонецЕсли; 
		КонецЕсли;		
			
	КонецЦикла; 
	
	Если НЕ ПустаяСтрока(РеквСтрокаСообщения) Тогда 
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не заполнены поля, обязательные к заполнению: %1 %1%2. %1 %1 Продолжить редактирование ?'"), Символы.ПС, РеквСтрокаСообщения);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПрименитьИзмененияЗавершение", ЭтотОбъект, ВыполняемоеОповещение);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;		

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьИзмененияЗавершение(Ответ, ВыполняемоеОповещение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Ложь);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНаименованиеПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательИндексПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательОбластьПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНаселенныйПунктПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательУлицаНомерДомаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательРФ_ИННПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательРФ_КПППриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательРФ_ОГРНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательРБ_УНППриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательРК_ИИНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательРК_БИНПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

// Обработка выбора адресной информации из справочников
//
&НаКлиенте
Процедура ПолучательНаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИмяСправочникаДляВыбора = "Контрагенты";
	Если ВладелецФормы.СтруктураРеквизитовФормы.НапрПеремещения = "ИМ" Тогда
			ИмяСправочникаДляВыбора = "Организации";
	КонецЕсли;
	Если НЕ ВладелецФормы.СуществуетСправочник(ИмяСправочникаДляВыбора) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранноеЗначение = Неопределено;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучательНаименованиеНачалоВыбораЗавершение", ЭтотОбъект);
	ВладелецФормы.ПолучитьСведенияИзСправочника(Элемент.ТекстРедактирования, ИмяСправочникаДляВыбора, ВыбранноеЗначение, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНаименованиеНачалоВыбораЗавершение(СтруктураВозврата, ДополнительныеПараметры) Экспорт 
	
	СтруктураСведений = СтруктураВозврата.СтруктураСведений;
	ВыбранноеЗначение = СтруктураВозврата.ВыбранноеЗначение;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураАдреса = ВладелецФормы.АдресВФормате9ЗапятыхВСтруктуруПорталаТСНаКлиенте(СтруктураСведений.Адрес);
	
	ПолучательНаименование = СтруктураСведений.Наименование;
	
	ПолучательИндекс =  СтруктураАдреса.Индекс;
	ПолучательОбласть = СтруктураАдреса.Область;
	ПолучательНаселенныйПункт = СтруктураАдреса.НаселенныйПункт;
	ПолучательУлицаНомерДома = СтруктураАдреса.УлицаНомерДома; 
	
	Если ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "РФ" Тогда
		ПолучательРФ_ИНН  = СтруктураСведений.ИНН;
		ПолучательРФ_КПП  = СтруктураСведений.КПП;
		ПолучательРФ_ОГРН = СтруктураСведений.ОГРН;
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "РБ" Тогда
		ПолучательРБ_УНП  = СтруктураСведений.ИНН;
	ИначеЕсли ВладелецФормы.СтруктураРеквизитовФормы.СтранаНазначения = "РК" Тогда	
	    ПолучательРК_ИИН  = СтруктураСведений.ИНН;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Отправитель_ВидДокКодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",                      "Выберите документ, удостоверяющий личность");
	ПараметрыФормы.Вставить("ТаблицаЗначений",                ВидыУдостЛичности);
	ПараметрыФормы.Вставить("СтруктураДляПоиска",             Новый Структура("Кратко", Получатель_ВидДокНаим));
	ПараметрыФормы.Вставить("НаимКолонкиНазвание",            "Наименование");
	ПараметрыФормы.Вставить("ВключитьВидимостьКолонкиКратко", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборДокументаЗавершение", ЭтотОбъект);

	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ВыборДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Получатель_ВидДокКод = Прав("00" + Результат["Код"], 2);
		Получатель_ВидДокНаим = ВРег(Результат["Кратко"]);
	КонецЕсли;
КонецПроцедуры