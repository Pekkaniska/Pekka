
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекПунктПараметр = Неопределено;
	Параметры.Свойство("ПунктНазначения", ТекПунктПараметр);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Пункт", ТекПунктПараметр);
КонецПроцедуры
