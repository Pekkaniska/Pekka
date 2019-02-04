#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

// Заполняет измерение ФизическоеЛицо
//
Процедура ЗаполнитьПоДокументам() Экспорт
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.ПорядокВыплаты КАК ПорядокВыплаты
	|ИЗ
	|	#Документ КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокВыплатыДокументов КАК Регистр
	|		ПО (Регистр.Регистратор = Документ.Ссылка)
	|ГДЕ
	|	Регистр.ПорядокВыплаты ЕСТЬ NULL ";
	
	ЗапросыПоДокументам = Новый Массив;
	
	Для Каждого Документ Из Метаданные.Документы Цикл
		Если Документ.Движения.Содержит(Метаданные.РегистрыСведений.ПорядокВыплатыДокументов) И Документ.Реквизиты.Найти("ПорядокВыплаты") <> Неопределено Тогда
			ТекстЗапросаПоДокументу = СтрЗаменить(ШаблонЗапроса, "#Документ", Документ.ПолноеИмя());
			ЗапросыПоДокументам.Добавить(ТекстЗапросаПоДокументу);
		КонецЕсли	
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(ЗапросыПоДокументам, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	
	ВыборкаДокументов = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаДокументов.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаДокументов.Ссылка);
	
		Запись = НаборЗаписей.Добавить();
		Запись.ДокументОснование= ВыборкаДокументов.Ссылка;
		Запись.ПорядокВыплаты	= ВыборкаДокументов.ПорядокВыплаты;
		
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
		
	КонецЦикла
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли