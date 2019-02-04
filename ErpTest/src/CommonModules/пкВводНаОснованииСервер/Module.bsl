
Процедура ПередДобавлениемКомандСоздатьНаОсновании(ИмяФормы, КомандыСоздатьНаОсновании, СтандартнаяОбработка) Экспорт
		
	Если ИмяФормы = "Документ.КоммерческоеПредложениеКлиенту.Форма.ФормаДокумента" Тогда
		КомандаСозданияНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСозданияНаОсновании.Обработчик = "пкВводНаОснованииКлиент.СоздатьЗаявкуНаАрендуТехникиКоммерческоеПредложениеКлиенту";
		КомандаСозданияНаОсновании.Идентификатор = "КоммерческоеПредложениеКлиентуСоздатьЗаявкуНаАрендуТехники";
		КомандаСозданияНаОсновании.Представление = НСтр("ru = 'Заявка на аренду техники'");
		КомандаСозданияНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСозданияНаОсновании.Порядок = 99;
	ИначеЕсли ИмяФормы = "Документ.ПринятиеКУчетуОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ПодготовкаКПередачеОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.СписаниеОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ПринятиеКУчетуОС.Форма.ФормаСписка"
		Или ИмяФормы = "Документ.ПодготовкаКПередачеОС.Форма.ФормаСписка"
		Или ИмяФормы = "Документ.СписаниеОС.Форма.ФормаСписка"
		Тогда
		КомандаСозданияНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСозданияНаОсновании.Обработчик = "пкВводНаОснованииКлиент.СоздатьпкПостановкаСнятиеНаУчетВРостехнадзоре";
		КомандаСозданияНаОсновании.Идентификатор = "ДокументОССоздать_пкПостановкаСнятиеНаУчетВРостехнадзоре";
		КомандаСозданияНаОсновании.Представление = НСтр("ru = 'Постановка\снятие на учет в Ростехнадзоре (пк)'");
		КомандаСозданияНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСозданияНаОсновании.Порядок = 99;
	КонецЕсли;
		
КонецПроцедуры


