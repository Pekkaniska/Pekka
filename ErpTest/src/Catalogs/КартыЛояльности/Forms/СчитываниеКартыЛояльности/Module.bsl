
#Область ОписаниеПеременных

&НаКлиенте
Перем СтэкСтраниц; // История переходов для возврата по кнопке назад

&НаКлиенте
Перем ДанныеСчитывателя; // Кэш данных считывателя магнитной карты

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	НеПодключатьОборудование = Параметры.НеПодключатьОборудование;
	Партнер                  = Параметры.Партнер;
	Дата                     = ТекущаяДатаСеанса();
	Организация              = Параметры.Организация;
	
	ОсновнойТипКода = КартыЛояльностиСервер.ПолучитьОсновнойТипКодаКартыЛояльности();
	
	НеИспользоватьРучнойВвод = Параметры.НеИспользоватьРучнойВвод;
	Если НеИспользоватьРучнойВвод Тогда
		Элементы.ГруппаКодКарты.Видимость = Ложь;
		ЭтаФорма.ТекущийЭлемент = Элементы.КнопкаГотово;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.КодКарты) Тогда
		
		// При считывании в форме списка было найдено несколько карт с данным кодом,
		// требуется предложить карты на выбор пользователю.
		ОбработатьПолученныйКодНаСервере(Параметры.КодКарты, Параметры.ТипКода, Истина);
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборКартыЛояльности;
		
	Иначе
		
		Если ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			ТипКода = ОсновнойТипКода;
			Элементы.ТипКода.Видимость = Ложь;
		Иначе
			ТипКода = Перечисления.ТипыКодовКарт.Штрихкод;
		КонецЕсли;
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности;
		
	КонецЕсли;
	
	Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазадОтсутствует;
	Элементы.СтраницыКнопкиДалее.ТекущаяСтраница = Элементы.СтраницыКнопкиДалее.ПодчиненныеЭлементы.КнопкаГотово;
	
	Если НЕ НеИспользоватьРучнойВвод Тогда
		Если Не ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			Текст = НСтр("ru = 'Считайте новую карту лояльности при помощи сканера штрихкода
			                   |(считывателя магнитных карт) или введите код вручную'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Считайте новую карту лояльности при помощи считывателя
			                   |магнитных карт или введите магнитный код вручную'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			Текст = НСтр("ru = 'Считайте новую карту лояльности при помощи сканера
			                   |штрихкода или введите штрихкод вручную'");
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(ОсновнойТипКода) Тогда
			Текст = НСтр("ru = 'Считайте новую карту лояльности при помощи сканера штрихкода
			                   |(считывателя магнитных карт)'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Считайте новую карту лояльности при помощи считывателя
			                   |магнитных карт'");
		ИначеЕсли ОсновнойТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			Текст = НСтр("ru = 'Считайте новую карту лояльности при помощи сканера
			                   |штрихкода'");
		КонецЕсли;
	КонецЕсли;
	НадписьСчитываниеКартыЛояльности = Текст;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтэкСтраниц = Новый Массив;
	
	Если НеПодключатьОборудование Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если НеПодключатьОборудование Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипКодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КодКартыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(КодКарты) Тогда
		ПодключитьОбработчикОжидания("ДалееОбработчикОжидания", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НайденныеКартыЛояльностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПодключитьОбработчикОжидания("ДалееОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Назад(Команда)
	
	Если СтэкСтраниц.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Страницы.ТекущаяСтраница = СтэкСтраниц[СтэкСтраниц.Количество()-1];
	СтэкСтраниц.Удалить(СтэкСтраниц.Количество()-1);
	
	Если СтэкСтраниц.Количество() = 0 Тогда
		Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазадОтсутствует;
	КонецЕсли;
	
	Элементы.СтраницыКнопкиДалее.ТекущаяСтраница = Элементы.СтраницыКнопкиДалее.ПодчиненныеЭлементы.КнопкаГотово;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ОтключитьОбработчикОжидания("ДалееОбработчикОжидания");
	
	ОчиститьСообщения();
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
		
		Если Не ЗначениеЗаполнено(КодКарты) Тогда
			
			Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
				ТекстСообщения = НСтр("ru = 'Штрихкод не заполнен.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Магнитный код не заполнен.'");
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"КодКарты");
			
			Возврат;
			
		КонецЕсли;
		
		ОбработатьПолученныйКодНаКлиенте(КодКарты, ТипКода, Ложь);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборКартыЛояльности Тогда
		
		ТекущиеДанные = Элементы.НайденныеКартыЛояльности.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ОбработатьВыборКартыЛояльности(ТекущиеДанные);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НайденныеКартыЛояльности.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеКартыЛояльности.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НайденныеКартыЛояльности.АвтоматическаяРегистрацияПриПервомСчитывании");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет());
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Элементы.Страницы.ТекущаяСтраница <> Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ОбработатьПолученныйКодНаКлиенте(МассивШтрихкодов[0].Штрихкод, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	Если Элементы.Страницы.ТекущаяСтраница <> Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСчитывателя = Данные;
	ПодключитьОбработчикОжидания("ОбработатьПолученныйКодНаКлиентеВОбработкеОжидания", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПерейтиНаСтраницу(Страница)
	
	СтэкСтраниц.Добавить(Элементы.Страницы.ТекущаяСтраница);
	Элементы.Страницы.ТекущаяСтраница = Страница;
	Элементы.СтраницыКнопкиНазад.ТекущаяСтраница = Элементы.СтраницыКнопкиНазад.ПодчиненныеЭлементы.КнопкаНазад;
	
	Если Страница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборКартыЛояльности Тогда
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
			Текст = НСтр("ru = 'Обнаружено несколько карт лояльности с магнитным кодом %1.
			                   |Выберите подходящую карту.'");
		Иначе
			Текст = НСтр("ru = 'Обнаружено несколько карт лояльности со штрихкодом %1.
			                   |Выберите подходящую карту.'");
		КонецЕсли;
		НадписьВыборКартыЛояльности = СтрШаблон(Текст, КодКарты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьПолученныйКодНаСервере(Данные, ТипКодаКарты, Предобработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НайденныеКартыЛояльности.Очистить();
	
	ТипКода = ТипКодаКарты;
	Если ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод Тогда
		Если Предобработка Тогда
			КодКарты = Данные[0]; // Данные 3х дорожек магнитной карты. Используется если карта не найдена.
			КартыЛояльности = КартыЛояльностиВызовСервера.НайтиКартыЛояльностиПоДаннымСоСчитывателяМагнитныхКарт(Данные);
		Иначе
			КодКарты = Данные;
			КартыЛояльности = КартыЛояльностиСервер.НайтиКартыЛояльностиПоМагнитномуКоду(КодКарты);
		КонецЕсли;
	Иначе
		КодКарты = Данные;
		КартыЛояльности = КартыЛояльностиВызовСервера.НайтиКартыЛояльностиПоШтрихкоду(КодКарты);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из КартыЛояльности.ЗарегистрированныеКартыЛояльности Цикл
		
		НоваяСтрока = НайденныеКартыЛояльности.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		НоваяСтрока.Наименование = Строка(СтрокаТЧ.Ссылка) + ?(ЗначениеЗаполнено(СтрокаТЧ.Партнер) И ЗначениеЗаполнено(СтрокаТЧ.Ссылка), " " + СтрШаблон(НСтр("ru = 'Клиент: %1'"), Строка(СтрокаТЧ.Партнер)), "");
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из КартыЛояльности.НеЗарегистрированныеКартыЛояльности Цикл
		
		НоваяСтрока = НайденныеКартыЛояльности.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		НоваяСтрока.Наименование = СтрШаблон(НСтр("ru = 'Незарегистрированная карта: %1'"), Строка(СтрокаТЧ.ВидКарты));
		
	КонецЦикла;
	
	Возврат НайденныеКартыЛояльности.Количество() > 0;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиенте(Данные, ПолученныйТипКода, Предобработка)
	
	Результат = ОбработатьПолученныйКодНаСервере(Данные, ПолученныйТипКода, Предобработка);
	Если Не Результат Тогда
		
		Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
			ТекстСообщения = НСтр("ru = 'Карта со штрихкодом ""%1"" не зарегистрирована.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Карта с магнитным кодом ""%1"" не зарегистрирована.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(ТекстСообщения, КодКарты),
			,
			"КодКарты");
		
		Возврат;
		
	КонецЕсли;
	
	Если НайденныеКартыЛояльности.Количество() > 1 Тогда
		ПерейтиНаСтраницу(Элементы.Страницы.ПодчиненныеЭлементы.ГруппаВыборКартыЛояльности);
		Текст = НСтр("ru = 'Обнаружено несколько карт лояльности с кодом %1.
		                   |Выберите подходящую карту.'");
		НадписьВыборКартыЛояльности = СтрШаблон(Текст, КодКарты);
	ИначеЕсли НайденныеКартыЛояльности.Количество() = 1 Тогда
		ОбработатьВыборКартыЛояльности(НайденныеКартыЛояльности[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗарегистрироватьКартуЛояльности(ВидКарты, МагнитныйКод, Штрихкод)
	
	СтруктураДанныхКарты = КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности();
	СтруктураДанныхКарты.ВидКарты = ВидКарты;
	Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод") Тогда
		СтруктураДанныхКарты.МагнитныйКод = МагнитныйКод;
	ИначеЕсли ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
		СтруктураДанныхКарты.Штрихкод = Штрихкод;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыКартЛояльности.Персонализирована КАК Персонализирована
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКартЛояльности
	|ГДЕ
	|	ВидыКартЛояльности.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ВидКарты);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.Персонализирована Тогда
		Если Не ЗначениеЗаполнено(Партнер) Тогда
			Возврат КартыЛояльностиСервер.СоздатьПартнераИЗарегистрироватьКартуЛояльности(СтруктураДанныхКарты);
		Иначе
			СтруктураДанныхКарты.Партнер    = Партнер;
			Возврат КартыЛояльностиСервер.ЗарегистрироватьКартуЛояльности(СтруктураДанныхКарты);
		КонецЕсли;
	Иначе
		Возврат КартыЛояльностиСервер.ЗарегистрироватьКартуЛояльности(СтруктураДанныхКарты);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборКартыЛояльности(ТекущиеДанные)
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		Если ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.СтатусыКартЛояльности.Действует")
			И ТекущиеДанные.ДатаНачалаДействия <= Дата
			И (Не ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончанияДействия) ИЛИ КонецДня(ТекущиеДанные.ДатаОкончанияДействия) >= Дата) Тогда
			
			Если ЗначениеЗаполнено(Организация) И Организация <> ТекущиеДанные.Организация Тогда
				Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
					ТекстСообщения = НСтр("ru = 'Карта ""%1"" со штрихкодом ""%2"" зарегистрирована на другую организацию ""%3"".'");
				Иначе
					ТекстСообщения = НСтр("ru = 'Карта ""%1"" со магнитным кодом ""%2"" зарегистрирована на другую организацию ""%3"".'");
				КонецЕсли;
				
				Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
					Поле = "КодКарты";
				Иначе
					Поле = СтрШаблон("НайденныеКартыЛояльности[%1].Наименование", НайденныеКартыЛояльности.Индекс(ТекущиеДанные));
				КонецЕсли;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстСообщения, ТекущиеДанные.ВидКарты, КодКарты, ТекущиеДанные.Организация),
					,
					Поле);
			Иначе
				Закрыть();
				Оповестить(
					"СчитанаКартаЛояльности",
					Новый Структура("КартаЛояльности, ФормаВладелец", ТекущиеДанные.Ссылка, ВладелецФормы.УникальныйИдентификатор),
					Неопределено);
			
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Считана карта лояльности'"),
					ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
					СтрШаблон(НСтр("ru = 'Считана карта лояльности %1'"), ТекущиеДанные.Ссылка),
					БиблиотекаКартинок.Информация32);
			КонецЕсли;
		Иначе
			
			Если ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.СтатусыКартЛояльности.Действует") Тогда
				
				Если ТекущиеДанные.ДатаНачалаДействия <= Дата Тогда
					Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
						ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" со штрихкодом %2 истек.'");
					Иначе
						ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" с магнитным кодом %2 истек.'");
					КонецЕсли;
				Иначе
					Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
						ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" со штрихкодом %2 еще не наступил.'");
					Иначе
						ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" с магнитным кодом %2 еще не наступил.'");
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				
				Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
					ТекстСообщения = НСтр("ru = 'Карта ""%1"" со штрихкодом %2 аннулирована.'");
				Иначе
					ТекстСообщения = НСтр("ru = 'Карта ""%1"" с магнитным кодом %2 аннулирована.'");
				КонецЕсли;
				
			КонецЕсли;
		
			Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
				Поле = "КодКарты";
			Иначе
				Поле = СтрШаблон("НайденныеКартыЛояльности[%1].Наименование", НайденныеКартыЛояльности.Индекс(ТекущиеДанные));
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ТекстСообщения, ТекущиеДанные.ВидКарты, КодКарты),
				,
				Поле);
			
		КонецЕсли;
		
	Иначе // Карта не зарегистрирована.
		
		Если ТекущиеДанные.АвтоматическаяРегистрацияПриПервомСчитывании Тогда
			
			Если ТекущиеДанные.СтатусВидаКарты = ПредопределенноеЗначение("Перечисление.СтатусыВидовКартЛояльности.Действует")
				И ТекущиеДанные.ДатаНачалаДействия <= Дата
				И (Не ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончанияДействия) ИЛИ КонецДня(ТекущиеДанные.ДатаОкончанияДействия) >= Дата) Тогда
			
				ТекущиеДанные.Ссылка = ЗарегистрироватьКартуЛояльности(ТекущиеДанные.ВидКарты, ТекущиеДанные.МагнитныйКод, ТекущиеДанные.Штрихкод);
				
				Закрыть();
				
				Оповестить(
					"Запись_КартаЛояльности",
					Новый Структура,
					ТекущиеДанные.Ссылка);
				
				Оповестить(
					"СчитанаКартаЛояльности",
					Новый Структура("КартаЛояльности, ФормаВладелец", ТекущиеДанные.Ссылка, ВладелецФормы.УникальныйИдентификатор),
					Неопределено);
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Считана карта лояльности'"),
					ПолучитьНавигационнуюСсылку(ТекущиеДанные.Ссылка),
					СтрШаблон(НСтр("ru = 'Считана карта лояльности %1'"), ТекущиеДанные.Ссылка),
					БиблиотекаКартинок.Информация32);
				
			Иначе
				
				Если ТекущиеДанные.СтатусВидаКарты = ПредопределенноеЗначение("Перечисление.СтатусыВидовКартЛояльности.Действует") Тогда
					
					Если ТекущиеДанные.ДатаНачалаДействия <= Дата Тогда
						Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
							ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" со штрихкодом %2 истек.'");
						Иначе
							ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" с магнитным кодом %2 истек.'");
						КонецЕсли;
					Иначе
						Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
							ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" со штрихкодом %2 еще не наступил.'");
						Иначе
							ТекстСообщения = НСтр("ru = 'Срок действия карты ""%1"" с магнитным кодом %2 еще не наступил.'");
						КонецЕсли;
					КонецЕсли;
					
				Иначе
					
					Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
						ТекстСообщения = НСтр("ru = 'Карта ""%1"" со штрихкодом %2 аннулирована.'");
					Иначе
						ТекстСообщения = НСтр("ru = 'Карта ""%1"" с магнитным кодом %2 аннулирована.'");
					КонецЕсли;
					
				КонецЕсли;
				
				Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
					Поле = "КодКарты";
				Иначе
					Поле = СтрШаблон("НайденныеКартыЛояльности[%1].Наименование", НайденныеКартыЛояльности.Индекс(ТекущиеДанные));
				КонецЕсли;
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстСообщения, ТекущиеДанные.ВидКарты, КодКарты),
					,
					Поле);
				
			КонецЕсли;
			
		Иначе
			
			Если ТипКода = ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод") Тогда
				ТекстСообщения = НСтр("ru = 'Карта ""%1"" со штрихкодом %2 не зарегистрирована. Карты вида ""%1"" регистрируются только с помощью помощника регистрации карт лояльности'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Карта ""%1"" с магнитным кодом %2 не зарегистрирована. Карты вида ""%1"" регистрируются только с помощью помощника регистрации карт лояльности'");
			КонецЕсли;
			
			Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ГруппаСчитываниеКартыЛояльности Тогда
				Поле = "КодКарты";
			Иначе
				Поле = СтрШаблон("НайденныеКартыЛояльности[%1].Наименование", НайденныеКартыЛояльности.Индекс(ТекущиеДанные));
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ТекстСообщения, ТекущиеДанные.ВидКарты, КодКарты),
				,
				Поле);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПолученныйКодНаКлиентеВОбработкеОжидания()
	ОбработатьПолученныйКодНаКлиенте(ДанныеСчитывателя, ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"), Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДалееОбработчикОжидания()
	
	Далее(Команды["Далее"]);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
