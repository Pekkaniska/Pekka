#Область ОбработчикиСобытий
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для работы с уведомлениями рекомендуется пользоваться формой 1С-Отчетность'"));
	
	ПараметрыФормы = Новый Структура("Тип", "Патент");
	ОткрытьФорму("Обработка.СообщенияВКонтролирующийОрган.Форма.ФормаОбработки", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
#КонецОбласти