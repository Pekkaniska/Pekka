#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьИсточникиВторичныхДанныхПлановыхНачислений(ДокументОбъект, Отказ, РежимЗаписи) Экспорт
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;	
	
	ПлановыеНачисленияСотрудников.ИнициализироватьНаборыИсточникиВторичныхДанных(ДокументОбъект, РежимЗаписи);
		
КонецПроцедуры

Процедура ЗаписатьВторичныеДанныеПлановыхНачисленийПриПроведенииДокумента(ДокументОбъект) Экспорт
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПлановыеНачисленияСотрудников.ЗарегистрироватьВторичныеДанныеПриПроведенииДокумента(ДокументОбъект);
КонецПроцедуры

Процедура ЗаписатьВторичныеДанныеПлановыхНачисленийПриОтменеПроведенияДокумента(ДокументОбъект) Экспорт
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыИсточникиВторичныхДанных = ПлановыеНачисленияСотрудников.РегистрыИсточникиВторичныхДанных();
	
	Для Каждого Набор Из ДокументОбъект.Движения Цикл
		Если РегистрыИсточникиВторичныхДанных[Набор.Метаданные().Имя] = Истина 
			И Не ЗарплатаКадрыПериодическиеРегистры.ТаблицаИзменившихсяДанныхНабораСформирована(Набор) Тогда		
			Набор.Записывать = Истина
		КонецЕсли;	
	КонецЦикла;		
		
	
	ПлановыеНачисленияСотрудников.ЗарегистрироватьВторичныеДанныеПриПроведенииДокумента(ДокументОбъект);
КонецПроцедуры

Процедура ЗаписатьВторичныеДанныеПлановыхНачисленийПриЗаписиНабора(Источник, Отказ, Замещение) Экспорт
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ПлановыеНачисленияСотрудников.ЗарегистрироватьВторичныеДанныеПриЗаписиНабора(Источник);		
КонецПроцедуры

#КонецОбласти