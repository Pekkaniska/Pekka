#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Начало периода'"), , , Ложь);
	
	УникальныеЗначения = Новый Соответствие;
	ИндексСтроки = 0;
	Для Каждого ДанныеФизическогоЛица Из Удержания Цикл
		Если УникальныеЗначения[ДанныеФизическогоЛица.ФизическоеЛицо] = Неопределено Тогда
			УникальныеЗначения.Вставить(ДанныеФизическогоЛица.ФизическоеЛицо, Истина);
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %1 была введена в документе ранее.'"), ДанныеФизическогоЛица.ФизическоеЛицо);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Удержания[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ФизическоеЛицо", ,Отказ);
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= ДатаОкончания;
	
	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		ОбщегоНазначения.ВыгрузитьКолонку(Удержания, "ФизическоеЛицо"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Удержания.ФизическоеЛицо", "Объект"));
	
	Если Действие = Перечисления.ДействияСУдержаниями.Начать Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДокументОснование");
	КонецЕсли;
	
	// Если указан документ основание, то контрагента указывать не нужно, его нельзя изменить.
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПрофсоюзнаяОрганизация");
	КонецЕсли;
	
	Если Действие <> Перечисления.ДействияСУдержаниями.Прекратить Тогда 
		ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаНачала, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда
			ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения.Сотрудник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = РасчетЗарплатыРасширенный.СоздатьДанныеДляРегистрацииПлановыхУдержаний();
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеДляРегистрацииПлановыхУдержанийСпискаСотрудников(ДанныеДляПроведения, Ссылка);
	
	ДвиженияУдержаний = Новый Структура;
	ДвиженияУдержаний.Вставить("ДанныеПлановыхУдержаний", ДанныеДляПроведения.ДанныеПлановыхУдержаний);
	ДвиженияУдержаний.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
	ДвиженияУдержаний.Вставить("РабочиеМестаУдержаний", ДанныеДляПроведения.РабочиеМестаУдержаний);

	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхУдержаний(Движения, ДвиженияУдержаний); 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		

	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		
		// Регистрируем получателя удержания только при назначении удержания, далее он не изменяется.
		ПолучателиУдержаний = РасчетЗарплатыРасширенный.НоваяТаблицаПолучателиУдержаний();
		Для Каждого ДанныеФизическогоЛица Из Удержания Цикл 
			НоваяСтрока = ПолучателиУдержаний.Добавить();
			НоваяСтрока.ФизическоеЛицо = ДанныеФизическогоЛица.ФизическоеЛицо;
			НоваяСтрока.Удержание = Удержание;
			НоваяСтрока.Контрагент = ПрофсоюзнаяОрганизация;
		КонецЦикла;
		
		РасчетЗарплатыРасширенный.ЗарегистрироватьПолучателяУдержания(ПолучателиУдержаний, Организация, Ссылка);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
