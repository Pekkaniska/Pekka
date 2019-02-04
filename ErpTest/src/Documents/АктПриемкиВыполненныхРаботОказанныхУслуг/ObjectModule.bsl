#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование, , Истина);
		
		ДоговорГПХ = СотрудникиФормыРасширенный.ДоговорГПХНеЗакрытыйАктом(ОбъектОснование);
		Если ЗначениеЗаполнено(ДоговорГПХ) Тогда
			ОбъектОснование = ДоговорГПХ;
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ДоговорАвторскогоЗаказа")
		Или ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ДоговорРаботыУслуги") Тогда
		
		Если Не ОбъектОснование.СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот Тогда
			ВызватьИсключение НСтр("ru = 'По этому договору не предусмотрена оплата на основании акта выполненных работ.'");
		КонецЕсли;
		
		Если Не ОбъектОснование.Проведен Тогда
			ВызватьИсключение НСтр("ru = 'Ввод на основании непроведенного документа невозможен.'");
		КонецЕсли;
		
		СвойстваЗаполнения = "Организация, Сотрудник, СтатьяФинансирования, СтатьяРасходов, ОтношениеКЕНВД, Подразделение, Территория, СпособОтраженияЗарплатыВБухучете, СуммаВычета, СуммаЕНВД";
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбъектОснование, СвойстваЗаполнения); 
		Договор = ОбъектОснование.Ссылка;
		Результат = ОбъектОснование.Сумма;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	Для Каждого Строка Из ДанныеДляПроведения Цикл
		
		Если Не Строка.ОплатаПоАктам Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'В документе %1 должен быть указан вариант оплаты ""по актам выполненных работ"".'"), Строка.Договор);
			ВызватьИсключение ТекстОшибки;
			
		ИначеЕсли Не Строка.ДоговорПроведен Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Документ %1 еще не проведен, акт выполненных работ можно вводить только на основании проведенного документа.'"), Строка.Договор);
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		НоваяСтрока = Движения.ПлановыеНачисленияПоДоговорам.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	Движения.ПлановыеНачисленияПоДоговорам.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает таблицу значений - данные, необходимые для формирования плановых начислений по договорам.
//
Функция ДанныеДляПроведения()
	
	НДФЛДоговорыРаботыУслуги = УчетНДФЛРасширенный.ДоходыНДФЛПоВидуОсобыхНачислений(Перечисления.ВидыОсобыхНачисленийИУдержаний.ДоговорРаботыУслуги);
	КодДохода = НДФЛДоговорыРаботыУслуги[0];
	
	ВычетыКДоходам = УчетНДФЛ.ВычетыКДоходам(Год(МесяцНачисления));
	КодВычета = ВычетыКДоходам[КодДохода][0];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("КодГПХдляСтраховыхВзносов", УчетСтраховыхВзносовРасширенный.ВидДоходаДляДоговораНаВыполнениеРабот(Ложь));
	Запрос.УстановитьПараметр("КодГПХдляСтраховыхВзносовОблагаетсяФСС_НС", УчетСтраховыхВзносовРасширенный.ВидДоходаДляДоговораНаВыполнениеРабот(Истина));
	Запрос.УстановитьПараметр("КодДохода", КодДохода);
	Запрос.УстановитьПараметр("КодВычета", КодВычета);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АктВыполненныхРабот.Организация,
	|	АктВыполненныхРабот.МесяцНачисления,
	|	АктВыполненныхРабот.Сотрудник,
	|	АктВыполненныхРабот.Договор КАК Договор,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.Номер ЕСТЬ НЕ NULL 
	|			ТОГДА &КодДохода
	|		КОГДА ДоговорАвторскогоЗаказа.Номер ЕСТЬ НЕ NULL 
	|			ТОГДА ДоговорАвторскогоЗаказа.ВидАвторскогоДоговора.КодДоходаНДФЛ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)
	|	КОНЕЦ КАК КодДохода,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.Номер ЕСТЬ НЕ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА ДоговорРаботыУслуги.ОблагаетсяФСС_НС
	|						ТОГДА &КодГПХдляСтраховыхВзносовОблагаетсяФСС_НС
	|					ИНАЧЕ &КодГПХдляСтраховыхВзносов
	|				КОНЕЦ
	|		КОГДА ДоговорАвторскогоЗаказа.Номер ЕСТЬ НЕ NULL 
	|			ТОГДА ДоговорАвторскогоЗаказа.ВидАвторскогоДоговора.КодДоходаСтраховыеВзносы
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыДоходовПоСтраховымВзносам.ПустаяСсылка)
	|	КОНЕЦ КАК КодДоходаСтраховыеВзносы,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.Номер ЕСТЬ НЕ NULL 
	|			ТОГДА &КодВычета
	|		КОГДА ДоговорАвторскогоЗаказа.Номер ЕСТЬ НЕ NULL 
	|			ТОГДА ДоговорАвторскогоЗаказа.КодВычета
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)
	|	КОНЕЦ КАК КодВычета,
	|	АктВыполненныхРабот.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	АктВыполненныхРабот.ОтношениеКЕНВД КАК ОтношениеКЕНВД,
	|	АктВыполненныхРабот.СуммаЕНВД КАК СуммаЕНВД,
	|	АктВыполненныхРабот.Подразделение КАК Подразделение,
	|	АктВыполненныхРабот.Территория КАК Территория,
	|	АктВыполненныхРабот.Договор.ДатаНачала КАК ДатаНачала,
	|	АктВыполненныхРабот.Договор.ДатаОкончания КАК ДатаОкончания,
	|	ЕСТЬNULL(АктВыполненныхРабот.Договор.ЗаключенСоСтудентомРаботающимВСтудотряде, ЛОЖЬ) КАК ЗаключенСоСтудентомРаботающимВСтудотряде,
	|	АктВыполненныхРабот.Результат КАК Сумма,
	|	АктВыполненныхРабот.СуммаВычета КАК СуммаВычета,
	|	АктВыполненныхРабот.СтатьяФинансирования,
	|	АктВыполненныхРабот.СтатьяРасходов,
	|	АктВыполненныхРабот.Ссылка КАК ДоговорАкт,
	|	АктВыполненныхРабот.Договор.Проведен КАК ДоговорПроведен,
	|	ВЫБОР
	|		КОГДА АктВыполненныхРабот.Договор.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОплатаПоАктам,
	|	АктВыполненныхРабот.ПланируемаяДатаВыплаты,
	|	АктВыполненныхРабот.ФизическоеЛицо
	|ИЗ
	|	Документ.АктПриемкиВыполненныхРаботОказанныхУслуг КАК АктВыполненныхРабот
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДоговорРаботыУслуги КАК ДоговорРаботыУслуги
	|		ПО АктВыполненныхРабот.Договор = ДоговорРаботыУслуги.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДоговорАвторскогоЗаказа КАК ДоговорАвторскогоЗаказа
	|		ПО АктВыполненныхРабот.Договор = ДоговорАвторскогоЗаказа.Ссылка
	|ГДЕ
	|	АктВыполненныхРабот.Ссылка = &Ссылка";
	
	РезультатыЗапроса = Запрос.Выполнить();
	
	Возврат РезультатыЗапроса.Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
