
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура("КонфигурацияИсточник", "КА");
	ОткрытьФорму("Обработка.ПомощникПереходаСДругихКонфигураций.Форма.Форма",
		ПараметрыОткрытия,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры
