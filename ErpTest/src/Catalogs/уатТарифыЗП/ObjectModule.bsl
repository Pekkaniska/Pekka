
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если НЕ ЭтоГруппа 
		И СпособРасчетаОплатыТруда = Перечисления.уатСпособыРасчетаОплатыТруда.СдельныйЗаработок Тогда
		ПроверяемыеРеквизиты.Добавить("ПараметрВыработки");
	КонецЕсли;
КонецПроцедуры