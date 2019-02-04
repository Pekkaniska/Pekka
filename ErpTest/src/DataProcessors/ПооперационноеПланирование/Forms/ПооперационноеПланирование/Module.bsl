
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МодифицироватьЭлементыФормыПриСоздании();
	
	ВосстановитьНастройкиФормыПриСоздании();
	
	ПрочитатьПараметрыФормыПриСоздании();
	
	УстановитьПометкуКнопкамПериодичности();
	
	ВывестиРасписаниеПриСозданииНаСервере();
	
	УправлениеДоступностью(ЭтотОбъект);
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРасписание;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НачатьОжиданиеФоновойОперацииПриОткрытии Тогда
		
		ПодключитьОбработчикОжидания("НачатьОжиданиеФоновойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если РасчетВыполнен Тогда
		ОбработатьРезультатыРасчетаПередЗакрытием(Отказ, СтандартнаяОбработка);
	Иначе
		УдалитьРезультатыМоделированияИБлокировкиРасписания();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутныеЛистыПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияПриИзменении(Элемент)
	
	ОбработатьИзменениеОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПроблемыРасписания

&НаКлиенте
Процедура ПроблемыРасписанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеСтроки = ПроблемыРасписания.НайтиПоИДентификатору(Выбраннаястрока);
	
	Если ДанныеСтроки.Категория = ПредопределенноеЗначение(
		"Перечисление.КатегорииПроблемПооперационногоРасписания.НеЗаданоВремяВыполненияОперации") Тогда
		
		Если ТипЗнч(ДанныеСтроки.Свойства) = Тип("Структура")
			И ДанныеСтроки.Свойства.Свойство("МаршрутныйЛист") Тогда
			ПоказатьЗначение(, ДанныеСтроки.Свойства.МаршрутныйЛист);
		КонецЕсли;
		
	ИначеЕсли ДанныеСтроки.Категория = ПредопределенноеЗначение(
		"Перечисление.КатегорииПроблемПооперационногоРасписания.НедоступенРабочийЦентр") Тогда
		
		Если ТипЗнч(ДанныеСтроки.Свойства) = Тип("Структура")
			И ДанныеСтроки.Свойства.Свойство("ВидРабочегоЦентра")
			И ДанныеСтроки.Свойства.Свойство("Период") Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ВидРабочегоЦентра", ДанныеСтроки.Свойства.ВидРабочегоЦентра);
			ПараметрыФормы.Вставить("НачалоПериода", ДанныеСтроки.Свойства.Период);
			ПараметрыФормы.Вставить("РежимРаботы", ПредопределенноеЗначение("Перечисление.РежимыРедактированияДоступностиВидовРЦ.ВводГрафикаРаботыРЦДляФормированияРасписанияРаботыРЦ"));
			ОткрытьФорму("Обработка.ДоступностьВидовРабочихЦентров.Форма", ПараметрыФормы);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовДиаграммыГанта

&НаКлиенте
Процедура ДиаграммаГантаОбработкаРасшифровки(Элемент, Расшифровки, СтандартнаяОбработка, Дата)
	
	Если ТипЗнч(Расшифровки) = Тип("СправочникСсылка.МоделиПооперационногоПланирования")
		И ЗначениеЗаполнено(Расшифровки)
		И ЗаписьРасписанияДопустима() Тогда
		
		ВыполнитьРасшифровкуМоделиПланирования(Расшифровки, СтандартнаяОбработка);
		
	ИначеЕсли ТипЗнч(Расшифровки) = Тип("Массив")
		И ТипЗнч(Расшифровки[1]) = Тип("Структура")
		И Расшифровки[1].Свойство("ПараллельнаяЗагрузка")
		И Расшифровки[1].ПараллельнаяЗагрузка Тогда
		
		ПараметрыФормы = Расшифровки[1];
		ПараметрыФормы.Вставить("ПериодВыборкиНачало", Период.ДатаНачала);
		ПараметрыФормы.Вставить("ПериодВыборкиОкончание", Период.ДатаОкончания);
		
		Если ЗначениеЗаполнено(Подразделение) Тогда
			Подразделения = Новый Массив;
			Подразделения.Добавить(Подразделение);
			ПараметрыФормы.Вставить("Подразделения", Подразделения);
		КонецЕсли;
		
		ОперативныйУчетПроизводстваКлиент.ОбработкаРасшифровкиИнтервалаСПараллельнойЗагрузкой(
			ЭтотОбъект, Расшифровки[1], СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиРасписание();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьРасписание(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборПараметровРасчетаЗавершение", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура("УникальныйИдентификатор, Подразделение, Распоряжения, МаршрутныеЛисты");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ПооперационноеПланирование.Форма.ПараметрыРасчета",
				 ПараметрыФормы,
				 ЭтаФорма,
				 ,
				 ,
				 ,
				 ОписаниеОповещения,
				 РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРасписаниеКоманда(Команда)
	
	Если ЗаписьРасписанияДопустима() Тогда
		
		ЗаписатьРасписание(Ложь);
		
	КонецЕсли;
	
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
Процедура АнализРасписания(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("МодельРасписания", МодельРасписания);
	ПараметрыОтбора.Вставить("ОптимальнаяМодельПланирования", ОптимальнаяМодельПланирования);
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Отбор", ПараметрыОтбора);
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.АнализПооперационногоРасписания.Форма", ПараметрыОтчета, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьПроблемыРасписания(Команда)
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРасписание Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПроблемыРасписания;
	Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРасписание;
	КонецЕсли;
	
	УстановитьЗаголовокКомандыПоказатьСкрытьПроблемы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьСтатусОпераций(Команда)
	
	Результат = АктуализироватьСтатусОперацийВФоновомРежиме();
	ЗаполнитьРеквизитыФоновойОперации(Результат);
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗавершенаАктуализацияСтатусОперацийВФоновомРежиме();
	Иначе
		НачатьОжиданиеФоновойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеНастройками

&НаСервере
Процедура ВосстановитьНастройкиФормыПриСоздании()
	
	НастройкиФормы = ХранилищеНастроекДанныхФорм.Загрузить(
		МенеджерНастроекКлючОбъекта(), МенеджерНастроекКлючНастроек());
	Если ЗначениеЗаполнено(НастройкиФормы) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	НастройкиФормы = СохраняемыеНастройкиФормы();
	
	ЗаполнитьЗначенияСвойств(НастройкиФормы, ЭтаФорма);
	ХранилищеНастроекДанныхФорм.Сохранить(
		МенеджерНастроекКлючОбъекта(), МенеджерНастроекКлючНастроек(), НастройкиФормы);
	
КонецПроцедуры

&НаСервере
Функция СохраняемыеНастройкиФормы()
	
	Результат = Новый Структура;
	Результат.Вставить("Период");
	Результат.Вставить("Периодичность");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция МенеджерНастроекКлючОбъекта()
	
	Возврат "ПооперационноеПланирование";
	
КонецФункции

&НаСервере
Функция МенеджерНастроекКлючНастроек()
	
	Возврат "НастройкиФормы";
	
КонецФункции

#КонецОбласти

#Область ВыводРасписания

&НаКлиенте
Процедура ОбработатьИзменениеОтбора()
	
	ВывестиРасписание();
	
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
	
	СохранитьНастройкиФормы();
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
	
	Элементы.ФормаУстановитьПериодДень.Пометка = ПометкаДень;
	Элементы.ФормаУстановитьПериодНеделя.Пометка = ПометкаНеделя;
	Элементы.ФормаУстановитьПериодМесяц.Пометка = ПометкаМесяц;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодичность()
	
	ПараметрыВывода = ПараметрыВыводаРасписания();
	Отчеты.ДиаграммаПооперационногоРасписания.УстановитьПериодичность(ПараметрыВывода, ДиаграммаГанта);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРасписаниеПриСозданииНаСервере()
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		
		Результат = ВывестиРасписаниеВФоновомРежиме();
		
		Если Результат.ЗаданиеВыполнено Тогда
			
			НачатьОжиданиеФоновойОперацииПриОткрытии = Ложь;
			
			ПрочитатьРезультатВыводаРасписанияВФоновомРежиме(ДиаграммаГанта, Результат.АдресХранилища);
			
		Иначе
			
			НачатьОжиданиеФоновойОперацииПриОткрытии = Истина;
			
			АдресХранилищаФоноваяОперация = Результат.АдресХранилища;
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиРасписание()
	
	Если ПроверитьЗаполнение() Тогда
		
		Результат = ВывестиРасписаниеВФоновомРежиме();
		ЗаполнитьРеквизитыФоновойОперации(Результат);
		
		Если Результат.ЗаданиеВыполнено Тогда
			ЗавершенВыводРасписанияВФоновомРежиме();
		Иначе
			НачатьОжиданиеФоновойОперации();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВывестиРасписаниеВФоновомРежиме()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Параметры", ПараметрыВыводаРасписания());
	ПараметрыЗадания.Вставить("ДиаграммаГанта", ДиаграммаГанта);
	
	ТекущаяФоноваяОперация = "ВыводРасписания";
	НаименованиеЗадания = НСтр("ru = 'Вывод расписания'");
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"Отчеты.ДиаграммаПооперационногоРасписания.ВывестиРасписаниеВФоновомРежиме",
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
	
	ПараметрыВывода = Отчеты.ДиаграммаПооперационногоРасписания.ПараметрыВывода();
	ЗаполнитьЗначенияСвойств(ПараметрыВывода, ЭтаФорма);
	
	Если ПараметрыВывода.Свойство("Подразделения") Тогда
		ПараметрыВывода.Подразделения.Добавить(Подразделение);
	КонецЕсли;
	
	ПараметрыВывода.Начало = Период.ДатаНачала;
	ПараметрыВывода.Окончание = Период.ДатаОкончания;
	
	Возврат ПараметрыВывода;
	
КонецФункции

&НаСервере
Процедура ПометитьОптимальнуюМодельнаСервере()
	
	Отчеты.ДиаграммаПооперационногоРасписания.ПометитьОптимальнуюМодель(
		ДиаграммаГанта, ОптимальнаяМодельПланирования);
	
КонецПроцедуры

#КонецОбласти

#Область РасчетРасписания

&НаКлиенте
Процедура ВыборПараметровРасчетаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено
		ИЛИ НЕ ЭтоАдресВременногоХранилища(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ВыполнитьРасчетВФоновомРежиме(РезультатЗакрытия);
	ЗаполнитьРеквизитыФоновойОперации(Результат);
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗавершенРасчетРасписанияВФоновомРежиме();
	Иначе
		НачатьОжиданиеФоновойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьРасчетВФоновомРежиме(АдресПараметрыЗадания)
	
	УдалитьРезультатыМоделированияИБлокировкиРасписания();
	ОчиститьХранилищеРезультатовРасчета(ЭтотОбъект);
	
	ПараметрыЗадания = ПолучитьИзВременногоХранилища(АдресПараметрыЗадания);
	
	ТекущаяФоноваяОперация = "РасчетРасписания";
	НаименованиеЗадания = НСтр("ru = 'Расчет пооперационного расписания производства'");
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"ОперативныйУчетПроизводстваПереопределяемый.РассчитатьПооперационноеРасписание",
						ПараметрыЗадания,
						НаименованиеЗадания);
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаКлиенте
Процедура ЗавершенРасчетРасписанияВФоновомРежиме()
	
	АдресХранилищаРезультатРасчета = АдресХранилищаФоноваяОперация;
	
	ПрочитатьРезультатыРасчета();
	
	УстановитьДоступностьКомандыЗаписатьРасписание();
	УстановитьВидимостьКомандыАнализРасписания();
	УдалитьБлокировкиРасписанияПриЗавершенииРасчета();
	УстановитьВидимостьКомандыПоказатьСкрытьПроблемыРасписания(ЭтотОбъект);
	
	СообщитьОРасчетеРасписания();
	
	ВывестиРасписание();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура СообщитьОРасчетеРасписания()
	
	Если РасчетВыполнен Тогда
		
		ТекстОповещения = НСтр("ru='Расчет расписания завершен.'");
		Картинка = БиблиотекаКартинок.Информация32;
		
	Иначе
		
		ТекстОповещения = НСтр("ru='Расчет расписания не выполнен.'");
		Картинка = БиблиотекаКартинок.Ошибка32;
		
	КонецЕсли;
	
	ОбнаруженыОшибки = НЕ(ПроблемыРасписания.Количество()=0);
	Если ОбнаруженыОшибки Тогда
		
		Пояснение = СтрШаблон(
			НСтр("ru='В процессе расчета возникли предупреждения (%1).'"),
			ПроблемыРасписания.Количество());
		
	Иначе
		Пояснение = "";
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения,, Пояснение, Картинка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОРасчетеРасписания()
	
	Оповестить(ОперативныйУчетПроизводстваКлиент.ИмяСобытияИзменениеПооперационногоРасписания());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандыЗаписатьРасписание()
	
	Если ЗаписьРасписанияДопустима() Тогда
		Модифицированность = Истина;
		Элементы.ФормаЗаписатьРасписание.Доступность = Истина;
	Иначе
		Модифицированность = Ложь;
		Элементы.ФормаЗаписатьРасписание.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКомандыАнализРасписания()
	
	Элементы.ФормаАнализРасписания.Видимость = РасчетВыполнен;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьКомандыПоказатьСкрытьПроблемыРасписания(Форма)
	
	ОтображатьКоманду = ЗначениеЗаполнено(Форма.ПроблемыРасписания);
	Форма.Элементы.ПоказатьСкрытьПроблемыРасписания.Видимость = ОтображатьКоманду;
	Если ОтображатьКоманду Тогда
		УстановитьЗаголовокКомандыПоказатьСкрытьПроблемы(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьБлокировкиРасписанияПриЗавершенииРасчета()
	
	Если НЕ ЗаписьРасписанияДопустима() Тогда
		УдалитьБлокировкиРасписания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРезультатыРасчета()
	
	МодельРасписания = РезультатРасчетаПоИмени(
		АдресХранилищаРезультатРасчета,
		"МодельРасписания",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
		
	ПодразделениеРасчет = РезультатРасчетаПоИмени(
		АдресХранилищаРезультатРасчета,
		"Подразделение",
		Справочники.СтруктураПредприятия.ПустаяСсылка());
	
	РасчетВыполнен = РезультатРасчетаПоИмени(
		АдресХранилищаРезультатРасчета,
		"РасчетВыполнен",
		Ложь);
		
	СценарииИспользуются = РезультатРасчетаПоИмени(
		АдресХранилищаРезультатРасчета,
		"СценарииИспользуются",
		Ложь);
	
	Если РасчетВыполнен Тогда
		
		ОптимальнаяМодельПланирования = РезультатРасчетаПоИмени(АдресХранилищаРезультатРасчета,
			"ОптимальнаяМодельПланирования",
			ПредопределенноеЗначение("Справочник.МоделиПооперационногоПланирования.ПустаяСсылка"));
		
	КонецЕсли;
	
	ПрочитатьПроблемыРасписания();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПроблемыРасписания()
	
	Если ЗначениеЗаполнено(МодельРасписания) Тогда
		
		РезультатПроблемы = РезультатРасчетаПоИмени(АдресХранилищаРезультатРасчета, "ПроблемыРасписания", Неопределено);
		
		Если ЗначениеЗаполнено(РезультатПроблемы) Тогда
			
			СчСтрок = 1;
			Для каждого Строка Из РезультатПроблемы Цикл
				НоваяСтрока = ПроблемыРасписания.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
				НоваяСтрока.НомерСтроки = СчСтрок;
				
				СчСтрок = СчСтрок + 1;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатРасчетаПоИмени(АдресХранилища, ИмяСвойства, ЗначениеПоУмолчанию = Неопределено)
	
	Если ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		РезультатРасчета = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если ТипЗнч(РезультатРасчета) = Тип("Структура") Тогда
			Если РезультатРасчета.Свойство(ИмяСвойства) Тогда
				Возврат РезультатРасчета[ИмяСвойства];
			Иначе
				Возврат ЗначениеПоУмолчанию;
			КонецЕсли;
		Иначе
			Возврат ЗначениеПоУмолчанию;
		КонецЕсли;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьХранилищеРезультатовРасчета(Форма)

	Форма.АдресХранилищаРезультатРасчета = "";
	Форма.ОптимальнаяМодельПланирования = Неопределено;
	
	Форма.МодельРасписания = Неопределено;
	Форма.ПодразделениеРасчет = Неопределено;
	Форма.РасчетВыполнен = Ложь;
	Форма.СценарииИспользуются = Ложь;
	
	Форма.ПроблемыРасписания.Очистить();
	Форма.Элементы.СтраницыФормы.ТекущаяСтраница = Форма.Элементы.СтраницаРасписание;
	
	УстановитьВидимостьКомандыПоказатьСкрытьПроблемыРасписания(Форма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьРезультатыМоделирования(МодельРасписания)
	
	Если ЗначениеЗаполнено(МодельРасписания) Тогда
		РегистрыСведений.ПооперационноеРасписание.ОчиститьРасписаниеМодельРасписания(МодельРасписания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатыРасчетаПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗаписьРасписанияДопустима() Тогда
		
		Если НЕ ВыполняетсяЗакрытие Тогда
			
			Отказ = Истина;
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
			ТекстВопроса = НСтр("ru = 'Данные были изменены. Записать изменения?'");
			Кнопки = РежимДиалогаВопрос.ДаНетОтмена;
			КнопкаПоУмолчанию = КодВозвратаДиалога.Отмена;
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КнопкаПоУмолчанию);
			
		КонецЕсли;
		
	Иначе
		
		УдалитьРезультатыМоделированияИБлокировкиРасписания();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ОтветПользователя = РезультатЗакрытия;
	
	Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
		
		ЗаписатьРасписание(Истина);
		
	ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
		
		УдалитьРезультатыМоделированияИБлокировкиРасписания();
		
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьРасписания

&НаКлиенте
Процедура ЗаписатьРасписание(ЗаписьПередЗакрытием)
	
	ЗаписьРасписанияПередЗакрытием = ЗаписьПередЗакрытием;
	
	Результат = ЗаписатьРасписаниеВФоновомРежиме();
	ЗаполнитьРеквизитыФоновойОперации(Результат);
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗавершенаЗаписьРасписанияВФоновомРежиме();
	Иначе
		Если ЗаписьПередЗакрытием Тогда
			ПодключитьОбработчикОжидания("НачатьОжиданиеФоновойОперации", 0.1, Истина);
		Иначе
			НачатьОжиданиеФоновойОперации();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьРасписаниеВФоновомРежиме()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("МодельРасписания", МодельРасписания);
	ПараметрыЗадания.Вставить("МодельПланирования", ОптимальнаяМодельПланирования);
	
	ТекущаяФоноваяОперация = "ЗаписьРасписания";
	НаименованиеЗадания = НСтр("ru = 'Запись расписания'");
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"Обработки.ПооперационноеПланирование.ЗаписатьРасписаниеВФоновомРежиме",
						ПараметрыЗадания,
						НаименованиеЗадания);
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаКлиенте
Функция ЗаписьРасписанияДопустима()
	
	Возврат ЗначениеЗаполнено(МодельРасписания) И РасчетВыполнен И НЕ СценарииИспользуются;
	
КонецФункции

&НаКлиенте
Процедура ЗавершенаЗаписьРасписанияВФоновомРежиме()
	
	Если ЭтоАдресВременногоХранилища(АдресХранилищаФоноваяОперация) Тогда
		
		ЗаписьВыполнена = ПолучитьИзВременногоХранилища(АдресХранилищаФоноваяОперация);
		
		Если ТипЗнч(ЗаписьВыполнена) = Тип("Булево") И ЗаписьВыполнена Тогда
			
			УдалитьБлокировкиРасписания();
			
			ОчиститьХранилищеРезультатовРасчета(ЭтотОбъект);
			
			ОповеститьОРасчетеРасписания();
			УстановитьДоступностьКомандыЗаписатьРасписание();
			УстановитьВидимостьКомандыАнализРасписания();
			
			Если ЗаписьРасписанияПередЗакрытием Тогда
				ВыполняетсяЗакрытие = Истина;
				Закрыть();
			Иначе
				СообщитьОЗаписиРасписания();
				ВывестиРасписание();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СообщитьОЗаписиРасписания()
	
	ТекстЗаголовка = НСтр("ru='Расписание записано'");
	ПоказатьОповещениеПользователя(ТекстЗаголовка,,, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнениеОперацийВФоновомРежиме

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
				
				Если ТекущаяФоноваяОперация = "РасчетРасписания" Тогда
					ЗавершенРасчетРасписанияВФоновомРежиме();
				ИначеЕсли ТекущаяФоноваяОперация = "ВыводРасписания" Тогда
					ЗавершенВыводРасписанияВФоновомРежиме();
				ИначеЕсли ТекущаяФоноваяОперация = "ЗаписьРасписания" Тогда
					ЗавершенаЗаписьРасписанияВФоновомРежиме();
				ИначеЕсли ТекущаяФоноваяОперация = "АктуализироватьСтатусОпераций" Тогда
					ЗавершенаАктуализацияСтатусОперацийВФоновомРежиме();
				КонецЕсли;
				
			Иначе
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
				
			КонецЕсли;
			
		Иначе
			
			Если ТекущаяФоноваяОперация = "РасчетРасписания" Тогда
				// Возможно задание было отменено пользователем и в регистре блокировок остались неактуальные записи.
				УдалитьБлокировкиРасписанияНаСервере();
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	Если НЕ ЗначениеЗаполнено(Форма.Подразделение) Тогда
		ТребуетсяОбновитьОперации = Ложь;
	Иначе
		ТребуетсяОбновитьОперации = ИзмененСпособУправления(Форма.Подразделение);
	КонецЕсли;
	
	Форма.Элементы.ФормаРассчитатьРасписание.Доступность = НЕ ТребуетсяОбновитьОперации;
	Форма.Элементы.ФормаЗаписатьРасписание.Доступность = НЕ ТребуетсяОбновитьОперации;
	Форма.Элементы.ГруппаАктуализироватьСтатусОпераций.Видимость = ТребуетсяОбновитьОперации;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзмененСпособУправления(Подразделение)
	
	Возврат РегистрыСведений.БлокировкиПооперационногоРасписания.РасписаниеПодразделенияЗаблокировано(
		Подразделение, Перечисления.ПричиныБлокировокПооперационногоРасписания.ИзмененСпособУправления);
	
КонецФункции

&НаСервере
Процедура ПрочитатьПараметрыФормыПриСоздании()
	
	Если Параметры.Свойство("Подразделение") Тогда
		Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура МодифицироватьЭлементыФормыПриСоздании()
	
	Отчеты.ДиаграммаПооперационногоРасписания.ДобавитьВФормуОбозначенияДиаграммы(ЭтаФорма, Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРасшифровкуМоделиПланирования(Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеДействия = Новый СписокЗначений;
	
	ДействиеУстановить = НСтр("ru = 'Установить в качестве оптимальной модели'");
	ДополнительныеДействия.Добавить("УстановитьОптимальной", ДействиеУстановить);
	
	ДействиеОткрыть = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Открыть ""%1""'"), ЗначениеРеквизитаОбъекта(Расшифровка, "Наименование"));
	ДополнительныеДействия.Добавить("ОткрытьЗначение", ДействиеОткрыть);
	
	Оповещение = Новый ОписаниеОповещения("ВыборДействияРасшифровкиМоделиПланированияЗавершение", ЭтотОбъект, Расшифровка);
	ДополнительныеДействия.ПоказатьВыборЭлемента(Оповещение, НСтр("ru = 'Выбор действия'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДействияРасшифровкиМоделиПланированияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли ВыбранныйЭлемент.Значение = "ОткрытьЗначение" Тогда
		
		ОткрытьФорму("Справочник.МоделиПооперационногоПланирования.ФормаОбъекта", Новый Структура("Ключ", ДополнительныеПараметры));		
		
	ИначеЕсли ВыбранныйЭлемент.Значение = "УстановитьОптимальной" Тогда
		
		ОптимальнаяМодельПланирования = ДополнительныеПараметры;
		ПометитьОптимальнуюМодельнаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита)
	
	Возврат (ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокКомандыПоказатьСкрытьПроблемы(Форма)
	
	Если Форма.Элементы.СтраницыФормы.ТекущаяСтраница = Форма.Элементы.СтраницаРасписание Тогда
		ЗаголовокКоманды = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Показать предупреждения (%1) >>'"), Форма.ПроблемыРасписания.Количество());
	Иначе
		ЗаголовокКоманды = НСтр("ru = '<< Назад к расписанию'");
	КонецЕсли;
	
	Форма.Элементы.ПоказатьСкрытьПроблемыРасписания.Заголовок = ЗаголовокКоманды;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьБлокировкиРасписания()
	
	Если ЗначениеЗаполнено(ПодразделениеРасчет) Тогда
		УдалитьБлокировкиРасписанияНаСервере(ПодразделениеРасчет);
		ПодразделениеРасчет = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьБлокировкиРасписанияНаСервере(Подразделение=Неопределено)

	НомерСеанса = НомерСеансаИнформационнойБазы();
	НачалоСеанса =  НачалоСеанса();
	
	РегистрыСведений.БлокировкиПооперационногоРасписания.РазблокироватьРасчетРасписания(
		НомерСеанса, НачалоСеанса, Подразделение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НачалоСеанса()
	
	НомерСеанса = НомерСеансаИнформационнойБазы();
	НачалоСеанса = '00010101';
	
	УстановитьПривилегированныйРежим(Истина);
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	УстановитьПривилегированныйРежим(Ложь);
	
	Для каждого Сеанс Из Сеансы Цикл
		Если Сеанс.НомерСеанса = НомерСеанса Тогда
			НачалоСеанса = Сеанс.НачалоСеанса;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НачалоСеанса;
	
КонецФункции

&НаСервере
Функция АктуализироватьСтатусОперацийВФоновомРежиме()
	
	ПараметрыЗадания = Новый Структура("Подразделение", Подразделение);
	
	ТекущаяФоноваяОперация = "АктуализироватьСтатусОпераций";
	НаименованиеЗадания = НСтр("ru = 'Актуализация статуса операций'");
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"РегистрыСведений.ПооперационноеРасписание.ПриПереходеСРегистрацииОтклоненийНаРегистрациюФакта",
						ПараметрыЗадания,
						НаименованиеЗадания);
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаКлиенте
Процедура ЗавершенаАктуализацияСтатусОперацийВФоновомРежиме()
	
	УправлениеДоступностью(ЭтотОбъект);
	ВывестиРасписание();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРезультатыМоделированияИБлокировкиРасписания()
	
	УдалитьРезультатыМоделирования(МодельРасписания);
	УдалитьБлокировкиРасписания();
	
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
