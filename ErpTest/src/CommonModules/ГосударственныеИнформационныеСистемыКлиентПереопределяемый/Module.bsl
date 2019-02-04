
#Область ПрограммныйИнтерфейс

Процедура ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Копирование = Ложь) Экспорт 
	
	//++ НЕ ГОСИС
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Копирование);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

Функция НеобходимоОбновитьСтатусыСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Удаление = Ложь) Экспорт
	
	//++ НЕ ГОСИС
	Возврат НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Удаление);
	//-- НЕ ГОСИС
	
	Возврат Ложь;
	
КонецФункции

Процедура ХарактеристикаСоздание(Элемент, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти
