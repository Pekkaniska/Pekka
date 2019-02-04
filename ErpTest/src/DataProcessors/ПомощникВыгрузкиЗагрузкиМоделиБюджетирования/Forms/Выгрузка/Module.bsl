#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	//++ НЕ УТКА
	ИспользоватьБюджетныйПроцесс = ПолучитьФункциональнуюОпцию("ИспользоватьБюджетныйПроцесс");
	//-- НЕ УТКА
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтатусВыполненнойЗагрузки = Ложь;
	// Устанавливаем текущую таблицу переходов
	ПереходыПоСценарию();
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
	Элементы.СтраницаЭтапыПодготовкиБюджетов.Видимость = ИспользоватьБюджетныйПроцесс;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИмяФайлаМоделиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИмяФайлаМоделиРасширениеПодключено",
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыБюджетов.ТекущиеДанные;
	УстановитьПометкиПодчиненных(ТекущиеДанные, "Флаг");
	УстановитьПометкиРодителей(ТекущиеДанные, "Флаг");

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПодготовкиБюджетовФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЭтапыПодготовкиБюджетов.ТекущиеДанные;
	УстановитьПометкиПодчиненных(ТекущиеДанные, "Флаг");
	УстановитьПометкиРодителей(ТекущиеДанные, "Флаг");

КонецПроцедуры

&НаКлиенте
Процедура МодельБюджетированияПриИзменении(Элемент)
	
	ИзменениеМоделиБюджетирования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ЗавершитьФоновоеЗадание(ИдентификаторЗадания);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Дерево = Неопределено;
	Если Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаВидыБюджетов Тогда
		Дерево = ВидыБюджетов;
	ИначеЕсли  Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаЭтапыПодготовкиБюджетов Тогда
		Дерево = ЭтапыПодготовкиБюджетов;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		Строка.Флаг = Истина;
		УстановитьПометкиПодчиненных(Строка, "Флаг");
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Дерево = Неопределено;
	Если Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаВидыБюджетов Тогда
		Дерево = ВидыБюджетов;
	ИначеЕсли  Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаЭтапыПодготовкиБюджетов Тогда
		Дерево = ЭтапыПодготовкиБюджетов;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		Строка.Флаг = Ложь;
		УстановитьПометкиПодчиненных(Строка, "Флаг");
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПравила(Команда)
	ТекстОшибки = ПроверитьПравилаНаСервере();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазделИнициализацииПереходовПомощника

&НаКлиенте
Функция ПараметрыПерехода()
	
	ПараметрыПерехода = Новый Структура;
	ПараметрыПерехода.Вставить("ПорядковыйНомерПерехода", "");
	ПараметрыПерехода.Вставить("ИмяОсновнойСтраницы", "");
	ПараметрыПерехода.Вставить("ИмяСтраницыНавигации", "");
	ПараметрыПерехода.Вставить("ИмяСтраницыДекорации", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПриОткрытии", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПослеОткрытия", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПриПереходеДалее", "");
	ПараметрыПерехода.Вставить("ИмяОбработчикаПриПереходеНазад", "");
	
	Возврат ПараметрыПерехода;
	
КонецФункции

&НаКлиенте
Процедура ПереходыПоСценарию()
	
	Переходы.Очистить();
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 1;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаПриветствие";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииНачало";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаДекорацииНачало";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаПриветствие_ПриОткрытии";
	ПараметрыПерехода.ИмяОбработчикаПриПереходеДалее = "СтраницаПриветствие_ПриПереходеДалее";
	ДобавитьПереход(ПараметрыПерехода);
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 2;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаФильтры";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииНазадДалее";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаНавигацииНазадДалее";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаФильтры_ПриОткрытии";
	ПараметрыПерехода.ИмяОбработчикаПриПереходеДалее = "СтраницаФильтры_ПриПереходеДалее";
	ДобавитьПереход(ПараметрыПерехода);
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 3;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаОжидания";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииОжидание";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаДекорацииОжидание";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаОжидания_ПриОткрытии";
	ПараметрыПерехода.ИмяОбработчикаПослеОткрытия = "СтраницаОжидания_ПослеОткрытия";
	ДобавитьПереход(ПараметрыПерехода);
	
	ПараметрыПерехода = ПараметрыПерехода();
	ПараметрыПерехода.ПорядковыйНомерПерехода = 4;
	ПараметрыПерехода.ИмяОсновнойСтраницы = "СтраницаЗавершение";
	ПараметрыПерехода.ИмяСтраницыНавигации = "СтраницаНавигацииОкончание";
	ПараметрыПерехода.ИмяСтраницыДекорации = "СтраницаДекорацииОкончание";
	ПараметрыПерехода.ИмяОбработчикаПриОткрытии = "СтраницаЗавершение_ПриОткрытии";
	ДобавитьПереход(ПараметрыПерехода);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПереход(ПараметрыПерехода)
	
	НоваяСтрока = Переходы.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПараметрыПерехода.ПорядковыйНомерПерехода;
	НоваяСтрока.ИмяОсновнойСтраницы     = ПараметрыПерехода.ИмяОсновнойСтраницы;
	НоваяСтрока.ИмяСтраницыДекорации    = ПараметрыПерехода.ИмяСтраницыДекорации;
	НоваяСтрока.ИмяСтраницыНавигации    = ПараметрыПерехода.ИмяСтраницыНавигации;
	
	НоваяСтрока.ИмяОбработчикаПриПереходеДалее = ПараметрыПерехода.ИмяОбработчикаПриПереходеДалее;
	НоваяСтрока.ИмяОбработчикаПриПереходеНазад = ПараметрыПерехода.ИмяОбработчикаПриПереходеНазад;
	НоваяСтрока.ИмяОбработчикаПриОткрытии      = ПараметрыПерехода.ИмяОбработчикаПриОткрытии;
	НоваяСтрока.ИмяОбработчикаПослеОткрытия    = ПараметрыПерехода.ИмяОбработчикаПослеОткрытия;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	ПорядковыйНомерПерехода = Значение;
	Если ПорядковыйНомерПерехода < 0 Тогда
		ПорядковыйНомерПерехода = 0;
	КонецЕсли;
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			Выполнить(ИмяПроцедуры);
					
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			Выполнить(ИмяПроцедуры);
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Выполнить(ИмяПроцедуры);
		
		Если Отказ Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			Возврат;
		ИначеЕсли ПропуститьСтраницу Тогда
			Если ЭтоПереходДалее Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			Иначе
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Установка отображения текущей страницы
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	ПодключитьОбработчикОжидания("ВыполнитьОбработчикПослеОткрытия", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикПослеОткрытия()
	
	СтрокиПереходаТекущие = Переходы.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ПослеОткрытия
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПослеОткрытия) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика]()";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПослеОткрытия);
		
		Выполнить(ИмяПроцедуры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РазделОбработчиковСобытийПерехода

&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
	Заголовок = НСтр("ru = 'Выгрузка модели бюджетирования.'");
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриПереходеДалее(Отказ)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(МодельБюджетирования) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указана Модель бюджетирования'"), , "МодельБюджетирования", "МодельБюджетирования", Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СокрЛП(Объект.ИмяФайлаМодели)) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан путь к файлу с данными'"), , "ИмяФайлаМодели", "ИмяФайлаМодели", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаФильтры_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
	Заголовок = НСтр("ru = 'Выбор выгружаемых видов бюджетов и этапов подготовки бюджетов.'");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаФильтры_ПриПереходеДалее(Отказ)
	
	ОчиститьСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаЗавершение_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
	Элементы.НадписьСтатусЗагрузки.Заголовок =
		?(СтатусВыполненнойЗагрузки,
			НСтр("ru = 'Выгрузка успешно завершена'"),
			НСтр("ru = 'Выгрузка выполненна с ошибками'"));
			
	Элементы.НадписьВариантовПродолжения.Заголовок = 
		?(СтатусВыполненнойЗагрузки,
			НСтр("ru = 'Нажмите кнопку ""Готово"" для выхода из помощника.'"),
			НСтр("ru = 'Для того чтобы попробовать загрузить еще раз, нажмите ""Назад"", для выхода из помощника, нажимите ""Готово""'"));
	
	ЗаполнитьИтоговуюИнформацию();
	
	Заголовок = НСтр("ru = 'Выгрузка модели бюджетирования.'");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Если Не ЭтоПереходДалее Тогда
		
		ПропуститьСтраницу = Истина;
		
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Выгрузка модели бюджетирования.'");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПослеОткрытия()
	
	Результат = ВыгрузитьНаСервере();
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);	
	Иначе
		ЗаписатьРезультат();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ВыгрузитьНаСервере()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("МодельБюджетирования", МодельБюджетирования);
	ПараметрыЗадания.Вставить("ВыбранныеВидыБюджета", ПолучитьВыбранныеЭлементыОтбора(ВидыБюджетов,"Ссылка"));
	ПараметрыЗадания.Вставить("ВыбранныеЭтапыПодготовкиБюджета", ПолучитьВыбранныеЭлементыОтбора(ЭтапыПодготовкиБюджетов,"Ссылка"));
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ВыгрузитьМодельУчета(ПараметрыЗадания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
		
	Иначе
		
		НаименованиеЗадания = "";
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ВыгрузитьМодельУчета",
				ПараметрыЗадания,
				НаименованиеЗадания);
		
		АдресХранилища = Результат.АдресХранилища;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИтоговуюИнформацию()
	
	ЕстьОшибки = Не СтатусВыполненнойЗагрузки;
	
	Элементы.ИтоговаяИнформация.Видимость = ЕстьОшибки;
	Если ЕстьОшибки Тогда
		ИтоговаяИнформация =  НСтр("ru = 'Протокол:'") + Символы.ПС + ПротоколОбмена.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ЗавершитьФоновоеЗадание(ИдентификаторЗадания)
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		ФоновоеЗадание.Отменить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
		ЗаписатьРезультат();
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьВыполнениеЗадания",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал,
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРезультат()
	
	РезультатВыгрузкиИзФайла = ПолучитьИзВременногоХранилища(АдресХранилища);
	СтатусВыполненнойЗагрузки = РезультатВыгрузкиИзФайла.ЗагрузкаВыполнена;
	Если СтатусВыполненнойЗагрузки Тогда
		
		// пишем архив
		ПолноеИмяФайлаАрхива = Объект.ИмяФайлаМодели;
		РезультатВыгрузкиИзФайла.ФайлВыгрузки.Записать(ПолноеИмяФайлаАрхива);
		
	Иначе
		
		ПротоколОбмена.УстановитьТекст(РезультатВыгрузкиИзФайла.ПротоколОбмена);
		
	КонецЕсли;
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаМоделиРасширениеПодключено(Результат, ДополнительныеПараметры) Экспорт 
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.Фильтр             = "Файл выгрузки (*.zip)|*.zip";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок 		   = НСтр("ru = 'Выберите путь к файлу выгрузки модели учета'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИмяФайлаМоделиПоказатьДиалогЗавершение",
		ЭтотОбъект);
		
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаМоделиПоказатьДиалогЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ИмяФайлаМодели = ВыбранныеФайлы[0];
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеМоделиБюджетирования()
	
	ЗаполнитьДеревоВидовБюджетов();
	Если Не ЭтоКА Тогда
		ЗаполнитьДеревоЭтапыПодготовкиБюджетов();
	КонецЕсли;
	
	// Раскроем верхний уровень дерева
	ЭлементыДерева = ВидыБюджетов.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ВидыБюджетов.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;
	ЭлементыДерева = ЭтапыПодготовкиБюджетов.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ЭтапыПодготовкиБюджетов.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоВидовБюджетов()
	
	Компоновка = Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ПолучитьМакет("ВидыБюджетов");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Компоновка));
	КомпоновщикНастроек.ЗагрузитьНастройки(Компоновка.НастройкиПоУмолчанию);
	
	ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(КомпоновщикНастроек.Настройки, "Владелец", МодельБюджетирования);
	
	РезультатДерево = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(Компоновка,КомпоновщикНастроек.Настройки,, Истина);
	
	ЗначениеВРеквизитФормы(РезультатДерево, "ВидыБюджетов");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЭтапыПодготовкиБюджетов()
	
	Если Не ИспользоватьБюджетныйПроцесс Тогда
		Возврат;
	КонецЕсли;
	
	Компоновка = Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ПолучитьМакет("ЭтапыПодготовкиБюджетов");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Компоновка));
	КомпоновщикНастроек.ЗагрузитьНастройки(Компоновка.НастройкиПоУмолчанию);
	
	ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(КомпоновщикНастроек.Настройки, "Владелец", МодельБюджетирования);
	
	РезультатДерево = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(Компоновка,КомпоновщикНастроек.Настройки,, Истина);
	
	ЗначениеВРеквизитФормы(РезультатДерево, "ЭтапыПодготовкиБюджетов");
	
КонецПроцедуры

// Устанавливает состояние пометки у подчиненных строк строки дерева значений
// в зависимости от пометки текущей строки.
//
// Параметры:
//  ТекСтрока      - Строка дерева значений.
// 
&НаКлиенте
Процедура УстановитьПометкиПодчиненных(ТекСтрока, ИмяФлажка)
	
	Подчиненные = ТекСтрока.ПолучитьЭлементы();
	
	Если Подчиненные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Подчиненные Цикл
		
		Строка[ИмяФлажка] = ТекСтрока[ИмяФлажка];
		
		УстановитьПометкиПодчиненных(Строка, ИмяФлажка);
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает состояние пометки у родительских строк строки дерева значений
// в зависимости от пометки текущей строки.
//
// Параметры:
//  ТекСтрока      - Строка дерева значений.
// 
&НаКлиенте
Процедура УстановитьПометкиРодителей(ТекСтрока, ИмяФлажка)
	
	Родитель = ТекСтрока.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ТекСостояние = Родитель[ИмяФлажка];
	
	НайденыВключенные  = Ложь;
	НайденыВыключенные = Ложь;
	
	Для Каждого Строка Из Родитель.ПолучитьЭлементы() Цикл
		Если Строка[ИмяФлажка] = 0 Тогда
			НайденыВыключенные = Истина;
		ИначеЕсли Строка[ИмяФлажка] = 1
			ИЛИ Строка[ИмяФлажка] = 2 Тогда
			НайденыВключенные  = Истина;
		КонецЕсли; 
		Если НайденыВключенные И НайденыВыключенные Тогда
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Если НайденыВключенные И НайденыВыключенные Тогда
		Включить = 2;
	ИначеЕсли НайденыВключенные И (Не НайденыВыключенные) Тогда
		Включить = 1;
	ИначеЕсли (Не НайденыВключенные) И НайденыВыключенные Тогда
		Включить = 0;
	ИначеЕсли (Не НайденыВключенные) И (Не НайденыВыключенные) Тогда
		Включить = 2;
	КонецЕсли;
	
	Если Включить = ТекСостояние Тогда
		Возврат;
	Иначе
		Родитель[ИмяФлажка] = Включить;
		УстановитьПометкиРодителей(Родитель, ИмяФлажка);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВыбранныеЭлементыОтбора(ДеревоОтбора,ИмяКолонки)
	
	ВыбранныеЗначения = Новый Массив;
	ЭлементыДерева = ДеревоОтбора.ПолучитьЭлементы();
	Для Каждого ЭлементыДерева Из ЭлементыДерева Цикл
		Если ЭлементыДерева.Флаг Тогда
			ВыбранныеЗначения.Добавить(ЭлементыДерева[ИмяКолонки]);
			ПодчиненныеЗначения = ПолучитьВыбранныеЭлементыОтбора(ЭлементыДерева,ИмяКолонки);
			Для Каждого Значение Из ПодчиненныеЗначения Цикл
				ВыбранныеЗначения.Добавить(Значение);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВыбранныеЗначения;
	
КонецФункции

&НаСервере
Функция ПроверитьПравилаНаСервере()
	
	Если Не ЭтоКА Тогда
		МакетПравилОбмена = Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ПолучитьМакет("ПравилаОбмена");
	Иначе
		МакетПравилОбмена = Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ПолучитьМакет("ПравилаОбменаКА");
	КонецЕсли;
	ИмяВременногоФайлаПравилОбмена = ПолучитьИмяВременногоФайла("xml");
	МакетПравилОбмена.Записать(ИмяВременногоФайлаПравилОбмена);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяВременногоФайлаПравилОбмена);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM  = ПостроительDOM.Прочитать(ЧтениеXML);
	
	Объекты = ДокументDOM.ПолучитьЭлементыПоИмени("Правило");
	
	ДоступныеТипы = Новый Соответствие();
	
	Для Каждого Элемент Из Объекты Цикл
		
		РеквизитыОбъекта = Элемент.ДочерниеУзлы;
		Для Каждого Реквизит Из РеквизитыОбъекта Цикл
			Если Реквизит.ИмяУзла = "Источник" Тогда
				ДоступныеТипы.Вставить(Тип(Реквизит.ТекстовоеСодержимое),Реквизит.ТекстовоеСодержимое);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	ТипыЗначенийАналитик = БюджетированиеСервер.ВсеТипыАналитик().Типы();
	
	ЕстьОшибки = Ложь;
	ТекстОшибки = "";
	Для Каждого ТипАналитики Из ТипыЗначенийАналитик Цикл
		ТипСтрокой = ДоступныеТипы.Получить(ТипАналитики);
		Если ТипСтрокой = Неопределено Тогда
			ЕстьОшибки = Истина;
			ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для типа %1 не определено правил обмена! %2'"),ТипАналитики, Символы.ПС);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьОшибки Тогда
		ТекстОшибки = НСтр("ru = 'Ошибок не найдено!'");
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременногоФайлаПравилОбмена);
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти
