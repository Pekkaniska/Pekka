
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплатыФормы.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВзаиморасчетыССотрудникамиУправленческийФормы");
		Модуль.ВедомостьВКассуФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ВедомостьНаВыплатуЗарплатыФормы.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ВедомостьНаВыплатуЗарплатыКлиентРасширенный.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ВедомостьНаВыплатуЗарплатыФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ВедомостьНаВыплатуЗарплатыФормы.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи); 
	
	СохраняемыеЗначения = Новый Структура;
	СохраняемыеЗначения.Вставить("Бухгалтер", ТекущийОбъект.Бухгалтер);
	СохраняемыеЗначения.Вставить("Составил", ТекущийОбъект.Составил);
	СохраняемыеЗначения.Вставить("ДолжностьСоставившего", ТекущийОбъект.ДолжностьСоставившего);
	СохраняемыеЗначения.Вставить("Проверил", ТекущийОбъект.Проверил);
	СохраняемыеЗначения.Вставить("ДолжностьПроверившего", ТекущийОбъект.ДолжностьПроверившего);
	СохраняемыеЗначения.Вставить("Раздатчик", ТекущийОбъект.Раздатчик);
	СохраняемыеЗначения.Вставить("ДолжностьРаздатчика", ТекущийОбъект.ДолжностьРаздатчика);
	
	ЗарплатаКадры.СохранитьЗначенияЗаполненияОтветственныхРаботников(ТекущийОбъект.Организация, СохраняемыеЗначения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ВедомостьНаВыплатуЗарплатыВКассу", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СпособВыплатыПриИзменении(Элемент)
	СпособВыплатыПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОснованийНажатие(Элемент, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиентРасширенный.ПредставлениеОснованийНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОкруглениеПриИзменении(Элемент)
	ОкруглениеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроцентВыплатыПриИзменении(Элемент)
	ПроцентВыплатыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура КассирПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура БухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура СоставилПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ПроверилПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура РаздатчикПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.КомментарийНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОповещениеЗавершения = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой",, ОповещениеЗавершения);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПеречислениеНДФЛВыполненоПриИзменении(Элемент)
	ВедомостьНаВыплатуЗарплатыКлиентРасширенный.ПеречислениеНДФЛВыполненоПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ВедомостьНаВыплатуЗарплатыКлиентРасширенный.ДатаПриИзменении(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыплатыПриИзменении(Элемент)
	ВедомостьНаВыплатуЗарплатыКлиентРасширенный.ДатаВыплатыПриИзменении(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		ВедомостьНаВыплатуЗарплатыКлиент.Подобрать(ЭтотОбъект);
	КонецЕсли;	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставПередУдалением(ЭтотОбъект, Элемент, Отказ) 
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеПриИзменении(Элемент)
	СоставКВыплатеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеОткрытие(Элемент, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставКВыплатеОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Заполнить(Команда)
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЗаполнениеДокументаВедомостьНаВыплатуЗарплатыВКассу");
	ВедомостьНаВыплатуЗарплатыКлиент.Заполнить(ЭтотОбъект)
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ВедомостьНаВыплатуЗарплатыКлиент.Подобрать(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗарплату(Команда)
	РедактироватьЗарплатуСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛ(Команда)
	РедактироватьНДФЛСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНДФЛ(Команда)
	ВедомостьНаВыплатуЗарплатыКлиент.ОбновитьНДФЛ(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.ОплатаПоказать(ЭтотОбъект, Элемент, НавигационнаяСсылка, СтандартнаяОбработка);
КонецПроцедуры

#Область ОграничениеДокумента

&НаКлиенте
Процедура Подключаемый_ОграничитьДокумент(Команда)
	
	ОграничитьДокументНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВызовыСервера

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.ОрганизацияПриИзмененииНаСервере(ЭтотОбъект);
	ПодписантПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СпособВыплатыПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.СпособВыплатыПриИзмененииНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОкруглениеПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ПараметрыРасчетаПриИзменении(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроцентВыплатыПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ПараметрыРасчетаПриИзменении(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыФормы.СоставОбработкаВыбораНаСервере(ЭтотОбъект, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.СоставПослеУдаленияНаСервере(ЭтотОбъект)
КонецПроцедуры

&НаСервере
Процедура СоставКВыплатеПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.СоставКВыплатеПриИзмененииНаСервере(ЭтотОбъект)	
КонецПроцедуры

&НаСервере
Процедура ПодписантПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.ПодписантПриИзмененииНаСервере(ЭтотОбъект)
КонецПроцедуры

&НаСервере
Процедура ОграничитьДокументНаСервере()
	
	ОграничениеИспользованияДокументовФормы.ОграничитьДокумент(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбратныеВызовы

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения() Экспорт
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ЗаполнитьПервоначальныеЗначения(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект) Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ПриПолученииДанныхНаСервере(ЭтотОбъект, ТекущийОбъект);
	ОграничениеИспользованияДокументовФормы.ПриПолученииДанныхНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхСтрокиСостава(СтрокаСостава) Экспорт
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ПриПолученииДанныхСтрокиСостава(ЭтотОбъект, СтрокаСостава)
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю() Экспорт
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ОбработатьСообщенияПользователю(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.УстановитьДоступностьЭлементов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей() Экспорт
	
	Если ПолучитьФункциональнуюОпциюФормы("РаботаВБюджетномУчреждении") Тогда
		ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер", "Объект.Кассир", "Объект.Бухгалтер", "Объект.Составил", "Объект.Проверил");
	Иначе
		ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер", "Объект.Кассир", "Объект.Бухгалтер");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеОплаты() Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.УстановитьПредставлениеОплаты(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаСервере() Экспорт
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ОчиститьНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере() Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.ЗаполнитьНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьНДФЛНаСервере(ИдентификаторыСтрок) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.ОбновитьНДФЛНаСервере(ЭтотОбъект, ИдентификаторыСтрок)
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников() Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресСпискаПодобранныхСотрудников(ЭтотОбъект)
КонецФункции

&НаКлиенте
Процедура РедактироватьЗарплатуСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьЗарплатуСтроки(ЭтотОбъект, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьЗарплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьЗарплатуСтрокиЗавершениеНаСервере(ЭтотОбъект, РезультатыРедактирования) 
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьНДФЛСтроки(ЭтотОбъект, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьНДФЛСтрокиЗавершениеНаСервере(ЭтотОбъект, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеЗарплатыПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеЗарплатыПоСтроке(ЭтотОбъект, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеНДФЛПоСтроке(ЭтотОбъект, ИдентификаторСтроки)
КонецФункции	

#КонецОбласти

#КонецОбласти
