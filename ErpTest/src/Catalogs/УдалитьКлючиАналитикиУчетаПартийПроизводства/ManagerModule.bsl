#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ЗаменаДублейКлючейАналитики

Процедура ЗаменитьДублиКлючейАналитики() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка,
	|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
	|	Аналитика.КлючАналитики КАК КлючАналитики
	|ИЗ
	|	Справочник.УдалитьКлючиАналитикиУчетаПартийПроизводства КАК ДанныеСправочника
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УдалитьАналитикаУчетаПартийПроизводства КАК ДанныеРегистра
	|	ПО
	|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УдалитьАналитикаУчетаПартийПроизводства КАК Аналитика
	|	ПО
	|		ДанныеСправочника.Номенклатура		= Аналитика.Номенклатура
	|		И ДанныеСправочника.Характеристика	= Аналитика.Характеристика
	|		И ДанныеСправочника.Спецификация	= Аналитика.Спецификация
	|		И ДанныеСправочника.Назначение		= Аналитика.Назначение
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики ЕСТЬ NULL
	|");
	
	// Сформируем соответствие ключей аналитики.
	СоответствиеАналитик = Новый Соответствие;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
	
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СоответствиеАналитик.Вставить(Выборка.Ссылка, Выборка.КлючАналитики);
			
			Если Не Выборка.ПометкаУдаления Тогда
				
				СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
				СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
				
			КонецЕсли;

		КонецЦикла;
		
		ОбщегоНазначенияУТ.ЗаменитьСсылки(СоответствиеАналитик);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли