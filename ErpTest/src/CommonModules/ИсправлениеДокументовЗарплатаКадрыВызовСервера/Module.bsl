#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВыплатаПроизводиласьОтражениеВУчетеПроизводилось(Организация, Документ, ПериодРегистрации, ВыплатаПроизводилась, ОтражениеВУчетеПроизводилось) Экспорт
	Если ВыплатаПроизводилась = НеОпределено Тогда
		ВыплатаПроизводилась = ИсправлениеДокументовЗарплатаКадры.ВыплатаПроизводилась(Организация, Документ, ПериодРегистрации);
	КонецЕсли;
	Если ОтражениеВУчетеПроизводилось = НеОпределено Тогда
		ОтражениеВУчетеПроизводилось = ИсправлениеДокументовЗарплатаКадры.ОтражениеВУчетеПроизводилось(Организация, ПериодРегистрации);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
