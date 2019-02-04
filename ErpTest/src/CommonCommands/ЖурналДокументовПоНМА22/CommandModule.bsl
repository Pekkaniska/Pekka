#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
		Истина, "ОбщаяКоманда.ЖурналДокументовПоНМА22");
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияФормы", "РегламентированныйУчет");
		
	ОткрытьФорму(
		"Обработка.ЖурналДокументовНМА2_4.Форма.ДокументыПоНМА2_2",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
