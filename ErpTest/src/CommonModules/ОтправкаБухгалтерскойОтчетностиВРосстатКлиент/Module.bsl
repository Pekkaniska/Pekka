#Область ПрограммныйИнтерфейс

Процедура СоздатьБухгалтерскуюОтчетностьВРосстатНажатие(Форма) Экспорт
	
	СтруктураРеквизитовФормы 	= Форма.СтруктураРеквизитовФормы;
	ОтчетностьВРосстат 			= Форма.ОтчетностьВРосстат;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("СтруктураРеквизитовФормы", 	СтруктураРеквизитовФормы);
	ДополнительныеПараметры.Вставить("ОтчетностьВРосстат", 			ОтчетностьВРосстат);

	Если ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок) Тогда
		
		СоздатьБухгалтерскуюОтчетностьВРосстат(, ДополнительныеПараметры);
		
	Иначе
		
		// Форма нужна для того, чтобы из нее получить ссылку на отчет
		// после его сохранения.
		ДополнительныеПараметры.Вставить("Форма", Форма);

		Оповещение = Новый ОписаниеОповещения(
			"СоздатьБухгалтерскуюОтчетностьВРосстат", 
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		Форма.СохранитьНаКлиенте(, Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "СозданОтчетВРосстат" И ТипЗнч(Параметр) = Тип("Структура") Тогда 
		
		// Событие возникает при создании отчета в Росстат из отчета в ФНС.
		
		БухОтчетность = Неопределено;
		Параметр.Свойство("БухОтчетность", БухОтчетность);
		Если БухОтчетность = Форма.СтруктураРеквизитовФормы.мСохраненныйДок Тогда
			
			Форма.ОтчетностьВРосстат = Параметр.ОтчетВРосстат;
			Форма.Элементы.СоздатьБухгалтерскуюОтчетностьВРосстат.Заголовок = "Отчет в Росстат";
			
			ОтправкаБухгалтерскойОтчетностиВРосстатКлиентСервер.УстановитьВидимостьСсылкиНаОтчетРосстатаИПанелиПредупреждения(Форма);
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Завершение отправки в контролирующий орган" 
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Ссылка = Форма.СтруктураРеквизитовФормы.мСохраненныйДок Тогда
		
		// Если отчет отправлен успешно, то предложить отправить в Росстат. Потом только перерисовывать панели.
		Если ОтправкаБухгалтерскойОтчетностиВРосстатВызовСервера.ОтчетОтправленВФНС(Форма.СтруктураРеквизитовФормы)
			И НЕ ЗначениеЗаполнено(Форма.ОтчетностьВРосстат) Тогда
		    ПоказатьВопросПроНеобходимостьОтправкиВРосстат(Форма);
		Иначе
			// Событие возникает при завершении отправки отчета в ФНС.
			ОтправкаБухгалтерскойОтчетностиВРосстатКлиентСервер.УстановитьВидимостьСсылкиНаОтчетРосстатаИПанелиПредупреждения(Форма);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Получен отказ на создание отчета в Росстат"
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Ссылка = Форма.СтруктураРеквизитовФормы.мСохраненныйДок Тогда
		
		ОтправкаБухгалтерскойОтчетностиВРосстатКлиентСервер.УстановитьВидимостьСсылкиНаОтчетРосстатаИПанелиПредупреждения(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылкиКраснойПанели(
		Форма, 
		Элемент, 
		НавигационнаяСсылкаФорматированнойСтроки, 
		СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПодготовитьИОтправить" Тогда
		
		 СоздатьБухгалтерскуюОтчетностьВРосстатНажатие(Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Подробнее" Тогда
		
		ТекстПредупреждения = НСтр("ru = 'В соответствии со ст. 18 Федерального закона ""О бухгалтерском учете"" 
                                    |№ 402-ФЗ от 06.12.2011 организации, обязанные составлять 
                                    |бухгалтерскую (финансовую) отчетность, обязаны представлять экземпляр 
                                    |годовой бухгалтерской отчетности в Росстат.'");
									 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправкаБухОтчетностиВРосстатСкрытьНажатие(
		Форма, 
		Элемент) Экспорт
	
	ОтправкаБухгалтерскойОтчетностиВРосстатВызовСервера.БольшеНеПоказыватьПанель(Форма.СтруктураРеквизитовФормы.мСохраненныйДок);
	// Форму нельзя с клиента передавать на сервер.
	ОтправкаБухгалтерскойОтчетностиВРосстатКлиентСервер.УстановитьВидимостьСсылкиНаОтчетРосстатаИПанелиПредупреждения(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьБухгалтерскуюОтчетностьВРосстат(Отказ = Неопределено, ДополнительныеПараметры) Экспорт 
	
	// Если отчет новый (не был записан), то мы должны заново получить ссылку на отчет
	// иначе ссылка на отчет быдет пустой.
	Если ДополнительныеПараметры.Свойство("Форма") Тогда
		СтруктураРеквизитовФормы = ДополнительныеПараметры.Форма.СтруктураРеквизитовФормы;
		ДополнительныеПараметры.Удалить("Форма");
	Иначе
		СтруктураРеквизитовФормы = ДополнительныеПараметры.СтруктураРеквизитовФормы;
	КонецЕсли;
	
	ОтчетностьВРосстат = ДополнительныеПараметры.ОтчетностьВРосстат;
	
	Если Не ЗначениеЗаполнено(ОтчетностьВРосстат) Тогда
		ИмяОтчетаРегламентированныйОтчетСтатистикаБухОтчетность = Неопределено;
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("РегламентированнаяОтчетность.СтатистическаяОтчетность.Прочая") Тогда
			ИмяОтчетаРегламентированныйОтчетСтатистикаБухОтчетность = "РегламентированныйОтчетСтатистикаБухОтчетность";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИмяОтчетаРегламентированныйОтчетСтатистикаБухОтчетность) Тогда
			Попытка
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("Организация", СтруктураРеквизитовФормы.Организация);
				ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", НачалоГода(СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета));
				ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета", КонецГода(СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета));
				ПараметрыФормы.Вставить("БухгалтерскаяОтчетность", СтруктураРеквизитовФормы.мСохраненныйДок);
				ПараметрыФормы.Вставить("НужноОповещатьОСоздании");
				
				ИмяФормыРегламентированныйОтчетСтатистикаБухОтчетность = СтрШаблон(
					"Отчет.%1.Форма.ОсновнаяФорма",
					ИмяОтчетаРегламентированныйОтчетСтатистикаБухОтчетность);
				ОткрытьФорму(ИмяФормыРегламентированныйОтчетСтатистикаБухОтчетность, ПараметрыФормы);
				
			Исключение
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru='Не удалось открыть форму отчета ""Бухгалтерская отчетность в Росстат"".'");
				Сообщение.Сообщить();

			КонецПопытки;
		Иначе
			ТекстСообщения = НСтр("ru='Форма отчета ""Бухгалтерская отчетность в Росстат"" не поддерживается.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	Иначе
		ПоказатьЗначение(,ОтчетностьВРосстат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьВопросПроНеобходимостьОтправкиВРосстат(Форма)
	
	ТекстВопроса = НСтр("ru = 'В соответствии со ст. 18 Федерального закона ""О бухгалтерском учете"" 
                                |№ 402-ФЗ от 06.12.2011 данный отчет должен быть отправлен и в Росстат. 
                                |
                                |Подготовить отчет для отправки в Росстат сейчас?'");
								
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("СтруктураРеквизитовФормы", Форма.СтруктураРеквизитовФормы);
	ДополнительныеПараметры.Вставить("ОтчетностьВРосстат", Форма.ОтчетностьВРосстат);
								
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПолучениеОтветаНаВопросПроНеобходимостьОтправкиВРосстат", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
	
	ЗаголовокВопроса = НСтр("ru = 'Отправка отчета в Росстат'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("ПодготовитьСейчас", НСтр("ru = 'Подготовить сейчас'"));
	Кнопки.Добавить("Позже", НСтр("ru = 'Позже'"));
	
	КнопкаПоУмолчанию = "ПодготовитьСейчас";
	
	ПоказатьВопрос(
		ОписаниеОповещения,
		ТекстВопроса,
		Кнопки,
		,
		КнопкаПоУмолчанию,
		ЗаголовокВопроса);
	
КонецПроцедуры
	
Процедура ПослеПолучениеОтветаНаВопросПроНеобходимостьОтправкиВРосстат(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = "ПодготовитьСейчас" Тогда
		
		СоздатьБухгалтерскуюОтчетностьВРосстат(, ВходящийКонтекст);
		
	Иначе
		
		Параметр = Новый Структура();
		Параметр.Вставить("Ссылка", ВходящийКонтекст.СтруктураРеквизитовФормы.мСохраненныйДок);
		 
		Оповестить("Получен отказ на создание отчета в Росстат", Параметр);
		
	КонецЕсли;
	
КонецПроцедуры
 

#КонецОбласти