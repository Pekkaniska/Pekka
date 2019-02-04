#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МодифицироватьЭлементыФормыПриСоздании();
	ПрочитатьПараметры();
	УстановитьПометкуКнопкамПериодичности();
	ВывестиРасписаниеПриСозданииНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НачатьОжиданиеФоновойОперацииПриОткрытии Тогда
		
		ПодключитьОбработчикОжидания("НачатьОжиданиеФоновойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПриИзменении(Элемент)
	
	Если Начало > Окончание Тогда
		Начало = Окончание;
	КонецЕсли;
	
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПриИзменении(Элемент)
	
	Если Окончание < Начало Тогда
		Окончание = Начало;
	КонецЕсли;
	
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделенияПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиРасписание();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодДень(Команда)

	УстановитьПериодДеньНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодНеделя(Команда)
	
	УстановитьПериодНеделяНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодМесяц(Команда)
	
	УстановитьПериодМесяцНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура МодифицироватьЭлементыФормыПриСоздании()
	
	Отчеты.ДиаграммаПооперационногоРасписания2_2.ДобавитьВФормуОбозначенияДиаграммы(ЭтаФорма, Ложь, Ложь);
	
КонецПроцедуры

Процедура ПрочитатьПараметры()
	
	Если Параметры.Свойство("Начало") Тогда
		Начало = Параметры.Начало;
	КонецЕсли;
	Если Параметры.Свойство("Окончание") Тогда
		Окончание = Параметры.Окончание;
	КонецЕсли;
	Если Параметры.Свойство("РабочийЦентр") Тогда
		РабочийЦентр = Параметры.РабочийЦентр;
	КонецЕсли;
	Если Параметры.Свойство("Подразделения") Тогда
		Подразделения.ЗагрузитьЗначения(Параметры.Подразделения);
	КонецЕсли;
	Если Параметры.Свойство("МодельРасписания") Тогда
		МодельРасписания = Параметры.МодельРасписания;
	КонецЕсли;
	Если Параметры.Свойство("МодельПланирования") Тогда
		МодельПланирования = Параметры.МодельПланирования;
	КонецЕсли;
	
	Если ((Параметры.Свойство("ПериодВыборкиНачало") И ЗначениеЗаполнено(Параметры.ПериодВыборкиНачало))
		ИЛИ (Параметры.Свойство("ПериодВыборкиОкончание") И ЗначениеЗаполнено(Параметры.ПериодВыборкиОкончание)))
		И ЗначениеЗаполнено(Начало) И ЗначениеЗаполнено(Окончание) Тогда
		РассчитатьПериодПоСмежнымОперациям(Параметры.ПериодВыборкиНачало, Параметры.ПериодВыборкиОкончание);
	КонецЕсли;
	
	Если НачалоДня(Начало) = НачалоДня(Окончание) Тогда
		Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.День;
	ИначеЕсли НачалоНедели(Параметры.Начало) = НачалоНедели(Параметры.Окончание) Тогда
		Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя;
	Иначе
		Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Месяц;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьПериодПоСмежнымОперациям(ПериодВыборкиНачало, ПериодВыборкиОкончание)
	
	Периоды = СмежныеОперации(ПериодВыборкиНачало, ПериодВыборкиОкончание);
	
	СтруктураПоиска = Новый Структура("Начало, Окончание", Начало, Окончание);
	НайденныеСтроки = Периоды.НайтиСтроки(СтруктураПоиска);
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
		
		ТекущийИндекс = Периоды.Индекс(НайденныеСтроки[0]);
		Пока ТекущийИндекс > 0 Цикл
			
			ТекущийИндекс = ТекущийИндекс - 1;
			ТекущаяСтрока = Периоды[ТекущийИндекс];
			
			Если ТекущаяСтрока.Окончание >= Начало Тогда
				Начало = Мин(Начало, ТекущаяСтрока.Начало);
			Иначе
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ТекущийИндекс = Периоды.Индекс(НайденныеСтроки[0]);
		Пока ТекущийИндекс < Периоды.Количество()-1 Цикл
			
			ТекущийИндекс = ТекущийИндекс + 1;
			ТекущаяСтрока = Периоды[ТекущийИндекс];
			
			Если ТекущаяСтрока.Начало <= Окончание Тогда
				Окончание = Макс(Окончание, ТекущаяСтрока.Окончание);
			Иначе
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СмежныеОперации(ПериодВыборкиНачало, ПериодВыборкиОкончание)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПооперационноеРасписание.Начало КАК Начало,
	|	ПооперационноеРасписание.Окончание КАК Окончание
	|ИЗ
	|	РегистрСведений.ПооперационноеРасписание КАК ПооперационноеРасписание
	|ГДЕ
	|	ПооперационноеРасписание.МодельРасписания = &МодельРасписания
	|	И ПооперационноеРасписание.МодельПланирования = &МодельПланирования
	|	И ПооперационноеРасписание.РабочийЦентр = &РабочийЦентр
	|	И (НЕ &ОтборНачало
	|			ИЛИ ПооперационноеРасписание.Начало >= &Начало)
	|	И (НЕ &ОтборОкончание
	|			ИЛИ ПооперационноеРасписание.Окончание <= &Окончание)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Начало,
	|	Окончание");
	
	Запрос.УстановитьПараметр("МодельРасписания", МодельРасписания);
	Запрос.УстановитьПараметр("МодельПланирования", МодельПланирования);
	Запрос.УстановитьПараметр("ОтборНачало", ЗначениеЗаполнено(ПериодВыборкиНачало));
	Запрос.УстановитьПараметр("Начало", ПериодВыборкиНачало);
	Запрос.УстановитьПараметр("ОтборОкончание", ЗначениеЗаполнено(ПериодВыборкиОкончание));
	Запрос.УстановитьПараметр("Окончание", ПериодВыборкиОкончание);
	Запрос.УстановитьПараметр("РабочийЦентр", РабочийЦентр);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ВывестиРасписаниеПриСозданииНаСервере()
	
	Результат = ВывестиРасписаниеВФоновомРежиме();
	
	Если Результат.ЗаданиеВыполнено Тогда
		
		НачатьОжиданиеФоновойОперацииПриОткрытии = Ложь;
		
		ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, Результат.АдресХранилища);
		
	Иначе
		
		НачатьОжиданиеФоновойОперацииПриОткрытии = Истина;
		
		АдресХранилищаФоноваяОперация = Результат.АдресХранилища;
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВывестиРасписание()
	  
	Результат = ВывестиРасписаниеВФоновомРежиме();
	ЗаполнитьРеквизитыФоновойОперации(Результат);
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗавершенВыводРасписанияВФоновомРежиме();
	Иначе
		НачатьОжиданиеФоновойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВывестиРасписаниеВФоновомРежиме()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Параметры", ПараметрыВыводаРасписания());
	ПараметрыЗадания.Вставить("ДиаграммаГанта", ДиаграммаГанта);
	
	НаименованиеЗадания = НСтр("ru = 'Расшифровка параллельной загрузки'");
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"Отчеты.ДиаграммаПооперационногоРасписания2_2.РасшифроватьПараллельнуюЗагрузкуВФоновомРежиме",
						ПараметрыЗадания,
						НаименованиеЗадания);
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаКлиенте
Процедура ЗавершенВыводРасписанияВФоновомРежиме()
	
	ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, АдресХранилищаФоноваяОперация);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, АдресХранилища)
	
	Если ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		
		ДиаграммаГанта = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыВыводаРасписания()
	
	ПараметрыВывода = Отчеты.ДиаграммаПооперационногоРасписания2_2.ПараметрыПараллельнойЗагрузки();
	
	ЗаполнитьЗначенияСвойств(ПараметрыВывода, ЭтаФорма);
	Если ПараметрыВывода.Свойство("Подразделения") Тогда
		ПараметрыВывода.Подразделения = Подразделения.ВыгрузитьЗначения();
	КонецЕсли;
	
	Возврат ПараметрыВывода;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьРеквизитыФоновойОперации(Результат)
	
	АдресХранилищаФоноваяОперация = Результат.АдресХранилища;
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОжиданиеФоновойОперации()
	
	ПодключитьОбработчикОжиданияФоновойОперации();
	ОткрытьФормуДлительнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияФоновойОперации()
	
	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДлительнойОперации()
	
	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				
				ЗавершенВыводРасписанияВФоновомРежиме();
				
			Иначе
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьИзменениеОтбора()
	
	Если ПроверитьЗаполнение() Тогда
		ВывестиРасписание();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодДеньНаСервере()
	
	Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.День;
	ОбработатьИзменениеПериодичностиОтображения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодНеделяНаСервере()
	
	Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя;
	ОбработатьИзменениеПериодичностиОтображения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодМесяцНаСервере()
	
	Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Месяц;
	ОбработатьИзменениеПериодичностиОтображения();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПериодичностиОтображения()
	
	УстановитьПометкуКнопкамПериодичности();
	УстановитьПериодичность();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуКнопкамПериодичности()
	
	ПометкаДень = Ложь;
	ПометкаНеделя = Ложь;
	ПометкаМесяц = Ложь;
	
	Если Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.День Тогда
		ПометкаДень = Истина;
	ИначеЕсли Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя Тогда
		ПометкаНеделя = Истина;
	ИначеЕсли Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Месяц Тогда
		ПометкаМесяц = Истина;
	Иначе
		Периодичность = ТипЕдиницыИнтервалаВремениАнализаДанных.Неделя;
		ПометкаНеделя = Истина;
	КонецЕсли;
	
	Элементы.УстановитьПериодДень.Пометка = ПометкаДень;
	Элементы.УстановитьПериодНеделя.Пометка = ПометкаНеделя;
	Элементы.УстановитьПериодМесяц.Пометка = ПометкаМесяц;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодичность()
	
	ПараметрыВывода = ПараметрыВыводаРасписания();
	Отчеты.ДиаграммаПооперационногоРасписания2_2.УстановитьПериодичность(ПараметрыВывода, ДиаграммаГанта);
	
КонецПроцедуры

#КонецОбласти
