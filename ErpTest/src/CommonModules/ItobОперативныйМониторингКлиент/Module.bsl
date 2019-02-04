////////////////////////////////////////////////////////////////////////////////
// Оперативный мониторинг (клиент)
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Выполняет скрипт на поле HTML, с учетом вида браузера
//
Функция ВыполнитьСкриптНаПолеHTML(ПолеHTML, Знач ТекстСкрипта) Экспорт
	
	Если ПолеHTML.Документ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СисИнфо = Новый СистемнаяИнформация;
	
	ТекстСкрипта = 
		"try {
		|"+ТекстСкрипта+"
		|} catch(err) {}";
				
	Попытка
		
		Если Найти(СисИнфо.ИнформацияПрограммыПросмотра, "Firefox") <> 0
			ИЛИ Найти(СисИнфо.ИнформацияПрограммыПросмотра, "Chrome") <> 0 Тогда
									
			tag = ПолеHTML.Документ.createElement("script");
			tag.type = "text/javascript";
			tag.text = ТекстСкрипта;
			ПолеHTML.Документ.getElementsByTagName("head").item(0).appendChild(tag);
			
		ИначеЕсли Найти(СисИнфо.ИнформацияПрограммыПросмотра, "Safari") <> 0 Тогда
			tag = ПолеHTML.Документ.createElement("script");
			tag.type = "text/javascript";
			tag.innerHTML = ТекстСкрипта;
			ПолеHTML.Документ.head.appendChild(tag);
			
		ИначеЕсли НРег(Лев(СисИнфо.ИнформацияПрограммыПросмотра, 7)) =  "mozilla" Тогда	
			ПолеHTML.document.parentWindow.eval(ТекстСкрипта);
			
		Иначе		
			
			ПолеHTML.Документ.parentWindow.execScript(ТекстСкрипта);
			
		КонецЕсли;		
	
	Исключение
		ItobОбщегоНазначенияСервер.ЗаписьЖурналаРегистрацииОшибка(НСтр("ru = 'Выполнение скрипта'", "ru"),ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));		
	КонецПопытки;		

КонецФункции // ВыполнитьСкриптНаПолеHTML()

// Проверка доступности сервера CsmSvc
// При этом запрашивается тестовая страница по протоколу HTTP.
//
// Параметры
//  АдресСервера  - Адрес сервера в формате <IP>:<Порт>, или <DNS имя>:<Порт>.
//
// Возвращаемое значение:
//  Булево   - Истина если доступен, Ложь если не доступен.
//
Функция ПроверитьДоступностьСервисаCsmSvc(ИмяСервера, ПортСервера) Экспорт
	
	#Если ВебКлиент Тогда
		
	// Запрашиваем данные на сервере	
	Возврат ItobОперативныйМониторингКлиентСервер.ПроверитьДоступностьСервисаCsmSvc(ИмяСервера, ПортСервера);
		
	#Иначе	
	
	Соединение = Новый HTTPСоединение(ИмяСервера, ПортСервера);
	
	Попытка
		Соединение.Получить("/index.html", КаталогВременныхФайлов()+"TestRequest.html");		
		Возврат Истина;
		
	Исключение
		Возврат Ложь;
	
	КонецПопытки;
	
	#КонецЕсли	

КонецФункции // ПроверитьДоступностьСервисаCsmSvc()

// Определяет часовой пояс клиента
//
Процедура ОпределениеЧасовогоПоясаСеанса() Экспорт
	
	МестноеВремяКлиента = МестноеВремя('20100101');
	РазницаВоВремени=Строка((МестноеВремяКлиента-'20100101')/(60*60));
	Знак = ?(Число(РазницаВоВремени)<0,"","+");
	МестныйЧасовойПояс="GMT"+Знак+РазницаВоВремени+":00";
	ItobОперативныйМониторингКлиентСервер.УстановкаЧасовогоПоясаСеанса(МестныйЧасовойПояс);

КонецПроцедуры

// Обработчик нажатия на карту
//
Процедура ОбработатьНажатиеНаПолеКарты(Элемент, ДанныеСобытия, СтандартнаяОбработка) Экспорт
	
	#Если НЕ ВебКлиент Тогда					
		
	Попытка
	
		ИмяСсылки = ДанныеСобытия.Href;
		Если Лев(ИмяСсылки, 11) <> "v8config://" Тогда
			Возврат;
		
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		СтрокаИмяФормы = СтрЗаменить(ИмяСсылки, "v8config://", "");
		СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "/", "");
		
		ОткрытьФорму(СтрокаИмяФормы);
	
	Исключение
		ItobОбщегоНазначенияСервер.ЗаписьЖурналаРегистрацииОшибка(НСтр("ru = 'Открытие формы'", "ru"),ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;	
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти
