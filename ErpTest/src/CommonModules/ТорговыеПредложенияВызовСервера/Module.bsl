////////////////////////////////////////////////////////////////////////////////
// Подсистема "Торговые предложения".
// ОбщийМодуль.ТорговыеПредложенияВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОбновитьСтатистикуСинхронизацииВФоне(УникальныйИдентификатор, ПараметрыПроцедуры) Экспорт
	
	НаименованиеЗадания = НСтр("ru = 'Торговые предложения. Обновление статистики синхронизации.'");
	ИмяПроцедуры        = "ТорговыеПредложенияСлужебный.ОбновитьСтатистикуСинхронизации";
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти